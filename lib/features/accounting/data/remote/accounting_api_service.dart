import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final accountingApiServiceProvider = Provider<AccountingApiService>((ref) {
  return AccountingApiService(ref.watch(dioClientProvider));
});

class AccountingApiService {
  final Dio _dio;

  AccountingApiService(this._dio);

  // ─── Connection ──────────────────────────────────────

  Future<Map<String, dynamic>> getStatus() async {
    final response = await _dio.get(ApiEndpoints.accountingStatus);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> connect({
    required String provider,
    required String accessToken,
    required String refreshToken,
    required String tokenExpiresAt,
    String? realmId,
    String? tenantId,
    String? companyName,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.accountingConnect,
      data: {
        'provider': provider,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'token_expires_at': tokenExpiresAt,
        if (realmId != null) 'realm_id': realmId,
        if (tenantId != null) 'tenant_id': tenantId,
        if (companyName != null) 'company_name': companyName,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> disconnect() async {
    final response = await _dio.post(ApiEndpoints.accountingDisconnect);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> refreshToken({
    required String accessToken,
    String? refreshTokenValue,
    required String tokenExpiresAt,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.accountingRefreshToken,
      data: {
        'access_token': accessToken,
        if (refreshTokenValue != null) 'refresh_token': refreshTokenValue,
        'token_expires_at': tokenExpiresAt,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  // ─── Account Mapping ─────────────────────────────────

  Future<Map<String, dynamic>> getMappings() async {
    final response = await _dio.get(ApiEndpoints.accountingMapping);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> saveMappings(List<Map<String, dynamic>> mappings) async {
    final response = await _dio.put(ApiEndpoints.accountingMapping, data: {'mappings': mappings});
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteMapping(String mappingId) async {
    final response = await _dio.delete(ApiEndpoints.accountingMappingDelete(mappingId));
    return response.data as Map<String, dynamic>;
  }

  // ─── POS Account Keys ────────────────────────────────

  Future<Map<String, dynamic>> getPosAccountKeys() async {
    final response = await _dio.get(ApiEndpoints.accountingPosAccountKeys);
    return response.data as Map<String, dynamic>;
  }

  // ─── Exports ─────────────────────────────────────────

  Future<Map<String, dynamic>> triggerExport({
    required String startDate,
    required String endDate,
    List<String>? exportTypes,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.accountingExports,
      data: {'start_date': startDate, 'end_date': endDate, if (exportTypes != null) 'export_types': exportTypes},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listExports({String? status, int? limit}) async {
    final response = await _dio.get(
      ApiEndpoints.accountingExports,
      queryParameters: {if (status != null) 'status': status, if (limit != null) 'limit': limit},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getExport(String exportId) async {
    final response = await _dio.get(ApiEndpoints.accountingExportById(exportId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> retryExport(String exportId) async {
    final response = await _dio.post(ApiEndpoints.accountingExportRetry(exportId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Auto-Export ─────────────────────────────────────

  Future<Map<String, dynamic>> getAutoExportConfig() async {
    final response = await _dio.get(ApiEndpoints.accountingAutoExport);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAutoExportConfig(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.accountingAutoExport, data: data);
    return response.data as Map<String, dynamic>;
  }
}
