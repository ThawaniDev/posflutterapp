import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/companion/providers/companion_state.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';

void main() {
  // ═══════════════ State Tests ═══════════════

  group('QuickStatsState', () {
    test('Initial state', () {
      const state = QuickStatsInitial();
      expect(state, isA<QuickStatsState>());
    });

    test('Loading state', () {
      const state = QuickStatsLoading();
      expect(state, isA<QuickStatsState>());
    });

    test('Loaded state holds all stats', () {
      const state = QuickStatsLoaded(
        todayRevenue: 1500.50,
        todayTransactions: 42,
        todayOrders: 38,
        pendingOrders: 4,
        activeStaff: 3,
        lowStockItems: 7,
        lastSync: '2025-01-01T12:00:00Z',
        currency: 'SAR',
        raw: {},
      );
      expect(state.todayRevenue, 1500.50);
      expect(state.todayTransactions, 42);
      expect(state.todayOrders, 38);
      expect(state.pendingOrders, 4);
      expect(state.activeStaff, 3);
      expect(state.lowStockItems, 7);
      expect(state.lastSync, '2025-01-01T12:00:00Z');
      expect(state.currency, 'SAR');
    });

    test('Error state holds message', () {
      const state = QuickStatsError('Network error');
      expect(state.message, 'Network error');
    });
  });

  group('PreferencesState', () {
    test('Initial state', () {
      const state = PreferencesInitial();
      expect(state, isA<PreferencesState>());
    });

    test('Loading state', () {
      const state = PreferencesLoading();
      expect(state, isA<PreferencesState>());
    });

    test('Loaded state holds all preferences', () {
      const state = PreferencesLoaded(
        theme: 'dark',
        language: 'ar',
        compactMode: true,
        notificationsEnabled: false,
        biometricLock: true,
        defaultPage: 'pos',
        currencyDisplay: 'code',
        raw: {},
      );
      expect(state.theme, 'dark');
      expect(state.language, 'ar');
      expect(state.compactMode, true);
      expect(state.notificationsEnabled, false);
      expect(state.biometricLock, true);
      expect(state.defaultPage, 'pos');
      expect(state.currencyDisplay, 'code');
    });

    test('Error state holds message', () {
      const state = PreferencesError('Failed to load');
      expect(state.message, 'Failed to load');
    });
  });

  group('QuickActionsState', () {
    test('Initial state', () {
      const state = QuickActionsInitial();
      expect(state, isA<QuickActionsState>());
    });

    test('Loading state', () {
      const state = QuickActionsLoading();
      expect(state, isA<QuickActionsState>());
    });

    test('Loaded state holds actions list', () {
      const state = QuickActionsLoaded(
        actions: [
          {'id': 'new_sale', 'label': 'New Sale', 'icon': 'point_of_sale', 'enabled': true, 'order': 1},
          {'id': 'view_orders', 'label': 'View Orders', 'icon': 'list_alt', 'enabled': true, 'order': 2},
        ],
      );
      expect(state.actions.length, 2);
      expect(state.actions[0]['id'], 'new_sale');
      expect(state.actions[1]['label'], 'View Orders');
    });

    test('Error state holds message', () {
      const state = QuickActionsError('Timeout');
      expect(state.message, 'Timeout');
    });
  });

  group('CompanionOperationState', () {
    test('Idle state', () {
      const state = CompanionOperationIdle();
      expect(state, isA<CompanionOperationState>());
    });

    test('Running state holds operation name', () {
      const state = CompanionOperationRunning('register_session');
      expect(state.operation, 'register_session');
    });

    test('Success state holds message and optional data', () {
      const state = CompanionOperationSuccess('Session registered', data: {'session_id': 'abc123'});
      expect(state.message, 'Session registered');
      expect(state.data?['session_id'], 'abc123');
    });

    test('Success state with null data', () {
      const state = CompanionOperationSuccess('Done');
      expect(state.data, isNull);
    });

    test('Error state holds message', () {
      const state = CompanionOperationError('Connection refused');
      expect(state.message, 'Connection refused');
    });
  });

  // ═══════════════ Endpoint Tests ═══════════════

  group('Companion API Endpoints', () {
    test('quickStats endpoint', () {
      expect(ApiEndpoints.companionQuickStats, '/companion/quick-stats');
    });

    test('summary endpoint', () {
      expect(ApiEndpoints.companionSummary, '/companion/summary');
    });

    test('sessions endpoint', () {
      expect(ApiEndpoints.companionSessions, '/companion/sessions');
    });

    test('session end endpoint', () {
      expect(ApiEndpoints.companionSessionEnd('abc-123'), '/companion/sessions/abc-123/end');
    });

    test('preferences endpoint', () {
      expect(ApiEndpoints.companionPreferences, '/companion/preferences');
    });

    test('quickActions endpoint', () {
      expect(ApiEndpoints.companionQuickActions, '/companion/quick-actions');
    });

    test('events endpoint', () {
      expect(ApiEndpoints.companionEvents, '/companion/events');
    });
  });

  // ═══════════════ Route Tests ═══════════════

  group('Companion Routes', () {
    test('companionDashboard route is /companion', () {
      expect(Routes.companionDashboard, '/companion');
    });
  });

  // ═══════════════ Cross-cutting ═══════════════

  group('Cross-cutting', () {
    test('QuickStatsLoaded with zero values', () {
      const state = QuickStatsLoaded(
        todayRevenue: 0,
        todayTransactions: 0,
        todayOrders: 0,
        pendingOrders: 0,
        activeStaff: 0,
        lowStockItems: 0,
        currency: 'SAR',
        raw: {},
      );
      expect(state.todayRevenue, 0);
      expect(state.lastSync, isNull);
    });

    test('PreferencesLoaded defaults pattern', () {
      const state = PreferencesLoaded(
        theme: 'system',
        language: 'en',
        compactMode: false,
        notificationsEnabled: true,
        biometricLock: false,
        defaultPage: 'dashboard',
        currencyDisplay: 'symbol',
        raw: {},
      );
      expect(state.theme, 'system');
      expect(state.notificationsEnabled, true);
    });

    test('QuickActionsLoaded empty list', () {
      const state = QuickActionsLoaded(actions: []);
      expect(state.actions, isEmpty);
    });

    test('CompanionOperationRunning various operations', () {
      const ops = ['register_session', 'end_session', 'log_event'];
      for (final op in ops) {
        final state = CompanionOperationRunning(op);
        expect(state.operation, op);
      }
    });

    test('All 4 state hierarchies are sealed', () {
      // Each state hierarchy has the correct subtypes
      expect(const QuickStatsInitial(), isA<QuickStatsState>());
      expect(const QuickStatsLoading(), isA<QuickStatsState>());
      expect(const QuickStatsError(''), isA<QuickStatsState>());

      expect(const PreferencesInitial(), isA<PreferencesState>());
      expect(const PreferencesLoading(), isA<PreferencesState>());
      expect(const PreferencesError(''), isA<PreferencesState>());

      expect(const QuickActionsInitial(), isA<QuickActionsState>());
      expect(const QuickActionsLoading(), isA<QuickActionsState>());
      expect(const QuickActionsError(''), isA<QuickActionsState>());

      expect(const CompanionOperationIdle(), isA<CompanionOperationState>());
      expect(const CompanionOperationRunning(''), isA<CompanionOperationState>());
      expect(const CompanionOperationError(''), isA<CompanionOperationState>());
      expect(const CompanionOperationSuccess(''), isA<CompanionOperationState>());
    });
  });
}
