import 'dart:async';

import 'package:wameedpos/features/sync/data/remote/sync_api_service.dart';
import 'package:wameedpos/features/sync/services/data_integrity_service.dart';

/// Handles incremental (delta) sync using sync tokens for efficient data transfer.
/// Only fetches records modified since the last successful sync.
class DeltaSyncService {
  DeltaSyncService({required this.apiService, required this.integrityService, this.maxBatchSize = 100});

  final SyncApiService apiService;
  final DataIntegrityService integrityService;
  final int maxBatchSize;

  String? _lastSyncToken;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  String? get lastSyncToken => _lastSyncToken;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Initialize with a stored sync token.
  void initialize({String? syncToken}) {
    _lastSyncToken = syncToken;
  }

  /// Pull only changed records since last sync token.
  Future<DeltaSyncResult> pullDelta({required String terminalId, List<String>? tables}) async {
    if (_isSyncing) {
      return const DeltaSyncResult(pulled: 0, hasMore: false, skipped: true);
    }

    _isSyncing = true;
    try {
      final result = await apiService.pull(terminalId: terminalId, tables: tables, syncToken: _lastSyncToken);

      final changes = List<Map<String, dynamic>>.from(result['changes'] as List? ?? []);
      final recordsCount = result['records_count'] as int? ?? 0;
      final newToken = result['sync_token'] as String?;
      final serverChecksum = result['checksum'] as String?;

      // Verify data integrity if checksum is provided
      if (serverChecksum != null) {
        final localChecksum = integrityService.computeChecksum(changes);
        if (localChecksum != serverChecksum) {
          return const DeltaSyncResult(pulled: 0, hasMore: false, error: 'Checksum verification failed');
        }
      }

      // Check if any table has more records
      bool hasMore = false;
      for (final change in changes) {
        if (change['has_more'] == true) {
          hasMore = true;
          break;
        }
      }

      if (newToken != null) {
        _lastSyncToken = newToken;
      }
      _lastSyncTime = DateTime.now();

      return DeltaSyncResult(pulled: recordsCount, hasMore: hasMore, changes: changes, syncToken: newToken);
    } catch (e) {
      return DeltaSyncResult(pulled: 0, hasMore: false, error: e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Push local changes with checksum verification.
  Future<DeltaPushResult> pushDelta({required String terminalId, required List<Map<String, dynamic>> changes}) async {
    if (_isSyncing) {
      return const DeltaPushResult(pushed: 0, skipped: true);
    }

    _isSyncing = true;
    try {
      final result = await apiService.push(terminalId: terminalId, changes: changes, syncToken: _lastSyncToken);

      final recordsSynced = result['records_synced'] as int? ?? 0;
      final conflicts = List<Map<String, dynamic>>.from(result['conflicts'] as List? ?? []);
      final newToken = result['sync_token'] as String?;

      if (newToken != null) {
        _lastSyncToken = newToken;
      }

      return DeltaPushResult(pushed: recordsSynced, conflictsCount: conflicts.length, conflicts: conflicts, syncToken: newToken);
    } catch (e) {
      return DeltaPushResult(pushed: 0, error: e.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// Reset the sync token to force a full re-sync.
  void resetToken() {
    _lastSyncToken = null;
    _lastSyncTime = null;
  }
}

class DeltaSyncResult {

  const DeltaSyncResult({
    required this.pulled,
    required this.hasMore,
    this.skipped = false,
    this.error,
    this.changes,
    this.syncToken,
  });
  final int pulled;
  final bool hasMore;
  final bool skipped;
  final String? error;
  final List<Map<String, dynamic>>? changes;
  final String? syncToken;

  bool get hasError => error != null;
}

class DeltaPushResult {

  const DeltaPushResult({
    required this.pushed,
    this.skipped = false,
    this.conflictsCount = 0,
    this.conflicts,
    this.error,
    this.syncToken,
  });
  final int pushed;
  final bool skipped;
  final int conflictsCount;
  final List<Map<String, dynamic>>? conflicts;
  final String? error;
  final String? syncToken;

  bool get hasError => error != null;
  bool get hasConflicts => conflictsCount > 0;
}
