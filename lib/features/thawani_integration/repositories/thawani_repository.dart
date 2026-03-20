import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/thawani_integration/data/remote/thawani_api_service.dart';

class ThawaniRepository {
  final ThawaniApiService _apiService;

  ThawaniRepository(this._apiService);

  Future<Map<String, dynamic>> getStats() => _apiService.getStats();
  Future<Map<String, dynamic>> getConfig() => _apiService.getConfig();
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) => _apiService.saveConfig(data);
  Future<Map<String, dynamic>> disconnect() => _apiService.disconnect();
  Future<Map<String, dynamic>> getOrders({String? status, int? perPage}) =>
      _apiService.getOrders(status: status, perPage: perPage);
  Future<Map<String, dynamic>> getProductMappings() => _apiService.getProductMappings();
  Future<Map<String, dynamic>> getSettlements({int? perPage}) => _apiService.getSettlements(perPage: perPage);
}

final thawaniRepositoryProvider = Provider<ThawaniRepository>((ref) {
  return ThawaniRepository(ref.watch(thawaniApiServiceProvider));
});
