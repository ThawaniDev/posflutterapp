import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/dashboard/data/remote/dashboard_api_service.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(dashboardApiServiceProvider));
});

class DashboardRepository {

  DashboardRepository(this._api);
  final DashboardApiService _api;

  Future<Map<String, dynamic>> getStats({int? days}) => _api.getStats(days: days);

  Future<Map<String, dynamic>> getSalesTrend({String? dateFrom, String? dateTo, int? days}) =>
      _api.getSalesTrend(dateFrom: dateFrom, dateTo: dateTo, days: days);

  Future<List<Map<String, dynamic>>> getTopProducts({String? dateFrom, String? dateTo, int? limit, String? metric}) =>
      _api.getTopProducts(dateFrom: dateFrom, dateTo: dateTo, limit: limit, metric: metric);

  Future<List<Map<String, dynamic>>> getLowStock({int? limit}) => _api.getLowStock(limit: limit);

  Future<List<Map<String, dynamic>>> getActiveCashiers() => _api.getActiveCashiers();

  Future<List<Map<String, dynamic>>> getRecentOrders({int? limit}) => _api.getRecentOrders(limit: limit);

  Future<Map<String, dynamic>> getFinancialSummary({String? dateFrom, String? dateTo, int? days}) =>
      _api.getFinancialSummary(dateFrom: dateFrom, dateTo: dateTo, days: days);

  Future<List<Map<String, dynamic>>> getHourlySales({String? dateFrom, String? dateTo}) =>
      _api.getHourlySales(dateFrom: dateFrom, dateTo: dateTo);

  Future<List<Map<String, dynamic>>> getBranches() => _api.getBranches();

  Future<List<Map<String, dynamic>>> getStaffPerformance({String? dateFrom, String? dateTo, int? days}) =>
      _api.getStaffPerformance(dateFrom: dateFrom, dateTo: dateTo, days: days);
}
