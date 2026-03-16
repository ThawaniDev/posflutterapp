import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/sync/models/sync_conflict.dart';
import 'package:thawani_pos/features/sync/providers/sync_state.dart';
import 'package:thawani_pos/features/sync/repositories/sync_repository.dart';

// ─── Sync Status Provider ──────────────────────────────────
class SyncStatusNotifier extends StateNotifier<SyncStatusState> {
  final SyncRepository _repo;
  SyncStatusNotifier(this._repo) : super(const SyncStatusInitial());

  Future<void> load() async {
    state = const SyncStatusLoading();
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
      state = SyncStatusError(e.toString());
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
    state = const SyncConflictListLoading();
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
      state = SyncConflictListError(e.toString());
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
