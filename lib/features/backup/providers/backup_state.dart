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
  final Map<String, dynamic> data;
  const BackupListLoaded(this.data);
}

class BackupListError extends BackupListState {
  final String message;
  const BackupListError(this.message);
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
  final Map<String, dynamic> data;
  const BackupScheduleLoaded(this.data);
}

class BackupScheduleError extends BackupScheduleState {
  final String message;
  const BackupScheduleError(this.message);
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
  final Map<String, dynamic> data;
  const BackupStorageLoaded(this.data);
}

class BackupStorageError extends BackupStorageState {
  final String message;
  const BackupStorageError(this.message);
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
  final Map<String, dynamic> data;
  const BackupOperationSuccess(this.data);
}

class BackupOperationError extends BackupOperationState {
  final String message;
  const BackupOperationError(this.message);
}
