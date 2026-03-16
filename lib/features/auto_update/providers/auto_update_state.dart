// ─── Update Check State ────────────────────────────────
sealed class UpdateCheckState {
  const UpdateCheckState();
}

class UpdateCheckInitial extends UpdateCheckState {
  const UpdateCheckInitial();
}

class UpdateCheckLoading extends UpdateCheckState {
  const UpdateCheckLoading();
}

class UpdateCheckLoaded extends UpdateCheckState {
  final bool updateAvailable;
  final String? latestVersion;
  final String? downloadUrl;
  final String? storeUrl;
  final String? releaseNotes;
  final String? releaseNotesAr;
  final bool isForceUpdate;
  final String? releaseId;
  final Map<String, dynamic> raw;

  const UpdateCheckLoaded({
    required this.updateAvailable,
    this.latestVersion,
    this.downloadUrl,
    this.storeUrl,
    this.releaseNotes,
    this.releaseNotesAr,
    this.isForceUpdate = false,
    this.releaseId,
    required this.raw,
  });
}

class UpdateCheckError extends UpdateCheckState {
  final String message;
  const UpdateCheckError(this.message);
}

// ─── Changelog State ──────────────────────────────────
sealed class ChangelogState {
  const ChangelogState();
}

class ChangelogInitial extends ChangelogState {
  const ChangelogInitial();
}

class ChangelogLoading extends ChangelogState {
  const ChangelogLoading();
}

class ChangelogLoaded extends ChangelogState {
  final List<Map<String, dynamic>> releases;
  const ChangelogLoaded({required this.releases});
}

class ChangelogError extends ChangelogState {
  final String message;
  const ChangelogError(this.message);
}

// ─── Update History State ─────────────────────────────
sealed class UpdateHistoryState {
  const UpdateHistoryState();
}

class HistoryInitial extends UpdateHistoryState {
  const HistoryInitial();
}

class HistoryLoading extends UpdateHistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends UpdateHistoryState {
  final List<Map<String, dynamic>> entries;
  const HistoryLoaded({required this.entries});
}

class HistoryError extends UpdateHistoryState {
  final String message;
  const HistoryError(this.message);
}

// ─── Update Operation State (report status) ───────────
sealed class UpdateOperationState {
  const UpdateOperationState();
}

class UpdateOperationIdle extends UpdateOperationState {
  const UpdateOperationIdle();
}

class UpdateOperationRunning extends UpdateOperationState {
  final String operation;
  const UpdateOperationRunning(this.operation);
}

class UpdateOperationSuccess extends UpdateOperationState {
  final String message;
  final Map<String, dynamic>? data;
  const UpdateOperationSuccess(this.message, {this.data});
}

class UpdateOperationError extends UpdateOperationState {
  final String message;
  const UpdateOperationError(this.message);
}
