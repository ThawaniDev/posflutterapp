import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/auto_update/providers/auto_update_state.dart';
import 'package:thawani_pos/features/auto_update/repositories/auto_update_repository.dart';

// ─── Update Check Provider ────────────────────────────
final updateCheckProvider = StateNotifierProvider<UpdateCheckNotifier, UpdateCheckState>(
  (ref) => UpdateCheckNotifier(ref.read(autoUpdateRepositoryProvider)),
);

class UpdateCheckNotifier extends StateNotifier<UpdateCheckState> {
  final AutoUpdateRepository _repo;
  UpdateCheckNotifier(this._repo) : super(const UpdateCheckInitial());

  Future<void> check({required String currentVersion, required String platform, String? channel}) async {
    state = const UpdateCheckLoading();
    try {
      final res = await _repo.checkForUpdate(currentVersion: currentVersion, platform: platform, channel: channel);
      final data = res['data'] as Map<String, dynamic>? ?? res;
      state = UpdateCheckLoaded(
        updateAvailable: data['update_available'] == true,
        latestVersion: data['latest_version']?.toString(),
        downloadUrl: data['download_url']?.toString(),
        storeUrl: data['store_url']?.toString(),
        releaseNotes: data['release_notes']?.toString(),
        releaseNotesAr: data['release_notes_ar']?.toString(),
        isForceUpdate: data['is_force_update'] == true,
        releaseId: data['release_id']?.toString(),
        raw: data,
      );
    } catch (e) {
      state = UpdateCheckError(e.toString());
    }
  }
}

// ─── Changelog Provider ──────────────────────────────
final changelogProvider = StateNotifierProvider<ChangelogNotifier, ChangelogState>(
  (ref) => ChangelogNotifier(ref.read(autoUpdateRepositoryProvider)),
);

class ChangelogNotifier extends StateNotifier<ChangelogState> {
  final AutoUpdateRepository _repo;
  ChangelogNotifier(this._repo) : super(const ChangelogInitial());

  Future<void> load({String? platform, String? channel}) async {
    state = const ChangelogLoading();
    try {
      final res = await _repo.getChangelog(platform: platform, channel: channel);
      final data = res['data'];
      final list = data is List ? data.cast<Map<String, dynamic>>() : <Map<String, dynamic>>[];
      state = ChangelogLoaded(releases: list);
    } catch (e) {
      state = ChangelogError(e.toString());
    }
  }
}

// ─── Update History Provider ──────────────────────────
final updateHistoryProvider = StateNotifierProvider<UpdateHistoryNotifier, UpdateHistoryState>(
  (ref) => UpdateHistoryNotifier(ref.read(autoUpdateRepositoryProvider)),
);

class UpdateHistoryNotifier extends StateNotifier<UpdateHistoryState> {
  final AutoUpdateRepository _repo;
  UpdateHistoryNotifier(this._repo) : super(const HistoryInitial());

  Future<void> load() async {
    state = const HistoryLoading();
    try {
      final res = await _repo.getUpdateHistory();
      final data = res['data'];
      final list = data is List ? data.cast<Map<String, dynamic>>() : <Map<String, dynamic>>[];
      state = HistoryLoaded(entries: list);
    } catch (e) {
      state = HistoryError(e.toString());
    }
  }
}

// ─── Update Operation Provider ────────────────────────
final updateOperationProvider = StateNotifierProvider<UpdateOperationNotifier, UpdateOperationState>(
  (ref) => UpdateOperationNotifier(ref.read(autoUpdateRepositoryProvider)),
);

class UpdateOperationNotifier extends StateNotifier<UpdateOperationState> {
  final AutoUpdateRepository _repo;
  UpdateOperationNotifier(this._repo) : super(const UpdateOperationIdle());

  Future<void> reportStatus({required String releaseId, required String status, String? errorMessage}) async {
    state = const UpdateOperationRunning('report_status');
    try {
      final res = await _repo.reportStatus(releaseId: releaseId, status: status, errorMessage: errorMessage);
      final msg = res['message']?.toString() ?? 'Status reported';
      state = UpdateOperationSuccess(msg, data: res['data'] as Map<String, dynamic>?);
    } catch (e) {
      state = UpdateOperationError(e.toString());
    }
  }

  void reset() => state = const UpdateOperationIdle();
}
