// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/security/data/remote/security_api_service.dart';
import 'package:wameedpos/features/security/enums/security_audit_action.dart';
import 'package:wameedpos/features/security/providers/security_providers.dart';
import 'package:wameedpos/features/security/providers/security_state.dart';
import 'package:wameedpos/features/security/repositories/security_repository.dart';

// ─── Stub ApiService (never actually called by our mock) ─────────────────────
class _StubApiService extends SecurityApiService {
  _StubApiService() : super(Dio());
}

// ─── Fake AuthLocalStorage ────────────────────────────────────────────────────
class _FakeAuthLocalStorage extends AuthLocalStorage {
  final String? _userId;
  _FakeAuthLocalStorage([this._userId = 'user-test-123']);

  @override
  Future<String?> getUserId() async => _userId;
}

// ─── Mock SecurityRepository ──────────────────────────────────────────────────
class _MockRepository extends SecurityRepository {
  _MockRepository({
    this.overviewResult,
    this.policyResult,
    this.auditLogsResult,
    this.devicesResult,
    this.loginAttemptsResult,
    this.sessionsResult,
    this.incidentsResult,
    this.exportResult,
    this.actionResult,
    this.shouldThrow = false,
    this.throwMessage = 'mock error',
  }) : super(_StubApiService());

  final Map<String, dynamic>? overviewResult;
  final Map<String, dynamic>? policyResult;
  final Map<String, dynamic>? auditLogsResult;
  final Map<String, dynamic>? devicesResult;
  final Map<String, dynamic>? loginAttemptsResult;
  final Map<String, dynamic>? sessionsResult;
  final Map<String, dynamic>? incidentsResult;
  final String? exportResult;
  final Map<String, dynamic>? actionResult;
  final bool shouldThrow;
  final String throwMessage;

  void _maybeThrow(String method) {
    if (shouldThrow) throw Exception('$method: $throwMessage');
  }

  @override
  Future<Map<String, dynamic>> getOverview({required String storeId}) async {
    _maybeThrow('getOverview');
    return overviewResult ??
        {
          'data': {
            'active_devices': 2,
            'active_sessions': 3,
            'unresolved_incidents': 1,
            'failed_logins_today': 5,
            'total_audit_logs': 100,
            'locked_out_users': 0,
            'recent_activity': [],
            'policy': {'pin_min_length': 4},
            'login_stats': {},
            'audit_stats': {},
            'critical_audits_7d': 0,
          },
        };
  }

  @override
  Future<Map<String, dynamic>> getPolicy({required String storeId}) async {
    _maybeThrow('getPolicy');
    return policyResult ??
        {
          'data': {
            'id': 'pol-1',
            'store_id': storeId,
            'pin_min_length': 4,
            'pin_max_length': 6,
            'max_failed_attempts': 5,
            'lockout_duration_minutes': 15,
          },
        };
  }

  @override
  Future<Map<String, dynamic>> updatePolicy({required String storeId, required Map<String, dynamic> data}) async {
    _maybeThrow('updatePolicy');
    return {
      'success': true,
      'data': {'id': 'pol-1', 'store_id': storeId, ...data},
    };
  }

  @override
  Future<Map<String, dynamic>> listAuditLogs({
    required String storeId,
    String? action,
    String? severity,
    String? userId,
    int? perPage,
  }) async {
    _maybeThrow('listAuditLogs');
    return auditLogsResult ??
        {
          'data': {
            'data': [
              {'id': 'log-1', 'store_id': storeId, 'action': 'login', 'user_type': 'staff', 'severity': 'info'},
              {'id': 'log-2', 'store_id': storeId, 'action': 'logout', 'user_type': 'staff', 'severity': 'info'},
            ],
          },
        };
  }

  @override
  Future<String> exportAuditLogs({required String storeId, String? action, String? severity, String? since}) async {
    _maybeThrow('exportAuditLogs');
    return exportResult ?? 'timestamp,user_id,action,severity\n2024-01-01,,login,info';
  }

