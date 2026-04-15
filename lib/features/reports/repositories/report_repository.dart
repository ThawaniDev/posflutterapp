import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/reports/data/remote/report_api_service.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(ref.watch(reportApiServiceProvider));
});

class ReportRepository {
  final ReportApiService _api;

  ReportRepository(this._api);

  Future<Map<String, dynamic>> getSalesSummary({ReportFilters filters = const ReportFilters()}) =>
      _api.getSalesSummary(filters: filters);

  Future<List<Map<String, dynamic>>> getProductPerformance({ReportFilters filters = const ReportFilters()}) =>
      _api.getProductPerformance(filters: filters);

  Future<List<Map<String, dynamic>>> getCategoryBreakdown({ReportFilters filters = const ReportFilters()}) =>
      _api.getCategoryBreakdown(filters: filters);

  Future<List<Map<String, dynamic>>> getStaffPerformance({ReportFilters filters = const ReportFilters()}) =>
      _api.getStaffPerformance(filters: filters);

  Future<List<Map<String, dynamic>>> getHourlySales({ReportFilters filters = const ReportFilters()}) =>
      _api.getHourlySales(filters: filters);

  Future<List<Map<String, dynamic>>> getPaymentMethods({ReportFilters filters = const ReportFilters()}) =>
      _api.getPaymentMethods(filters: filters);

  Future<Map<String, dynamic>> getDashboard({ReportFilters filters = const ReportFilters()}) =>
      _api.getDashboard(filters: filters);

  Future<List<Map<String, dynamic>>> getSlowMovers({ReportFilters filters = const ReportFilters()}) =>
      _api.getSlowMovers(filters: filters);

  Future<List<Map<String, dynamic>>> getProductMargin({ReportFilters filters = const ReportFilters()}) =>
      _api.getProductMargin(filters: filters);

  Future<Map<String, dynamic>> getInventoryValuation({ReportFilters filters = const ReportFilters()}) =>
      _api.getInventoryValuation(filters: filters);

  Future<List<Map<String, dynamic>>> getInventoryTurnover({ReportFilters filters = const ReportFilters()}) =>
      _api.getInventoryTurnover(filters: filters);

  Future<Map<String, dynamic>> getInventoryShrinkage({ReportFilters filters = const ReportFilters()}) =>
      _api.getInventoryShrinkage(filters: filters);

  Future<List<Map<String, dynamic>>> getInventoryLowStock({ReportFilters filters = const ReportFilters()}) =>
      _api.getInventoryLowStock(filters: filters);

  Future<Map<String, dynamic>> getFinancialDailyPl({ReportFilters filters = const ReportFilters()}) =>
      _api.getFinancialDailyPl(filters: filters);

  Future<Map<String, dynamic>> getFinancialExpenses({ReportFilters filters = const ReportFilters()}) =>
      _api.getFinancialExpenses(filters: filters);

  Future<Map<String, dynamic>> getFinancialCashVariance({ReportFilters filters = const ReportFilters()}) =>
      _api.getFinancialCashVariance(filters: filters);

  Future<List<Map<String, dynamic>>> getTopCustomers({ReportFilters filters = const ReportFilters()}) =>
      _api.getTopCustomers(filters: filters);

  Future<Map<String, dynamic>> getCustomerRetention({ReportFilters filters = const ReportFilters()}) =>
      _api.getCustomerRetention(filters: filters);

  Future<Map<String, dynamic>> exportReport({
    required String reportType,
    required String format,
    ReportFilters filters = const ReportFilters(),
  }) => _api.exportReport(reportType: reportType, format: format, filters: filters);

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
