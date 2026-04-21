import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_florist/data/remote/florist_api_service.dart';
import 'package:wameedpos/features/industry_florist/models/flower_arrangement.dart';
import 'package:wameedpos/features/industry_florist/models/flower_freshness_log.dart';
import 'package:wameedpos/features/industry_florist/models/flower_subscription.dart';

final floristRepositoryProvider = Provider<FloristRepository>((ref) {
  return FloristRepository(apiService: ref.watch(floristApiServiceProvider));
});

class FloristRepository {
  FloristRepository({required FloristApiService apiService}) : _apiService = apiService;
  final FloristApiService _apiService;

  Future<List<FlowerArrangement>> listArrangements({String? search, int perPage = 20}) =>
      _apiService.listArrangements(search: search, perPage: perPage);
  Future<FlowerArrangement> createArrangement(Map<String, dynamic> data) => _apiService.createArrangement(data);
  Future<FlowerArrangement> updateArrangement(String id, Map<String, dynamic> data) => _apiService.updateArrangement(id, data);
  Future<void> deleteArrangement(String id) => _apiService.deleteArrangement(id);

  Future<List<FlowerFreshnessLog>> listFreshnessLogs({String? status, int perPage = 20}) =>
      _apiService.listFreshnessLogs(status: status, perPage: perPage);
  Future<FlowerFreshnessLog> createFreshnessLog(Map<String, dynamic> data) => _apiService.createFreshnessLog(data);
  Future<FlowerFreshnessLog> updateFreshnessLogStatus(String id, String status) =>
      _apiService.updateFreshnessLogStatus(id, status);

  Future<List<FlowerSubscription>> listSubscriptions({int perPage = 20}) => _apiService.listSubscriptions(perPage: perPage);
  Future<FlowerSubscription> createSubscription(Map<String, dynamic> data) => _apiService.createSubscription(data);
  Future<FlowerSubscription> updateSubscription(String id, Map<String, dynamic> data) => _apiService.updateSubscription(id, data);
  Future<FlowerSubscription> toggleSubscription(String id) => _apiService.toggleSubscription(id);
}
