// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/reports/data/remote/report_api_service.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';

// ─── Helpers ──────────────────────────────────────────────────────

/// Creates a Dio whose interceptor resolves every request via [handler].
Dio _fakeDio(Map<String, dynamic> Function(RequestOptions opts) handler) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (opts, requestHandler) {
        try {
          final data = handler(opts);
          requestHandler.resolve(Response(data: data, requestOptions: opts, statusCode: 200));
        } catch (e) {
          requestHandler.reject(DioException(requestOptions: opts, error: e));
        }
      },
    ),
  );
  return dio;
}

/// Standard API envelope.
Map<String, dynamic> _envelope(dynamic data, {String message = 'ok'}) =>
    {'success': true, 'message': message, 'data': data};

/// Returns a Dio that always rejects with a 500 DioException.
Dio _errorDio() {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (opts, requestHandler) {
        requestHandler.reject(
          DioException(
            requestOptions: opts,
            response: Response(requestOptions: opts, statusCode: 500),
            type: DioExceptionType.badResponse,
          ),
        );
      },
    ),
  );
  return dio;
}

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  group('ReportApiService', () {
    // ─ getSalesSummary ───────────────────────────────────────

    test('getSalesSummary: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.salesSummary);
        expect(opts.method, 'GET');
        return _envelope({
          'totals': {'total_revenue': 5000.0, 'total_transactions': 20},
          'series': [
            {'date': '2024-06-01', 'total_revenue': 2000.0},
            {'date': '2024-06-02', 'total_revenue': 3000.0},
          ],
          'previous_period': null,
        });
      });

      final svc = ReportApiService(dio);
      final result = await svc.getSalesSummary();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['totals']['total_revenue'], 5000.0);
      expect((result['series'] as List).length, 2);
    });

    test('getSalesSummary: passes filter query params', () async {
      final filter = ReportFilters(
        dateRange: DateTimeRange(
          start: DateTime(2024, 6, 1),
          end: DateTime(2024, 6, 30),
        ),
        granularity: 'monthly',
        compare: true,
        orderSource: 'pos',
      );

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['date_from'], '2024-06-01');
        expect(opts.queryParameters['date_to'], '2024-06-30');
        expect(opts.queryParameters['granularity'], 'monthly');
        expect(opts.queryParameters['compare'], '1');
        expect(opts.queryParameters['order_source'], 'pos');
        return _envelope({'totals': {}, 'series': []});
      });

      final svc = ReportApiService(dio);
      await svc.getSalesSummary(filters: filter);
    });

    test('getSalesSummary: propagates DioException on error', () async {
      final svc = ReportApiService(_errorDio());
      expect(svc.getSalesSummary(), throwsA(isA<DioException>()));
    });

    // ─ getProductPerformance ─────────────────────────────────

    test('getProductPerformance: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.productPerformance);
        expect(opts.method, 'GET');
        return _envelope([
          {'product_name': 'Laptop', 'total_revenue': 5000.0, 'quantity_sold': 10},
          {'product_name': 'Mouse', 'total_revenue': 500.0, 'quantity_sold': 50},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getProductPerformance();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 2);
      expect(result.first['product_name'], 'Laptop');
    });

    test('getProductPerformance: passes category_id filter', () async {
      final filter = ReportFilters(categoryId: 'cat-42');

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['category_id'], 'cat-42');
        return _envelope(<Map<String, dynamic>>[]);
      });

      final svc = ReportApiService(dio);
      await svc.getProductPerformance(filters: filter);
    });

    // ─ getCategoryBreakdown ──────────────────────────────────

    test('getCategoryBreakdown: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.categoryBreakdown);
        return _envelope([
          {'category_name': 'Electronics', 'total_revenue': 10000.0},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getCategoryBreakdown();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['category_name'], 'Electronics');
    });

    // ─ getStaffPerformance ───────────────────────────────────

    test('getStaffPerformance: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.staffPerformance);
        return _envelope([
          {'staff_name': 'Ahmed Ali', 'total_orders': 25, 'hours_worked': 40.0},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getStaffPerformance();

      expect(result.length, 1);
      expect(result.first['hours_worked'], 40.0);
    });

    test('getStaffPerformance: passes staff_id filter', () async {
      final filter = ReportFilters(staffId: 'staff-99');

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['staff_id'], 'staff-99');
        return _envelope(<Map<String, dynamic>>[]);
      });

      final svc = ReportApiService(dio);
      await svc.getStaffPerformance(filters: filter);
    });

    // ─ getHourlySales ────────────────────────────────────────

    test('getHourlySales: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.hourlySales);
        return _envelope(List.generate(24, (h) => {'hour': h, 'total_orders': h * 2, 'total_revenue': h * 50.0}));
      });

      final svc = ReportApiService(dio);
      final result = await svc.getHourlySales();

      expect(result.length, 24);
      expect(result[9]['hour'], 9);
    });

    // ─ getPaymentMethods ─────────────────────────────────────

    test('getPaymentMethods: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.paymentMethods);
        return _envelope([
          {'method': 'cash', 'total_amount': 3000.0, 'transaction_count': 30},
          {'method': 'card', 'total_amount': 2000.0, 'transaction_count': 20},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getPaymentMethods();

      expect(result.length, 2);
      expect(result.first['method'], 'cash');
    });

    test('getPaymentMethods: passes payment_method filter', () async {
      final filter = ReportFilters(paymentMethod: 'card');

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['payment_method'], 'card');
        return _envelope(<Map<String, dynamic>>[]);
      });

      final svc = ReportApiService(dio);
      await svc.getPaymentMethods(filters: filter);
    });

    // ─ getDashboard ──────────────────────────────────────────

    test('getDashboard: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.dashboard);
        expect(opts.method, 'GET');
        return _envelope({
          'today': {'total_transactions': 10, 'total_revenue': 1000.0},
          'yesterday': {'total_transactions': 8, 'total_revenue': 800.0},
          'top_products': [
            {'product_name': 'Laptop', 'revenue': 600.0},
          ],
        });
      });

      final svc = ReportApiService(dio);
      final result = await svc.getDashboard();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['today']['total_transactions'], 10);
      expect(result['yesterday']['total_revenue'], 800.0);
      expect((result['top_products'] as List).length, 1);
    });

    // ─ getSlowMovers ─────────────────────────────────────────

    test('getSlowMovers: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.slowMovers);
        return _envelope([
          {'product_name': 'Old Stock', 'quantity_sold': 1},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getSlowMovers();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['quantity_sold'], 1);
    });

    test('getSlowMovers: passes limit filter', () async {
      final filter = ReportFilters(limit: 5);

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['limit'], 5);
        return _envelope(<Map<String, dynamic>>[]);
      });

      final svc = ReportApiService(dio);
      await svc.getSlowMovers(filters: filter);
    });

    // ─ getProductMargin ──────────────────────────────────────

    test('getProductMargin: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.productMargin);
        return _envelope([
          {'product_name': 'Laptop', 'margin_percentage': 40.0, 'revenue': 1000.0, 'cost': 600.0},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getProductMargin();

      expect(result.first['margin_percentage'], 40.0);
    });

    // ─ getInventoryValuation ─────────────────────────────────

    test('getInventoryValuation: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.inventoryValuation);
        return _envelope({
          'total_stock_value': 50000.0,
          'total_cost_value': 35000.0,
          'total_products': 120,
          'products': [],
        });
      });

      final svc = ReportApiService(dio);
      final result = await svc.getInventoryValuation();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['total_stock_value'], 50000.0);
    });

    // ─ getInventoryTurnover ──────────────────────────────────

    test('getInventoryTurnover: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.inventoryTurnover);
        return _envelope([
          {'product_name': 'Laptop', 'turnover_rate': 2.5},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getInventoryTurnover();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['turnover_rate'], 2.5);
    });

    // ─ getInventoryShrinkage ─────────────────────────────────

    test('getInventoryShrinkage: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.inventoryShrinkage);
        return _envelope({'total_shrinkage_value': 500.0, 'items': []});
      });

      final svc = ReportApiService(dio);
      final result = await svc.getInventoryShrinkage();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['total_shrinkage_value'], 500.0);
    });

    // ─ getInventoryLowStock ──────────────────────────────────

    test('getInventoryLowStock: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.inventoryLowStock);
        return _envelope([
          {'product_name': 'Sugar', 'current_stock': 2, 'reorder_point': 10},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getInventoryLowStock();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['current_stock'], 2);
    });

    // ─ getInventoryExpiry ────────────────────────────────────

    test('getInventoryExpiry: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.inventoryExpiry);
        return _envelope({'expiring_soon': [], 'expired': []});
      });

      final svc = ReportApiService(dio);
      final result = await svc.getInventoryExpiry();

      expect(result, isA<Map<String, dynamic>>());
      expect(result.containsKey('expiring_soon'), isTrue);
    });

    // ─ getFinancialDailyPl ───────────────────────────────────

    test('getFinancialDailyPl: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.financialDailyPl);
        return _envelope({
          'totals': {'net_profit': 2000.0, 'total_revenue': 5000.0},
          'daily': [
            {'date': '2024-06-01', 'net_profit': 2000.0},
          ],
        });
      });

      final svc = ReportApiService(dio);
      final result = await svc.getFinancialDailyPl();

      expect(result['totals']['net_profit'], 2000.0);
      expect((result['daily'] as List).length, 1);
    });

    // ─ getFinancialExpenses ──────────────────────────────────

    test('getFinancialExpenses: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.financialExpenses);
        return _envelope({
          'total_expenses': 1500.0,
          'categories': [
            {'category': 'Rent', 'total': 1000.0},
          ],
        });
      });

      final svc = ReportApiService(dio);
      final result = await svc.getFinancialExpenses();

      expect(result['total_expenses'], 1500.0);
      expect((result['categories'] as List).length, 1);
    });

    // ─ getFinancialCashVariance ──────────────────────────────

    test('getFinancialCashVariance: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.financialCashVariance);
        return _envelope({'total_variance': -50.0, 'sessions': []});
      });

      final svc = ReportApiService(dio);
      final result = await svc.getFinancialCashVariance();

      expect(result['total_variance'], -50.0);
    });

    // ─ getFinancialDeliveryCommission ────────────────────────

    test('getFinancialDeliveryCommission: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.financialDeliveryCommission);
        return _envelope({'total_commission': 300.0, 'orders': []});
      });

      final svc = ReportApiService(dio);
      final result = await svc.getFinancialDeliveryCommission();

      expect(result['total_commission'], 300.0);
    });

    // ─ getTopCustomers ───────────────────────────────────────

    test('getTopCustomers: calls correct endpoint and returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.topCustomers);
        return _envelope([
          {'customer_name': 'Ali Hassan', 'total_spent': 5000.0, 'order_count': 10},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getTopCustomers();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['customer_name'], 'Ali Hassan');
    });

    test('getTopCustomers: passes min_amount filter', () async {
      final filter = ReportFilters(minAmount: 100.0);

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['min_amount'], 100.0);
        return _envelope(<Map<String, dynamic>>[]);
      });

      final svc = ReportApiService(dio);
      await svc.getTopCustomers(filters: filter);
    });

    // ─ getCustomerRetention ──────────────────────────────────

    test('getCustomerRetention: calls correct endpoint and returns Map', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.customerRetention);
        return _envelope({
          'total_customers': 100,
          'new_customers': 20,
          'returning_customers': 80,
          'returning_customers_30d': 40,
          'loyalty_points_redeemed': 1500,
        });
      });

      final svc = ReportApiService(dio);
      final result = await svc.getCustomerRetention();

      expect(result['returning_customers_30d'], 40);
      expect(result['loyalty_points_redeemed'], 1500);
    });

    // ─ exportReport ──────────────────────────────────────────

    test('exportReport: uses POST and sends correct body', () async {
      final filter = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 6, 1), end: DateTime(2024, 6, 30)),
      );

      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.reportExport);
        expect(opts.method, 'POST');
        final body = opts.data as Map<String, dynamic>;
        expect(body['report_type'], 'sales_summary');
        expect(body['format'], 'csv');
        expect(body['date_from'], '2024-06-01');
        expect(body['date_to'], '2024-06-30');
        return _envelope({'url': 'https://example.com/export.csv', 'format': 'csv', 'filename': 'report.csv'});
      });

      final svc = ReportApiService(dio);
      final result = await svc.exportReport(reportType: 'sales_summary', format: 'csv', filters: filter);

      expect(result['format'], 'csv');
      expect(result['filename'], 'report.csv');
    });

    test('exportReport: pdf format sends correct body', () async {
      final dio = _fakeDio((opts) {
        final body = opts.data as Map<String, dynamic>;
        expect(body['format'], 'pdf');
        return _envelope({'url': 'https://example.com/report.pdf', 'format': 'pdf', 'filename': 'report.pdf'});
      });

      final svc = ReportApiService(dio);
      final result = await svc.exportReport(reportType: 'product_performance', format: 'pdf');

      expect(result['format'], 'pdf');
    });

    // ─ getScheduledReports ───────────────────────────────────

    test('getScheduledReports: GET correct endpoint, returns List', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.reportSchedules);
        expect(opts.method, 'GET');
        return _envelope([
          {'id': 'sch-1', 'name': 'Daily Sales', 'frequency': 'daily', 'is_active': true},
        ]);
      });

      final svc = ReportApiService(dio);
      final result = await svc.getScheduledReports();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.first['name'], 'Daily Sales');
    });

    // ─ createScheduledReport ────────────────────────────────

    test('createScheduledReport: POST correct endpoint with body', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.reportSchedules);
        expect(opts.method, 'POST');
        final body = opts.data as Map<String, dynamic>;
        expect(body['report_type'], 'sales_summary');
        expect(body['name'], 'Daily Sales Report');
        expect(body['frequency'], 'daily');
        expect(body['recipients'], ['manager@example.com']);
        expect(body.containsKey('format'), isFalse);
        return _envelope({'id': 'sch-new', 'name': 'Daily Sales Report', 'next_run_at': '2024-07-01T08:00:00Z'});
      });

      final svc = ReportApiService(dio);
      final result = await svc.createScheduledReport(
        reportType: 'sales_summary',
        name: 'Daily Sales Report',
        frequency: 'daily',
        recipients: ['manager@example.com'],
      );

      expect(result['id'], 'sch-new');
      expect(result.containsKey('next_run_at'), isTrue);
    });

    test('createScheduledReport: includes format when provided', () async {
      final dio = _fakeDio((opts) {
        final body = opts.data as Map<String, dynamic>;
        expect(body['format'], 'pdf');
        return _envelope({'id': 'sch-pdf'});
      });

      final svc = ReportApiService(dio);
      await svc.createScheduledReport(
        reportType: 'product_performance',
        name: 'Weekly Report',
        frequency: 'weekly',
        recipients: ['owner@example.com'],
        format: 'pdf',
      );
    });

    // ─ deleteScheduledReport ────────────────────────────────

    test('deleteScheduledReport: DELETE correct endpoint with id', () async {
      const scheduleId = 'sch-delete-me';

      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.reportScheduleDelete(scheduleId));
        expect(opts.method, 'DELETE');
        return {'success': true};
      });

      final svc = ReportApiService(dio);
      // Should complete without error
      await expectLater(svc.deleteScheduledReport(scheduleId), completes);
    });

    test('deleteScheduledReport: propagates DioException on error', () async {
      final svc = ReportApiService(_errorDio());
      expect(svc.deleteScheduledReport('sch-gone'), throwsA(isA<DioException>()));
    });

    // ─ sort_by / sort_dir params ────────────────────────────

    test('getSalesSummary: passes sort_by and sort_dir filters', () async {
      final filter = ReportFilters(sortBy: 'total_revenue', sortDir: 'desc');

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['sort_by'], 'total_revenue');
        expect(opts.queryParameters['sort_dir'], 'desc');
        return _envelope({'totals': {}, 'series': []});
      });

      final svc = ReportApiService(dio);
      await svc.getSalesSummary(filters: filter);
    });

    // ─ compare=false does NOT send param ─────────────────────

    test('getSalesSummary: compare=false does not send compare param', () async {
      const filter = ReportFilters(compare: false);

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters.containsKey('compare'), isFalse);
        return _envelope({'totals': {}, 'series': []});
      });

      final svc = ReportApiService(dio);
      await svc.getSalesSummary(filters: filter);
    });

    // ─ branch_id param ───────────────────────────────────────

    test('getStaffPerformance: passes branch_id filter', () async {
      final filter = ReportFilters(branchId: 'branch-7');

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['branch_id'], 'branch-7');
        return _envelope(<Map<String, dynamic>>[]);
      });

      final svc = ReportApiService(dio);
      await svc.getStaffPerformance(filters: filter);
    });

    // ─ order_status param ────────────────────────────────────

    test('getProductPerformance: passes order_status filter', () async {
      final filter = ReportFilters(orderStatus: 'completed');

      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['order_status'], 'completed');
        return _envelope(<Map<String, dynamic>>[]);
      });

      final svc = ReportApiService(dio);
      await svc.getProductPerformance(filters: filter);
    });
  });
}
