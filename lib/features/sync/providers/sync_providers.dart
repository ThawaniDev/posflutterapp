import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/sync/data/remote/sync_api_service.dart';
import 'package:wameedpos/features/sync/models/sync_conflict.dart';
import 'package:wameedpos/features/sync/providers/sync_state.dart';
import 'package:wameedpos/features/sync/repositories/sync_repository.dart';
import 'package:wameedpos/features/sync/services/connectivity_service.dart';
import 'package:wameedpos/features/sync/services/conflict_resolver_service.dart' as conflict_resolver;
import 'package:wameedpos/features/sync/services/data_integrity_service.dart';
import 'package:wameedpos/features/sync/services/delta_sync_service.dart';
import 'package:wameedpos/features/sync/services/full_sync_service.dart';
import 'package:wameedpos/features/sync/services/sync_engine.dart';
import 'package:wameedpos/features/sync/services/sync_queue_manager.dart';
import 'package:wameedpos/features/sync/services/sync_retry_service.dart';
import 'package:wameedpos/features/sync/services/websocket_service.dart';

// ─── Connectivity Provider ─────────────────────────────────

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  service.startMonitoring();
  return service.statusStream;
});

// ─── WebSocket Provider ────────────────────────────────────

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final dio = ref.watch(dioClientProvider);
  final baseUrl = dio.options.baseUrl;
  final service = WebSocketService(baseUrl: baseUrl);
  ref.onDispose(() => service.dispose());
  return service;
});

final wsConnectionStateProvider = StreamProvider<WebSocketConnectionState>((ref) {
  return ref.watch(webSocketServiceProvider).connectionState;
});

// ─── Sync Queue Provider ───────────────────────────────────

final syncQueueManagerProvider = Provider<SyncQueueManager>((ref) {
  return SyncQueueManager(storagePath: '.');
});

// ─── Sync Engine Provider ──────────────────────────────────

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    apiService: ref.watch(syncApiServiceProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    queueManager: ref.watch(syncQueueManagerProvider),
    webSocket: ref.watch(webSocketServiceProvider),
    terminalId: 'default',
  );
  ref.onDispose(() => engine.stop());
  return engine;
});

final syncEngineStatusProvider = StreamProvider<SyncEngineStatus>((ref) {
  return ref.watch(syncEngineProvider).statusStream;
});

// ─── Data Integrity Provider ───────────────────────────────

final dataIntegrityServiceProvider = Provider<DataIntegrityService>((ref) {
  return DataIntegrityService();
});

// ─── Delta Sync Provider ───────────────────────────────────

final deltaSyncServiceProvider = Provider<DeltaSyncService>((ref) {
  return DeltaSyncService(
    apiService: ref.watch(syncApiServiceProvider),
    integrityService: ref.watch(dataIntegrityServiceProvider),
  );
});

// ─── Full Sync Provider ────────────────────────────────────

final fullSyncServiceProvider = Provider<FullSyncService>((ref) {
  final service = FullSyncService(
    apiService: ref.watch(syncApiServiceProvider),
    integrityService: ref.watch(dataIntegrityServiceProvider),
  );
  ref.onDispose(() => service.dispose());
  return service;
});

final fullSyncProgressProvider = StreamProvider<FullSyncProgress>((ref) {
  return ref.watch(fullSyncServiceProvider).progressStream;
});

// ─── Conflict Resolver Provider ────────────────────────────

final conflictResolverServiceProvider = Provider<conflict_resolver.ConflictResolverService>((ref) {
  final service = conflict_resolver.ConflictResolverService(apiService: ref.watch(syncApiServiceProvider));
  ref.onDispose(() => service.dispose());
  return service;
});

final conflictStreamProvider = StreamProvider<List<conflict_resolver.SyncConflict>>((ref) {
  return ref.watch(conflictResolverServiceProvider).conflictsStream;
});

// ─── Sync Retry Provider ───────────────────────────────────

final syncRetryServiceProvider = Provider<SyncRetryService>((ref) {
  final service = SyncRetryService();
  ref.onDispose(() => service.dispose());
  return service;
});

final retryStreamProvider = StreamProvider<RetryAttempt>((ref) {
  return ref.watch(syncRetryServiceProvider).retryStream;
});

