import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/security/data/remote/security_api_service.dart';

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  return SecurityRepository(ref.watch(securityApiServiceProvider));
});

class SecurityRepository {
  final SecurityApiService _api;

  SecurityRepository(this._api);

  Future<Map<String, dynamic>> getPolicy({required String storeId}) => _api.getPolicy(storeId: storeId);

  Future<Map<String, dynamic>> updatePolicy({required String storeId, required Map<String, dynamic> data}) =>
      _api.updatePolicy(storeId: storeId, data: data);

  Future<Map<String, dynamic>> listAuditLogs({
    required String storeId,
    String? action,
    String? severity,
    String? userId,
    int? perPage,
  }) => _api.listAuditLogs(storeId: storeId, action: action, severity: severity, userId: userId, perPage: perPage);

  Future<Map<String, dynamic>> recordAudit({required Map<String, dynamic> data}) => _api.recordAudit(data: data);

  Future<Map<String, dynamic>> listDevices({required String storeId, bool? activeOnly}) =>
      _api.listDevices(storeId: storeId, activeOnly: activeOnly);

  Future<Map<String, dynamic>> registerDevice({required Map<String, dynamic> data}) => _api.registerDevice(data: data);

  Future<Map<String, dynamic>> deactivateDevice({required String deviceId}) => _api.deactivateDevice(deviceId: deviceId);

  Future<Map<String, dynamic>> requestRemoteWipe({required String deviceId}) => _api.requestRemoteWipe(deviceId: deviceId);

  Future<Map<String, dynamic>> listLoginAttempts({
    required String storeId,
    String? attemptType,
    bool? isSuccessful,
    int? perPage,
  }) => _api.listLoginAttempts(storeId: storeId, attemptType: attemptType, isSuccessful: isSuccessful, perPage: perPage);

  Future<Map<String, dynamic>> recordLoginAttempt({required Map<String, dynamic> data}) => _api.recordLoginAttempt(data: data);

  Future<Map<String, dynamic>> failedAttemptCount({
    required String storeId,
    required String userIdentifier,
    int? windowMinutes,
  }) => _api.failedAttemptCount(storeId: storeId, userIdentifier: userIdentifier, windowMinutes: windowMinutes);
}
