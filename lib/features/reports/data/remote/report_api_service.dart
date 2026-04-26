import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';

final reportApiServiceProvider = Provider<ReportApiService>((ref) {
  return ReportApiService(ref.watch(dioClientProvider));
});

class ReportApiService {
  ReportApiService(this._dio);
  final Dio _dio;

  Map<String, dynamic> _buildParams(ReportFilters filters) => filters.toQueryParams();

  // ─── Sales Summary ─────────────────────────────────────────

  Future<Map<String, dynamic>> getSalesSummary({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.salesSummary, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Product Performance ───────────────────────────────────

  Future<List<Map<String, dynamic>>> getProductPerformance({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.productPerformance, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Category Breakdown ────────────────────────────────────

  Future<List<Map<String, dynamic>>> getCategoryBreakdown({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.categoryBreakdown, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Staff Performance ─────────────────────────────────────

  Future<List<Map<String, dynamic>>> getStaffPerformance({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.staffPerformance, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Hourly Sales ──────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getHourlySales({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.hourlySales, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Payment Methods ───────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPaymentMethods({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.paymentMethods, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Dashboard ─────────────────────────────────────────────

  Future<Map<String, dynamic>> getDashboard({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.dashboard, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Slow Movers ───────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getSlowMovers({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.slowMovers, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Product Margin ────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getProductMargin({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.productMargin, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Inventory Valuation ───────────────────────────────────

  Future<Map<String, dynamic>> getInventoryValuation({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.inventoryValuation, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Inventory Turnover ────────────────────────────────────

  Future<List<Map<String, dynamic>>> getInventoryTurnover({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.inventoryTurnover, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Inventory Shrinkage ───────────────────────────────────

  Future<Map<String, dynamic>> getInventoryShrinkage({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.inventoryShrinkage, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Inventory Low Stock ───────────────────────────────────

  Future<List<Map<String, dynamic>>> getInventoryLowStock({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.inventoryLowStock, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Financial: Daily P&L ─────────────────────────────────

  Future<Map<String, dynamic>> getFinancialDailyPl({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.financialDailyPl, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Financial: Expenses ───────────────────────────────────

  Future<Map<String, dynamic>> getFinancialExpenses({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.financialExpenses, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Financial: Cash Variance ──────────────────────────────

  Future<Map<String, dynamic>> getFinancialCashVariance({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.financialCashVariance, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Top Customers ────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getTopCustomers({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.topCustomers, queryParameters: _buildParams(filters));
    return (response.data['data'] as List).cast<Map<String, dynamic>>();
  }

  // ─── Customer Retention ────────────────────────────────────

  Future<Map<String, dynamic>> getCustomerRetention({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.customerRetention, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Inventory Expiry ──────────────────────────────────────

  Future<Map<String, dynamic>> getInventoryExpiry({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.inventoryExpiry, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Financial: Delivery Commission ───────────────────────

  Future<Map<String, dynamic>> getFinancialDeliveryCommission({ReportFilters filters = const ReportFilters()}) async {
    final response = await _dio.get(ApiEndpoints.financialDeliveryCommission, queryParameters: _buildParams(filters));
    return response.data['data'] as Map<String, dynamic>;
  }

  // ─── Export Report ─────────────────────────────────────────

  Future<Map<String, dynamic>> exportReport({
    required String reportType,
    required String format,
    ReportFilters filters = const ReportFilters(),
  }) async {
    final body = <String, dynamic>{'report_type': reportType, 'format': format, ..._buildParams(filters)};

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
