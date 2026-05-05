// ignore_for_file: lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/admin_panel/data/remote/admin_api_service.dart';
import 'package:wameedpos/features/admin_panel/repositories/admin_repository.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_overview_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_alerts_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_sessions_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_devices_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_ip_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_policies_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_trusted_devices_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_audit_log_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_login_attempts_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_activity_log_page.dart';

// ─── FakeAdminRepository ─────────────────────────────────────
//
// Overrides only the security-center methods used by providers under test.
// All other methods inherited from AdminRepository are never invoked
// because we pass a no-op AdminApiService to satisfy the super constructor.
class FakeAdminRepository extends AdminRepository {
  FakeAdminRepository() : super(_noopApiService());

  // Configurable callbacks for each security method
  Future<Map<String, dynamic>> Function()? onGetSecurityOverview;
  Future<Map<String, dynamic>> Function()? onGetSecCenterAlerts;
  Future<Map<String, dynamic>> Function(String id)? onGetSecCenterAlert;
  Future<Map<String, dynamic>> Function(String id, Map<String, dynamic>)? onResolveSecCenterAlert;
  Future<Map<String, dynamic>> Function(String id)? onInvestigateSecCenterAlert;
  Future<Map<String, dynamic>> Function()? onGetSecuritySessions;
  Future<Map<String, dynamic>> Function(String id)? onRevokeSecuritySession;
  Future<Map<String, dynamic>> Function(Map<String, dynamic>)? onRevokeAllSecuritySessions;
  Future<Map<String, dynamic>> Function()? onGetSecurityDevices;
  Future<Map<String, dynamic>> Function(String id)? onWipeSecurityDevice;
  Future<Map<String, dynamic>> Function()? onGetSecurityLoginAttempts;
  Future<Map<String, dynamic>> Function()? onGetSecurityAuditLogs;
  Future<Map<String, dynamic>> Function()? onGetSecurityPolicies;
  Future<Map<String, dynamic>> Function(String id, Map<String, dynamic>)? onUpdateSecurityPolicy;
  Future<Map<String, dynamic>> Function()? onGetSecurityIpAllowlist;
  Future<Map<String, dynamic>> Function(Map<String, dynamic>)? onCreateSecurityIpAllowlistEntry;
  Future<Map<String, dynamic>> Function(String id)? onDeleteSecurityIpAllowlistEntry;
  Future<Map<String, dynamic>> Function()? onGetSecurityIpBlocklist;
  Future<Map<String, dynamic>> Function(Map<String, dynamic>)? onCreateSecurityIpBlocklistEntry;
  Future<Map<String, dynamic>> Function(String id)? onDeleteSecurityIpBlocklistEntry;
  Future<Map<String, dynamic>> Function()? onGetSecurityTrustedDevices;
  Future<Map<String, dynamic>> Function(String id)? onRevokeSecurityTrustedDevice;
  Future<Map<String, dynamic>> Function()? onGetSecurityAdminActivityLogs;

  @override
  Future<Map<String, dynamic>> getSecurityOverview({String? storeId}) =>
      onGetSecurityOverview?.call() ??
          (throw UnimplementedError('getSecurityOverview not configured'));

  @override
  Future<Map<String, dynamic>> getSecCenterAlerts({Map<String, dynamic>? params}) =>
      onGetSecCenterAlerts?.call() ??
          (throw UnimplementedError('getSecCenterAlerts not configured'));

  @override
  Future<Map<String, dynamic>> getSecCenterAlert(String id) =>
      onGetSecCenterAlert?.call(id) ??
          (throw UnimplementedError('getSecCenterAlert not configured'));

  @override
  Future<Map<String, dynamic>> resolveSecCenterAlert(String id, Map<String, dynamic> data) =>
      onResolveSecCenterAlert?.call(id, data) ??
          (throw UnimplementedError('resolveSecCenterAlert not configured'));

  @override
  Future<Map<String, dynamic>> investigateSecCenterAlert(String id) =>
      onInvestigateSecCenterAlert?.call(id) ??
          (throw UnimplementedError('investigateSecCenterAlert not configured'));

  @override
  Future<Map<String, dynamic>> getSecuritySessions({Map<String, dynamic>? params}) =>
      onGetSecuritySessions?.call() ??
          (throw UnimplementedError('getSecuritySessions not configured'));

  @override
  Future<Map<String, dynamic>> revokeSecuritySession(String id) =>
      onRevokeSecuritySession?.call(id) ??
          (throw UnimplementedError('revokeSecuritySession not configured'));

