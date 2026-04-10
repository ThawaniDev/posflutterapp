import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/companion/providers/companion_state.dart';

void main() {
  // ─── Quick Stats State ─────────────────────────────────
  group('QuickStatsState', () {
    test('QuickStatsInitial is default', () {
      const state = QuickStatsInitial();
      expect(state, isA<QuickStatsState>());
    });

    test('QuickStatsLoading indicates loading', () {
      const state = QuickStatsLoading();
      expect(state, isA<QuickStatsState>());
    });

    test('QuickStatsLoaded holds all fields', () {
      const state = QuickStatsLoaded(
        todayRevenue: 1500.0,
        todayTransactions: 25,
        todayOrders: 20,
        pendingOrders: 3,
        activeStaff: 5,
        lowStockItems: 2,
        lastSync: '2024-01-01T12:00:00Z',
        currency: 'SAR',
        raw: {},
      );
      expect(state.todayRevenue, 1500.0);
      expect(state.todayTransactions, 25);
      expect(state.todayOrders, 20);
      expect(state.pendingOrders, 3);
      expect(state.activeStaff, 5);
      expect(state.lowStockItems, 2);
      expect(state.currency, 'SAR');
    });

    test('QuickStatsError holds message', () {
      const state = QuickStatsError('Network error');
      expect(state.message, 'Network error');
    });
  });

  // ─── Companion Dashboard State ─────────────────────────
  group('CompanionDashboardState', () {
    test('CompanionDashboardInitial is default', () {
      const state = CompanionDashboardInitial();
      expect(state, isA<CompanionDashboardState>());
    });

    test('CompanionDashboardLoaded holds today vs yesterday', () {
      const state = CompanionDashboardLoaded(
        todayRevenue: 2000.0,
        yesterdayRevenue: 1800.0,
        todayOrders: 30,
        yesterdayOrders: 25,
        activeStaff: 4,
        lowStockItems: 1,
        pendingOrders: 2,
        storeIsOpen: true,
        currency: 'SAR',
        raw: {},
      );
      expect(state.todayRevenue, 2000.0);
      expect(state.yesterdayRevenue, 1800.0);
      expect(state.storeIsOpen, true);
    });

    test('CompanionDashboardError holds message', () {
      const state = CompanionDashboardError('Server error');
      expect(state.message, 'Server error');
    });
  });

  // ─── Sales Summary State ───────────────────────────────
  group('SalesSummaryState', () {
    test('SalesSummaryLoaded holds breakdown data', () {
      const state = SalesSummaryLoaded(
        period: {'type': 'week'},
        totalRevenue: 10000.0,
        totalOrders: 80,
        averageOrderValue: 125.0,
        dailyBreakdown: [],
        raw: {},
      );
      expect(state.period, {'type': 'week'});
      expect(state.totalRevenue, 10000.0);
      expect(state.averageOrderValue, 125.0);
    });
  });

  // ─── Active Orders State ───────────────────────────────
  group('ActiveOrdersState', () {
    test('ActiveOrdersLoaded holds orders', () {
      const state = ActiveOrdersLoaded(
        orders: [
          {'id': 'o1', 'status': 'pending', 'total': 120.0},
        ],
        total: 1,
      );
      expect(state.orders, hasLength(1));
      expect(state.total, 1);
    });
  });

  // ─── Inventory Alerts State ────────────────────────────
  group('InventoryAlertsState', () {
    test('InventoryAlertsLoaded holds counts', () {
      const state = InventoryAlertsLoaded(alerts: [], lowStockCount: 5, outOfStockCount: 2);
      expect(state.lowStockCount, 5);
      expect(state.outOfStockCount, 2);
    });
  });

  // ─── Active Staff State ────────────────────────────────
  group('ActiveStaffState', () {
    test('ActiveStaffLoaded holds staff list', () {
      const state = ActiveStaffLoaded(
        staff: [
          {'name': 'Alice', 'role': 'cashier'},
        ],
        totalActive: 1,
      );
      expect(state.staff, hasLength(1));
      expect(state.totalActive, 1);
    });
  });

  // ─── Companion Operation State ─────────────────────────
  group('CompanionOperationState', () {
    test('CompanionOperationIdle is default', () {
      const state = CompanionOperationIdle();
      expect(state, isA<CompanionOperationState>());
    });

    test('CompanionOperationRunning holds operation name', () {
      const state = CompanionOperationRunning('register_session');
      expect(state.operation, 'register_session');
    });

    test('CompanionOperationSuccess holds message and optional data', () {
      const state = CompanionOperationSuccess('Done', data: {'session_id': 's1'});
      expect(state.message, 'Done');
      expect(state.data?['session_id'], 's1');
    });

    test('CompanionOperationError holds message', () {
      const state = CompanionOperationError('Failed');
      expect(state.message, 'Failed');
    });
  });
}
