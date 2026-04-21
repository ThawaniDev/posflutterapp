sealed class BackupListState {
  const BackupListState();
}

class BackupListInitial extends BackupListState {
  const BackupListInitial();
}

class BackupListLoading extends BackupListState {
  const BackupListLoading();
}

class BackupListLoaded extends BackupListState {
  const BackupListLoaded(this.data);
  final Map<String, dynamic> data;
}

class BackupListError extends BackupListState {
  const BackupListError(this.message);
  final String message;
}

// ── Schedule State ───────────────────────────────────────────

sealed class BackupScheduleState {
  const BackupScheduleState();
}

class BackupScheduleInitial extends BackupScheduleState {
  const BackupScheduleInitial();
}

class BackupScheduleLoading extends BackupScheduleState {
  const BackupScheduleLoading();
}

class BackupScheduleLoaded extends BackupScheduleState {
  const BackupScheduleLoaded(this.data);
  final Map<String, dynamic> data;
}

class BackupScheduleError extends BackupScheduleState {
  const BackupScheduleError(this.message);
  final String message;
}

// ── Storage State ────────────────────────────────────────────

sealed class BackupStorageState {
  const BackupStorageState();
}

class BackupStorageInitial extends BackupStorageState {
  const BackupStorageInitial();
}

class BackupStorageLoading extends BackupStorageState {
  const BackupStorageLoading();
}

class BackupStorageLoaded extends BackupStorageState {
  const BackupStorageLoaded(this.data);
  final Map<String, dynamic> data;
}

class BackupStorageError extends BackupStorageState {
  const BackupStorageError(this.message);
  final String message;
}

// ── Operation State (create, restore, verify, delete, export) ─

sealed class BackupOperationState {
  const BackupOperationState();
}

class BackupOperationIdle extends BackupOperationState {
  const BackupOperationIdle();
}

class BackupOperationRunning extends BackupOperationState {
  const BackupOperationRunning();
}

class BackupOperationSuccess extends BackupOperationState {
  const BackupOperationSuccess(this.data);
  final Map<String, dynamic> data;
}

class BackupOperationError extends BackupOperationState {
  const BackupOperationError(this.message);
  final String message;
}