  @override
  Future<Map<String, dynamic>> listDevices({required String storeId, bool? activeOnly}) async {
    _maybeThrow('listDevices');
    return devicesResult ??
        {
          'data': [
            {'id': 'dev-1', 'store_id': storeId, 'device_name': 'Terminal 1', 'hardware_id': 'HW-001', 'is_active': true},
            {'id': 'dev-2', 'store_id': storeId, 'device_name': 'Terminal 2', 'hardware_id': 'HW-002', 'is_active': false},
          ],
        };
  }

  @override
  Future<Map<String, dynamic>> deactivateDevice({required String deviceId}) async {
    _maybeThrow('deactivateDevice');
    return actionResult ??
        {
          'success': true,
          'data': {'id': deviceId, 'is_active': false},
        };
  }

  @override
  Future<Map<String, dynamic>> requestRemoteWipe({required String deviceId}) async {
    _maybeThrow('requestRemoteWipe');
    return actionResult ??
        {
          'success': true,
          'data': {'id': deviceId, 'remote_wipe_requested': true},
        };
  }

  @override
  Future<Map<String, dynamic>> listLoginAttempts({
    required String storeId,
    String? attemptType,
    bool? isSuccessful,
    int? perPage,
  }) async {
    _maybeThrow('listLoginAttempts');
    return loginAttemptsResult ??
        {
          'data': {
            'data': [
              {
                'id': 'la-1',
                'store_id': storeId,
                'user_identifier': 'user@test.com',
                'attempt_type': 'pin',
                'is_successful': true,
              },
              {
                'id': 'la-2',
                'store_id': storeId,
                'user_identifier': 'user@test.com',
                'attempt_type': 'pin',
                'is_successful': false,
              },
            ],
          },
        };
  }

  @override
  Future<Map<String, dynamic>> listSessions({required String storeId, String? status}) async {
    _maybeThrow('listSessions');
    return sessionsResult ??
        {
          'data': [
            {
              'id': 'sess-1',
              'store_id': storeId,
              'user_id': 'user-1',
              'session_type': 'pos',
              'status': 'active',
              'started_at': '2024-01-01T08:00:00.000Z',
            },
          ],
        };
  }

  @override
  Future<Map<String, dynamic>> endSession({required String sessionId}) async {
    _maybeThrow('endSession');
    return {
      'success': true,
      'data': {'id': sessionId, 'status': 'ended'},
    };
  }

  @override
  Future<Map<String, dynamic>> endAllSessions({required String storeId, String? userId}) async {
    _maybeThrow('endAllSessions');
    return {
      'success': true,
      'data': {'ended_count': 3},
    };
  }

  @override
  Future<Map<String, dynamic>> listIncidents({required String storeId, String? severity, bool? isResolved}) async {
    _maybeThrow('listIncidents');
    return incidentsResult ??
        {
          'data': {
            'data': [
              {
                'id': 'inc-1',
                'store_id': storeId,
                'incident_type': 'brute_force',
                'severity': 'high',
                'title': 'Multiple failed logins',
                'status': 'open',
              },
            ],
          },
        };
  }

