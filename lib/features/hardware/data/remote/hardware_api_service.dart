import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class HardwareApiService {
  HardwareApiService(this._dio);

  final Dio _dio;

  Future<List<dynamic>> listConfigs({String? terminalId, String? deviceType, bool? isActive}) async {
    final response = await _dio.get(
      ApiEndpoints.hardwareConfig,
      queryParameters: {
        if (terminalId != null) 'terminal_id': terminalId,
        if (deviceType != null) 'device_type': deviceType,
        if (isActive != null) 'is_active': isActive,
      },
    );
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> saveConfig({
    required String terminalId,
    required String deviceType,
    required String connectionType,
    String? deviceName,
    Map<String, dynamic>? configJson,
    bool? isActive,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.hardwareConfig,
      data: {
        'terminal_id': terminalId,
        'device_type': deviceType,
        'connection_type': connectionType,
        if (deviceName != null) 'device_name': deviceName,
        if (configJson != null) 'config_json': configJson,
        if (isActive != null) 'is_active': isActive,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> removeConfig(String id) async {
    await _dio.delete(ApiEndpoints.hardwareConfigDelete(id));
  }

  Future<List<dynamic>> supportedModels({String? deviceType, bool? isCertified}) async {
    final response = await _dio.get(
      ApiEndpoints.hardwareSupportedModels,
      queryParameters: {if (deviceType != null) 'device_type': deviceType, if (isCertified != null) 'is_certified': isCertified},
    );
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> testDevice({
    required String terminalId,
    required String deviceType,
    required String connectionType,
    String? testType,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.hardwareTest,
      data: {
        'terminal_id': terminalId,
        'device_type': deviceType,
        'connection_type': connectionType,
        if (testType != null) 'test_type': testType,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> recordEvent({
    required String terminalId,
    required String deviceType,
    required String event,
    Map<String, dynamic>? details,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.hardwareEventLog,
      data: {'terminal_id': terminalId, 'device_type': deviceType, 'event': event, if (details != null) 'details': details},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> eventLogs({String? terminalId, String? deviceType, String? event, int? perPage}) async {
    final response = await _dio.get(
      ApiEndpoints.hardwareEventLogs,
      queryParameters: {
        if (terminalId != null) 'terminal_id': terminalId,
        if (deviceType != null) 'device_type': deviceType,
        if (event != null) 'event': event,
        if (perPage != null) 'per_page': perPage,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}

final hardwareApiServiceProvider = Provider<HardwareApiService>((ref) {
  return HardwareApiService(ref.watch(dioClientProvider));
});
