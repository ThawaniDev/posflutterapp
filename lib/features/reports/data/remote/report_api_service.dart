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

  // ─── Slow Movers ───────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getSlowMovers({String? dateFrom, String? dateTo, int? limit}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (limit != null) params['limit'] = limit;

    final response = await _dio.get(ApiEndpoints.slowMovers, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Product Margin ────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getProductMargin({String? dateFrom, String? dateTo, String? categoryId}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (categoryId != null) params['category_id'] = categoryId;

    final response = await _dio.get(ApiEndpoints.productMargin, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Inventory Valuation ───────────────────────────────────

  Future<Map<String, dynamic>> getInventoryValuation() async {
    final response = await _dio.get(ApiEndpoints.inventoryValuation);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Inventory Turnover ────────────────────────────────────

  Future<List<Map<String, dynamic>>> getInventoryTurnover({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.inventoryTurnover, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Inventory Shrinkage ───────────────────────────────────

  Future<Map<String, dynamic>> getInventoryShrinkage({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.inventoryShrinkage, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Inventory Low Stock ───────────────────────────────────

  Future<List<Map<String, dynamic>>> getInventoryLowStock() async {
    final response = await _dio.get(ApiEndpoints.inventoryLowStock);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Financial: Daily P&L ─────────────────────────────────

  Future<Map<String, dynamic>> getFinancialDailyPl({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.financialDailyPl, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Financial: Expenses ───────────────────────────────────

  Future<Map<String, dynamic>> getFinancialExpenses({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.financialExpenses, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Financial: Cash Variance ──────────────────────────────

  Future<Map<String, dynamic>> getFinancialCashVariance({String? dateFrom, String? dateTo}) async {
    final params = <String, dynamic>{};
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.financialCashVariance, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Top Customers ────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getTopCustomers({int? limit}) async {
    final params = <String, dynamic>{};
    if (limit != null) params['limit'] = limit;

    final response = await _dio.get(ApiEndpoints.topCustomers, queryParameters: params);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Customer Retention ────────────────────────────────────

  Future<Map<String, dynamic>> getCustomerRetention() async {
    final response = await _dio.get(ApiEndpoints.customerRetention);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Export Report ─────────────────────────────────────────

  Future<Map<String, dynamic>> exportReport({
    required String reportType,
    required String format,
    String? dateFrom,
    String? dateTo,
  }) async {
    final body = <String, dynamic>{'report_type': reportType, 'format': format};
    if (dateFrom != null) body['date_from'] = dateFrom;
    if (dateTo != null) body['date_to'] = dateTo;

    final response = await _dio.post(ApiEndpoints.reportExport, data: body);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Scheduled Reports ─────────────────────────────────────

  Future<List<Map<String, dynamic>>> getScheduledReports() async {
    final response = await _dio.get(ApiEndpoints.reportSchedules);
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createScheduledReport({
    required String reportType,
    required String name,
    required String frequency,
    required List<String> recipients,
    String? format,
  }) async {
    final body = <String, dynamic>{
      'report_type': reportType,
      'name': name,
      'frequency': frequency,
      'recipients': recipients,
      if (format != null) 'format': format,
    };

    final response = await _dio.post(ApiEndpoints.reportSchedules, data: body);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteScheduledReport(String id) async {
    await _dio.delete(ApiEndpoints.reportScheduleDelete(id));
  }
}