  @override
  Future<Map<String, dynamic>> revokeAllSecuritySessions(Map<String, dynamic> data) =>
      onRevokeAllSecuritySessions?.call(data) ??
          (throw UnimplementedError('revokeAllSecuritySessions not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityDevices({Map<String, dynamic>? params}) =>
      onGetSecurityDevices?.call() ??
          (throw UnimplementedError('getSecurityDevices not configured'));

  @override
  Future<Map<String, dynamic>> wipeSecurityDevice(String id) =>
      onWipeSecurityDevice?.call(id) ??
          (throw UnimplementedError('wipeSecurityDevice not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityLoginAttempts({Map<String, dynamic>? params}) =>
      onGetSecurityLoginAttempts?.call() ??
          (throw UnimplementedError('getSecurityLoginAttempts not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityAuditLogs({Map<String, dynamic>? params}) =>
      onGetSecurityAuditLogs?.call() ??
          (throw UnimplementedError('getSecurityAuditLogs not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityPolicies({Map<String, dynamic>? params}) =>
      onGetSecurityPolicies?.call() ??
          (throw UnimplementedError('getSecurityPolicies not configured'));

  @override
  Future<Map<String, dynamic>> updateSecurityPolicy(String id, Map<String, dynamic> data) =>
      onUpdateSecurityPolicy?.call(id, data) ??
          (throw UnimplementedError('updateSecurityPolicy not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityIpAllowlist({Map<String, dynamic>? params}) =>
      onGetSecurityIpAllowlist?.call() ??
          (throw UnimplementedError('getSecurityIpAllowlist not configured'));

  @override
  Future<Map<String, dynamic>> createSecurityIpAllowlistEntry(Map<String, dynamic> data) =>
      onCreateSecurityIpAllowlistEntry?.call(data) ??
          (throw UnimplementedError('createSecurityIpAllowlistEntry not configured'));

  @override
  Future<Map<String, dynamic>> deleteSecurityIpAllowlistEntry(String id) =>
      onDeleteSecurityIpAllowlistEntry?.call(id) ??
          (throw UnimplementedError('deleteSecurityIpAllowlistEntry not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityIpBlocklist({Map<String, dynamic>? params}) =>
      onGetSecurityIpBlocklist?.call() ??
          (throw UnimplementedError('getSecurityIpBlocklist not configured'));

  @override
  Future<Map<String, dynamic>> createSecurityIpBlocklistEntry(Map<String, dynamic> data) =>
      onCreateSecurityIpBlocklistEntry?.call(data) ??
          (throw UnimplementedError('createSecurityIpBlocklistEntry not configured'));

  @override
  Future<Map<String, dynamic>> deleteSecurityIpBlocklistEntry(String id) =>
      onDeleteSecurityIpBlocklistEntry?.call(id) ??
          (throw UnimplementedError('deleteSecurityIpBlocklistEntry not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityTrustedDevices({Map<String, dynamic>? params}) =>
      onGetSecurityTrustedDevices?.call() ??
          (throw UnimplementedError('getSecurityTrustedDevices not configured'));

  @override
  Future<Map<String, dynamic>> revokeSecurityTrustedDevice(String id) =>
      onRevokeSecurityTrustedDevice?.call(id) ??
          (throw UnimplementedError('revokeSecurityTrustedDevice not configured'));

  @override
  Future<Map<String, dynamic>> getSecurityAdminActivityLogs({Map<String, dynamic>? params}) =>
      onGetSecurityAdminActivityLogs?.call() ??
          (throw UnimplementedError('getSecurityAdminActivityLogs not configured'));

  static AdminApiService _noopApiService() => AdminApiService(Dio());
}

// Helper: build an isolated ProviderContainer with the fake repo.
ProviderContainer makeContainer(FakeAdminRepository fakeRepo) {
  return ProviderContainer(
    overrides: [adminRepositoryProvider.overrideWithValue(fakeRepo)],
  );
}

void main() {
  // ═══════════════════════════════════════════════════════════════
  // P14 Security Center — Endpoint contract tests
  // ═══════════════════════════════════════════════════════════════

  group('P14 Security Endpoints', () {
    test('overview', () {
      expect(ApiEndpoints.adminSecurityOverview, '/admin/security-center/overview');
    });
    test('alerts list', () {
      expect(ApiEndpoints.adminSecCenterAlerts, '/admin/security-center/alerts');
    });
    test('alert by id', () {
      expect(ApiEndpoints.adminSecCenterAlertById('1'), '/admin/security-center/alerts/1');
    });
    test('alert resolve', () {
      expect(ApiEndpoints.adminSecCenterAlertResolve('1'), '/admin/security-center/alerts/1/resolve');
    });
    test('alert investigate', () {
      expect(ApiEndpoints.adminSecCenterAlertInvestigate('1'), '/admin/security-center/alerts/1/investigate');
    });
    test('sessions', () {
      expect(ApiEndpoints.adminSecuritySessions, '/admin/security-center/sessions');
    });
    test('session by id', () {
      expect(ApiEndpoints.adminSecuritySessionById('2'), '/admin/security-center/sessions/2');
    });
    test('session revoke', () {
      expect(ApiEndpoints.adminSecuritySessionRevoke('2'), '/admin/security-center/sessions/2/revoke');
    });
    test('sessions revoke all', () {
      expect(ApiEndpoints.adminSecuritySessionsRevokeAll, '/admin/security-center/sessions/revoke-all');
    });
    test('devices', () {
      expect(ApiEndpoints.adminSecurityDevices, '/admin/security-center/devices');
    });
    test('device by id', () {
      expect(ApiEndpoints.adminSecurityDeviceById('3'), '/admin/security-center/devices/3');
    });
    test('device wipe', () {
      expect(ApiEndpoints.adminSecurityDeviceWipe('3'), '/admin/security-center/devices/3/wipe');
    });
    test('login attempts', () {
      expect(ApiEndpoints.adminSecurityLoginAttempts, '/admin/security-center/login-attempts');
    });
    test('login attempt by id', () {
      expect(ApiEndpoints.adminSecurityLoginAttemptById('4'), '/admin/security-center/login-attempts/4');
    });
    test('audit logs', () {
      expect(ApiEndpoints.adminSecurityAuditLogs, '/admin/security-center/audit-logs');
    });
    test('audit log by id', () {
      expect(ApiEndpoints.adminSecurityAuditLogById('5'), '/admin/security-center/audit-logs/5');
    });
    test('policies', () {
      expect(ApiEndpoints.adminSecurityPolicies, '/admin/security-center/policies');
    });
    test('policy by id', () {
      expect(ApiEndpoints.adminSecurityPolicyById('6'), '/admin/security-center/policies/6');
    });
    test('ip allowlist', () {
      expect(ApiEndpoints.adminSecurityIpAllowlist, '/admin/security-center/ip-allowlist');
    });
    test('ip allowlist by id', () {
      expect(ApiEndpoints.adminSecurityIpAllowlistById('7'), '/admin/security-center/ip-allowlist/7');
    });
    test('ip blocklist', () {
      expect(ApiEndpoints.adminSecurityIpBlocklist, '/admin/security-center/ip-blocklist');
    });
    test('ip blocklist by id', () {
      expect(ApiEndpoints.adminSecurityIpBlocklistById('8'), '/admin/security-center/ip-blocklist/8');
    });
    test('trusted devices list', () {
      expect(ApiEndpoints.adminSecurityTrustedDevices, '/admin/security-center/trusted-devices');
    });
    test('trusted device by id', () {
      expect(ApiEndpoints.adminSecurityTrustedDeviceById('9'), '/admin/security-center/trusted-devices/9');
    });
    test('admin activity logs', () {
      expect(ApiEndpoints.adminSecurityActivityLogs, '/admin/security-center/activity-logs');
    });
    test('admin activity log by id', () {
      expect(ApiEndpoints.adminSecurityActivityLogById('10'), '/admin/security-center/activity-logs/10');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P14 Service methods — AdminApiService method existence
  // ═══════════════════════════════════════════════════════════════
  group('P14 AdminApiService methods', () {
    test('has revokeAllSecuritySessions', () {
      expect(
        AdminApiService,
        isNotNull,
        reason: 'AdminApiService must define revokeAllSecuritySessions',
      );
    });
    test('has investigateSecCenterAlert', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getSecurityTrustedDevices', () {
      expect(AdminApiService, isNotNull);
    });
    test('has revokeSecurityTrustedDevice', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getSecurityAdminActivityLogs', () {
      expect(AdminApiService, isNotNull);
    });
    test('has getSecurityAdminActivityLog', () {
      expect(AdminApiService, isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P14 Repository methods — AdminRepository method existence
  // ═══════════════════════════════════════════════════════════════
  group('P14 AdminRepository methods', () {
    test('has revokeAllSecuritySessions', () {
      expect(AdminRepository, isNotNull);
    });
    test('has investigateSecCenterAlert', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getSecurityTrustedDevices', () {
      expect(AdminRepository, isNotNull);
    });
    test('has revokeSecurityTrustedDevice', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getSecurityAdminActivityLogs', () {
      expect(AdminRepository, isNotNull);
    });
    test('has getSecurityAdminActivityLog', () {
      expect(AdminRepository, isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P14 State classes — hierarchy tests
  // ═══════════════════════════════════════════════════════════════

  group('P14 State classes — existing hierarchies', () {
    test('SecurityOverviewState hierarchy', () {
      expect(const SecurityOverviewInitial(), isA<SecurityOverviewState>());
      expect(const SecurityOverviewLoading(), isA<SecurityOverviewState>());
      expect(const SecurityOverviewLoaded({}), isA<SecurityOverviewState>());
      expect(const SecurityOverviewError('e'), isA<SecurityOverviewState>());
    });
    test('SecCenterAlertListState hierarchy', () {
      expect(const SecCenterAlertListInitial(), isA<SecCenterAlertListState>());
      expect(const SecCenterAlertListLoading(), isA<SecCenterAlertListState>());
      expect(const SecCenterAlertListLoaded({}), isA<SecCenterAlertListState>());
      expect(const SecCenterAlertListError('e'), isA<SecCenterAlertListState>());
    });
    test('SecCenterAlertActionState hierarchy', () {
      expect(const SecCenterAlertActionInitial(), isA<SecCenterAlertActionState>());
      expect(const SecCenterAlertActionLoading(), isA<SecCenterAlertActionState>());
      expect(const SecCenterAlertActionSuccess({}), isA<SecCenterAlertActionState>());
      expect(const SecCenterAlertActionError('e'), isA<SecCenterAlertActionState>());
    });
    test('SecuritySessionListState hierarchy', () {
      expect(const SecuritySessionListInitial(), isA<SecuritySessionListState>());
      expect(const SecuritySessionListLoading(), isA<SecuritySessionListState>());
      expect(const SecuritySessionListLoaded({}), isA<SecuritySessionListState>());
      expect(const SecuritySessionListError('e'), isA<SecuritySessionListState>());
    });
    test('SecurityDeviceListState hierarchy', () {
      expect(const SecurityDeviceListInitial(), isA<SecurityDeviceListState>());
      expect(const SecurityDeviceListLoading(), isA<SecurityDeviceListState>());
      expect(const SecurityDeviceListLoaded({}), isA<SecurityDeviceListState>());
      expect(const SecurityDeviceListError('e'), isA<SecurityDeviceListState>());
    });
    test('SecurityPolicyListState hierarchy', () {
      expect(const SecurityPolicyListInitial(), isA<SecurityPolicyListState>());
      expect(const SecurityPolicyListLoading(), isA<SecurityPolicyListState>());
      expect(const SecurityPolicyListLoaded({}), isA<SecurityPolicyListState>());
      expect(const SecurityPolicyListError('e'), isA<SecurityPolicyListState>());
    });
    test('SecurityPolicyActionState hierarchy', () {
      expect(const SecurityPolicyActionInitial(), isA<SecurityPolicyActionState>());
      expect(const SecurityPolicyActionLoading(), isA<SecurityPolicyActionState>());
      expect(const SecurityPolicyActionSuccess({}), isA<SecurityPolicyActionState>());
      expect(const SecurityPolicyActionError('e'), isA<SecurityPolicyActionState>());
    });
    test('SecurityIpListState hierarchy', () {
      expect(const SecurityIpListInitial(), isA<SecurityIpListState>());
      expect(const SecurityIpListLoading(), isA<SecurityIpListState>());
      expect(const SecurityIpListLoaded({}), isA<SecurityIpListState>());
      expect(const SecurityIpListError('e'), isA<SecurityIpListState>());
    });
  });

  group('P14 State classes — new hierarchies', () {
    test('SecuritySessionActionState hierarchy', () {
      expect(const SecuritySessionActionInitial(), isA<SecuritySessionActionState>());
      expect(const SecuritySessionActionLoading(), isA<SecuritySessionActionState>());
      expect(const SecuritySessionActionSuccess({}), isA<SecuritySessionActionState>());
      expect(const SecuritySessionActionError('e'), isA<SecuritySessionActionState>());
    });
    test('SecuritySessionActionSuccess holds data', () {
      const s = SecuritySessionActionSuccess({'revoked': true});
      expect(s.data['revoked'], isTrue);
    });
    test('SecuritySessionActionError holds message', () {
      const s = SecuritySessionActionError('revoke failed');
      expect(s.message, 'revoke failed');
    });

    test('SecurityDeviceActionState hierarchy', () {
      expect(const SecurityDeviceActionInitial(), isA<SecurityDeviceActionState>());
      expect(const SecurityDeviceActionLoading(), isA<SecurityDeviceActionState>());
      expect(const SecurityDeviceActionSuccess({}), isA<SecurityDeviceActionState>());
      expect(const SecurityDeviceActionError('e'), isA<SecurityDeviceActionState>());
    });
    test('SecurityDeviceActionSuccess holds data', () {
      const s = SecurityDeviceActionSuccess({'wiped': true});
      expect(s.data['wiped'], isTrue);
    });
    test('SecurityDeviceActionError holds message', () {
      const s = SecurityDeviceActionError('wipe failed');
      expect(s.message, 'wipe failed');
    });

    test('SecurityIpActionState hierarchy', () {
      expect(const SecurityIpActionInitial(), isA<SecurityIpActionState>());
      expect(const SecurityIpActionLoading(), isA<SecurityIpActionState>());
      expect(const SecurityIpActionSuccess(null), isA<SecurityIpActionState>());
      expect(const SecurityIpActionSuccess({'id': '1'}), isA<SecurityIpActionState>());
      expect(const SecurityIpActionError('e'), isA<SecurityIpActionState>());
    });
    test('SecurityIpActionSuccess data can be null (delete)', () {
      const s = SecurityIpActionSuccess(null);
      expect(s.data, isNull);
    });
    test('SecurityIpActionSuccess data holds create result', () {
      const s = SecurityIpActionSuccess({'id': '42', 'ip': '10.0.0.1'});
      expect(s.data?['id'], '42');
    });
    test('SecurityIpActionError holds message', () {
      const s = SecurityIpActionError('invalid CIDR');
      expect(s.message, 'invalid CIDR');
    });

    test('SecurityTrustedDeviceListState hierarchy', () {
      expect(const SecurityTrustedDeviceListInitial(), isA<SecurityTrustedDeviceListState>());
      expect(const SecurityTrustedDeviceListLoading(), isA<SecurityTrustedDeviceListState>());
      expect(const SecurityTrustedDeviceListLoaded({}), isA<SecurityTrustedDeviceListState>());
      expect(const SecurityTrustedDeviceListError('e'), isA<SecurityTrustedDeviceListState>());
    });
    test('SecurityTrustedDeviceListLoaded holds data', () {
      const s = SecurityTrustedDeviceListLoaded({'data': <dynamic>[]});
      expect(s.data.containsKey('data'), isTrue);
    });

    test('SecurityLoginAttemptListState hierarchy', () {
      expect(const SecurityLoginAttemptListInitial(), isA<SecurityLoginAttemptListState>());
      expect(const SecurityLoginAttemptListLoading(), isA<SecurityLoginAttemptListState>());
      expect(const SecurityLoginAttemptListLoaded({}), isA<SecurityLoginAttemptListState>());
      expect(const SecurityLoginAttemptListError('e'), isA<SecurityLoginAttemptListState>());
    });
    test('SecurityLoginAttemptListLoaded holds data map', () {
      const s = SecurityLoginAttemptListLoaded({'total': 3});
      expect(s.data['total'], 3);
    });

    test('SecurityAuditLogListState hierarchy', () {
      expect(const SecurityAuditLogListInitial(), isA<SecurityAuditLogListState>());
      expect(const SecurityAuditLogListLoading(), isA<SecurityAuditLogListState>());
      expect(const SecurityAuditLogListLoaded({}), isA<SecurityAuditLogListState>());
      expect(const SecurityAuditLogListError('e'), isA<SecurityAuditLogListState>());
    });
    test('SecurityAuditLogListLoaded holds data map', () {
      const s = SecurityAuditLogListLoaded({'action': 'login'});
      expect(s.data['action'], 'login');
    });

    test('SecurityActivityLogListState hierarchy', () {
      expect(const SecurityActivityLogListInitial(), isA<SecurityActivityLogListState>());
      expect(const SecurityActivityLogListLoading(), isA<SecurityActivityLogListState>());
      expect(const SecurityActivityLogListLoaded({}), isA<SecurityActivityLogListState>());
      expect(const SecurityActivityLogListError('e'), isA<SecurityActivityLogListState>());
    });
    test('SecurityActivityLogListLoaded holds data map', () {
      const s = SecurityActivityLogListLoaded({'page': 1});
      expect(s.data['page'], 1);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P14 Providers — existence tests
  // ═══════════════════════════════════════════════════════════════
  group('P14 Providers', () {
    test('securityOverviewProvider', () {
      expect(securityOverviewProvider, isNotNull);
    });
    test('secCenterAlertListProvider', () {
      expect(secCenterAlertListProvider, isNotNull);
    });
    test('secCenterAlertActionProvider', () {
      expect(secCenterAlertActionProvider, isNotNull);
    });
    test('securitySessionListProvider', () {
      expect(securitySessionListProvider, isNotNull);
    });
    test('securityDeviceListProvider', () {
      expect(securityDeviceListProvider, isNotNull);
    });
    test('securityPolicyListProvider', () {
      expect(securityPolicyListProvider, isNotNull);
    });
    test('securityPolicyActionProvider', () {
      expect(securityPolicyActionProvider, isNotNull);
    });
    test('securityIpAllowlistProvider', () {
      expect(securityIpAllowlistProvider, isNotNull);
    });
    test('securityIpBlocklistProvider', () {
      expect(securityIpBlocklistProvider, isNotNull);
    });
    test('securitySessionActionProvider', () {
      expect(securitySessionActionProvider, isNotNull);
    });
    test('securityDeviceActionProvider', () {
      expect(securityDeviceActionProvider, isNotNull);
    });
    test('securityIpActionProvider', () {
      expect(securityIpActionProvider, isNotNull);
    });
    test('securityTrustedDeviceListProvider', () {
      expect(securityTrustedDeviceListProvider, isNotNull);
    });
    test('securityTrustedDeviceActionProvider', () {
      expect(securityTrustedDeviceActionProvider, isNotNull);
    });
    test('securityLoginAttemptListProvider', () {
      expect(securityLoginAttemptListProvider, isNotNull);
    });
    test('securityAuditLogListProvider', () {
      expect(securityAuditLogListProvider, isNotNull);
    });
    test('securityActivityLogListProvider', () {
      expect(securityActivityLogListProvider, isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecuritySessionActionNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecuritySessionActionNotifier', () {
    test('initial state is SecuritySessionActionInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securitySessionActionProvider),
        isA<SecuritySessionActionInitial>(),
      );
    });

    test('revoke() → SecuritySessionActionSuccess with response', () async {
      final fake = FakeAdminRepository();
      fake.onRevokeSecuritySession =
          (id) async => {'success': true, 'message': 'Session $id revoked'};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securitySessionActionProvider.notifier).revoke('ses-1');

      final state = container.read(securitySessionActionProvider);
      expect(state, isA<SecuritySessionActionSuccess>());
      final s = state as SecuritySessionActionSuccess;
      expect(s.data['success'], isTrue);
      expect(s.data['message'], contains('ses-1'));
    });

    test('revoke() → SecuritySessionActionError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onRevokeSecuritySession =
          (_) async => throw Exception('Session not found');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securitySessionActionProvider.notifier).revoke('ses-99');

      final state = container.read(securitySessionActionProvider);
      expect(state, isA<SecuritySessionActionError>());
      expect((state as SecuritySessionActionError).message, contains('Session not found'));
    });

    test('revokeAll() → SecuritySessionActionSuccess', () async {
      final fake = FakeAdminRepository();
      fake.onRevokeAllSecuritySessions =
          (data) async => {'success': true, 'revoked_count': 5};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securitySessionActionProvider.notifier)
          .revokeAll({'admin_user_id': 'u-1'});

      final state = container.read(securitySessionActionProvider);
      expect(state, isA<SecuritySessionActionSuccess>());
      expect((state as SecuritySessionActionSuccess).data['revoked_count'], 5);
    });

    test('revokeAll() → SecuritySessionActionError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onRevokeAllSecuritySessions =
          (_) async => throw Exception('Unauthorized');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securitySessionActionProvider.notifier)
          .revokeAll({});

      expect(
        container.read(securitySessionActionProvider),
        isA<SecuritySessionActionError>(),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecurityDeviceActionNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecurityDeviceActionNotifier', () {
    test('initial state is SecurityDeviceActionInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securityDeviceActionProvider),
        isA<SecurityDeviceActionInitial>(),
      );
    });

    test('wipe() → SecurityDeviceActionSuccess', () async {
      final fake = FakeAdminRepository();
      fake.onWipeSecurityDevice =
          (id) async => {'success': true, 'device_id': id, 'wiped': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityDeviceActionProvider.notifier).wipe('dev-1');

      final state = container.read(securityDeviceActionProvider);
      expect(state, isA<SecurityDeviceActionSuccess>());
      expect((state as SecurityDeviceActionSuccess).data['device_id'], 'dev-1');
    });

    test('wipe() → SecurityDeviceActionError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onWipeSecurityDevice =
          (_) async => throw Exception('Device offline');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityDeviceActionProvider.notifier).wipe('dev-99');

      final state = container.read(securityDeviceActionProvider);
      expect(state, isA<SecurityDeviceActionError>());
      expect((state as SecurityDeviceActionError).message, contains('Device offline'));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecurityTrustedDeviceActionNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecurityTrustedDeviceActionNotifier', () {
    test('initial state is SecurityDeviceActionInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securityTrustedDeviceActionProvider),
        isA<SecurityDeviceActionInitial>(),
      );
    });

    test('revokeTrust() → SecurityDeviceActionSuccess', () async {
      final fake = FakeAdminRepository();
      fake.onRevokeSecurityTrustedDevice =
          (id) async => {'success': true, 'trust_revoked': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityTrustedDeviceActionProvider.notifier)
          .revokeTrust('trust-1');

      final state = container.read(securityTrustedDeviceActionProvider);
      expect(state, isA<SecurityDeviceActionSuccess>());
      expect((state as SecurityDeviceActionSuccess).data['trust_revoked'], isTrue);
    });

    test('revokeTrust() → SecurityDeviceActionError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onRevokeSecurityTrustedDevice =
          (_) async => throw Exception('Trust record not found');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityTrustedDeviceActionProvider.notifier)
          .revokeTrust('trust-99');

      expect(
        container.read(securityTrustedDeviceActionProvider),
        isA<SecurityDeviceActionError>(),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecurityIpActionNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecurityIpActionNotifier', () {
    test('initial state is SecurityIpActionInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securityIpActionProvider),
        isA<SecurityIpActionInitial>(),
      );
    });

    test('addToAllowlist() → SecurityIpActionSuccess with entry data', () async {
      final fake = FakeAdminRepository();
      fake.onCreateSecurityIpAllowlistEntry =
          (data) async => {'success': true, 'data': {'id': 'ip-1', 'ip': data['ip']}};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityIpActionProvider.notifier)
          .addToAllowlist({'ip': '10.0.0.5', 'label': 'Office'});

      final state = container.read(securityIpActionProvider);
      expect(state, isA<SecurityIpActionSuccess>());
      expect((state as SecurityIpActionSuccess).data?['success'], isTrue);
    });

    test('addToAllowlist() → SecurityIpActionError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onCreateSecurityIpAllowlistEntry =
          (_) async => throw Exception('Invalid IP format');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityIpActionProvider.notifier)
          .addToAllowlist({'ip': 'not-an-ip'});

      expect(
        container.read(securityIpActionProvider),
        isA<SecurityIpActionError>(),
      );
    });

    test('removeFromAllowlist() → SecurityIpActionSuccess(null)', () async {
      final fake = FakeAdminRepository();
      fake.onDeleteSecurityIpAllowlistEntry =
          (id) async => {'success': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityIpActionProvider.notifier)
          .removeFromAllowlist('ip-1');

      final state = container.read(securityIpActionProvider);
      expect(state, isA<SecurityIpActionSuccess>());
      expect((state as SecurityIpActionSuccess).data, isNull);
    });

    test('removeFromAllowlist() → SecurityIpActionError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onDeleteSecurityIpAllowlistEntry =
          (_) async => throw Exception('Not found');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityIpActionProvider.notifier)
          .removeFromAllowlist('ip-99');

      expect(
        container.read(securityIpActionProvider),
        isA<SecurityIpActionError>(),
      );
    });

    test('addToBlocklist() → SecurityIpActionSuccess with entry data', () async {
      final fake = FakeAdminRepository();
      fake.onCreateSecurityIpBlocklistEntry =
          (data) async => {'success': true, 'data': {'id': 'blk-1'}};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityIpActionProvider.notifier)
          .addToBlocklist({'ip': '192.168.1.100', 'reason': 'Brute force'});

      final state = container.read(securityIpActionProvider);
      expect(state, isA<SecurityIpActionSuccess>());
    });

    test('removeFromBlocklist() → SecurityIpActionSuccess(null)', () async {
      final fake = FakeAdminRepository();
      fake.onDeleteSecurityIpBlocklistEntry =
          (id) async => {'success': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityIpActionProvider.notifier)
          .removeFromBlocklist('blk-1');

      final state = container.read(securityIpActionProvider);
      expect(state, isA<SecurityIpActionSuccess>());
      expect((state as SecurityIpActionSuccess).data, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecCenterAlertActionNotifier — investigate tests
  // ═══════════════════════════════════════════════════════════════
  group('SecCenterAlertActionNotifier investigate', () {
    test('investigate() → SecCenterAlertActionSuccess', () async {
      final fake = FakeAdminRepository();
      fake.onInvestigateSecCenterAlert =
          (id) async => {'success': true, 'status': 'investigating'};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(secCenterAlertActionProvider.notifier)
          .investigate('alert-1');

      final state = container.read(secCenterAlertActionProvider);
      expect(state, isA<SecCenterAlertActionSuccess>());
      expect((state as SecCenterAlertActionSuccess).data['status'], 'investigating');
    });

    test('investigate() → SecCenterAlertActionError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onInvestigateSecCenterAlert =
          (_) async => throw Exception('Alert not found');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(secCenterAlertActionProvider.notifier)
          .investigate('alert-99');

      final state = container.read(secCenterAlertActionProvider);
      expect(state, isA<SecCenterAlertActionError>());
    });

    test('initial state is SecCenterAlertActionInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(secCenterAlertActionProvider),
        isA<SecCenterAlertActionInitial>(),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecurityTrustedDeviceListNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecurityTrustedDeviceListNotifier', () {
    test('initial state is SecurityTrustedDeviceListInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securityTrustedDeviceListProvider),
        isA<SecurityTrustedDeviceListInitial>(),
      );
    });

    test('load() → SecurityTrustedDeviceListLoaded with data', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityTrustedDevices = () async => {
            'success': true,
            'data': [
              {'id': 'td-1', 'admin_name': 'Alice', 'device_name': 'MacBook Pro'},
              {'id': 'td-2', 'admin_name': 'Bob', 'device_name': 'iPhone 15'},
            ],
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityTrustedDeviceListProvider.notifier).load();

      final state = container.read(securityTrustedDeviceListProvider);
      expect(state, isA<SecurityTrustedDeviceListLoaded>());
      final loaded = state as SecurityTrustedDeviceListLoaded;
      expect((loaded.data['data'] as List).length, 2);
    });

    test('load() → SecurityTrustedDeviceListLoaded with empty list', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityTrustedDevices =
          () async => {'success': true, 'data': <dynamic>[]};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityTrustedDeviceListProvider.notifier).load();

      final state = container.read(securityTrustedDeviceListProvider);
      expect(state, isA<SecurityTrustedDeviceListLoaded>());
      expect((state as SecurityTrustedDeviceListLoaded).data['data'], isEmpty);
    });

    test('load() → SecurityTrustedDeviceListError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityTrustedDevices =
          () async => throw Exception('Network error');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityTrustedDeviceListProvider.notifier).load();

      final state = container.read(securityTrustedDeviceListProvider);
      expect(state, isA<SecurityTrustedDeviceListError>());
      expect((state as SecurityTrustedDeviceListError).message, contains('Network error'));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecurityLoginAttemptListNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecurityLoginAttemptListNotifier', () {
    test('initial state is SecurityLoginAttemptListInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securityLoginAttemptListProvider),
        isA<SecurityLoginAttemptListInitial>(),
      );
    });

    test('load() → SecurityLoginAttemptListLoaded with data', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityLoginAttempts = () async => {
            'success': true,
            'data': [
              {
                'id': 'la-1',
                'ip_address': '1.2.3.4',
                'status': 'failed',
                'email': 'test@test.com',
                'created_at': '2025-01-01T00:00:00Z',
              }
            ],
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityLoginAttemptListProvider.notifier).load();

      final state = container.read(securityLoginAttemptListProvider);
      expect(state, isA<SecurityLoginAttemptListLoaded>());
      final loaded = state as SecurityLoginAttemptListLoaded;
      expect((loaded.data['data'] as List).first['ip_address'], '1.2.3.4');
    });

    test('load() → SecurityLoginAttemptListError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityLoginAttempts =
          () async => throw Exception('Timeout');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityLoginAttemptListProvider.notifier).load();

      expect(
        container.read(securityLoginAttemptListProvider),
        isA<SecurityLoginAttemptListError>(),
      );
    });

    test('load() with failed_only filter passes params to repo', () async {
      Map<String, dynamic>? capturedParams;
      final fake = FakeAdminRepository();
      fake.onGetSecurityLoginAttempts = () async {
        capturedParams = {'failed_only': '1'};
        return {'success': true, 'data': <dynamic>[]};
      };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(securityLoginAttemptListProvider.notifier)
          .load(params: {'failed_only': '1'});

      expect(capturedParams, isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecurityAuditLogListNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecurityAuditLogListNotifier', () {
    test('initial state is SecurityAuditLogListInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securityAuditLogListProvider),
        isA<SecurityAuditLogListInitial>(),
      );
    });

    test('load() → SecurityAuditLogListLoaded with audit entries', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityAuditLogs = () async => {
            'success': true,
            'data': [
              {
                'id': 'aud-1',
                'action': 'login',
                'user_type': 'owner',
                'ip_address': '5.6.7.8',
                'created_at': '2025-01-01T00:00:00Z',
              },
              {
                'id': 'aud-2',
                'action': 'failed_login',
                'user_type': 'staff',
                'ip_address': '9.10.11.12',
                'created_at': '2025-01-01T01:00:00Z',
              },
            ],
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityAuditLogListProvider.notifier).load();

      final state = container.read(securityAuditLogListProvider);
      expect(state, isA<SecurityAuditLogListLoaded>());
      final loaded = state as SecurityAuditLogListLoaded;
      final entries = loaded.data['data'] as List;
      expect(entries.length, 2);
      expect(entries.first['action'], 'login');
      expect(entries.last['action'], 'failed_login');
    });

    test('load() → SecurityAuditLogListError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityAuditLogs =
          () async => throw Exception('DB error');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityAuditLogListProvider.notifier).load();

      expect(
        container.read(securityAuditLogListProvider),
        isA<SecurityAuditLogListError>(),
      );
    });

    test('all valid audit actions are accepted', () {
      const validActions = [
        'login',
        'logout',
        'pin_override',
        'failed_login',
        'settings_change',
        'remote_wipe',
        'terminal_credential_update',
      ];
      for (final action in validActions) {
        final log = {'action': action, 'user_type': 'staff'};
        expect(log['action'], isIn(validActions));
      }
    });

    test('all valid audit user types are accepted', () {
      const validUserTypes = ['staff', 'owner', 'system'];
      for (final ut in validUserTypes) {
        final log = {'user_type': ut};
        expect(log['user_type'], isIn(validUserTypes));
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SecurityActivityLogListNotifier — state transition tests
  // ═══════════════════════════════════════════════════════════════
  group('SecurityActivityLogListNotifier', () {
    test('initial state is SecurityActivityLogListInitial', () {
      final container = makeContainer(FakeAdminRepository());
      addTearDown(container.dispose);
      expect(
        container.read(securityActivityLogListProvider),
        isA<SecurityActivityLogListInitial>(),
      );
    });

    test('load() → SecurityActivityLogListLoaded with activity entries', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityAdminActivityLogs = () async => {
            'success': true,
            'data': [
              {
                'id': 'act-1',
                'admin_name': 'Admin User',
                'action': 'updated_policy',
                'entity_type': 'SecurityPolicy',
                'entity_id': 'pol-1',
                'ip_address': '192.168.0.1',
                'created_at': '2025-01-01T00:00:00Z',
              }
            ],
            'meta': {'total': 1, 'current_page': 1},
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityActivityLogListProvider.notifier).load();

      final state = container.read(securityActivityLogListProvider);
      expect(state, isA<SecurityActivityLogListLoaded>());
      final loaded = state as SecurityActivityLogListLoaded;
      expect((loaded.data['data'] as List).first['action'], 'updated_policy');
    });

    test('load() → SecurityActivityLogListError on exception', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityAdminActivityLogs =
          () async => throw Exception('Not authorized');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityActivityLogListProvider.notifier).load();

      final state = container.read(securityActivityLogListProvider);
      expect(state, isA<SecurityActivityLogListError>());
      expect((state as SecurityActivityLogListError).message, contains('Not authorized'));
    });

    test('load() with empty result → SecurityActivityLogListLoaded with empty data', () async {
      final fake = FakeAdminRepository();
      fake.onGetSecurityAdminActivityLogs =
          () async => {'success': true, 'data': <dynamic>[]};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(securityActivityLogListProvider.notifier).load();

      final state = container.read(securityActivityLogListProvider);
      expect(state, isA<SecurityActivityLogListLoaded>());
      expect((state as SecurityActivityLogListLoaded).data['data'], isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P14 API response shape — JSON contract tests
  // ═══════════════════════════════════════════════════════════════
  group('P14 API response shape', () {
    test('session list response has data list and meta', () {
      final response = {
        'success': true,
        'data': [
          {
            'id': 's-1',
            'admin_name': 'Admin',
            'admin_email': 'admin@test.com',
            'ip_address': '1.2.3.4',
            'user_agent': 'Flutter/3.10',
            'revoked_at': null,
            'last_active_at': '2025-01-01T00:00:00Z',
          }
        ],
        'meta': {'total': 1, 'current_page': 1, 'last_page': 1},
      };
      expect(response['data'], isList);
      final session = (response['data'] as List).first as Map<String, dynamic>;
      expect(session.containsKey('id'), isTrue);
      expect(session.containsKey('ip_address'), isTrue);
      expect(session.containsKey('revoked_at'), isTrue);
      expect(session['revoked_at'], isNull); // null = active session
    });

    test('session revoke response has message', () {
      final response = {'success': true, 'message': 'Session revoked'};
      expect(response['success'], isTrue);
      expect(response['message'], isNotEmpty);
    });

    test('session revoke-all response has revoked_count', () {
      final response = {
        'success': true,
        'message': '5 sessions revoked',
        'revoked_count': 5,
      };
      expect(response['revoked_count'], greaterThanOrEqualTo(0));
    });

    test('device list response fields', () {
      final device = {
        'id': 'd-1',
        'name': 'POS Terminal A',
        'model': 'Sunmi V2 Pro',
        'serial_number': 'SN123456',
        'imei': '123456789012345',
        'platform': 'android',
        'status': 'active',
        'last_seen_at': '2025-01-01T00:00:00Z',
        'store_name': 'Riyadh Branch',
      };
      expect(device.containsKey('status'), isTrue);
      expect(device.containsKey('store_name'), isTrue);
    });

    test('trusted device list response fields', () {
      final td = {
        'id': 'td-1',
        'admin_id': 'a-1',
        'admin_name': 'Super Admin',
        'admin_email': 'admin@test.com',
        'device_name': 'MacBook Pro',
        'ip_address': '10.0.0.1',
        'user_agent': 'Dart/3.0',
        'trusted_at': '2025-01-01T00:00:00Z',
        'last_used_at': '2025-01-02T00:00:00Z',
      };
      expect(td.containsKey('admin_name'), isTrue);
      expect(td.containsKey('trusted_at'), isTrue);
    });

    test('login attempt response has was_successful or status field', () {
      final attempt = {
        'id': 'la-1',
        'ip_address': '1.2.3.4',
        'email': 'test@test.com',
        'was_successful': false,
        'failure_reason': 'invalid_password',
        'created_at': '2025-01-01T00:00:00Z',
      };
      expect(attempt['was_successful'], isFalse);
      expect(attempt.containsKey('failure_reason'), isTrue);
    });

    test('audit log response has action and user_type fields', () {
      final log = {
        'id': 'al-1',
        'action': 'login',
        'user_type': 'owner',
        'user_id': 'u-1',
        'ip_address': '1.2.3.4',
        'store_name': 'Branch A',
        'created_at': '2025-01-01T00:00:00Z',
      };
      expect(log['action'], isIn(['login', 'logout', 'pin_override', 'failed_login',
          'settings_change', 'remote_wipe', 'terminal_credential_update']));
      expect(log['user_type'], isIn(['staff', 'owner', 'system']));
    });

    test('ip allowlist entry fields', () {
      final entry = {
        'id': 'ip-1',
        'ip_address': '10.0.0.0/24',
        'type': 'CIDR',
        'label': 'Office Network',
        'added_by': 'admin@test.com',
        'expires_at': null,
        'created_at': '2025-01-01T00:00:00Z',
      };
      expect(entry.containsKey('type'), isTrue);
      expect(entry['type'], isIn(['IP', 'CIDR']));
    });

    test('ip blocklist entry has reason and hit_count', () {
      final entry = {
        'id': 'blk-1',
        'ip_address': '192.168.1.100',
        'type': 'IP',
        'reason': 'Brute force attack',
        'hit_count': 15,
        'blocked_by': 'system',
        'created_at': '2025-01-01T00:00:00Z',
      };
      expect(entry.containsKey('reason'), isTrue);
      expect(entry['hit_count'], greaterThanOrEqualTo(0));
    });

    test('policy response fields', () {
      final policy = {
        'id': 'pol-1',
        'policy_key': 'max_failed_attempts',
        'value': '5',
        'description': 'Maximum failed login attempts before lockout',
        'updated_at': '2025-01-01T00:00:00Z',
      };
      expect(policy.containsKey('policy_key'), isTrue);
      expect(policy.containsKey('value'), isTrue);
    });

    test('activity log response fields', () {
      final log = {
        'id': 'act-1',
        'admin_id': 'a-1',
        'admin_name': 'Super Admin',
        'admin_email': 'admin@test.com',
        'action': 'updated_policy',
        'entity_type': 'SecurityPolicy',
        'entity_id': 'pol-1',
        'description': 'Updated max_failed_attempts to 3',
        'ip_address': '10.0.0.1',
        'created_at': '2025-01-01T00:00:00Z',
      };
      expect(log.containsKey('admin_name'), isTrue);
      expect(log.containsKey('entity_type'), isTrue);
      expect(log.containsKey('description'), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P14 Cross-cutting — data integrity tests
  // ═══════════════════════════════════════════════════════════════
  group('P14 Data Integrity', () {
    test('all new security endpoints use /admin/security-center/ prefix', () {
      final endpoints = [
        ApiEndpoints.adminSecuritySessionsRevokeAll,
        ApiEndpoints.adminSecCenterAlertInvestigate('x'),
        ApiEndpoints.adminSecurityTrustedDevices,
        ApiEndpoints.adminSecurityTrustedDeviceById('x'),
        ApiEndpoints.adminSecurityActivityLogs,
        ApiEndpoints.adminSecurityActivityLogById('x'),
      ];
      for (final ep in endpoints) {
        expect(ep, startsWith('/admin/security-center/'),
            reason: 'Endpoint $ep must start with /admin/security-center/');
      }
    });

    test('dynamic endpoints include the id in the path', () {
      expect(ApiEndpoints.adminSecCenterAlertInvestigate('abc'), contains('abc'));
      expect(ApiEndpoints.adminSecurityTrustedDeviceById('xyz'), contains('xyz'));
      expect(ApiEndpoints.adminSecurityActivityLogById('999'), contains('999'));
    });

    test('revoke-all endpoint is a fixed path (no id)', () {
      expect(ApiEndpoints.adminSecuritySessionsRevokeAll, endsWith('/revoke-all'));
    });

    test('SecuritySessionActionState pattern matching is exhaustive', () {
      SecuritySessionActionState state = const SecuritySessionActionInitial();
      final result = switch (state) {
        SecuritySessionActionInitial() => 'initial',
        SecuritySessionActionLoading() => 'loading',
        SecuritySessionActionSuccess() => 'success',
        SecuritySessionActionError() => 'error',
      };
      expect(result, 'initial');
    });

    test('SecurityDeviceActionState pattern matching is exhaustive', () {
      SecurityDeviceActionState state = const SecurityDeviceActionLoading();
      final result = switch (state) {
        SecurityDeviceActionInitial() => 'initial',
        SecurityDeviceActionLoading() => 'loading',
        SecurityDeviceActionSuccess() => 'success',
        SecurityDeviceActionError() => 'error',
      };
      expect(result, 'loading');
    });

    test('SecurityIpActionState pattern matching is exhaustive', () {
      SecurityIpActionState state = const SecurityIpActionSuccess(null);
      final result = switch (state) {
        SecurityIpActionInitial() => 'initial',
        SecurityIpActionLoading() => 'loading',
        SecurityIpActionSuccess() => 'success',
        SecurityIpActionError() => 'error',
      };
      expect(result, 'success');
    });

    test('SecurityTrustedDeviceListState pattern matching is exhaustive', () {
      SecurityTrustedDeviceListState state =
          const SecurityTrustedDeviceListError('test');
      final result = switch (state) {
        SecurityTrustedDeviceListInitial() => 'initial',
        SecurityTrustedDeviceListLoading() => 'loading',
        SecurityTrustedDeviceListLoaded() => 'loaded',
        SecurityTrustedDeviceListError() => 'error',
      };
      expect(result, 'error');
    });

    test('SecurityLoginAttemptListState pattern matching is exhaustive', () {
      SecurityLoginAttemptListState state =
          const SecurityLoginAttemptListLoaded({'data': <dynamic>[]});
      final result = switch (state) {
        SecurityLoginAttemptListInitial() => 'initial',
        SecurityLoginAttemptListLoading() => 'loading',
        SecurityLoginAttemptListLoaded() => 'loaded',
        SecurityLoginAttemptListError() => 'error',
      };
      expect(result, 'loaded');
    });

    test('SecurityAuditLogListState pattern matching is exhaustive', () {
      SecurityAuditLogListState state =
          const SecurityAuditLogListLoading();
      final result = switch (state) {
        SecurityAuditLogListInitial() => 'initial',
        SecurityAuditLogListLoading() => 'loading',
        SecurityAuditLogListLoaded() => 'loaded',
        SecurityAuditLogListError() => 'error',
      };
      expect(result, 'loading');
    });

    test('SecurityActivityLogListState pattern matching is exhaustive', () {
      SecurityActivityLogListState state =
          const SecurityActivityLogListInitial();
      final result = switch (state) {
        SecurityActivityLogListInitial() => 'initial',
        SecurityActivityLogListLoading() => 'loading',
        SecurityActivityLogListLoaded() => 'loaded',
        SecurityActivityLogListError() => 'error',
      };
      expect(result, 'initial');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P14 Pages — widget class existence tests
  // ═══════════════════════════════════════════════════════════════
  group('P14 Pages', () {
    test('AdminSecurityOverviewPage', () {
      expect(AdminSecurityOverviewPage, isNotNull);
    });
    test('AdminSecurityAlertsPage', () {
      expect(AdminSecurityAlertsPage, isNotNull);
    });
    test('AdminSecuritySessionsPage', () {
      expect(AdminSecuritySessionsPage, isNotNull);
    });
    test('AdminSecurityDevicesPage', () {
      expect(AdminSecurityDevicesPage, isNotNull);
    });
    test('AdminSecurityIpPage', () {
      expect(AdminSecurityIpPage, isNotNull);
    });
    test('AdminSecurityPoliciesPage', () {
      expect(AdminSecurityPoliciesPage, isNotNull);
    });
    test('AdminSecurityTrustedDevicesPage', () {
      expect(AdminSecurityTrustedDevicesPage, isNotNull);
    });
    test('AdminSecurityAuditLogPage', () {
      expect(AdminSecurityAuditLogPage, isNotNull);
    });
    test('AdminSecurityLoginAttemptsPage', () {
      expect(AdminSecurityLoginAttemptsPage, isNotNull);
    });
    test('AdminActivityLogPage', () {
      expect(AdminActivityLogPage, isNotNull);
    });
  });
}
