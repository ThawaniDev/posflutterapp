import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/industry_florist/models/flower_arrangement.dart';
import 'package:thawani_pos/features/industry_florist/models/flower_freshness_log.dart';
import 'package:thawani_pos/features/industry_florist/models/flower_subscription.dart';

final floristApiServiceProvider = Provider<FloristApiService>((ref) {
  return FloristApiService(ref.watch(dioClientProvider));
});

class FloristApiService {
  final Dio _dio;
  FloristApiService(this._dio);

  Future<List<FlowerArrangement>> listArrangements({String? search, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.floristArrangements,
      queryParameters: {'per_page': perPage, if (search != null && search.isNotEmpty) 'search': search},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => FlowerArrangement.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<FlowerArrangement> createArrangement(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.floristArrangements, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return FlowerArrangement.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<FlowerArrangement> updateArrangement(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.floristArrangement(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return FlowerArrangement.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteArrangement(String id) async {
    await _dio.delete(ApiEndpoints.floristArrangement(id));
  }

  Future<List<FlowerFreshnessLog>> listFreshnessLogs({String? status, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.floristFreshnessLogs,
      queryParameters: {'per_page': perPage, if (status != null) 'status': status},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => FlowerFreshnessLog.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<FlowerFreshnessLog> createFreshnessLog(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.floristFreshnessLogs, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return FlowerFreshnessLog.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<FlowerFreshnessLog> updateFreshnessLogStatus(String id, String status) async {
    final response = await _dio.patch(ApiEndpoints.floristFreshnessLogStatus(id), data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return FlowerFreshnessLog.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<FlowerSubscription>> listSubscriptions({int perPage = 20}) async {
    final response = await _dio.get(ApiEndpoints.floristSubscriptions, queryParameters: {'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? [];
    return list.map((j) => FlowerSubscription.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<FlowerSubscription> createSubscription(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.floristSubscriptions, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return FlowerSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<FlowerSubscription> updateSubscription(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.floristSubscription(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return FlowerSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<FlowerSubscription> toggleSubscription(String id) async {
    final response = await _dio.patch(ApiEndpoints.floristSubscriptionToggle(id));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return FlowerSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
