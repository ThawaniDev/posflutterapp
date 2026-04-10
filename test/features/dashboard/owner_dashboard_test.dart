import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/dashboard/providers/dashboard_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // Owner Dashboard State
  // ═══════════════════════════════════════════════════════════

  group('OwnerDashboardState', () {
    test('initial state', () {
      expect(const OwnerDashboardInitial(), isA<OwnerDashboardState>());
    });

    test('loading state', () {
      expect(const OwnerDashboardLoading(), isA<OwnerDashboardState>());
    });

    test('loaded state holds all data', () {
      const state = OwnerDashboardLoaded(
        stats: {
          'today_sales': 12450.0,
          'today_transactions': 142,
          'avg_basket': 87.60,
          'net_profit': 3120.0,
          'sales_trend': 12.5,
          'transactions_trend': -3.2,
          'basket_trend': 5.1,
          'profit_trend': 8.7,
        },
        salesTrend: {
          'current': [
            {'date': '2024-06-01', 'revenue': 1000.0},
            {'date': '2024-06-02', 'revenue': 1200.0},
          ],
          'previous': [
            {'date': '2024-05-25', 'revenue': 900.0},
            {'date': '2024-05-26', 'revenue': 800.0},
          ],
        },
        topProducts: [
          {'product_name': 'Product A', 'total_quantity': 50, 'total_revenue': 5000.0},
          {'product_name': 'Product B', 'total_quantity': 30, 'total_revenue': 3000.0},
        ],
        lowStock: [
          {'product_name': 'Widget X', 'quantity': 3, 'reorder_point': 10},
        ],
        activeCashiers: [
          {'cashier_name': 'Ahmed Ali', 'opened_at': '08:30', 'session_total': 4500.0},
        ],
        recentOrders: [
          {
            'order_number': '1001',
            'status': 'completed',
            'total': 120.50,
            'customer_name': 'Walk-in',
            'created_at': '2024-06-01 14:30',
          },
        ],
        financialSummary: {
          'gross_revenue': 12450.0,
          'net_revenue': 11200.0,
          'tax_collected': 625.0,
          'refunds': 0.0,
        },
        hourlySales: [
          {'hour': 9, 'revenue': 800.0, 'transactions': 12},
          {'hour': 12, 'revenue': 2400.0, 'transactions': 28},
        ],
        staffPerformance: [
          {'name': 'Ahmed', 'sales': 5000.0, 'transactions': 45},
        ],
        branches: [
          {'name': 'Main Branch', 'revenue': 12450.0},
        ],
      );

      expect(state.stats['today_sales'], 12450.0);
      expect(state.stats['today_transactions'], 142);
      expect(state.stats['avg_basket'], 87.60);
      expect(state.stats['net_profit'], 3120.0);
      expect(state.salesTrend['current'], isA<List>());
      expect((state.salesTrend['current'] as List).length, 2);
      expect(state.topProducts.length, 2);
      expect(state.topProducts[0]['product_name'], 'Product A');
      expect(state.lowStock.length, 1);
      expect(state.lowStock[0]['quantity'], 3);
      expect(state.activeCashiers.length, 1);
      expect(state.activeCashiers[0]['cashier_name'], 'Ahmed Ali');
      expect(state.recentOrders.length, 1);
      expect(state.recentOrders[0]['order_number'], '1001');
    });

    test('error state', () {
      const state = OwnerDashboardError(message: 'Connection failed');
      expect(state.message, 'Connection failed');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Financial Summary State
  // ═══════════════════════════════════════════════════════════

  group('FinancialSummaryState', () {
    test('initial state', () {
      expect(const FinancialSummaryInitial(), isA<FinancialSummaryState>());
    });

    test('loading state', () {
      expect(const FinancialSummaryLoading(), isA<FinancialSummaryState>());
    });

    test('loaded state', () {
      const state = FinancialSummaryLoaded(
        data: {
          'revenue': 50000.0,
          'cost': 25000.0,
          'gross_profit': 25000.0,
          'tax_collected': 7500.0,
          'discounts_given': 2000.0,
          'refunds': 500.0,
          'net_profit': 17000.0,
        },
      );
      expect(state.data['revenue'], 50000.0);
      expect(state.data['net_profit'], 17000.0);
      expect(state.data['gross_profit'], 25000.0);
    });

    test('error state', () {
      const state = FinancialSummaryError(message: 'Unauthorized');
      expect(state.message, 'Unauthorized');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Staff Performance State (Dashboard)
  // ═══════════════════════════════════════════════════════════

  group('StaffPerformanceState (dashboard)', () {
    test('initial state', () {
      expect(const StaffPerformanceInitial(), isA<StaffPerformanceState>());
    });

    test('loading state', () {
      expect(const StaffPerformanceLoading(), isA<StaffPerformanceState>());
    });

    test('loaded state', () {
      const state = StaffPerformanceLoaded(
        staff: [
          {'cashier_name': 'Ahmed Ali', 'total_transactions': 45, 'total_revenue': 8500.0, 'avg_transaction': 188.89},
          {'cashier_name': 'Sara Hassan', 'total_transactions': 38, 'total_revenue': 7200.0, 'avg_transaction': 189.47},
        ],
      );
      expect(state.staff.length, 2);
      expect(state.staff[0]['cashier_name'], 'Ahmed Ali');
      expect(state.staff[1]['total_transactions'], 38);
    });

    test('error state', () {
      const state = StaffPerformanceError(message: 'Server error');
      expect(state.message, 'Server error');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Branch Overview State
  // ═══════════════════════════════════════════════════════════

  group('BranchOverviewState', () {
    test('initial state', () {
      expect(const BranchOverviewInitial(), isA<BranchOverviewState>());
    });

    test('loading state', () {
      expect(const BranchOverviewLoading(), isA<BranchOverviewState>());
    });

    test('loaded with branches', () {
      const state = BranchOverviewLoaded(
        branches: [
          {'store_name': 'Main Branch', 'today_sales': 8000.0, 'today_transactions': 85},
          {'store_name': 'Mall Branch', 'today_sales': 4450.0, 'today_transactions': 57},
        ],
      );
      expect(state.branches.length, 2);
      expect(state.branches[0]['store_name'], 'Main Branch');
      expect(state.branches[1]['today_sales'], 4450.0);
    });

    test('loaded with empty branches', () {
      const state = BranchOverviewLoaded(branches: []);
      expect(state.branches, isEmpty);
    });

    test('error state', () {
      const state = BranchOverviewError(message: 'Permission denied');
      expect(state.message, 'Permission denied');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // State Transitions (sealed class exhaustiveness)
  // ═══════════════════════════════════════════════════════════

  group('State pattern matching', () {
    test('owner dashboard state switch exhaustiveness', () {
      const OwnerDashboardState state = OwnerDashboardInitial();
      final result = switch (state) {
        OwnerDashboardInitial() => 'initial',
        OwnerDashboardLoading() => 'loading',
        OwnerDashboardLoaded() => 'loaded',
        OwnerDashboardError() => 'error',
      };
      expect(result, 'initial');
    });

    test('financial summary state switch exhaustiveness', () {
      const FinancialSummaryState state = FinancialSummaryLoading();
      final result = switch (state) {
        FinancialSummaryInitial() => 'initial',
        FinancialSummaryLoading() => 'loading',
        FinancialSummaryLoaded() => 'loaded',
        FinancialSummaryError() => 'error',
      };
      expect(result, 'loading');
    });

    test('branch overview state switch with destructuring', () {
      const BranchOverviewState state = BranchOverviewError(message: 'fail');
      final result = switch (state) {
        BranchOverviewInitial() => 'initial',
        BranchOverviewLoading() => 'loading',
        BranchOverviewLoaded(:final branches) => 'loaded:${branches.length}',
        BranchOverviewError(:final message) => 'error:$message',
      };
      expect(result, 'error:fail');
    });
  });
}
