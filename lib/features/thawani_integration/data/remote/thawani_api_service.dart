import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class ThawaniApiService {
  final Dio _dio;

  ThawaniApiService(this._dio);

  /// GET /thawani/stats
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(ApiEndpoints.thawaniStats);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/config
  Future<Map<String, dynamic>> getConfig() async {
    final response = await _dio.get(ApiEndpoints.thawaniConfig);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/config
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.thawaniConfig, data: data);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /thawani/disconnect
  Future<Map<String, dynamic>> disconnect() async {
    final response = await _dio.put(ApiEndpoints.thawaniDisconnect);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/orders
  Future<Map<String, dynamic>> getOrders({String? status, int? perPage}) async {
    final params = <String, dynamic>{};
    if (status != null) params['status'] = status;
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.thawaniOrders, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/product-mappings
  Future<Map<String, dynamic>> getProductMappings() async {
    final response = await _dio.get(ApiEndpoints.thawaniProductMappings);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/settlements
  Future<Map<String, dynamic>> getSettlements({int? perPage}) async {
    final params = <String, dynamic>{};
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.thawaniSettlements, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/test-connection
  Future<Map<String, dynamic>> testConnection() async {
    final response = await _dio.post(ApiEndpoints.thawaniTestConnection);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/push-products
  Future<Map<String, dynamic>> pushProducts() async {
    final response = await _dio.post(ApiEndpoints.thawaniPushProducts);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/pull-products
  Future<Map<String, dynamic>> pullProducts() async {
    final response = await _dio.post(ApiEndpoints.thawaniPullProducts);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/category-mappings
  Future<Map<String, dynamic>> getCategoryMappings() async {
    final response = await _dio.get(ApiEndpoints.thawaniCategoryMappings);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/push-categories
  Future<Map<String, dynamic>> pushCategories() async {
    final response = await _dio.post(ApiEndpoints.thawaniPushCategories);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/pull-categories
  Future<Map<String, dynamic>> pullCategories() async {
    final response = await _dio.post(ApiEndpoints.thawaniPullCategories);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/column-mappings
  Future<Map<String, dynamic>> getColumnMappings() async {
    final response = await _dio.get(ApiEndpoints.thawaniColumnMappings);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/column-mappings/seed-defaults
  Future<Map<String, dynamic>> seedColumnDefaults() async {
    final response = await _dio.post(ApiEndpoints.thawaniSeedColumnDefaults);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/sync-logs
  Future<Map<String, dynamic>> getSyncLogs({String? entityType, String? status, int? perPage}) async {
    final params = <String, dynamic>{};
    if (entityType != null) params['entity_type'] = entityType;
    if (status != null) params['status'] = status;
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.thawaniSyncLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/queue-stats
  Future<Map<String, dynamic>> getQueueStats() async {
    final response = await _dio.get(ApiEndpoints.thawaniQueueStats);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/process-queue
  Future<Map<String, dynamic>> processQueue() async {
    final response = await _dio.post(ApiEndpoints.thawaniProcessQueue);
    return response.data as Map<String, dynamic>;
  }
}

final thawaniApiServiceProvider = Provider<ThawaniApiService>((ref) {
  return ThawaniApiService(ref.watch(dioClientProvider));
});
