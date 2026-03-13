import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

final reportApiServiceProvider = Provider<ReportApiService>((ref) {
  return ReportApiService(ref.watch(dioClientProvider));
});

class ReportApiService {
  final Dio _dio;

  ReportApiService(this._dio);

  // ─── Sales Summary ─────────────────────────────────────────

  Future<Map<String, dynamic>> getSalesSummary({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.salesSummary, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Product Performance ───────────────────────────────────

  Future<List<Map<String, dynamic>>> getProductPerformance({
    String? dateFrom,
    String? dateTo,
    String? categoryId,
    int? limit,
  }) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (categoryId != null) params['category_id'] = categoryId;
    if (limit != null) params['limit'] = limit;

    final response = await _dio.get(ApiEndpoints.productPerformance, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Category Breakdown ────────────────────────────────────

  Future<List<Map<String, dynamic>>> getCategoryBreakdown({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.categoryBreakdown, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Staff Performance ─────────────────────────────────────

  Future<List<Map<String, dynamic>>> getStaffPerformance({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.staffPerformance, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Hourly Sales ──────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getHourlySales({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.hourlySales, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Payment Methods ───────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPaymentMethods({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.paymentMethods, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Dashboard ─────────────────────────────────────────────

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get(ApiEndpoints.dashboard);
    return response.data['data'] as Map<String, dynamic>;
  }
}
