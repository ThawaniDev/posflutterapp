import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final backupApiServiceProvider = Provider<BackupApiService>((ref) {
  return BackupApiService(ref.watch(dioClientProvider));
});

class BackupApiService {
  BackupApiService(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> createBackup({
    required String terminalId,
    String backupType = 'manual',
    bool encrypt = false,
  }) async {
    final res = await _dio.post(
      ApiEndpoints.backupCreate,
      data: {'terminal_id': terminalId, 'backup_type': backupType, 'encrypt': encrypt},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listBackups({String? backupType, String? status, int? perPage}) async {
    final params = <String, dynamic>{};
    if (backupType != null) params['backup_type'] = backupType;
    if (status != null) params['status'] = status;
    if (perPage != null) params['per_page'] = perPage;
    final res = await _dio.get(ApiEndpoints.backupList, queryParameters: params);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBackup(String backupId) async {
    final res = await _dio.get(ApiEndpoints.backupById(backupId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> restoreBackup(String backupId) async {
    final res = await _dio.post(ApiEndpoints.backupRestore(backupId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyBackup(String backupId) async {
    final res = await _dio.post(ApiEndpoints.backupVerify(backupId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSchedule() async {
    final res = await _dio.get(ApiEndpoints.backupSchedule);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateSchedule({
    required bool autoBackupEnabled,
    required String frequency,
    required int retentionDays,
    required bool encryptBackups,
    bool localBackupEnabled = true,
    bool cloudBackupEnabled = true,
    int backupHour = 2,
  }) async {
    final res = await _dio.put(
      ApiEndpoints.backupSchedule,
      data: {
        'auto_backup_enabled': autoBackupEnabled,
        'frequency': frequency,
        'retention_days': retentionDays,
        'encrypt_backups': encryptBackups,
        'local_backup_enabled': localBackupEnabled,
        'cloud_backup_enabled': cloudBackupEnabled,
        'backup_hour': backupHour,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getStorageUsage() async {
    final res = await _dio.get(ApiEndpoints.backupStorage);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteBackup(String backupId) async {
    final res = await _dio.delete(ApiEndpoints.backupDelete(backupId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> exportData({
    required List<String> tables,
    String format = 'json',
    bool includeImages = false,
  }) async {
    final res = await _dio.post(
      ApiEndpoints.backupExport,
      data: {'tables': tables, 'format': format, 'include_images': includeImages},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProviderStatus() async {
    final res = await _dio.get(ApiEndpoints.backupProviderStatus);
    return res.data as Map<String, dynamic>;
  }
}
