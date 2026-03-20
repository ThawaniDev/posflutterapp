import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class DeliveryApiService {
  final Dio _dio;

  DeliveryApiService(this._dio);

  /// GET /delivery/stats
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(ApiEndpoints.deliveryStats);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/configs
  Future<Map<String, dynamic>> getConfigs() async {
    final response = await _dio.get(ApiEndpoints.deliveryConfigs);
    return response.data as Map<String, dynamic>;
  }

  /// POST /delivery/configs
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.deliveryConfigs, data: data);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /delivery/configs/{id}/toggle
  Future<Map<String, dynamic>> toggleConfig(String id) async {
    final response = await _dio.put(ApiEndpoints.deliveryConfigToggle(id));
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/orders
  Future<Map<String, dynamic>> getOrders({String? platform, String? status, int? perPage}) async {
    final params = <String, dynamic>{};
    if (platform != null) params['platform'] = platform;
    if (status != null) params['status'] = status;
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.deliveryOrders, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/sync-logs
  Future<Map<String, dynamic>> getSyncLogs({String? platform, int? perPage}) async {
    final params = <String, dynamic>{};
    if (platform != null) params['platform'] = platform;
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.deliverySyncLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }
}

final deliveryApiServiceProvider = Provider<DeliveryApiService>((ref) {
  return DeliveryApiService(ref.watch(dioClientProvider));
});
