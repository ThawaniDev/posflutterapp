import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

final dashboardApiServiceProvider = Provider<DashboardApiService>((ref) {
  return DashboardApiService(ref.watch(dioClientProvider));
});

class DashboardApiService {
  final Dio _dio;

  DashboardApiService(this._dio);

  Future<Map<String, dynamic>> getStats({int? days}) async {
    final params = <String, dynamic>{};
    if (days != null) params['days'] = days;
    final response = await _dio.get(ApiEndpoints.ownerDashboardStats, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSalesTrend({String? dateFrom, String? dateTo, int? days}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (days != null) params['days'] = days;
    final response = await _dio.get(ApiEndpoints.ownerDashboardSalesTrend, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getTopProducts({String? dateFrom, String? dateTo, int? limit, String? metric}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (limit != null) params['limit'] = limit;
    if (metric != null) params['metric'] = metric;
    final response = await _dio.get(ApiEndpoints.ownerDashboardTopProducts, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getLowStock({int? limit}) async {
    final params = <String, dynamic>{};
    if (limit != null) params['limit'] = limit;
    final response = await _dio.get(ApiEndpoints.ownerDashboardLowStock, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getActiveCashiers() async {
    final response = await _dio.get(ApiEndpoints.ownerDashboardActiveCashiers);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getRecentOrders({int? limit}) async {
    final params = <String, dynamic>{};
    if (limit != null) params['limit'] = limit;
    final response = await _dio.get(ApiEndpoints.ownerDashboardRecentOrders, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getFinancialSummary({String? dateFrom, String? dateTo, int? days}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (days != null) params['days'] = days;
    final response = await _dio.get(ApiEndpoints.ownerDashboardFinancialSummary, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getHourlySales({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    final response = await _dio.get(ApiEndpoints.ownerDashboardHourlySales, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getBranches() async {
    final response = await _dio.get(ApiEndpoints.ownerDashboardBranches);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getStaffPerformance({String? dateFrom, String? dateTo, int? days}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (days != null) params['days'] = days;
    final response = await _dio.get(ApiEndpoints.ownerDashboardStaffPerformance, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }
}
