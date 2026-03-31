import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/reports/data/remote/report_api_service.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(ref.watch(reportApiServiceProvider));
});

class ReportRepository {
  final ReportApiService _api;

  ReportRepository(this._api);

  Future<Map<String, dynamic>> getSalesSummary({String? dateFrom, String? dateTo}) =>
      _api.getSalesSummary(dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getProductPerformance({String? dateFrom, String? dateTo, String? categoryId, int? limit}) =>
      _api.getProductPerformance(dateFrom: dateFrom, dateTo: dateTo, categoryId: categoryId, limit: limit);

  Future<List<Map<String, dynamic>>> getCategoryBreakdown({String? dateFrom, String? dateTo}) =>
      _api.getCategoryBreakdown(dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getStaffPerformance({String? dateFrom, String? dateTo}) =>
      _api.getStaffPerformance(dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getHourlySales({String? dateFrom, String? dateTo}) =>
      _api.getHourlySales(dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getPaymentMethods({String? dateFrom, String? dateTo}) =>
      _api.getPaymentMethods(dateFrom: dateFrom, dateTo: dateTo);

  Future<Map<String, dynamic>> getDashboard() => _api.getDashboard();

  Future<List<Map<String, dynamic>>> getSlowMovers({String? dateFrom, String? dateTo, int? limit}) =>
      _api.getSlowMovers(dateFrom: dateFrom, dateTo: dateTo, limit: limit);

  Future<List<Map<String, dynamic>>> getProductMargin({String? dateFrom, String? dateTo, String? categoryId}) =>
      _api.getProductMargin(dateFrom: dateFrom, dateTo: dateTo, categoryId: categoryId);

  Future<Map<String, dynamic>> getInventoryValuation() => _api.getInventoryValuation();

  Future<List<Map<String, dynamic>>> getInventoryTurnover({String? dateFrom, String? dateTo}) =>
      _api.getInventoryTurnover(dateFrom: dateFrom, dateTo: dateTo);

  Future<Map<String, dynamic>> getInventoryShrinkage({String? dateFrom, String? dateTo}) =>
      _api.getInventoryShrinkage(dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getInventoryLowStock() => _api.getInventoryLowStock();

  Future<Map<String, dynamic>> getFinancialDailyPl({String? dateFrom, String? dateTo}) =>
      _api.getFinancialDailyPl(dateFrom: dateFrom, dateTo: dateTo);

  Future<Map<String, dynamic>> getFinancialExpenses({String? dateFrom, String? dateTo}) =>
      _api.getFinancialExpenses(dateFrom: dateFrom, dateTo: dateTo);

  Future<Map<String, dynamic>> getFinancialCashVariance({String? dateFrom, String? dateTo}) =>
      _api.getFinancialCashVariance(dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getTopCustomers({int? limit}) => _api.getTopCustomers(limit: limit);

  Future<Map<String, dynamic>> getCustomerRetention() => _api.getCustomerRetention();

  Future<Map<String, dynamic>> exportReport({
    required String reportType,
    required String format,
    String? dateFrom,
    String? dateTo,
  }) => _api.exportReport(reportType: reportType, format: format, dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getScheduledReports() => _api.getScheduledReports();

  Future<Map<String, dynamic>> createScheduledReport({
    required String reportType,
    required String name,
    required String frequency,
    required List<String> recipients,
    String? format,
  }) => _api.createScheduledReport(
    reportType: reportType,
    name: name,
    frequency: frequency,
    recipients: recipients,
    format: format,
  );

  Future<void> deleteScheduledReport(String id) => _api.deleteScheduledReport(id);
}
