import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_bakery/data/remote/bakery_api_service.dart';
import 'package:wameedpos/features/industry_bakery/models/bakery_recipe.dart';
import 'package:wameedpos/features/industry_bakery/models/production_schedule.dart';
import 'package:wameedpos/features/industry_bakery/models/custom_cake_order.dart';

final bakeryRepositoryProvider = Provider<BakeryRepository>((ref) {
  return BakeryRepository(apiService: ref.watch(bakeryApiServiceProvider));
});

class BakeryRepository {
  BakeryRepository({required BakeryApiService apiService}) : _apiService = apiService;
  final BakeryApiService _apiService;

  Future<List<BakeryRecipe>> listRecipes({String? search, int perPage = 20}) =>
      _apiService.listRecipes(search: search, perPage: perPage);
  Future<BakeryRecipe> createRecipe(Map<String, dynamic> data) => _apiService.createRecipe(data);
  Future<BakeryRecipe> updateRecipe(String id, Map<String, dynamic> data) => _apiService.updateRecipe(id, data);
  Future<void> deleteRecipe(String id) => _apiService.deleteRecipe(id);

  Future<List<ProductionSchedule>> listProductionSchedules({String? status, int perPage = 20}) =>
      _apiService.listProductionSchedules(status: status, perPage: perPage);
  Future<ProductionSchedule> createProductionSchedule(Map<String, dynamic> data) => _apiService.createProductionSchedule(data);
  Future<ProductionSchedule> updateProductionSchedule(String id, Map<String, dynamic> data) =>
      _apiService.updateProductionSchedule(id, data);
  Future<ProductionSchedule> updateProductionScheduleStatus(String id, String status) =>
      _apiService.updateProductionScheduleStatus(id, status);

  Future<List<CustomCakeOrder>> listCakeOrders({String? status, int perPage = 20}) =>
      _apiService.listCakeOrders(status: status, perPage: perPage);
  Future<CustomCakeOrder> createCakeOrder(Map<String, dynamic> data) => _apiService.createCakeOrder(data);
  Future<CustomCakeOrder> updateCakeOrder(String id, Map<String, dynamic> data) => _apiService.updateCakeOrder(id, data);
  Future<CustomCakeOrder> updateCakeOrderStatus(String id, String status) => _apiService.updateCakeOrderStatus(id, status);
}
