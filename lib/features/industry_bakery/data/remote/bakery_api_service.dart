import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/industry_bakery/models/bakery_recipe.dart';
import 'package:thawani_pos/features/industry_bakery/models/production_schedule.dart';
import 'package:thawani_pos/features/industry_bakery/models/custom_cake_order.dart';

final bakeryApiServiceProvider = Provider<BakeryApiService>((ref) {
  return BakeryApiService(ref.watch(dioClientProvider));
});

class BakeryApiService {
  final Dio _dio;
  BakeryApiService(this._dio);

  Future<List<BakeryRecipe>> listRecipes({String? search, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.bakeryRecipes,
      queryParameters: {'per_page': perPage, if (search != null && search.isNotEmpty) 'search': search},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => BakeryRecipe.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<BakeryRecipe> createRecipe(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.bakeryRecipes, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return BakeryRecipe.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<BakeryRecipe> updateRecipe(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.bakeryRecipe(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return BakeryRecipe.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteRecipe(String id) async {
    await _dio.delete(ApiEndpoints.bakeryRecipe(id));
  }

  Future<List<ProductionSchedule>> listProductionSchedules({String? status, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.bakeryProductionSchedules,
      queryParameters: {'per_page': perPage, if (status != null) 'status': status},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => ProductionSchedule.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ProductionSchedule> createProductionSchedule(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.bakeryProductionSchedules, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ProductionSchedule.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<ProductionSchedule> updateProductionSchedule(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.bakeryProductionSchedule(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ProductionSchedule.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<ProductionSchedule> updateProductionScheduleStatus(String id, String status) async {
    final response = await _dio.patch(ApiEndpoints.bakeryProductionScheduleStatus(id), data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ProductionSchedule.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<CustomCakeOrder>> listCakeOrders({String? status, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.bakeryCakeOrders,
      queryParameters: {'per_page': perPage, if (status != null) 'status': status},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => CustomCakeOrder.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<CustomCakeOrder> createCakeOrder(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.bakeryCakeOrders, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CustomCakeOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<CustomCakeOrder> updateCakeOrder(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.bakeryCakeOrder(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CustomCakeOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<CustomCakeOrder> updateCakeOrderStatus(String id, String status) async {
    final response = await _dio.patch(ApiEndpoints.bakeryCakeOrderStatus(id), data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CustomCakeOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