// ─── Sync Status Provider ──────────────────────────────────
class SyncStatusNotifier extends StateNotifier<SyncStatusState> {
  final SyncRepository _repo;
  SyncStatusNotifier(this._repo) : super(const SyncStatusInitial());

  Future<void> load() async {
    if (state is! SyncStatusLoaded) state = const SyncStatusLoading();
    try {
      final data = await _repo.status();
      state = SyncStatusLoaded(
        serverOnline: data['server_online'] as bool,
        serverTimestamp: data['server_timestamp'] as String,
        lastSync: data['last_sync'] as Map<String, dynamic>?,
        pendingConflicts: data['pending_conflicts'] as int,
        failedSyncs24h: data['failed_syncs_24h'] as int,
        recentLogs: List<Map<String, dynamic>>.from(data['recent_logs'] as List),
      );
    } catch (e) {
      if (state is! SyncStatusLoaded) state = SyncStatusError(e.toString());
    }
  }
}

final syncStatusProvider = StateNotifierProvider<SyncStatusNotifier, SyncStatusState>((ref) {
  return SyncStatusNotifier(ref.watch(syncRepositoryProvider));
});

// ─── Sync Operation Provider ───────────────────────────────
class SyncOperationNotifier extends StateNotifier<SyncOperationState> {
  final SyncRepository _repo;
  SyncOperationNotifier(this._repo) : super(const SyncOperationIdle());

  Future<void> push({required String terminalId, required List<Map<String, dynamic>> changes, String? syncToken}) async {
    state = const SyncOperationRunning('push');
    try {
      final data = await _repo.push(terminalId: terminalId, changes: changes, syncToken: syncToken);
      state = SyncOperationSuccess(recordsSynced: data['records_synced'] as int, syncToken: data['sync_token'] as String);
    } catch (e) {
      state = SyncOperationError(e.toString());
    }
  }

  Future<void> pull({required String terminalId, List<String>? tables, String? syncToken}) async {
    state = const SyncOperationRunning('pull');
    try {
      final data = await _repo.pull(terminalId: terminalId, tables: tables, syncToken: syncToken);
      state = SyncOperationSuccess(recordsSynced: data['records_count'] as int, syncToken: data['sync_token'] as String);
    } catch (e) {
      state = SyncOperationError(e.toString());
    }
  }

  Future<void> fullSync({required String terminalId}) async {
    state = const SyncOperationRunning('full');
    try {
      final data = await _repo.fullSync(terminalId: terminalId);
      state = SyncOperationSuccess(recordsSynced: data['records_count'] as int, syncToken: data['sync_token'] as String);
    } catch (e) {
      state = SyncOperationError(e.toString());
    }
  }

  void reset() => state = const SyncOperationIdle();
}

final syncOperationProvider = StateNotifierProvider<SyncOperationNotifier, SyncOperationState>((ref) {
  return SyncOperationNotifier(ref.watch(syncRepositoryProvider));
});

// ─── Conflict List Provider ───────────────────────────────
class SyncConflictListNotifier extends StateNotifier<SyncConflictListState> {
  final SyncRepository _repo;
  SyncConflictListNotifier(this._repo) : super(const SyncConflictListInitial());

  Future<void> load({String? status, String? tableName}) async {
    if (state is! SyncConflictListLoaded) state = const SyncConflictListLoading();
    try {
      final data = await _repo.listConflicts(status: status, tableName: tableName);
      final pagination = data['pagination'] as Map<String, dynamic>;
      final conflictsRaw = data['conflicts'] as List;
      state = SyncConflictListLoaded(
        conflicts: conflictsRaw.map((c) => SyncConflict.fromJson(c as Map<String, dynamic>)).toList(),
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
        total: pagination['total'] as int,
      );
    } catch (e) {
      if (state is! SyncConflictListLoaded) state = SyncConflictListError(e.toString());
    }
  }

  Future<void> resolveConflict({required String conflictId, required String resolution}) async {
    try {
      await _repo.resolveConflict(conflictId: conflictId, resolution: resolution);
      // Reload after resolution
      await load(status: 'unresolved');
    } catch (e) {
      state = SyncConflictListError(e.toString());
    }
  }
}

final syncConflictListProvider = StateNotifierProvider<SyncConflictListNotifier, SyncConflictListState>((ref) {
  return SyncConflictListNotifier(ref.watch(syncRepositoryProvider));
});
