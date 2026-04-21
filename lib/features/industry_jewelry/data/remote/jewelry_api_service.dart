import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/industry_jewelry/models/daily_metal_rate.dart';
import 'package:wameedpos/features/industry_jewelry/models/jewelry_product_detail.dart';
import 'package:wameedpos/features/industry_jewelry/models/buyback_transaction.dart';

final jewelryApiServiceProvider = Provider<JewelryApiService>((ref) {
  return JewelryApiService(ref.watch(dioClientProvider));
});

class JewelryApiService {
  JewelryApiService(this._dio);
  final Dio _dio;

  Future<List<DailyMetalRate>> listMetalRates({String? metalType, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.jewelryMetalRates,
      queryParameters: {'per_page': perPage, 'metal_type': ?metalType},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => DailyMetalRate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<DailyMetalRate> upsertMetalRate(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.jewelryMetalRates, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return DailyMetalRate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<JewelryProductDetail>> listProductDetails({String? metalType, String? productId, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.jewelryProductDetails,
      queryParameters: {
        'per_page': perPage,
        'metal_type': ?metalType,
        'product_id': ?productId,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => JewelryProductDetail.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<JewelryProductDetail> createProductDetail(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.jewelryProductDetails, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return JewelryProductDetail.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<JewelryProductDetail> updateProductDetail(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.jewelryProductDetail(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return JewelryProductDetail.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<BuybackTransaction>> listBuybacks({String? metalType, String? customerId, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.jewelryBuybacks,
      queryParameters: {
        'per_page': perPage,
        'metal_type': ?metalType,
        'customer_id': ?customerId,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => BuybackTransaction.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<BuybackTransaction> createBuyback(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.jewelryBuybacks, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return BuybackTransaction.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
