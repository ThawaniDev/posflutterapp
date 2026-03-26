import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/delivery_integration/data/remote/delivery_api_service.dart';

class DeliveryRepository {
  final DeliveryApiService _apiService;

  DeliveryRepository(this._apiService);

  Future<Map<String, dynamic>> getStats() => _apiService.getStats();
  Future<Map<String, dynamic>> getConfigs() => _apiService.getConfigs();
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) => _apiService.saveConfig(data);
  Future<Map<String, dynamic>> toggleConfig(String id) => _apiService.toggleConfig(id);
  Future<Map<String, dynamic>> testConnection(String id) => _apiService.testConnection(id);
  Future<Map<String, dynamic>> getOrders({String? platform, String? status, int? perPage}) =>
      _apiService.getOrders(platform: platform, status: status, perPage: perPage);
  Future<Map<String, dynamic>> getActiveOrders() => _apiService.getActiveOrders();
  Future<Map<String, dynamic>> getOrderDetail(String id) => _apiService.getOrderDetail(id);
  Future<Map<String, dynamic>> updateOrderStatus(String id, {required String status, String? rejectionReason}) =>
      _apiService.updateOrderStatus(id, status: status, rejectionReason: rejectionReason);
  Future<Map<String, dynamic>> getSyncLogs({String? platform, int? perPage}) =>
      _apiService.getSyncLogs(platform: platform, perPage: perPage);
  Future<Map<String, dynamic>> triggerMenuSync({String? platform, required List<Map<String, dynamic>> products}) =>
      _apiService.triggerMenuSync(platform: platform, products: products);
  Future<Map<String, dynamic>> getPlatforms() => _apiService.getPlatforms();
}

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  return DeliveryRepository(ref.watch(deliveryApiServiceProvider));
});
