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
}
