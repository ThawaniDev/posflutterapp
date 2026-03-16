import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

final securityApiServiceProvider = Provider<SecurityApiService>((ref) {
  return SecurityApiService(ref.watch(dioClientProvider));
});

class SecurityApiService {
  final Dio _dio;

  SecurityApiService(this._dio);

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
        if (action != null) 'action': action,
        if (severity != null) 'severity': severity,
        if (userId != null) 'user_id': userId,
        if (perPage != null) 'per_page': perPage,
      },
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> recordAudit({required Map<String, dynamic> data}) async {
    final res = await _dio.post(ApiEndpoints.securityAuditLogs, data: data);
    return res.data as Map<String, dynamic>;
  }

  // ─── Devices ──────────────────────────────────────────────

  Future<Map<String, dynamic>> listDevices({required String storeId, bool? activeOnly}) async {
    final res = await _dio.get(
      ApiEndpoints.securityDevices,
      queryParameters: {'store_id': storeId, if (activeOnly != null) 'active_only': activeOnly},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> registerDevice({required Map<String, dynamic> data}) async {
    final res = await _dio.post(ApiEndpoints.securityDevices, data: data);
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
        if (attemptType != null) 'attempt_type': attemptType,
        if (isSuccessful != null) 'is_successful': isSuccessful,
        if (perPage != null) 'per_page': perPage,
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
        if (windowMinutes != null) 'window_minutes': windowMinutes,
      },
    );
    return res.data as Map<String, dynamic>;
  }
}
