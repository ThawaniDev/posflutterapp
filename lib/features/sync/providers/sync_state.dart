import 'package:thawani_pos/features/sync/models/sync_conflict.dart';

// ─── Sync Status State ─────────────────────────────────────
sealed class SyncStatusState {
  const SyncStatusState();
}

final class SyncStatusInitial extends SyncStatusState {
  const SyncStatusInitial();
}

final class SyncStatusLoading extends SyncStatusState {
  const SyncStatusLoading();
}

final class SyncStatusLoaded extends SyncStatusState {
  final bool serverOnline;
  final String serverTimestamp;
  final Map<String, dynamic>? lastSync;
  final int pendingConflicts;
  final int failedSyncs24h;
  final List<Map<String, dynamic>> recentLogs;

  const SyncStatusLoaded({
    required this.serverOnline,
    required this.serverTimestamp,
    this.lastSync,
    required this.pendingConflicts,
    required this.failedSyncs24h,
    required this.recentLogs,
  });
}

final class SyncStatusError extends SyncStatusState {
  final String message;
  const SyncStatusError(this.message);
}

// ─── Sync Operation State ──────────────────────────────────
sealed class SyncOperationState {
  const SyncOperationState();
}

final class SyncOperationIdle extends SyncOperationState {
  const SyncOperationIdle();
}

final class SyncOperationRunning extends SyncOperationState {
  final String operation;
  const SyncOperationRunning(this.operation);
}

final class SyncOperationSuccess extends SyncOperationState {
  final int recordsSynced;
  final String syncToken;
  const SyncOperationSuccess({required this.recordsSynced, required this.syncToken});
}

final class SyncOperationError extends SyncOperationState {
  final String message;
  const SyncOperationError(this.message);
}

// ─── Conflict List State ───────────────────────────────────
sealed class SyncConflictListState {
  const SyncConflictListState();
}

final class SyncConflictListInitial extends SyncConflictListState {
  const SyncConflictListInitial();
}

final class SyncConflictListLoading extends SyncConflictListState {
  const SyncConflictListLoading();
}

final class SyncConflictListLoaded extends SyncConflictListState {
  final List<SyncConflict> conflicts;
  final int currentPage;
  final int lastPage;
  final int total;

  const SyncConflictListLoaded({required this.conflicts, required this.currentPage, required this.lastPage, required this.total});
}

final class SyncConflictListError extends SyncConflictListState {
  final String message;
  const SyncConflictListError(this.message);
}
