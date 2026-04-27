import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

class DeliveryApiService {

  DeliveryApiService(this._dio);
  final Dio _dio;

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

  /// GET /delivery/configs/{id}
  Future<Map<String, dynamic>> getConfigDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.deliveryConfigDetail(id));
    return response.data as Map<String, dynamic>;
  }

  /// POST /delivery/configs
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.deliveryConfigs, data: data);
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /delivery/configs/{id}
  Future<Map<String, dynamic>> deleteConfig(String id) async {
    final response = await _dio.delete(ApiEndpoints.deliveryConfigDelete(id));
    return response.data as Map<String, dynamic>;
  }

  /// PUT /delivery/configs/{id}/toggle
  Future<Map<String, dynamic>> toggleConfig(String id) async {
    final response = await _dio.put(ApiEndpoints.deliveryConfigToggle(id));
    return response.data as Map<String, dynamic>;
  }

  /// POST /delivery/configs/{id}/test-connection
  Future<Map<String, dynamic>> testConnection(String id) async {
    final response = await _dio.post(ApiEndpoints.deliveryConfigTestConnection(id));
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/orders
  Future<Map<String, dynamic>> getOrders({
    String? platform,
    String? status,
    int? perPage,
    int? page,
    String? dateFrom,
    String? dateTo,
  }) async {
    final params = <String, dynamic>{};
    if (platform != null) params['platform'] = platform;
    if (status != null) params['status'] = status;
    if (perPage != null) params['per_page'] = perPage;
    if (page != null) params['page'] = page;
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.deliveryOrders, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/orders/active
  Future<Map<String, dynamic>> getActiveOrders() async {
    final response = await _dio.get(ApiEndpoints.deliveryOrdersActive);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/orders/{id}
  Future<Map<String, dynamic>> getOrderDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.deliveryOrderDetail(id));
    return response.data as Map<String, dynamic>;
  }

  /// PUT /delivery/orders/{id}/status
  Future<Map<String, dynamic>> updateOrderStatus(String id, {required String status, String? rejectionReason}) async {
    final data = <String, dynamic>{'status': status};
    if (rejectionReason != null) data['rejection_reason'] = rejectionReason;
    final response = await _dio.put(ApiEndpoints.deliveryOrderUpdateStatus(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/sync-logs
  Future<Map<String, dynamic>> getSyncLogs({String? platform, int? perPage, int? page}) async {
    final params = <String, dynamic>{};
    if (platform != null) params['platform'] = platform;
    if (perPage != null) params['per_page'] = perPage;
    if (page != null) params['page'] = page;

    final response = await _dio.get(ApiEndpoints.deliverySyncLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// POST /delivery/menu-sync
  Future<Map<String, dynamic>> triggerMenuSync({String? platform, List<Map<String, dynamic>>? products}) async {
    final data = <String, dynamic>{};
    if (platform != null) data['platform'] = platform;
    // Only include products if explicitly provided; omitting it lets the backend
    // load the full store catalog from the product catalog at job dispatch time.
    if (products != null && products.isNotEmpty) data['products'] = products;
    final response = await _dio.post(ApiEndpoints.deliveryMenuSync, data: data);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/platforms
  Future<Map<String, dynamic>> getPlatforms() async {
    final response = await _dio.get(ApiEndpoints.deliveryPlatforms);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/webhook-logs
  Future<Map<String, dynamic>> getWebhookLogs({String? platform, int? perPage, int? page}) async {
    final params = <String, dynamic>{};
    if (platform != null) params['platform'] = platform;
    if (perPage != null) params['per_page'] = perPage;
    if (page != null) params['page'] = page;

    final response = await _dio.get(ApiEndpoints.deliveryWebhookLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/status-push-logs
  Future<Map<String, dynamic>> getStatusPushLogs({String? platform, int? perPage, int? page}) async {
    final params = <String, dynamic>{};
    if (platform != null) params['platform'] = platform;
    if (perPage != null) params['per_page'] = perPage;
    if (page != null) params['page'] = page;

    final response = await _dio.get(ApiEndpoints.deliveryStatusPushLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }
}

final deliveryApiServiceProvider = Provider<DeliveryApiService>((ref) {
  return DeliveryApiService(ref.watch(dioClientProvider));
});
