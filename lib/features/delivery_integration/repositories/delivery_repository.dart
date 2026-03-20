import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/delivery_integration/data/remote/delivery_api_service.dart';

class DeliveryRepository {
  final DeliveryApiService _apiService;

  DeliveryRepository(this._apiService);

  Future<Map<String, dynamic>> getStats() => _apiService.getStats();
  Future<Map<String, dynamic>> getConfigs() => _apiService.getConfigs();
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) => _apiService.saveConfig(data);
  Future<Map<String, dynamic>> toggleConfig(String id) => _apiService.toggleConfig(id);
  Future<Map<String, dynamic>> getOrders({String? platform, String? status, int? perPage}) =>
      _apiService.getOrders(platform: platform, status: status, perPage: perPage);
  Future<Map<String, dynamic>> getSyncLogs({String? platform, int? perPage}) =>
      _apiService.getSyncLogs(platform: platform, perPage: perPage);
}

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  return DeliveryRepository(ref.watch(deliveryApiServiceProvider));
});
