import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final dashboardApiServiceProvider = Provider<DashboardApiService>((ref) {
  return DashboardApiService(ref.watch(dioClientProvider));
});

class DashboardApiService {
  DashboardApiService(this._dio);
  final Dio _dio;

  // ─── Single aggregated endpoint ────────────────────────────

  Future<Map<String, dynamic>> getDashboardSummary({int? days}) async {
    final params = <String, dynamic>{};
    if (days != null) params['days'] = days;
    final response = await _dio.get(ApiEndpoints.ownerDashboardSummary, queryParameters: params);
    final raw = response.data['data'] as Map<String, dynamic>;

    // Reuse the same flattening helpers so the rest of the app is unchanged
    final statsRaw = raw['stats'] as Map<String, dynamic>;
    final stats = {
      'today_sales': _extractValue(statsRaw['today_sales']),
      'sales_trend': _extractChange(statsRaw['today_sales']),
      'today_transactions': _extractValue(statsRaw['transactions']),
      'transactions_trend': _extractChange(statsRaw['transactions']),
      'avg_basket': _extractValue(statsRaw['avg_basket']),
      'basket_trend': _extractChange(statsRaw['avg_basket']),
      'net_profit': _extractValue(statsRaw['net_profit']),
      'profit_trend': _extractChange(statsRaw['net_profit']),
      'unique_customers': statsRaw['unique_customers'] ?? 0,
      'total_refunds': statsRaw['total_refunds'] ?? 0,
    };

    final finRaw = raw['financial_summary'] as Map<String, dynamic>;
    final revenue = finRaw['revenue'] as Map<String, dynamic>? ?? {};
    final payments = finRaw['payments'] as List? ?? [];
    final paymentMethods = <String, dynamic>{};
    for (final p in payments) {
      if (p is Map<String, dynamic>) {
        paymentMethods[p['method']?.toString() ?? 'other'] = p['total'] ?? 0;
      }
    }
    final financialSummary = {
      'total_revenue': revenue['total'] ?? 0,
      'total_cost': revenue['cost'] ?? 0,
      'net_profit': revenue['net'] ?? 0,
      'total_tax': revenue['tax'] ?? 0,
      'total_discount': revenue['discounts'] ?? 0,
      'total_refunds': revenue['refunds'] ?? 0,
      'payment_methods': paymentMethods,
      'period': finRaw['period'],
      'daily': finRaw['daily'],
    };

    return {
      'stats': stats,
      'sales_trend': raw['sales_trend'] as Map<String, dynamic>,
      'top_products': (raw['top_products'] as List).cast<Map<String, dynamic>>(),
      'low_stock': (raw['low_stock'] as List).cast<Map<String, dynamic>>(),
      'active_cashiers': (raw['active_cashiers'] as List).cast<Map<String, dynamic>>(),
      'recent_orders': (raw['recent_orders'] as List).cast<Map<String, dynamic>>(),
      'financial_summary': financialSummary,
      'hourly_sales': (raw['hourly_sales'] as List).cast<Map<String, dynamic>>(),
      'branches': (raw['branches'] as List).cast<Map<String, dynamic>>(),
      'staff_performance': (raw['staff_performance'] as List).cast<Map<String, dynamic>>(),
    };
  }

  // ─── Individual endpoints (kept for targeted refreshes) ────

  Future<Map<String, dynamic>> getStats({int? days}) async {
    final params = <String, dynamic>{};
    if (days != null) params['days'] = days;
    final response = await _dio.get(ApiEndpoints.ownerDashboardStats, queryParameters: params);
    final raw = response.data['data'] as Map<String, dynamic>;

    // Flatten nested {value, change} structure into flat keys the UI expects
    return {
      'today_sales': _extractValue(raw['today_sales']),
      'sales_trend': _extractChange(raw['today_sales']),
      'today_transactions': _extractValue(raw['transactions']),
      'transactions_trend': _extractChange(raw['transactions']),
      'avg_basket': _extractValue(raw['avg_basket']),
      'basket_trend': _extractChange(raw['avg_basket']),
      'net_profit': _extractValue(raw['net_profit']),
      'profit_trend': _extractChange(raw['net_profit']),
      'unique_customers': raw['unique_customers'] ?? 0,
      'total_refunds': raw['total_refunds'] ?? 0,
    };
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
    final raw = response.data['data'] as Map<String, dynamic>;
    final revenue = raw['revenue'] as Map<String, dynamic>? ?? {};
    final payments = raw['payments'] as List? ?? [];

    // Flatten nested revenue structure into flat keys the UI expects
    final paymentMethods = <String, dynamic>{};
    for (final p in payments) {
      if (p is Map<String, dynamic>) {
        paymentMethods[p['method']?.toString() ?? 'other'] = p['total'] ?? 0;
      }
    }

    return {
      'total_revenue': revenue['total'] ?? 0,
      'total_cost': revenue['cost'] ?? 0,
      'net_profit': revenue['net'] ?? 0,
      'total_tax': revenue['tax'] ?? 0,
      'total_discount': revenue['discounts'] ?? 0,
      'total_refunds': revenue['refunds'] ?? 0,
      'payment_methods': paymentMethods,
      'period': raw['period'],
      'daily': raw['daily'],
    };
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

  dynamic _extractValue(dynamic field) {
    if (field is Map) return field['value'];
    return field;
  }

  dynamic _extractChange(dynamic field) {
    if (field is Map) return field['change'];
    return null;
  }
}
