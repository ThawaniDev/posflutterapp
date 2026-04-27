import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

class ThawaniApiService {
  ThawaniApiService(this._dio);
  final Dio _dio;

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

  // ─── Order Management ──────────────────────────────────

  /// GET /thawani/orders/{id}
  Future<Map<String, dynamic>> getOrderDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.thawaniOrderDetail(id));
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/orders/{id}/accept
  Future<Map<String, dynamic>> acceptOrder(String id) async {
    final response = await _dio.post(ApiEndpoints.thawaniOrderAccept(id));
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/orders/{id}/reject
  Future<Map<String, dynamic>> rejectOrder(String id, String reason) async {
    final response = await _dio.post(ApiEndpoints.thawaniOrderReject(id), data: {'reason': reason});
    return response.data as Map<String, dynamic>;
  }

  /// PUT /thawani/orders/{id}/status
  Future<Map<String, dynamic>> updateOrderStatus(String id, String status) async {
    final response = await _dio.put(ApiEndpoints.thawaniOrderStatus(id), data: {'status': status});
    return response.data as Map<String, dynamic>;
  }

  // ─── Online Menu Management ────────────────────────────

  /// GET /thawani/products
  Future<Map<String, dynamic>> getProducts({String? search, bool? isPublished, int? perPage, int? page}) async {
    final params = <String, dynamic>{};
    if (search != null) params['search'] = search;
    if (isPublished != null) params['is_published'] = isPublished;
    if (perPage != null) params['per_page'] = perPage;
    if (page != null) params['page'] = page;

    final response = await _dio.get(ApiEndpoints.thawaniProducts, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /thawani/products/{id}/publish
  Future<Map<String, dynamic>> publishProduct(
    String id, {
    required bool isPublished,
    double? onlinePrice,
    int? displayOrder,
  }) async {
    final data = <String, dynamic>{'is_published': isPublished};
    if (onlinePrice != null) data['online_price'] = onlinePrice;
    if (displayOrder != null) data['display_order'] = displayOrder;

    final response = await _dio.put(ApiEndpoints.thawaniProductPublish(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/products/bulk-publish
  Future<Map<String, dynamic>> bulkPublishProducts(List<String> productIds, bool isPublished) async {
    final response = await _dio.post(
      ApiEndpoints.thawaniProductsBulkPublish,
      data: {'product_ids': productIds, 'is_published': isPublished},
    );
    return response.data as Map<String, dynamic>;
  }

  // ─── Store Availability ────────────────────────────────

  /// PUT /thawani/store/availability
  Future<Map<String, dynamic>> updateStoreAvailability(bool isOpen, {String? closedReason}) async {
    final data = <String, dynamic>{'is_open': isOpen};
    if (closedReason != null) data['closed_reason'] = closedReason;

    final response = await _dio.put(ApiEndpoints.thawaniStoreAvailability, data: data);
    return response.data as Map<String, dynamic>;
  }

  // ─── Inventory Sync ────────────────────────────────────

  /// POST /thawani/inventory/sync
  Future<Map<String, dynamic>> syncInventory() async {
    final response = await _dio.post(ApiEndpoints.thawaniInventorySync);
    return response.data as Map<String, dynamic>;
  }
}

final thawaniApiServiceProvider = Provider<ThawaniApiService>((ref) {
  return ThawaniApiService(ref.watch(dioClientProvider));
});
