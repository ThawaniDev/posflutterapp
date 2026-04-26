import 'package:wameedpos/features/sync/models/sync_conflict.dart';

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
  const SyncStatusLoaded({
    required this.serverOnline,
    required this.serverTimestamp,
    this.lastSync,
    required this.pendingConflicts,
    required this.failedSyncs24h,
    required this.recentLogs,
  });
  final bool serverOnline;
  final String serverTimestamp;
  final Map<String, dynamic>? lastSync;
  final int pendingConflicts;
  final int failedSyncs24h;
  final List<Map<String, dynamic>> recentLogs;
}

final class SyncStatusError extends SyncStatusState {
  const SyncStatusError(this.message);
  final String message;
}

// ─── Sync Operation State ──────────────────────────────────
sealed class SyncOperationState {
  const SyncOperationState();
}

final class SyncOperationIdle extends SyncOperationState {
  const SyncOperationIdle();
}

final class SyncOperationRunning extends SyncOperationState {
  const SyncOperationRunning(this.operation);
  final String operation;
}

final class SyncOperationSuccess extends SyncOperationState {
  const SyncOperationSuccess({required this.recordsSynced, required this.syncToken});
  final int recordsSynced;
  final String syncToken;
}

final class SyncOperationError extends SyncOperationState {
  const SyncOperationError(this.message);
  final String message;
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
  const SyncConflictListLoaded({required this.conflicts, required this.currentPage, required this.lastPage, required this.total});
  final List<SyncConflict> conflicts;
  final int currentPage;
  final int lastPage;
  final int total;
}

final class SyncConflictListError extends SyncConflictListState {
  const SyncConflictListError(this.message);
  final String message;
}

// ─── Sync Logs State ──────────────────────────────────────
sealed class SyncLogsState {
  const SyncLogsState();
}

final class SyncLogsInitial extends SyncLogsState {
  const SyncLogsInitial();
}

final class SyncLogsLoading extends SyncLogsState {
  const SyncLogsLoading();
}

final class SyncLogsLoaded extends SyncLogsState {
  const SyncLogsLoaded({required this.logs, required this.currentPage, required this.lastPage, required this.total});
  final List<Map<String, dynamic>> logs;
  final int currentPage;
  final int lastPage;
  final int total;
}

final class SyncLogsError extends SyncLogsState {
  const SyncLogsError(this.message);
  final String message;
}
