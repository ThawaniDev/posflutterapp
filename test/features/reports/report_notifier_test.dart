// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/reports/data/remote/report_api_service.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/repositories/report_repository.dart';

// ─── Fake Repository ──────────────────────────────────────────────

/// A fake [ReportRepository] that allows controlling the response or error
/// for each method. Extend to add methods as needed by tests.
class _FakeRepo extends ReportRepository {
  _FakeRepo() : super(_noopApiService());

  // Configurable responses
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetSalesSummary;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetProductPerformance;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetCategoryBreakdown;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetStaffPerformance;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetHourlySales;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetPaymentMethods;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetDashboard;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetSlowMovers;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetProductMargin;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetInventoryValuation;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetInventoryTurnover;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetInventoryShrinkage;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetInventoryLowStock;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetInventoryExpiry;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetFinancialDailyPl;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetFinancialExpenses;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetFinancialCashVariance;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetFinancialDeliveryCommission;
  Future<List<Map<String, dynamic>>> Function(ReportFilters)? onGetTopCustomers;
  Future<Map<String, dynamic>> Function(ReportFilters)? onGetCustomerRetention;
  Future<List<Map<String, dynamic>>> Function()? onGetScheduledReports;

  @override
  Future<Map<String, dynamic>> getSalesSummary({ReportFilters filters = const ReportFilters()}) =>
      onGetSalesSummary?.call(filters) ?? super.getSalesSummary(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getProductPerformance({ReportFilters filters = const ReportFilters()}) =>
      onGetProductPerformance?.call(filters) ?? super.getProductPerformance(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getCategoryBreakdown({ReportFilters filters = const ReportFilters()}) =>
      onGetCategoryBreakdown?.call(filters) ?? super.getCategoryBreakdown(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getStaffPerformance({ReportFilters filters = const ReportFilters()}) =>
      onGetStaffPerformance?.call(filters) ?? super.getStaffPerformance(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getHourlySales({ReportFilters filters = const ReportFilters()}) =>
      onGetHourlySales?.call(filters) ?? super.getHourlySales(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getPaymentMethods({ReportFilters filters = const ReportFilters()}) =>
      onGetPaymentMethods?.call(filters) ?? super.getPaymentMethods(filters: filters);

  @override
  Future<Map<String, dynamic>> getDashboard({ReportFilters filters = const ReportFilters()}) =>
      onGetDashboard?.call(filters) ?? super.getDashboard(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getSlowMovers({ReportFilters filters = const ReportFilters()}) =>
      onGetSlowMovers?.call(filters) ?? super.getSlowMovers(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getProductMargin({ReportFilters filters = const ReportFilters()}) =>
      onGetProductMargin?.call(filters) ?? super.getProductMargin(filters: filters);

  @override
  Future<Map<String, dynamic>> getInventoryValuation({ReportFilters filters = const ReportFilters()}) =>
      onGetInventoryValuation?.call(filters) ?? super.getInventoryValuation(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getInventoryTurnover({ReportFilters filters = const ReportFilters()}) =>
      onGetInventoryTurnover?.call(filters) ?? super.getInventoryTurnover(filters: filters);

  @override
  Future<Map<String, dynamic>> getInventoryShrinkage({ReportFilters filters = const ReportFilters()}) =>
      onGetInventoryShrinkage?.call(filters) ?? super.getInventoryShrinkage(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getInventoryLowStock({ReportFilters filters = const ReportFilters()}) =>
      onGetInventoryLowStock?.call(filters) ?? super.getInventoryLowStock(filters: filters);

  @override
  Future<Map<String, dynamic>> getInventoryExpiry({ReportFilters filters = const ReportFilters()}) =>
      onGetInventoryExpiry?.call(filters) ?? super.getInventoryExpiry(filters: filters);

  @override
  Future<Map<String, dynamic>> getFinancialDailyPl({ReportFilters filters = const ReportFilters()}) =>
      onGetFinancialDailyPl?.call(filters) ?? super.getFinancialDailyPl(filters: filters);

  @override
  Future<Map<String, dynamic>> getFinancialExpenses({ReportFilters filters = const ReportFilters()}) =>
      onGetFinancialExpenses?.call(filters) ?? super.getFinancialExpenses(filters: filters);

  @override
  Future<Map<String, dynamic>> getFinancialCashVariance({ReportFilters filters = const ReportFilters()}) =>
      onGetFinancialCashVariance?.call(filters) ?? super.getFinancialCashVariance(filters: filters);

  @override
  Future<Map<String, dynamic>> getFinancialDeliveryCommission({ReportFilters filters = const ReportFilters()}) =>
      onGetFinancialDeliveryCommission?.call(filters) ?? super.getFinancialDeliveryCommission(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getTopCustomers({ReportFilters filters = const ReportFilters()}) =>
      onGetTopCustomers?.call(filters) ?? super.getTopCustomers(filters: filters);

  @override
  Future<Map<String, dynamic>> getCustomerRetention({ReportFilters filters = const ReportFilters()}) =>
      onGetCustomerRetention?.call(filters) ?? super.getCustomerRetention(filters: filters);

  @override
  Future<List<Map<String, dynamic>>> getScheduledReports() => onGetScheduledReports?.call() ?? super.getScheduledReports();
}

/// A no-op Dio used to satisfy [ReportApiService] constructor when the
/// _FakeRepo overrides will never delegate to the parent.
ReportApiService _noopApiService() {
  final dio = Dio();
  // No interceptors — any real call would throw. Overridden methods never
  // call super, so this is fine for tests that configure onGet* handlers.
  return ReportApiService(dio);
}

// ─── Helper ───────────────────────────────────────────────────────

/// Build a [ProviderContainer] that overrides [reportRepositoryProvider] with
/// the given [fakeRepo].
ProviderContainer _container(_FakeRepo fakeRepo) {
  return ProviderContainer(overrides: [reportRepositoryProvider.overrideWithValue(fakeRepo)]);
}

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════
  // SalesSummaryNotifier
  // ═══════════════════════════════════════════════════════════

  group('SalesSummaryNotifier', () {
    final sampleData = {
      'totals': {'total_revenue': 5000.0, 'total_transactions': 20},
      'series': [
        {'date': '2024-06-01', 'total_revenue': 2000.0},
        {'date': '2024-06-02', 'total_revenue': 3000.0},
      ],
    };

    test('initial state is SalesSummaryInitial', () {
      final repo = _FakeRepo();
      final notifier = SalesSummaryNotifier(repo);
      expect(notifier.state, isA<SalesSummaryInitial>());
    });

    test('transitions to Loaded on success', () async {
      final repo = _FakeRepo()..onGetSalesSummary = (_) async => sampleData;
      final notifier = SalesSummaryNotifier(repo);
      await notifier.load();

      final state = notifier.state as SalesSummaryLoaded;
      expect(state.totals['total_revenue'], 5000.0);
      expect(state.daily.length, 2);
      expect(state.previousPeriod, isNull);
    });

    test('transitions to Loaded with previousPeriod when compare=true', () async {
      final withPrev = {
        ...sampleData,
        'previous_period': {'total_revenue': 4000.0},
      };

      final repo = _FakeRepo()..onGetSalesSummary = (_) async => withPrev;
      final notifier = SalesSummaryNotifier(repo);
      await notifier.load(filters: const ReportFilters(compare: true));

      final state = notifier.state as SalesSummaryLoaded;
      expect(state.previousPeriod, isNotNull);
      expect(state.previousPeriod!['total_revenue'], 4000.0);
    });

    test('transitions to SalesSummaryError on exception', () async {
      final repo = _FakeRepo()..onGetSalesSummary = (_) async => throw Exception('network error');
      final notifier = SalesSummaryNotifier(repo);
      await notifier.load();

      final state = notifier.state as SalesSummaryError;
      expect(state.message, contains('network error'));
    });

    test('DioException 402 yields subscription_required error message', () async {
      final opts = RequestOptions(path: '/test');
      final repo = _FakeRepo()
        ..onGetSalesSummary = (_) async => throw DioException(
          requestOptions: opts,
          response: Response(requestOptions: opts, statusCode: 402),
          type: DioExceptionType.badResponse,
        );

      final notifier = SalesSummaryNotifier(repo);
      await notifier.load();

      final state = notifier.state as SalesSummaryError;
      expect(state.message, 'subscription_required');
    });

    test('does not overwrite Loaded state with Loading on reload', () async {
      final repo = _FakeRepo()..onGetSalesSummary = (_) async => sampleData;
      final notifier = SalesSummaryNotifier(repo);

      // First load → Loaded
      await notifier.load();
      expect(notifier.state, isA<SalesSummaryLoaded>());

      // Second load while already loaded → should NOT flash Loading
      final completer = Future<void>(() async {
        // Call load synchronously captures that state remains Loaded
        final before = notifier.state;
        notifier.load();
        expect(notifier.state, same(before)); // still Loaded, not Loading
      });
      await completer;
    });

    test('passes filters to repository', () async {
      ReportFilters? captured;
      final filter = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 6, 1), end: DateTime(2024, 6, 30)),
        granularity: 'monthly',
      );

      final repo = _FakeRepo()
        ..onGetSalesSummary = (f) async {
          captured = f;
          return sampleData;
        };

      final notifier = SalesSummaryNotifier(repo);
      await notifier.load(filters: filter);

      expect(captured?.granularity, 'monthly');
      expect(captured?.dateRange?.start, DateTime(2024, 6, 1));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // ProductPerformanceNotifier
  // ═══════════════════════════════════════════════════════════

  group('ProductPerformanceNotifier', () {
    final sampleProducts = [
      {'product_name': 'Laptop', 'total_revenue': 5000.0, 'quantity_sold': 10},
      {'product_name': 'Mouse', 'total_revenue': 500.0, 'quantity_sold': 50},
    ];

    test('initial state is ProductPerformanceInitial', () {
      final notifier = ProductPerformanceNotifier(_FakeRepo());
      expect(notifier.state, isA<ProductPerformanceInitial>());
    });

    test('transitions to Loaded on success', () async {
      final repo = _FakeRepo()..onGetProductPerformance = (_) async => sampleProducts;
      final notifier = ProductPerformanceNotifier(repo);
      await notifier.load();

      final state = notifier.state as ProductPerformanceLoaded;
      expect(state.products.length, 2);
      expect(state.products.first['product_name'], 'Laptop');
    });

    test('transitions to Error on exception', () async {
      final repo = _FakeRepo()..onGetProductPerformance = (_) async => throw Exception('timeout');
      final notifier = ProductPerformanceNotifier(repo);
      await notifier.load();

      expect(notifier.state, isA<ProductPerformanceError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // DashboardNotifier
  // ═══════════════════════════════════════════════════════════

  group('DashboardNotifier', () {
    final sampleDashboard = {
      'today': {'total_transactions': 10, 'total_revenue': 1000.0, 'net_revenue': 800.0},
      'yesterday': {'total_transactions': 8, 'total_revenue': 800.0, 'net_revenue': 640.0},
      'top_products': [
        {'product_name': 'Laptop', 'revenue': 600.0},
      ],
    };

    test('initial state is DashboardInitial', () {
      final notifier = DashboardNotifier(_FakeRepo());
      expect(notifier.state, isA<DashboardInitial>());
    });

    test('transitions through Loading → Loaded', () async {
      final states = <DashboardState>[];
      final repo = _FakeRepo()..onGetDashboard = (_) async => sampleDashboard;
      final notifier = DashboardNotifier(repo);
      notifier.addListener(states.add);

      await notifier.load();

      expect(states.any((s) => s is DashboardLoading), isTrue);
      expect(notifier.state, isA<DashboardLoaded>());
    });

    test('Loaded state has correct today/yesterday/topProducts', () async {
      final repo = _FakeRepo()..onGetDashboard = (_) async => sampleDashboard;
      final notifier = DashboardNotifier(repo);
      await notifier.load();

      final state = notifier.state as DashboardLoaded;
      expect(state.today['total_revenue'], 1000.0);
      expect(state.yesterday['total_transactions'], 8);
      expect(state.topProducts.length, 1);
      expect(state.topProducts.first['product_name'], 'Laptop');
    });

    test('transitions to Error on exception', () async {
      final repo = _FakeRepo()..onGetDashboard = (_) async => throw Exception('server down');
      final notifier = DashboardNotifier(repo);
      await notifier.load();

      final state = notifier.state as DashboardError;
      expect(state.message, contains('server down'));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // StaffPerformanceNotifier
  // ═══════════════════════════════════════════════════════════

  group('StaffPerformanceNotifier', () {
    test('Loaded state contains staff list', () async {
      final sampleStaff = [
        {'staff_name': 'Ahmed Ali', 'total_orders': 25, 'hours_worked': 40.0},
      ];

      final repo = _FakeRepo()..onGetStaffPerformance = (_) async => sampleStaff;
      final notifier = StaffPerformanceNotifier(repo);
      await notifier.load();

      final state = notifier.state as StaffPerformanceLoaded;
      expect(state.staff.first['hours_worked'], 40.0);
    });

    test('transitions to Error on exception', () async {
      final repo = _FakeRepo()..onGetStaffPerformance = (_) async => throw Exception('permission denied');
      final notifier = StaffPerformanceNotifier(repo);
      await notifier.load();

      expect(notifier.state, isA<StaffPerformanceError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // HourlySalesNotifier
  // ═══════════════════════════════════════════════════════════

  group('HourlySalesNotifier', () {
    test('Loaded state contains 24-bucket list', () async {
      final buckets = List.generate(24, (h) => {'hour': h, 'total_orders': h, 'total_revenue': h * 50.0});
      final repo = _FakeRepo()..onGetHourlySales = (_) async => buckets;
      final notifier = HourlySalesNotifier(repo);
      await notifier.load();

      final state = notifier.state as HourlySalesLoaded;
      expect(state.hours.length, 24);
      expect(state.hours[14]['hour'], 14);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // PaymentMethodsNotifier
  // ═══════════════════════════════════════════════════════════

  group('PaymentMethodsNotifier', () {
    test('Loaded state contains methods list', () async {
      final methods = [
        {'method': 'cash', 'total_amount': 3000.0},
        {'method': 'card', 'total_amount': 2000.0},
      ];
      final repo = _FakeRepo()..onGetPaymentMethods = (_) async => methods;
      final notifier = PaymentMethodsNotifier(repo);
      await notifier.load();

      final state = notifier.state as PaymentMethodsLoaded;
      expect(state.methods.length, 2);
      expect(state.methods.first['method'], 'cash');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // InventoryValuationNotifier
  // ═══════════════════════════════════════════════════════════

  group('InventoryValuationNotifier', () {
    test('Loaded state contains data map', () async {
      final data = {'total_stock_value': 50000.0, 'total_products': 120, 'products': []};
      final repo = _FakeRepo()..onGetInventoryValuation = (_) async => data;
      final notifier = InventoryValuationNotifier(repo);
      await notifier.load();

      final state = notifier.state as InventoryValuationLoaded;
      expect(state.data['total_stock_value'], 50000.0);
    });

    test('transitions to Error on exception', () async {
      final repo = _FakeRepo()..onGetInventoryValuation = (_) async => throw Exception('no data');
      final notifier = InventoryValuationNotifier(repo);
      await notifier.load();

      expect(notifier.state, isA<InventoryValuationError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // InventoryLowStockNotifier
  // ═══════════════════════════════════════════════════════════

  group('InventoryLowStockNotifier', () {
    test('Loaded state contains low stock products', () async {
      final products = [
        {'product_name': 'Sugar', 'current_stock': 2, 'reorder_point': 10},
      ];
      final repo = _FakeRepo()..onGetInventoryLowStock = (_) async => products;
      final notifier = InventoryLowStockNotifier(repo);
      await notifier.load();

      final state = notifier.state as InventoryLowStockLoaded;
      expect(state.products.first['product_name'], 'Sugar');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // FinancialDailyPlNotifier
  // ═══════════════════════════════════════════════════════════

  group('FinancialDailyPlNotifier', () {
    test('Loaded state maps totals and daily correctly', () async {
      final data = {
        'totals': {'net_profit': 2000.0, 'total_revenue': 5000.0},
        'daily': [
          {'date': '2024-06-01', 'net_profit': 2000.0},
        ],
      };
      final repo = _FakeRepo()..onGetFinancialDailyPl = (_) async => data;
      final notifier = FinancialDailyPlNotifier(repo);
      await notifier.load();

      final state = notifier.state as FinancialDailyPlLoaded;
      expect(state.totals['net_profit'], 2000.0);
      expect(state.daily.length, 1);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // FinancialExpensesNotifier
  // ═══════════════════════════════════════════════════════════

  group('FinancialExpensesNotifier', () {
    test('Loaded state has totalExpenses and categories', () async {
      final data = {
        'total_expenses': 1500.0,
        'categories': [
          {'category': 'Rent', 'total': 1000.0},
        ],
      };
      final repo = _FakeRepo()..onGetFinancialExpenses = (_) async => data;
      final notifier = FinancialExpensesNotifier(repo);
      await notifier.load();

      final state = notifier.state as FinancialExpensesLoaded;
      expect(state.totalExpenses, 1500.0);
      expect(state.categories.length, 1);
    });

    test('handles string total_expenses via double.tryParse', () async {
      final data = {'total_expenses': '2500.50', 'categories': []};
      final repo = _FakeRepo()..onGetFinancialExpenses = (_) async => data;
      final notifier = FinancialExpensesNotifier(repo);
      await notifier.load();

      final state = notifier.state as FinancialExpensesLoaded;
      expect(state.totalExpenses, 2500.50);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // TopCustomersNotifier
  // ═══════════════════════════════════════════════════════════

  group('TopCustomersNotifier', () {
    test('Loaded state contains customers list', () async {
      final customers = [
        {'customer_name': 'Ali Hassan', 'total_spent': 5000.0, 'order_count': 10},
      ];
      final repo = _FakeRepo()..onGetTopCustomers = (_) async => customers;
      final notifier = TopCustomersNotifier(repo);
      await notifier.load();

      final state = notifier.state as TopCustomersLoaded;
      expect(state.customers.first['customer_name'], 'Ali Hassan');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // CustomerRetentionNotifier
  // ═══════════════════════════════════════════════════════════

  group('CustomerRetentionNotifier', () {
    test('Loaded state contains data map', () async {
      final data = {
        'total_customers': 100,
        'new_customers': 20,
        'returning_customers': 80,
        'returning_customers_30d': 40,
        'loyalty_points_redeemed': 1500,
      };
      final repo = _FakeRepo()..onGetCustomerRetention = (_) async => data;
      final notifier = CustomerRetentionNotifier(repo);
      await notifier.load();

      final state = notifier.state as CustomerRetentionLoaded;
      expect(state.data['returning_customers_30d'], 40);
      expect(state.data['loyalty_points_redeemed'], 1500);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SlowMoversNotifier
  // ═══════════════════════════════════════════════════════════

  group('SlowMoversNotifier', () {
    test('Loaded state contains slow products', () async {
      final products = [
        {'product_name': 'Old Stock Item', 'quantity_sold': 0},
      ];
      final repo = _FakeRepo()..onGetSlowMovers = (_) async => products;
      final notifier = SlowMoversNotifier(repo);
      await notifier.load();

      final state = notifier.state as SlowMoversLoaded;
      expect(state.products.first['quantity_sold'], 0);
    });

    test('transitions to Error on exception', () async {
      final repo = _FakeRepo()..onGetSlowMovers = (_) async => throw Exception('failed');
      final notifier = SlowMoversNotifier(repo);
      await notifier.load();

      expect(notifier.state, isA<SlowMoversError>());
    });
  });

  // ═══════════════════════════════════════════════════════════
  // ProviderContainer overrides
  // ═══════════════════════════════════════════════════════════

  group('ProviderContainer integration', () {
    test('salesSummaryProvider works with overridden repository', () async {
      final sampleData = {
        'totals': {'total_revenue': 9999.0, 'total_transactions': 99},
        'series': [],
      };

      final repo = _FakeRepo()..onGetSalesSummary = (_) async => sampleData;
      final container = _container(repo);
      addTearDown(container.dispose);

      final notifier = container.read(salesSummaryProvider.notifier);
      await notifier.load();

      final state = container.read(salesSummaryProvider);
      expect(state, isA<SalesSummaryLoaded>());
      expect((state as SalesSummaryLoaded).totals['total_revenue'], 9999.0);
    });

    test('productPerformanceProvider works with overridden repository', () async {
      final repo = _FakeRepo()
        ..onGetProductPerformance = (_) async => [
          {'product_name': 'Test Product', 'total_revenue': 1.0, 'quantity_sold': 1},
        ];
      final container = _container(repo);
      addTearDown(container.dispose);

      final notifier = container.read(productPerformanceProvider.notifier);
      await notifier.load();

      final state = container.read(productPerformanceProvider);
      expect(state, isA<ProductPerformanceLoaded>());
    });

    test('dashboard provider error propagates to state', () async {
      final repo = _FakeRepo()..onGetDashboard = (_) async => throw Exception('conn refused');
      final container = _container(repo);
      addTearDown(container.dispose);

      final notifier = container.read(dashboardProvider.notifier);
      await notifier.load();

      final state = container.read(dashboardProvider);
      expect(state, isA<DashboardError>());
      expect((state as DashboardError).message, contains('conn refused'));
    });
  });
}
