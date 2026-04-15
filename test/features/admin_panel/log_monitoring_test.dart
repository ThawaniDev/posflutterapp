import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  //  P9 Endpoint Tests
  // ═══════════════════════════════════════════════════════════

  group('P9 API Endpoints', () {
    test('adminActivityLogs is correct', () {
      expect(ApiEndpoints.adminActivityLogs, '/admin/logs/activity');
    });

    test('adminActivityLogById generates correct path', () {
      expect(ApiEndpoints.adminActivityLogById('abc'), '/admin/logs/activity/abc');
    });

    test('adminSecurityAlerts is correct', () {
      expect(ApiEndpoints.adminSecurityAlerts, '/admin/logs/security-alerts');
    });

    test('adminSecurityAlertById generates correct path', () {
      expect(ApiEndpoints.adminSecurityAlertById('x1'), '/admin/logs/security-alerts/x1');
    });

    test('adminSecurityAlertResolve generates correct path', () {
      expect(ApiEndpoints.adminSecurityAlertResolve('x1'), '/admin/logs/security-alerts/x1/resolve');
    });

    test('adminNotificationLogs is correct', () {
      expect(ApiEndpoints.adminNotificationLogs, '/admin/logs/notifications');
    });

    test('adminPlatformEvents is correct', () {
      expect(ApiEndpoints.adminPlatformEvents, '/admin/logs/events');
    });

    test('adminPlatformEventById generates correct path', () {
      expect(ApiEndpoints.adminPlatformEventById('ev1'), '/admin/logs/events/ev1');
    });

    test('adminHealthDashboard is correct', () {
      expect(ApiEndpoints.adminHealthDashboard, '/admin/logs/health/dashboard');
    });

    test('adminHealthChecks is correct', () {
      expect(ApiEndpoints.adminHealthChecks, '/admin/logs/health/checks');
    });

    test('adminStoreHealth is correct', () {
      expect(ApiEndpoints.adminStoreHealth, '/admin/logs/store-health');
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 State Tests — Activity Log
  // ═══════════════════════════════════════════════════════════

  group('ActivityLogListState', () {
    test('initial state', () {
      const state = ActivityLogListInitial();
      expect(state, isA<ActivityLogListState>());
    });

    test('loading state', () {
      const state = ActivityLogListLoading();
      expect(state, isA<ActivityLogListState>());
    });

    test('loaded state holds data', () {
      const state = ActivityLogListLoaded({'data': []});
      expect(state.data, {'data': []});
    });

    test('error state holds message', () {
      const state = ActivityLogListError('fail');
      expect(state.message, 'fail');
    });

    test('pattern matching exhaustive', () {
      final states = <ActivityLogListState>[
        const ActivityLogListInitial(),
        const ActivityLogListLoading(),
        const ActivityLogListLoaded({'k': 'v'}),
        const ActivityLogListError('e'),
      ];
      for (final s in states) {
        final result = switch (s) {
          ActivityLogListInitial() => 'init',
          ActivityLogListLoading() => 'load',
          ActivityLogListLoaded() => 'done',
          ActivityLogListError() => 'err',
        };
        expect(result, isNotEmpty);
      }
    });
  });

  group('ActivityLogDetailState', () {
    test('initial state', () {
      expect(const ActivityLogDetailInitial(), isA<ActivityLogDetailState>());
    });

    test('loaded state holds data', () {
      const state = ActivityLogDetailLoaded({'id': '1'});
      expect(state.data['id'], '1');
    });

    test('error state', () {
      const state = ActivityLogDetailError('not found');
      expect(state.message, 'not found');
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 State Tests — Security Alert
  // ═══════════════════════════════════════════════════════════

  group('SecurityAlertListState', () {
    test('all variants', () {
      final states = <SecurityAlertListState>[
        const SecurityAlertListInitial(),
        const SecurityAlertListLoading(),
        const SecurityAlertListLoaded({'total': 5}),
        const SecurityAlertListError('err'),
      ];
      expect(states.length, 4);
    });

    test('loaded data access', () {
      const s = SecurityAlertListLoaded({'alert': 'brute_force'});
      expect(s.data['alert'], 'brute_force');
    });
  });

  group('SecurityAlertDetailState', () {
    test('pattern matching', () {
      final s = const SecurityAlertDetailLoaded({'severity': 'high'});
      final result = switch (s as SecurityAlertDetailState) {
        SecurityAlertDetailInitial() => 'init',
        SecurityAlertDetailLoading() => 'load',
        SecurityAlertDetailLoaded(data: final d) => d['severity'],
        SecurityAlertDetailError() => 'err',
      };
      expect(result, 'high');
    });
  });

  group('SecurityAlertActionState', () {
    test('success holds message', () {
      const s = SecurityAlertActionSuccess('resolved');
      expect(s.message, 'resolved');
    });

    test('error holds message', () {
      const s = SecurityAlertActionError('denied');
      expect(s.message, 'denied');
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 State Tests — Notification Log
  // ═══════════════════════════════════════════════════════════

  group('NotificationLogListState', () {
    test('all variants', () {
      final states = <NotificationLogListState>[
        const NotificationLogListInitial(),
        const NotificationLogListLoading(),
        const NotificationLogListLoaded({'channel': 'push'}),
        const NotificationLogListError('timeout'),
      ];
      expect(states.length, 4);
    });

    test('loaded data shape', () {
      const s = NotificationLogListLoaded({'total': 100});
      expect(s.data['total'], 100);
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 State Tests — Platform Event
  // ═══════════════════════════════════════════════════════════

  group('PlatformEventListState', () {
    test('all variants', () {
      final states = <PlatformEventListState>[
        const PlatformEventListInitial(),
        const PlatformEventListLoading(),
        const PlatformEventListLoaded({'events': []}),
        const PlatformEventListError('err'),
      ];
      expect(states.length, 4);
    });
  });

  group('PlatformEventDetailState', () {
    test('loaded state', () {
      const s = PlatformEventDetailLoaded({'event_type': 'deployment'});
      expect(s.data['event_type'], 'deployment');
    });
  });

  group('PlatformEventActionState', () {
    test('success and error', () {
      const success = PlatformEventActionSuccess('logged');
      const error = PlatformEventActionError('invalid');
      expect(success.message, 'logged');
      expect(error.message, 'invalid');
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 State Tests — Health Dashboard
  // ═══════════════════════════════════════════════════════════

  group('HealthDashboardState', () {
    test('all variants', () {
      final states = <HealthDashboardState>[
        const HealthDashboardInitial(),
        const HealthDashboardLoading(),
        const HealthDashboardLoaded({'score': 95}),
        const HealthDashboardError('down'),
      ];
      expect(states.length, 4);
    });

    test('loaded holds summary', () {
      const s = HealthDashboardLoaded({
        'summary': {'healthy': 3},
      });
      expect((s.data['summary'] as Map)['healthy'], 3);
    });
  });

  group('HealthCheckListState', () {
    test('all variants', () {
      final states = <HealthCheckListState>[
        const HealthCheckListInitial(),
        const HealthCheckListLoading(),
        const HealthCheckListLoaded({'data': []}),
        const HealthCheckListError('fail'),
      ];
      expect(states.length, 4);
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 State Tests — Store Health
  // ═══════════════════════════════════════════════════════════

  group('StoreHealthListState', () {
    test('all variants and pattern matching', () {
      final states = <StoreHealthListState>[
        const StoreHealthListInitial(),
        const StoreHealthListLoading(),
        const StoreHealthListLoaded({'stores': []}),
        const StoreHealthListError('timeout'),
      ];
      for (final s in states) {
        final result = switch (s) {
          StoreHealthListInitial() => 'init',
          StoreHealthListLoading() => 'load',
          StoreHealthListLoaded() => 'done',
          StoreHealthListError() => 'err',
        };
        expect(result, isNotEmpty);
      }
    });

    test('loaded data shape', () {
      const s = StoreHealthListLoaded({'sync_status': 'ok', 'count': 42});
      expect(s.data['sync_status'], 'ok');
      expect(s.data['count'], 42);
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 Endpoint Integrity
  // ═══════════════════════════════════════════════════════════

  group('P9 Endpoint Integrity', () {
    test('all log endpoints start with /admin/logs/', () {
      final endpoints = [
        ApiEndpoints.adminActivityLogs,
        ApiEndpoints.adminSecurityAlerts,
        ApiEndpoints.adminNotificationLogs,
        ApiEndpoints.adminPlatformEvents,
        ApiEndpoints.adminHealthDashboard,
        ApiEndpoints.adminHealthChecks,
        ApiEndpoints.adminStoreHealth,
      ];
      for (final ep in endpoints) {
        expect(ep, startsWith('/admin/logs/'));
      }
    });

    test('dynamic endpoints contain id parameter', () {
      final ids = ['test-uuid-123', 'abc-456'];
      for (final id in ids) {
        expect(ApiEndpoints.adminActivityLogById(id), contains(id));
        expect(ApiEndpoints.adminSecurityAlertById(id), contains(id));
        expect(ApiEndpoints.adminSecurityAlertResolve(id), contains(id));
        expect(ApiEndpoints.adminPlatformEventById(id), contains(id));
      }
    });

    test('resolve endpoint ends with /resolve', () {
      expect(ApiEndpoints.adminSecurityAlertResolve('x'), endsWith('/resolve'));
    });

    test('health endpoints follow /health/ structure', () {
      expect(ApiEndpoints.adminHealthDashboard, contains('/health/dashboard'));
      expect(ApiEndpoints.adminHealthChecks, contains('/health/checks'));
    });

    test('no duplicate endpoint paths', () {
      final paths = [
        ApiEndpoints.adminActivityLogs,
        ApiEndpoints.adminSecurityAlerts,
        ApiEndpoints.adminNotificationLogs,
        ApiEndpoints.adminPlatformEvents,
        ApiEndpoints.adminHealthDashboard,
        ApiEndpoints.adminHealthChecks,
        ApiEndpoints.adminStoreHealth,
      ];
      expect(paths.toSet().length, paths.length);
    });
  });

  // ═══════════════════════════════════════════════════════════
  //  P9 Edge Cases
  // ═══════════════════════════════════════════════════════════

  group('P9 Edge Cases', () {
    test('empty data in loaded states', () {
      const al = ActivityLogListLoaded({});
      const sl = SecurityAlertListLoaded({});
      const nl = NotificationLogListLoaded({});
      const pl = PlatformEventListLoaded({});
      const hd = HealthDashboardLoaded({});
      const hc = HealthCheckListLoaded({});
      const sh = StoreHealthListLoaded({});

      expect(al.data, isEmpty);
      expect(sl.data, isEmpty);
      expect(nl.data, isEmpty);
      expect(pl.data, isEmpty);
      expect(hd.data, isEmpty);
      expect(hc.data, isEmpty);
      expect(sh.data, isEmpty);
    });

    test('error messages can be long', () {
      final longMsg = 'e' * 1000;
      final states = [
        ActivityLogListError(longMsg),
        SecurityAlertListError(longMsg),
        SecurityAlertActionError(longMsg),
        NotificationLogListError(longMsg),
        PlatformEventListError(longMsg),
        PlatformEventActionError(longMsg),
        HealthDashboardError(longMsg),
        HealthCheckListError(longMsg),
        StoreHealthListError(longMsg),
      ];
      for (final s in states) {
        expect((s as dynamic).message.length, 1000);
      }
    });

    test('deeply nested data in loaded states', () {
      const state = HealthDashboardLoaded({
        'data': {
          'summary': {'total_checks': 100, 'healthy': 95, 'degraded': 3, 'down': 2, 'health_score': 95.0},
          'services': [
            {'service': 'api', 'status': 'healthy'},
            {'service': 'database', 'status': 'healthy'},
          ],
        },
      });
      final summary = (state.data['data'] as Map)['summary'] as Map;
      expect(summary['health_score'], 95.0);
    });
  });
}
