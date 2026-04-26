import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/security/data/remote/security_api_service.dart';

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  return SecurityRepository(ref.watch(securityApiServiceProvider));
});

class SecurityRepository {

  SecurityRepository(this._api);
  final SecurityApiService _api;

  // Overview
  Future<Map<String, dynamic>> getOverview({required String storeId}) => _api.getOverview(storeId: storeId);

  // Policy
  Future<Map<String, dynamic>> getPolicy({required String storeId}) => _api.getPolicy(storeId: storeId);

  Future<Map<String, dynamic>> updatePolicy({required String storeId, required Map<String, dynamic> data}) =>
      _api.updatePolicy(storeId: storeId, data: data);

  // Audit Logs
  Future<Map<String, dynamic>> listAuditLogs({
    required String storeId,
    String? action,
    String? severity,
    String? userId,
    int? perPage,
  }) => _api.listAuditLogs(storeId: storeId, action: action, severity: severity, userId: userId, perPage: perPage);

  Future<Map<String, dynamic>> recordAudit({required Map<String, dynamic> data}) => _api.recordAudit(data: data);

  Future<Map<String, dynamic>> getAuditStats({required String storeId}) => _api.getAuditStats(storeId: storeId);

  Future<String> exportAuditLogs({
    required String storeId,
    String? action,
    String? severity,
    String? since,
  }) => _api.exportAuditLogs(storeId: storeId, action: action, severity: severity, since: since);

  // Devices
  Future<Map<String, dynamic>> listDevices({required String storeId, bool? activeOnly}) =>
      _api.listDevices(storeId: storeId, activeOnly: activeOnly);

  Future<Map<String, dynamic>> registerDevice({required Map<String, dynamic> data}) => _api.registerDevice(data: data);

  Future<Map<String, dynamic>> getDevice({required String deviceId}) => _api.getDevice(deviceId: deviceId);

  Future<Map<String, dynamic>> deactivateDevice({required String deviceId}) => _api.deactivateDevice(deviceId: deviceId);

  Future<Map<String, dynamic>> requestRemoteWipe({required String deviceId}) => _api.requestRemoteWipe(deviceId: deviceId);

  Future<Map<String, dynamic>> deviceHeartbeat({required String deviceId, Map<String, dynamic>? data}) =>
      _api.deviceHeartbeat(deviceId: deviceId, data: data);

  // Login Attempts
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

  Future<Map<String, dynamic>> isLockedOut({required String storeId, required String userIdentifier}) =>
      _api.isLockedOut(storeId: storeId, userIdentifier: userIdentifier);

  Future<Map<String, dynamic>> loginAttemptsStats({required String storeId}) => _api.loginAttemptsStats(storeId: storeId);

  // Sessions
  Future<Map<String, dynamic>> listSessions({required String storeId, String? status}) =>
      _api.listSessions(storeId: storeId, status: status);

  Future<Map<String, dynamic>> startSession({required Map<String, dynamic> data}) => _api.startSession(data: data);

  Future<Map<String, dynamic>> endSession({required String sessionId}) => _api.endSession(sessionId: sessionId);

  Future<Map<String, dynamic>> sessionHeartbeat({required String sessionId}) => _api.sessionHeartbeat(sessionId: sessionId);

  Future<Map<String, dynamic>> endAllSessions({required String storeId, String? userId}) =>
      _api.endAllSessions(storeId: storeId, userId: userId);

  // Incidents
  Future<Map<String, dynamic>> listIncidents({required String storeId, String? severity, bool? isResolved}) =>
      _api.listIncidents(storeId: storeId, severity: severity, isResolved: isResolved);

  Future<Map<String, dynamic>> createIncident({required Map<String, dynamic> data}) => _api.createIncident(data: data);

  Future<Map<String, dynamic>> resolveIncident({required String incidentId, String? resolutionNotes}) =>
      _api.resolveIncident(incidentId: incidentId, resolutionNotes: resolutionNotes);
}
