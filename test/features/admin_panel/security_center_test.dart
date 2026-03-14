import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/features/admin_panel/data/remote/admin_api_service.dart';
import 'package:thawani_pos/features/admin_panel/repositories/admin_repository.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_security_overview_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_security_alerts_page.dart';

void main() {
  // ─── Endpoint Tests ───────────────────────────────────────────────
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
    test('sessions', () {
      expect(ApiEndpoints.adminSecuritySessions, '/admin/security-center/sessions');
    });
    test('session by id', () {
      expect(ApiEndpoints.adminSecuritySessionById('2'), '/admin/security-center/sessions/2');
    });
    test('session revoke', () {
      expect(ApiEndpoints.adminSecuritySessionRevoke('2'), '/admin/security-center/sessions/2/revoke');
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
  });

  // ─── Service methods ──────────────────────────────────────────────
  group('P14 Service methods', () {
    test('AdminApiService exists', () {
      expect(AdminApiService, isNotNull);
    });
  });

  // ─── Repository methods ───────────────────────────────────────────
  group('P14 Repository methods', () {
    test('AdminRepository exists', () {
      expect(AdminRepository, isNotNull);
    });
  });

  // ─── State classes ────────────────────────────────────────────────
  group('P14 State classes', () {
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

  // ─── Providers ────────────────────────────────────────────────────
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
  });

  // ─── Pages ────────────────────────────────────────────────────────
  group('P14 Pages', () {
    test('AdminSecurityOverviewPage', () {
      expect(AdminSecurityOverviewPage, isNotNull);
    });
    test('AdminSecurityAlertsPage', () {
      expect(AdminSecurityAlertsPage, isNotNull);
    });
  });
}
