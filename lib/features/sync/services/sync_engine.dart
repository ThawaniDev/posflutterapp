import 'dart:async';

import 'package:thawani_pos/features/sync/data/remote/sync_api_service.dart';
import 'package:thawani_pos/features/sync/services/connectivity_service.dart';
import 'package:thawani_pos/features/sync/services/sync_queue_manager.dart';
import 'package:thawani_pos/features/sync/services/websocket_service.dart';

/// Core sync orchestrator that coordinates connectivity, queue replay,
/// periodic sync, and real-time WebSocket events.
class SyncEngine {
  SyncEngine({
    required this.apiService,
    required this.connectivity,
    required this.queueManager,
    required this.webSocket,
    required this.terminalId,
    this.autoSyncInterval = const Duration(minutes: 5),
    this.maxRetries = 5,
  });

  final SyncApiService apiService;
  final ConnectivityService connectivity;
  final SyncQueueManager queueManager;
  final WebSocketService webSocket;
  final String terminalId;
  final Duration autoSyncInterval;
  final int maxRetries;

  Timer? _autoSyncTimer;
  StreamSubscription<ConnectivityStatus>? _connectivitySub;
  StreamSubscription<SyncEvent>? _wsSub;
  String? _lastSyncToken;
  bool _isSyncing = false;

  final _statusController = StreamController<SyncEngineStatus>.broadcast();
  Stream<SyncEngineStatus> get statusStream => _statusController.stream;
  SyncEngineStatus _currentStatus = SyncEngineStatus.idle;
  SyncEngineStatus get currentStatus => _currentStatus;

  /// Initialize and start syncing.
  Future<void> start() async {
    await queueManager.load();

    // Listen for connectivity changes
    _connectivitySub = connectivity.statusStream.listen(_onConnectivityChanged);
    connectivity.startMonitoring();

    // Listen for real-time events
    _wsSub = webSocket.events.listen(_onWebSocketEvent);

    // Start auto-sync timer
    _autoSyncTimer = Timer.periodic(autoSyncInterval, (_) => syncNow());

    // Initial sync if online
    if (connectivity.isOnline) {
      await _replayQueue();
      await syncNow();
      webSocket.connect();
    }
  }

  /// Perform a sync cycle: replay queue → push local → pull remote.
  Future<SyncResult> syncNow() async {
    if (_isSyncing) return const SyncResult(pushed: 0, pulled: 0, skipped: true);
    _isSyncing = true;
    _updateStatus(SyncEngineStatus.syncing);

    try {
      if (!connectivity.isOnline) {
        _updateStatus(SyncEngineStatus.offline);
        return const SyncResult(pushed: 0, pulled: 0, skipped: true);
      }

      // 1. Replay queued operations
      final replayed = await _replayQueue();

      // 2. Pull remote changes
      final pullResult = await apiService.pull(terminalId: terminalId, syncToken: _lastSyncToken);

      final pulledCount = (pullResult['records_count'] as int?) ?? 0;
      _lastSyncToken = pullResult['sync_token'] as String? ?? _lastSyncToken;

      // 3. Send heartbeat
      await apiService.heartbeat(terminalId: terminalId);

      _updateStatus(SyncEngineStatus.idle);
      return SyncResult(pushed: replayed, pulled: pulledCount, skipped: false);
    } catch (e) {
      _updateStatus(SyncEngineStatus.error);
      return SyncResult(pushed: 0, pulled: 0, skipped: false, error: e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Queue a local change for sync. If online, replays immediately.
  Future<void> recordChange(QueuedOperation operation) async {
    await queueManager.enqueue(operation);
    if (connectivity.isOnline && !_isSyncing) {
      await _replayQueue();
    }
  }

  /// Perform a full sync (destructive — pulls all data from server).
  Future<SyncResult> fullSync() async {
    if (_isSyncing) return const SyncResult(pushed: 0, pulled: 0, skipped: true);
    _isSyncing = true;
    _updateStatus(SyncEngineStatus.syncing);

    try {
      // Replay queue first
      final replayed = await _replayQueue();

      // Full sync
      final result = await apiService.fullSync(terminalId: terminalId);
      final pulledCount = (result['records_count'] as int?) ?? 0;
      _lastSyncToken = result['sync_token'] as String? ?? _lastSyncToken;

      _updateStatus(SyncEngineStatus.idle);
      return SyncResult(pushed: replayed, pulled: pulledCount, skipped: false);
    } catch (e) {
      _updateStatus(SyncEngineStatus.error);
      return SyncResult(pushed: 0, pulled: 0, skipped: false, error: e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Get the current sync token.
  String? get lastSyncToken => _lastSyncToken;

  /// Get the number of pending offline operations.
  int get pendingOperations => queueManager.pendingCount;

  Future<int> _replayQueue() async {
    if (queueManager.isEmpty) return 0;

    int replayed = 0;
    final operations = List<QueuedOperation>.from(queueManager.pending);

    for (final op in operations) {
      if (op.retryCount >= maxRetries) continue;

      try {
        await apiService.push(
          terminalId: terminalId,
          changes: [
            {'table': op.table, 'operation': op.type.name, 'data': op.data, 'client_timestamp': op.createdAt.toIso8601String()},
          ],
          syncToken: _lastSyncToken,
        );
        await queueManager.dequeue(op.id);
        replayed++;
      } catch (e) {
        await queueManager.markFailed(op.id, e.toString());
      }
    }

    return replayed;
  }

  void _onConnectivityChanged(ConnectivityStatus status) {
    if (status == ConnectivityStatus.online) {
      _updateStatus(SyncEngineStatus.syncing);
      _replayQueue().then((_) => syncNow());
      webSocket.connect();
    } else {
      _updateStatus(SyncEngineStatus.offline);
      webSocket.disconnect();
    }
  }

  void _onWebSocketEvent(SyncEvent event) {
    if (event.type == 'data_changed') {
      // Trigger a targeted pull for the affected table
      syncNow();
    }
  }

  void _updateStatus(SyncEngineStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _statusController.add(status);
    }
  }

  /// Shut down the sync engine.
  Future<void> stop() async {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
    await _connectivitySub?.cancel();
    await _wsSub?.cancel();
    connectivity.stopMonitoring();
    await webSocket.disconnect();
    _statusController.close();
  }
}

enum SyncEngineStatus { idle, syncing, offline, error }

class SyncResult {
  final int pushed;
  final int pulled;
  final bool skipped;
  final String? error;

  const SyncResult({required this.pushed, required this.pulled, this.skipped = false, this.error});

  bool get hasError => error != null;
}
