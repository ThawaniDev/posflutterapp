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
  final bool updateAvailable;
  final String? latestVersion;
  final String? downloadUrl;
  final String? storeUrl;
  final String? releaseNotes;
  final String? releaseNotesAr;
  final bool isForceUpdate;
  final String? releaseId;
  final Map<String, dynamic> raw;
}

class UpdateCheckError extends UpdateCheckState {
  const UpdateCheckError(this.message);
  final String message;
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
  const ChangelogLoaded({required this.releases});
  final List<Map<String, dynamic>> releases;
}

class ChangelogError extends ChangelogState {
  const ChangelogError(this.message);
  final String message;
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
  const HistoryLoaded({required this.entries});
  final List<Map<String, dynamic>> entries;
}

class HistoryError extends UpdateHistoryState {
  const HistoryError(this.message);
  final String message;
}

// ─── Update Operation State (report status) ───────────
sealed class UpdateOperationState {
  const UpdateOperationState();
}

class UpdateOperationIdle extends UpdateOperationState {
  const UpdateOperationIdle();
}

class UpdateOperationRunning extends UpdateOperationState {
  const UpdateOperationRunning(this.operation);
  final String operation;
}

class UpdateOperationSuccess extends UpdateOperationState {
  const UpdateOperationSuccess(this.message, {this.data});
  final String message;
  final Map<String, dynamic>? data;
}

class UpdateOperationError extends UpdateOperationState {
  const UpdateOperationError(this.message);
  final String message;
}
