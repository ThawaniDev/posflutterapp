import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/delivery_integration/data/remote/delivery_api_service.dart';

class DeliveryRepository {
  final DeliveryApiService _apiService;

  DeliveryRepository(this._apiService);

  Future<Map<String, dynamic>> getStats() => _apiService.getStats();
  Future<Map<String, dynamic>> getConfigs() => _apiService.getConfigs();
  Future<Map<String, dynamic>> getConfigDetail(String id) => _apiService.getConfigDetail(id);
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) => _apiService.saveConfig(data);
  Future<Map<String, dynamic>> deleteConfig(String id) => _apiService.deleteConfig(id);
  Future<Map<String, dynamic>> toggleConfig(String id) => _apiService.toggleConfig(id);
  Future<Map<String, dynamic>> testConnection(String id) => _apiService.testConnection(id);
  Future<Map<String, dynamic>> getOrders({
    String? platform,
    String? status,
    int? perPage,
    int? page,
    String? dateFrom,
    String? dateTo,
  }) =>
      _apiService.getOrders(platform: platform, status: status, perPage: perPage, page: page, dateFrom: dateFrom, dateTo: dateTo);
  Future<Map<String, dynamic>> getActiveOrders() => _apiService.getActiveOrders();
  Future<Map<String, dynamic>> getOrderDetail(String id) => _apiService.getOrderDetail(id);
  Future<Map<String, dynamic>> updateOrderStatus(String id, {required String status, String? rejectionReason}) =>
      _apiService.updateOrderStatus(id, status: status, rejectionReason: rejectionReason);
  Future<Map<String, dynamic>> getSyncLogs({String? platform, int? perPage, int? page}) =>
      _apiService.getSyncLogs(platform: platform, perPage: perPage, page: page);
  Future<Map<String, dynamic>> triggerMenuSync({String? platform, required List<Map<String, dynamic>> products}) =>
      _apiService.triggerMenuSync(platform: platform, products: products);
  Future<Map<String, dynamic>> getPlatforms() => _apiService.getPlatforms();
  Future<Map<String, dynamic>> getWebhookLogs({String? platform, int? perPage, int? page}) =>
      _apiService.getWebhookLogs(platform: platform, perPage: perPage, page: page);
  Future<Map<String, dynamic>> getStatusPushLogs({String? platform, int? perPage, int? page}) =>
      _apiService.getStatusPushLogs(platform: platform, perPage: perPage, page: page);
}

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  return DeliveryRepository(ref.watch(deliveryApiServiceProvider));
});
