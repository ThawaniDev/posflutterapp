import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final securityApiServiceProvider = Provider<SecurityApiService>((ref) {
  return SecurityApiService(ref.watch(dioClientProvider));
});

class SecurityApiService {

  SecurityApiService(this._dio);
  final Dio _dio;

  // ─── Overview ─────────────────────────────────────────────

  Future<Map<String, dynamic>> getOverview({required String storeId}) async {
    final res = await _dio.get(ApiEndpoints.securityOverviewEndpoint, queryParameters: {'store_id': storeId});
    return res.data as Map<String, dynamic>;
  }

  // ─── Policies ─────────────────────────────────────────────

  Future<Map<String, dynamic>> getPolicy({required String storeId}) async {
    final res = await _dio.get(ApiEndpoints.securityPolicy, queryParameters: {'store_id': storeId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updatePolicy({required String storeId, required Map<String, dynamic> data}) async {
    final res = await _dio.put(ApiEndpoints.securityPolicy, data: data, queryParameters: {'store_id': storeId});
    return res.data as Map<String, dynamic>;
  }

  // ─── Audit Logs ───────────────────────────────────────────

  Future<Map<String, dynamic>> listAuditLogs({
    required String storeId,
    String? action,
    String? severity,
    String? userId,
    int? perPage,
  }) async {
    final res = await _dio.get(
      ApiEndpoints.securityAuditLogs,
      queryParameters: {
        'store_id': storeId,
        'action': ?action,
        'severity': ?severity,
        'user_id': ?userId,
        'per_page': ?perPage,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> recordAudit({required Map<String, dynamic> data}) async {
    final res = await _dio.post(ApiEndpoints.securityAuditLogs, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAuditStats({required String storeId}) async {
    final res = await _dio.get(ApiEndpoints.securityAuditStats, queryParameters: {'store_id': storeId});
    return res.data as Map<String, dynamic>;
  }

  // ─── Devices ──────────────────────────────────────────────

  Future<Map<String, dynamic>> listDevices({required String storeId, bool? activeOnly}) async {
    final res = await _dio.get(
      ApiEndpoints.securityDevices,
      queryParameters: {'store_id': storeId, 'active_only': ?activeOnly},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> registerDevice({required Map<String, dynamic> data}) async {
    final res = await _dio.post(ApiEndpoints.securityDevices, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDevice({required String deviceId}) async {
    final res = await _dio.get(ApiEndpoints.securityDeviceById(deviceId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deactivateDevice({required String deviceId}) async {
    final res = await _dio.put(ApiEndpoints.securityDeviceDeactivate(deviceId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> requestRemoteWipe({required String deviceId}) async {
    final res = await _dio.put(ApiEndpoints.securityDeviceRemoteWipe(deviceId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deviceHeartbeat({required String deviceId, Map<String, dynamic>? data}) async {
    final res = await _dio.put(ApiEndpoints.securityDeviceHeartbeat(deviceId), data: data ?? {});
    return res.data as Map<String, dynamic>;
  }

  // ─── Login Attempts ───────────────────────────────────────

  Future<Map<String, dynamic>> listLoginAttempts({
    required String storeId,
    String? attemptType,
    bool? isSuccessful,
    int? perPage,
  }) async {
    final res = await _dio.get(
      ApiEndpoints.securityLoginAttempts,
      queryParameters: {
        'store_id': storeId,
        'attempt_type': ?attemptType,
        'is_successful': ?isSuccessful,
        'per_page': ?perPage,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> recordLoginAttempt({required Map<String, dynamic> data}) async {
    final res = await _dio.post(ApiEndpoints.securityLoginAttempts, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> failedAttemptCount({
    required String storeId,
    required String userIdentifier,
    int? windowMinutes,
  }) async {
    final res = await _dio.get(
      ApiEndpoints.securityLoginAttemptsFailedCount,
      queryParameters: {
        'store_id': storeId,
        'user_identifier': userIdentifier,
        'window_minutes': ?windowMinutes,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> isLockedOut({required String storeId, required String userIdentifier}) async {
    final res = await _dio.get(
      ApiEndpoints.securityLoginAttemptsIsLockedOut,
      queryParameters: {'store_id': storeId, 'user_identifier': userIdentifier},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> loginAttemptsStats({required String storeId}) async {
    final res = await _dio.get(ApiEndpoints.securityLoginAttemptsStats, queryParameters: {'store_id': storeId});
    return res.data as Map<String, dynamic>;
  }

  // ─── Sessions ─────────────────────────────────────────────

  Future<Map<String, dynamic>> listSessions({required String storeId, String? status}) async {
    final res = await _dio.get(
      ApiEndpoints.securitySessions,
      queryParameters: {'store_id': storeId, 'status': ?status},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> startSession({required Map<String, dynamic> data}) async {
    final res = await _dio.post(ApiEndpoints.securitySessions, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> endSession({required String sessionId}) async {
    final res = await _dio.put(ApiEndpoints.securitySessionEnd(sessionId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sessionHeartbeat({required String sessionId}) async {
    final res = await _dio.put(ApiEndpoints.securitySessionHeartbeat(sessionId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> endAllSessions({required String storeId}) async {
    final res = await _dio.post(ApiEndpoints.securitySessionsEndAll, data: {'store_id': storeId});
    return res.data as Map<String, dynamic>;
  }

  // ─── Incidents ────────────────────────────────────────────

  Future<Map<String, dynamic>> listIncidents({required String storeId, String? severity, bool? isResolved}) async {
    final res = await _dio.get(
      ApiEndpoints.securityIncidents,
      queryParameters: {
        'store_id': storeId,
        'severity': ?severity,
        'is_resolved': ?isResolved,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createIncident({required Map<String, dynamic> data}) async {
    final res = await _dio.post(ApiEndpoints.securityIncidents, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resolveIncident({required String incidentId, String? resolutionNotes}) async {
    final res = await _dio.put(
      ApiEndpoints.securityIncidentResolve(incidentId),
      data: {'resolution_notes': ?resolutionNotes},
    );
    return res.data as Map<String, dynamic>;
  }
}
