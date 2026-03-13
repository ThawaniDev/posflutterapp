import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/reports/models/daily_sales_summary.dart';
import 'package:thawani_pos/features/reports/models/product_sales_summary.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // Models
  // ═══════════════════════════════════════════════════════════

  group('DailySalesSummary model', () {
    final json = {
      'id': 'dss-1',
      'store_id': 'store-1',
      'date': '2024-06-01',
      'total_transactions': 25,
      'total_revenue': 2500.50,
      'total_cost': 1500.00,
      'total_discount': 100.00,
      'total_tax': 250.00,
      'total_refunds': 50.00,
      'net_revenue': 2100.50,
      'cash_revenue': 1200.00,
      'card_revenue': 1000.50,
      'other_revenue': 300.00,
      'avg_basket_size': 100.02,
    };

    test('fromJson parses correctly', () {
      final summary = DailySalesSummary.fromJson(json);
      expect(summary.id, 'dss-1');
      expect(summary.storeId, 'store-1');
      expect(summary.date, DateTime.parse('2024-06-01'));
      expect(summary.totalTransactions, 25);
      expect(summary.totalRevenue, 2500.50);
      expect(summary.totalCost, 1500.00);
      expect(summary.totalDiscount, 100.00);
      expect(summary.totalTax, 250.00);
      expect(summary.totalRefunds, 50.00);
      expect(summary.netRevenue, 2100.50);
      expect(summary.cashRevenue, 1200.00);
      expect(summary.cardRevenue, 1000.50);
      expect(summary.otherRevenue, 300.00);
      expect(summary.avgBasketSize, 100.02);
    });

    test('toJson roundtrip', () {
      final summary = DailySalesSummary.fromJson(json);
      final output = summary.toJson();
      expect(output['id'], 'dss-1');
      expect(output['store_id'], 'store-1');
      expect(output['total_transactions'], 25);
      expect(output['total_revenue'], 2500.50);
    });

    test('fromJson handles null optionals', () {
      final minimal = {'id': 'dss-2', 'store_id': 'store-1', 'date': '2024-06-02'};
      final summary = DailySalesSummary.fromJson(minimal);
      expect(summary.totalTransactions, isNull);
      expect(summary.totalRevenue, isNull);
      expect(summary.netRevenue, isNull);
    });

    test('copyWith creates new instance', () {
      final summary = DailySalesSummary.fromJson(json);
      final updated = summary.copyWith(totalTransactions: 50);
      expect(updated.totalTransactions, 50);
      expect(updated.totalRevenue, 2500.50); // unchanged
      expect(updated.id, 'dss-1'); // unchanged
    });

    test('equality by id', () {
      final a = DailySalesSummary.fromJson(json);
      final b = DailySalesSummary.fromJson(json);
      expect(a, equals(b));
    });

    test('inequality for different ids', () {
      final a = DailySalesSummary.fromJson(json);
      final b = DailySalesSummary.fromJson({...json, 'id': 'dss-other'});
      expect(a, isNot(equals(b)));
    });
  });

  group('ProductSalesSummary model', () {
    final json = {
      'id': 'pss-1',
      'store_id': 'store-1',
      'product_id': 'prod-1',
      'date': '2024-06-01',
      'quantity_sold': 50.5,
      'revenue': 5050.00,
      'cost': 2525.00,
      'discount_amount': 100.00,
      'tax_amount': 505.00,
      'return_quantity': 2.0,
      'return_amount': 200.00,
    };

    test('fromJson parses correctly', () {
      final summary = ProductSalesSummary.fromJson(json);
      expect(summary.id, 'pss-1');
      expect(summary.storeId, 'store-1');
      expect(summary.productId, 'prod-1');
      expect(summary.quantitySold, 50.5);
      expect(summary.revenue, 5050.00);
      expect(summary.cost, 2525.00);
      expect(summary.discountAmount, 100.00);
      expect(summary.returnQuantity, 2.0);
    });

    test('toJson roundtrip', () {
      final summary = ProductSalesSummary.fromJson(json);
      final output = summary.toJson();
      expect(output['product_id'], 'prod-1');
      expect(output['quantity_sold'], 50.5);
      expect(output['revenue'], 5050.00);
    });

    test('fromJson handles null optionals', () {
      final minimal = {'id': 'pss-2', 'store_id': 'store-1', 'product_id': 'prod-2', 'date': '2024-06-02'};
      final summary = ProductSalesSummary.fromJson(minimal);
      expect(summary.quantitySold, isNull);
      expect(summary.revenue, isNull);
    });

    test('copyWith', () {
      final summary = ProductSalesSummary.fromJson(json);
      final updated = summary.copyWith(revenue: 9999.99);
      expect(updated.revenue, 9999.99);
      expect(updated.productId, 'prod-1');
    });

    test('equality', () {
      final a = ProductSalesSummary.fromJson(json);
      final b = ProductSalesSummary.fromJson(json);
      expect(a, equals(b));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // States
  // ═══════════════════════════════════════════════════════════

  group('SalesSummaryState', () {
    test('initial state', () {
      expect(const SalesSummaryInitial(), isA<SalesSummaryState>());
    });

    test('loading state', () {
      expect(const SalesSummaryLoading(), isA<SalesSummaryState>());
    });

    test('loaded state', () {
      const state = SalesSummaryLoaded(
        totals: {'total_revenue': 1000.0, 'total_transactions': 10},
        daily: [
          {'date': '2024-06-01', 'total_revenue': 500.0},
          {'date': '2024-06-02', 'total_revenue': 500.0},
        ],
      );
      expect(state.totals['total_revenue'], 1000.0);
      expect(state.daily.length, 2);
    });

    test('error state', () {
      const state = SalesSummaryError(message: 'Network error');
      expect(state.message, 'Network error');
    });
  });

  group('ProductPerformanceState', () {
    test('initial state', () {
      expect(const ProductPerformanceInitial(), isA<ProductPerformanceState>());
    });

    test('loaded state', () {
      const state = ProductPerformanceLoaded(
        products: [
          {'product_name': 'Laptop', 'total_revenue': 5000.0, 'profit': 2000.0},
        ],
      );
      expect(state.products.length, 1);
      expect(state.products[0]['product_name'], 'Laptop');
    });

    test('error state', () {
      const state = ProductPerformanceError(message: 'Failed');
      expect(state.message, 'Failed');
    });
  });

  group('CategoryBreakdownState', () {
    test('initial state', () {
      expect(const CategoryBreakdownInitial(), isA<CategoryBreakdownState>());
    });

    test('loaded state', () {
      const state = CategoryBreakdownLoaded(
        categories: [
          {'category_name': 'Electronics', 'total_revenue': 10000.0, 'product_count': 5},
        ],
      );
      expect(state.categories.length, 1);
    });

    test('error state', () {
      const state = CategoryBreakdownError(message: 'Timeout');
      expect(state.message, 'Timeout');
    });
  });

  group('StaffPerformanceState', () {
    test('initial state', () {
      expect(const StaffPerformanceInitial(), isA<StaffPerformanceState>());
    });

    test('loaded state', () {
      const state = StaffPerformanceLoaded(
        staff: [
          {'staff_name': 'Ahmed Ali', 'total_orders': 25, 'total_revenue': 5000.0},
        ],
      );
      expect(state.staff[0]['staff_name'], 'Ahmed Ali');
    });

    test('error state', () {
      const state = StaffPerformanceError(message: 'Access denied');
      expect(state.message, 'Access denied');
    });
  });

  group('HourlySalesState', () {
    test('initial state', () {
      expect(const HourlySalesInitial(), isA<HourlySalesState>());
    });

    test('loaded state', () {
      const state = HourlySalesLoaded(
        hours: [
          {'hour': 9, 'total_orders': 15, 'total_revenue': 750.0},
          {'hour': 14, 'total_orders': 20, 'total_revenue': 1200.0},
        ],
      );
      expect(state.hours.length, 2);
      expect(state.hours[0]['hour'], 9);
    });

    test('error state', () {
      const state = HourlySalesError(message: 'Server error');
      expect(state.message, 'Server error');
    });
  });

  group('PaymentMethodsState', () {
    test('initial state', () {
      expect(const PaymentMethodsInitial(), isA<PaymentMethodsState>());
    });

    test('loaded state', () {
      const state = PaymentMethodsLoaded(
        methods: [
          {'method': 'cash', 'total_amount': 5000.0, 'transaction_count': 50},
          {'method': 'card', 'total_amount': 3000.0, 'transaction_count': 30},
        ],
      );
      expect(state.methods.length, 2);
      expect(state.methods[0]['method'], 'cash');
    });

    test('error state', () {
      const state = PaymentMethodsError(message: 'Unavailable');
      expect(state.message, 'Unavailable');
    });
  });

  group('DashboardState', () {
    test('initial state', () {
      expect(const DashboardInitial(), isA<DashboardState>());
    });

    test('loading state', () {
      expect(const DashboardLoading(), isA<DashboardState>());
    });

    test('loaded state', () {
      const state = DashboardLoaded(
        today: {'total_transactions': 25, 'total_revenue': 2500.0, 'net_revenue': 2000.0},
        yesterday: {'total_transactions': 20, 'total_revenue': 2000.0},
        topProducts: [
          {'product_name': 'Laptop', 'revenue': 1500.0},
        ],
      );
      expect(state.today['total_transactions'], 25);
      expect(state.yesterday['total_revenue'], 2000.0);
      expect(state.topProducts.length, 1);
    });

    test('error state', () {
      const state = DashboardError(message: 'Connection refused');
      expect(state.message, 'Connection refused');
    });
  });
}
