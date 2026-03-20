import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/backup/providers/backup_state.dart';
import 'package:thawani_pos/features/backup/repositories/backup_repository.dart';

// ── Backup List ──────────────────────────────────────────────

final backupListProvider = StateNotifierProvider<BackupListNotifier, BackupListState>(
  (ref) => BackupListNotifier(ref.watch(backupRepositoryProvider)),
);

class BackupListNotifier extends StateNotifier<BackupListState> {
  final BackupRepository _repo;
  BackupListNotifier(this._repo) : super(const BackupListInitial());

  Future<void> load({String? backupType, String? status}) async {
    if (state is! BackupListLoaded) state = const BackupListLoading();
    try {
      final data = await _repo.listBackups(backupType: backupType, status: status);
      state = BackupListLoaded(data);
    } catch (e) {
      if (state is! BackupListLoaded) state = BackupListError(e.toString());
    }
  }
}

// ── Backup Schedule ──────────────────────────────────────────

final backupScheduleProvider = StateNotifierProvider<BackupScheduleNotifier, BackupScheduleState>(
  (ref) => BackupScheduleNotifier(ref.watch(backupRepositoryProvider)),
);

class BackupScheduleNotifier extends StateNotifier<BackupScheduleState> {
  final BackupRepository _repo;
  BackupScheduleNotifier(this._repo) : super(const BackupScheduleInitial());

  Future<void> load() async {
    if (state is! BackupScheduleLoaded) state = const BackupScheduleLoading();
    try {
      final data = await _repo.getSchedule();
      state = BackupScheduleLoaded(data);
    } catch (e) {
      if (state is! BackupScheduleLoaded) state = BackupScheduleError(e.toString());
    }
  }

  Future<void> update({
    required bool autoBackupEnabled,
    required String frequency,
    required int retentionDays,
    required bool encryptBackups,
  }) async {
    state = const BackupScheduleLoading();
    try {
      final data = await _repo.updateSchedule(
        autoBackupEnabled: autoBackupEnabled,
        frequency: frequency,
        retentionDays: retentionDays,
        encryptBackups: encryptBackups,
      );
      state = BackupScheduleLoaded(data);
    } catch (e) {
      state = BackupScheduleError(e.toString());
    }
  }
}

// ── Backup Storage ───────────────────────────────────────────

final backupStorageProvider = StateNotifierProvider<BackupStorageNotifier, BackupStorageState>(
  (ref) => BackupStorageNotifier(ref.watch(backupRepositoryProvider)),
);

class BackupStorageNotifier extends StateNotifier<BackupStorageState> {
  final BackupRepository _repo;
  BackupStorageNotifier(this._repo) : super(const BackupStorageInitial());

  Future<void> load() async {
    if (state is! BackupStorageLoaded) state = const BackupStorageLoading();
    try {
      final data = await _repo.getStorageUsage();
      state = BackupStorageLoaded(data);
    } catch (e) {
      if (state is! BackupStorageLoaded) state = BackupStorageError(e.toString());
    }
  }
}

// ── Backup Operations ────────────────────────────────────────

final backupOperationProvider = StateNotifierProvider<BackupOperationNotifier, BackupOperationState>(
  (ref) => BackupOperationNotifier(ref.watch(backupRepositoryProvider)),
);

class BackupOperationNotifier extends StateNotifier<BackupOperationState> {
  final BackupRepository _repo;
  BackupOperationNotifier(this._repo) : super(const BackupOperationIdle());

  Future<void> createBackup({required String terminalId, String backupType = 'manual', bool encrypt = false}) async {
    state = const BackupOperationRunning();
    try {
      final data = await _repo.createBackup(terminalId: terminalId, backupType: backupType, encrypt: encrypt);
      state = BackupOperationSuccess(data);
    } catch (e) {
      state = BackupOperationError(e.toString());
    }
  }

  Future<void> restoreBackup(String backupId) async {
    state = const BackupOperationRunning();
    try {
      final data = await _repo.restoreBackup(backupId);
      state = BackupOperationSuccess(data);
    } catch (e) {
      state = BackupOperationError(e.toString());
    }
  }

  Future<void> verifyBackup(String backupId) async {
    state = const BackupOperationRunning();
    try {
      final data = await _repo.verifyBackup(backupId);
      state = BackupOperationSuccess(data);
    } catch (e) {
      state = BackupOperationError(e.toString());
    }
  }

  Future<void> deleteBackup(String backupId) async {
    state = const BackupOperationRunning();
    try {
      final data = await _repo.deleteBackup(backupId);
      state = BackupOperationSuccess(data);
    } catch (e) {
      state = BackupOperationError(e.toString());
    }
  }

  Future<void> exportData({required List<String> tables, String format = 'json', bool includeImages = false}) async {
    state = const BackupOperationRunning();
    try {
      final data = await _repo.exportData(tables: tables, format: format, includeImages: includeImages);
      state = BackupOperationSuccess(data);
    } catch (e) {
      state = BackupOperationError(e.toString());
    }
  }

  void reset() {
    state = const BackupOperationIdle();
  }
}
