import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/backup/data/remote/backup_api_service.dart';

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(ref.watch(backupApiServiceProvider));
});

class BackupRepository {
  BackupRepository(this._api);
  final BackupApiService _api;

  Future<Map<String, dynamic>> createBackup({required String terminalId, String backupType = 'manual', bool encrypt = false}) =>
      _api.createBackup(terminalId: terminalId, backupType: backupType, encrypt: encrypt);

  Future<Map<String, dynamic>> listBackups({String? backupType, String? status, int? perPage}) =>
      _api.listBackups(backupType: backupType, status: status, perPage: perPage);

  Future<Map<String, dynamic>> getBackup(String backupId) => _api.getBackup(backupId);

  Future<Map<String, dynamic>> restoreBackup(String backupId) => _api.restoreBackup(backupId);

  Future<Map<String, dynamic>> verifyBackup(String backupId) => _api.verifyBackup(backupId);

  Future<Map<String, dynamic>> getSchedule() => _api.getSchedule();

  Future<Map<String, dynamic>> updateSchedule({
    required bool autoBackupEnabled,
    required String frequency,
    required int retentionDays,
    required bool encryptBackups,
    bool localBackupEnabled = true,
    bool cloudBackupEnabled = true,
    int backupHour = 2,
  }) => _api.updateSchedule(
    autoBackupEnabled: autoBackupEnabled,
    frequency: frequency,
    retentionDays: retentionDays,
    encryptBackups: encryptBackups,
    localBackupEnabled: localBackupEnabled,
    cloudBackupEnabled: cloudBackupEnabled,
    backupHour: backupHour,
  );

  Future<Map<String, dynamic>> getStorageUsage() => _api.getStorageUsage();

  Future<Map<String, dynamic>> deleteBackup(String backupId) => _api.deleteBackup(backupId);

  Future<Map<String, dynamic>> exportData({required List<String> tables, String format = 'json', bool includeImages = false}) =>
      _api.exportData(tables: tables, format: format, includeImages: includeImages);

  Future<Map<String, dynamic>> getProviderStatus() => _api.getProviderStatus();
}