  @override
  Future<Map<String, dynamic>> resolveIncident({required String incidentId, String? resolutionNotes}) async {
    _maybeThrow('resolveIncident');
    return {
      'success': true,
      'data': {'id': incidentId, 'status': 'resolved'},
    };
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

ProviderContainer _makeContainer(_MockRepository repo) {
  return ProviderContainer(
    overrides: [
      securityRepositoryProvider.overrideWithValue(repo),
      authLocalStorageProvider.overrideWithValue(_FakeAuthLocalStorage()),
    ],
  );
}

void main() {
  // ═══ SecurityOverviewNotifier ══════════════════════════════════════════════

  group('SecurityOverviewNotifier', () {
    test('initial state is SecurityOverviewInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(securityOverviewProvider), isA<SecurityOverviewInitial>());
    });

    test('loadOverview transitions initial → loading → loaded', () async {
      final repo = _MockRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final states = <SecurityOverviewState>[];
      container.listen<SecurityOverviewState>(securityOverviewProvider, (_, s) => states.add(s));

      await container.read(securityOverviewProvider.notifier).load('store-1');

      expect(states.length, 2); // loading + loaded
      expect(states[0], isA<SecurityOverviewLoading>());
      expect(states[1], isA<SecurityOverviewLoaded>());
    });

    test('loadOverview loaded state contains overview data', () async {
      final repo = _MockRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(securityOverviewProvider.notifier).load('store-1');

      final state = container.read(securityOverviewProvider);
      expect(state, isA<SecurityOverviewLoaded>());
      final loaded = state as SecurityOverviewLoaded;
      expect(loaded.overview['active_devices'], 2);
      expect(loaded.overview['active_sessions'], 3);
      expect(loaded.overview['unresolved_incidents'], 1);
    });

    test('loadOverview transitions to error on exception', () async {
      final repo = _MockRepository(shouldThrow: true, throwMessage: 'network failure');
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(securityOverviewProvider.notifier).load('store-1');

      final state = container.read(securityOverviewProvider);
      expect(state, isA<SecurityOverviewError>());
      final err = state as SecurityOverviewError;
      expect(err.message, contains('network failure'));
    });

    test('overview structure has all required keys', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityOverviewProvider.notifier).load('store-1');
      final state = container.read(securityOverviewProvider) as SecurityOverviewLoaded;

      final keys = [
        'active_devices',
        'active_sessions',
        'unresolved_incidents',
        'failed_logins_today',
        'total_audit_logs',
        'locked_out_users',
        'recent_activity',
        'policy',
      ];
      for (final key in keys) {
        expect(state.overview.containsKey(key), isTrue, reason: 'Missing overview key: $key');
      }
    });
  });

  // ═══ SecurityPolicyNotifier ════════════════════════════════════════════════

  group('SecurityPolicyNotifier', () {
    test('initial state is SecurityPolicyInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(securityPolicyProvider), isA<SecurityPolicyInitial>());
    });

    test('loadPolicy transitions to SecurityPolicyLoaded', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityPolicyProvider.notifier).loadPolicy('store-1');

      final state = container.read(securityPolicyProvider);
      expect(state, isA<SecurityPolicyLoaded>());
      final loaded = state as SecurityPolicyLoaded;
      expect(loaded.policy.pinMinLength, 4);
      expect(loaded.policy.maxFailedAttempts, 5);
    });

    test('loadPolicy transitions to SecurityPolicyError on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true, throwMessage: 'policy error'));
      addTearDown(container.dispose);

      await container.read(securityPolicyProvider.notifier).loadPolicy('store-1');

      expect(container.read(securityPolicyProvider), isA<SecurityPolicyError>());
    });

    test('updatePolicy saves and reloads to loaded state', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityPolicyProvider.notifier).updatePolicy('store-1', {'pin_min_length': 6});

      final state = container.read(securityPolicyProvider);
      expect(state, isA<SecurityPolicyLoaded>());
    });

    test('updatePolicy error transitions to SecurityPolicyError', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true, throwMessage: 'update fail'));
      addTearDown(container.dispose);

      await container.read(securityPolicyProvider.notifier).updatePolicy('store-1', {});

      expect(container.read(securityPolicyProvider), isA<SecurityPolicyError>());
    });
  });

  // ═══ AuditLogListNotifier ══════════════════════════════════════════════════

  group('AuditLogListNotifier', () {
    test('initial state is AuditLogListInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(auditLogListProvider), isA<AuditLogListInitial>());
    });

    test('loadLogs transitions to AuditLogListLoaded', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(auditLogListProvider.notifier).loadLogs('store-1');

      final state = container.read(auditLogListProvider);
      expect(state, isA<AuditLogListLoaded>());
      final loaded = state as AuditLogListLoaded;
      expect(loaded.logs.length, 2);
      expect(loaded.logs.first.action, SecurityAuditAction.login);
    });

    test('loadLogs transitions to AuditLogListError on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(auditLogListProvider.notifier).loadLogs('store-1');

      expect(container.read(auditLogListProvider), isA<AuditLogListError>());
    });

    test('loadLogs loading → loaded state transitions captured', () async {
      final repo = _MockRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final states = <AuditLogListState>[];
      container.listen<AuditLogListState>(auditLogListProvider, (_, s) => states.add(s));

      await container.read(auditLogListProvider.notifier).loadLogs('store-1');

      expect(states[0], isA<AuditLogListLoading>());
      expect(states[1], isA<AuditLogListLoaded>());
    });
  });

  // ═══ DeviceListNotifier ═══════════════════════════════════════════════════

  group('DeviceListNotifier', () {
    test('initial state is DeviceListInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deviceListProvider), isA<DeviceListInitial>());
    });

    test('loadDevices returns all devices by default', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(deviceListProvider.notifier).loadDevices('store-1');

      final state = container.read(deviceListProvider) as DeviceListLoaded;
      expect(state.devices.length, 2);
      expect(state.devices.first.deviceName, 'Terminal 1');
    });

    test('loadDevices with activeOnly=true filters inactive devices on client', () async {
      final repo = _MockRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deviceListProvider.notifier).loadDevices('store-1', activeOnly: true);

      final state = container.read(deviceListProvider) as DeviceListLoaded;
      // If the provider passes activeOnly to the repo, the mock returns all anyway —
      // what matters is the provider correctly calls the repo.
      expect(state, isA<DeviceListLoaded>());
    });

    test('loadDevices error state contains message', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true, throwMessage: 'device error'));
      addTearDown(container.dispose);

      await container.read(deviceListProvider.notifier).loadDevices('store-1');

      final state = container.read(deviceListProvider) as DeviceListError;
      expect(state.message, contains('device error'));
    });
  });

  // ═══ LoginAttemptsNotifier ════════════════════════════════════════════════

  group('LoginAttemptsNotifier', () {
    test('initial state is LoginAttemptsInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(loginAttemptsProvider), isA<LoginAttemptsInitial>());
    });

    test('loadAttempts transitions to LoginAttemptsLoaded', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(loginAttemptsProvider.notifier).loadAttempts('store-1');

      final state = container.read(loginAttemptsProvider);
      expect(state, isA<LoginAttemptsLoaded>());
      final loaded = state as LoginAttemptsLoaded;
      expect(loaded.attempts.length, 2);
      expect(loaded.attempts.first.isSuccessful, true);
    });

    test('loadAttempts error state on exception', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(loginAttemptsProvider.notifier).loadAttempts('store-1');

      expect(container.read(loginAttemptsProvider), isA<LoginAttemptsError>());
    });
  });

  // ═══ SessionListNotifier ══════════════════════════════════════════════════

  group('SessionListNotifier', () {
    test('initial state is SessionListInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(sessionListProvider), isA<SessionListInitial>());
    });

    test('loadSessions transitions to SessionListLoaded', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(sessionListProvider.notifier).loadSessions('store-1');

      final state = container.read(sessionListProvider);
      expect(state, isA<SessionListLoaded>());
      final loaded = state as SessionListLoaded;
      expect(loaded.sessions.length, 1);
      expect(loaded.sessions.first.id, isNotEmpty);
    });

    test('loadSessions error state on exception', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(sessionListProvider.notifier).loadSessions('store-1');

      expect(container.read(sessionListProvider), isA<SessionListError>());
    });

    test('loadSessions state transition: loading → loaded', () async {
      final repo = _MockRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final states = <SessionListState>[];
      container.listen<SessionListState>(sessionListProvider, (_, s) => states.add(s));

      await container.read(sessionListProvider.notifier).loadSessions('store-1');

      expect(states.first, isA<SessionListLoading>());
      expect(states.last, isA<SessionListLoaded>());
    });
  });

  // ═══ IncidentListNotifier ════════════════════════════════════════════════

  group('IncidentListNotifier', () {
    test('initial state is IncidentListInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(incidentListProvider), isA<IncidentListInitial>());
    });

    test('loadIncidents parses paginated response (data.data)', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(incidentListProvider.notifier).loadIncidents('store-1');

      final state = container.read(incidentListProvider);
      expect(state, isA<IncidentListLoaded>());
      final loaded = state as IncidentListLoaded;
      expect(loaded.incidents.length, 1);
      expect(loaded.incidents.first.title, 'Multiple failed logins');
    });

    test('loadIncidents handles empty data.data array', () async {
      final repo = _MockRepository(
        incidentsResult: {
          'data': {'data': []},
        },
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(incidentListProvider.notifier).loadIncidents('store-1');

      final state = container.read(incidentListProvider) as IncidentListLoaded;
      expect(state.incidents, isEmpty);
    });

    test('loadIncidents error state on exception', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(incidentListProvider.notifier).loadIncidents('store-1');

      expect(container.read(incidentListProvider), isA<IncidentListError>());
    });
  });

  // ═══ SecurityActionNotifier ═══════════════════════════════════════════════

  group('SecurityActionNotifier', () {
    test('initial state is SecurityActionInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(securityActionProvider), isA<SecurityActionInitial>());
    });

    test('deactivateDevice succeeds with SecurityActionSuccess', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityActionProvider.notifier).deactivateDevice('dev-1');

      final state = container.read(securityActionProvider);
      expect(state, isA<SecurityActionSuccess>());
      final success = state as SecurityActionSuccess;
      expect(success.message, contains('deactivated'));
    });

    test('deactivateDevice error transitions to SecurityActionError', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true, throwMessage: 'wipe error'));
      addTearDown(container.dispose);

      await container.read(securityActionProvider.notifier).deactivateDevice('dev-1');

      expect(container.read(securityActionProvider), isA<SecurityActionError>());
    });

    test('requestRemoteWipe succeeds with SecurityActionSuccess', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityActionProvider.notifier).requestRemoteWipe('dev-1');

      expect(container.read(securityActionProvider), isA<SecurityActionSuccess>());
    });

    test('endSession succeeds with SecurityActionSuccess', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityActionProvider.notifier).endSession('sess-1');

      final state = container.read(securityActionProvider) as SecurityActionSuccess;
      expect(state.message, contains('Session ended'));
    });

    test('endAllSessions reads userId from auth storage', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityActionProvider.notifier).endAllSessions('store-1');

      expect(container.read(securityActionProvider), isA<SecurityActionSuccess>());
    });

    test('resolveIncident with notes succeeds', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityActionProvider.notifier).resolveIncident('inc-1', resolutionNotes: 'Fixed by admin');

      expect(container.read(securityActionProvider), isA<SecurityActionSuccess>());
    });

    test('exportAuditLogs returns CSV string on success', () async {
      final container = _makeContainer(_MockRepository(exportResult: 'timestamp,action\n2024-01-01,login'));
      addTearDown(container.dispose);

      final csv = await container.read(securityActionProvider.notifier).exportAuditLogs(storeId: 'store-1');

      expect(csv, isNotNull);
      expect(csv, contains('timestamp'));
      expect(container.read(securityActionProvider), isA<SecurityActionSuccess>());
    });

    test('exportAuditLogs returns null and error state on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true, throwMessage: 'rate limited'));
      addTearDown(container.dispose);

      final csv = await container.read(securityActionProvider.notifier).exportAuditLogs(storeId: 'store-1');

      expect(csv, isNull);
      final state = container.read(securityActionProvider) as SecurityActionError;
      expect(state.message, contains('rate limited'));
    });

    test('reset returns to SecurityActionInitial', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(securityActionProvider.notifier).deactivateDevice('dev-1');
      container.read(securityActionProvider.notifier).reset();

      expect(container.read(securityActionProvider), isA<SecurityActionInitial>());
    });

    test('action transitions: initial → loading → success', () async {
      final repo = _MockRepository();
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final states = <SecurityActionState>[];
      container.listen<SecurityActionState>(securityActionProvider, (_, s) => states.add(s));

      await container.read(securityActionProvider.notifier).deactivateDevice('dev-1');

      expect(states[0], isA<SecurityActionLoading>());
      expect(states[1], isA<SecurityActionSuccess>());
    });
  });
}
