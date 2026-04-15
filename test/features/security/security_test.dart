import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/security/enums/login_attempt_type.dart';
import 'package:wameedpos/features/security/enums/security_audit_action.dart';
import 'package:wameedpos/features/security/enums/security_alert_status.dart';
import 'package:wameedpos/features/security/enums/role_audit_action.dart';
import 'package:wameedpos/features/security/enums/session_status.dart';
import 'package:wameedpos/features/security/models/security_policy.dart';
import 'package:wameedpos/features/security/models/security_audit_log.dart';
import 'package:wameedpos/features/security/models/device_registration.dart';
import 'package:wameedpos/features/security/models/login_attempt.dart';
import 'package:wameedpos/features/security/models/pin_override.dart';
import 'package:wameedpos/features/security/models/security_alert.dart';
import 'package:wameedpos/features/security/providers/security_state.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';

void main() {
  // ═══ Enum Tests ═══════════════════════════════════════════════

  group('LoginAttemptType', () {
    test('fromValue parses all values', () {
      expect(LoginAttemptType.fromValue('pin'), LoginAttemptType.pin);
      expect(LoginAttemptType.fromValue('password'), LoginAttemptType.password);
      expect(LoginAttemptType.fromValue('biometric'), LoginAttemptType.biometric);
      expect(LoginAttemptType.fromValue('two_factor'), LoginAttemptType.twoFactor);
    });

    test('fromValue throws on invalid', () {
      expect(() => LoginAttemptType.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns null on invalid', () {
      expect(LoginAttemptType.tryFromValue('nope'), isNull);
      expect(LoginAttemptType.tryFromValue(null), isNull);
    });

    test('value property returns correct string', () {
      expect(LoginAttemptType.pin.value, 'pin');
      expect(LoginAttemptType.twoFactor.value, 'two_factor');
    });
  });

  group('SecurityAuditAction', () {
    test('fromValue parses all values', () {
      expect(SecurityAuditAction.fromValue('login'), SecurityAuditAction.login);
      expect(SecurityAuditAction.fromValue('logout'), SecurityAuditAction.logout);
      expect(SecurityAuditAction.fromValue('pin_override'), SecurityAuditAction.pinOverride);
      expect(SecurityAuditAction.fromValue('failed_login'), SecurityAuditAction.failedLogin);
      expect(SecurityAuditAction.fromValue('settings_change'), SecurityAuditAction.settingsChange);
      expect(SecurityAuditAction.fromValue('remote_wipe'), SecurityAuditAction.remoteWipe);
    });
  });

  group('SecurityAlertStatus', () {
    test('fromValue parses known values', () {
      expect(SecurityAlertStatus.fromValue('new'), SecurityAlertStatus.newValue);
      expect(SecurityAlertStatus.fromValue('investigating'), SecurityAlertStatus.investigating);
      expect(SecurityAlertStatus.fromValue('resolved'), SecurityAlertStatus.resolved);
    });
  });

  group('RoleAuditAction', () {
    test('all values roundtrip', () {
      for (final v in RoleAuditAction.values) {
        expect(RoleAuditAction.fromValue(v.value), v);
      }
    });
  });

  group('SessionStatus', () {
    test('all values roundtrip', () {
      for (final v in SessionStatus.values) {
        expect(SessionStatus.fromValue(v.value), v);
      }
    });
  });

  // ═══ Model Tests ═════════════════════════════════════════════

  group('SecurityPolicy', () {
    final json = {
      'id': 'policy-1',
      'store_id': 'store-1',
      'pin_min_length': 4,
      'pin_max_length': 6,
      'auto_lock_seconds': 300,
      'max_failed_attempts': 5,
      'lockout_duration_minutes': 15,
      'require_2fa_owner': false,
      'session_max_hours': 12,
      'require_pin_override_void': true,
      'require_pin_override_return': true,
      'require_pin_override_discount': false,
      'discount_override_threshold': 20.0,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson creates correctly', () {
      final p = SecurityPolicy.fromJson(json);
      expect(p.id, 'policy-1');
      expect(p.storeId, 'store-1');
      expect(p.pinMinLength, 4);
      expect(p.pinMaxLength, 6);
      expect(p.autoLockSeconds, 300);
      expect(p.maxFailedAttempts, 5);
      expect(p.require2faOwner, false);
      expect(p.requirePinOverrideVoid, true);
      expect(p.discountOverrideThreshold, 20.0);
    });

    test('toJson roundtrips', () {
      final p = SecurityPolicy.fromJson(json);
      final out = p.toJson();
      expect(out['id'], 'policy-1');
      expect(out['pin_min_length'], 4);
      expect(out['require_pin_override_void'], true);
    });

    test('copyWith updates fields', () {
      final p = SecurityPolicy.fromJson(json);
      final p2 = p.copyWith(pinMinLength: 6, require2faOwner: true);
      expect(p2.pinMinLength, 6);
      expect(p2.require2faOwner, true);
      expect(p2.id, 'policy-1');
    });

    test('equality by id', () {
      final a = SecurityPolicy.fromJson(json);
      final b = SecurityPolicy.fromJson(json);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('SecurityAuditLog', () {
    final json = {
      'id': 'log-1',
      'store_id': 'store-1',
      'user_id': 'user-1',
      'user_type': 'staff',
      'action': 'login',
      'resource_type': 'order',
      'resource_id': 'ord-1',
      'details': {'ip': '1.2.3.4'},
      'severity': 'info',
      'ip_address': '1.2.3.4',
      'device_id': 'dev-1',
      'created_at': '2024-01-01T10:00:00.000Z',
    };

    test('fromJson creates correctly', () {
      final l = SecurityAuditLog.fromJson(json);
      expect(l.id, 'log-1');
      expect(l.action, SecurityAuditAction.login);
      expect(l.details, {'ip': '1.2.3.4'});
      expect(l.ipAddress, '1.2.3.4');
    });

    test('toJson roundtrips', () {
      final l = SecurityAuditLog.fromJson(json);
      final out = l.toJson();
      expect(out['action'], 'login');
      expect(out['severity'], 'info');
      expect(out['user_type'], 'staff');
    });

    test('equality by id', () {
      final a = SecurityAuditLog.fromJson(json);
      final b = SecurityAuditLog.fromJson(json);
      expect(a, b);
    });
  });

  group('DeviceRegistration', () {
    final json = {
      'id': 'dev-1',
      'store_id': 'store-1',
      'device_name': 'POS Terminal 1',
      'hardware_id': 'HW-ABC-123',
      'os_info': 'Android 14',
      'app_version': '2.1.0',
      'last_active_at': '2024-06-01T12:00:00.000Z',
      'is_active': true,
      'remote_wipe_requested': false,
      'registered_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson creates correctly', () {
      final d = DeviceRegistration.fromJson(json);
      expect(d.id, 'dev-1');
      expect(d.deviceName, 'POS Terminal 1');
      expect(d.hardwareId, 'HW-ABC-123');
      expect(d.isActive, true);
      expect(d.remoteWipeRequested, false);
      expect(d.osInfo, 'Android 14');
      expect(d.appVersion, '2.1.0');
    });

    test('toJson roundtrips', () {
      final d = DeviceRegistration.fromJson(json);
      final out = d.toJson();
      expect(out['device_name'], 'POS Terminal 1');
      expect(out['hardware_id'], 'HW-ABC-123');
      expect(out['is_active'], true);
    });

    test('copyWith updates fields', () {
      final d = DeviceRegistration.fromJson(json);
      final d2 = d.copyWith(isActive: false, remoteWipeRequested: true);
      expect(d2.isActive, false);
      expect(d2.remoteWipeRequested, true);
      expect(d2.deviceName, 'POS Terminal 1');
    });

    test('defaults when fields missing', () {
      final d = DeviceRegistration.fromJson({'id': 'x', 'store_id': 's', 'device_name': 'T', 'hardware_id': 'H'});
      expect(d.isActive, true);
      expect(d.remoteWipeRequested, false);
      expect(d.osInfo, isNull);
    });

    test('equality by id', () {
      final a = DeviceRegistration.fromJson(json);
      final b = DeviceRegistration.fromJson(json);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('LoginAttempt', () {
    final json = {
      'id': 'att-1',
      'store_id': 'store-1',
      'user_identifier': 'cashier@test.com',
      'attempt_type': 'pin',
      'is_successful': true,
      'ip_address': '10.0.0.1',
      'device_id': 'dev-1',
      'attempted_at': '2024-06-01T10:00:00.000Z',
    };

    test('fromJson creates correctly', () {
      final a = LoginAttempt.fromJson(json);
      expect(a.id, 'att-1');
      expect(a.userIdentifier, 'cashier@test.com');
      expect(a.attemptType, LoginAttemptType.pin);
      expect(a.isSuccessful, true);
      expect(a.ipAddress, '10.0.0.1');
    });

    test('toJson roundtrips', () {
      final a = LoginAttempt.fromJson(json);
      final out = a.toJson();
      expect(out['attempt_type'], 'pin');
      expect(out['is_successful'], true);
      expect(out['user_identifier'], 'cashier@test.com');
    });

    test('copyWith updates fields', () {
      final a = LoginAttempt.fromJson(json);
      final a2 = a.copyWith(isSuccessful: false, attemptType: LoginAttemptType.biometric);
      expect(a2.isSuccessful, false);
      expect(a2.attemptType, LoginAttemptType.biometric);
      expect(a2.userIdentifier, 'cashier@test.com');
    });

    test('equality by id', () {
      final a = LoginAttempt.fromJson(json);
      final b = LoginAttempt.fromJson(json);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('PinOverride', () {
    final json = {
      'id': 'po-1',
      'store_id': 'store-1',
      'requesting_user_id': 'user-1',
      'authorizing_user_id': 'user-2',
      'permission_code': 'void_order',
      'action_context': {'order_id': 'ord-1'},
      'created_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson creates correctly', () {
      final po = PinOverride.fromJson(json);
      expect(po.id, 'po-1');
      expect(po.permissionCode, 'void_order');
      expect(po.actionContext, {'order_id': 'ord-1'});
    });

    test('toJson roundtrips', () {
      final po = PinOverride.fromJson(json);
      final out = po.toJson();
      expect(out['permission_code'], 'void_order');
      expect(out['store_id'], 'store-1');
    });
  });

  group('SecurityAlert', () {
    final json = {
      'id': 'alert-1',
      'admin_user_id': 'admin-1',
      'alert_type': 'brute_force',
      'severity': 'high',
      'details': {'attempts': 10},
      'status': 'new',
      'resolved_at': null,
      'resolved_by': null,
      'resolution_notes': null,
      'created_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson creates correctly', () {
      final a = SecurityAlert.fromJson(json);
      expect(a.id, 'alert-1');
      expect(a.status, SecurityAlertStatus.newValue);
      expect(a.details, {'attempts': 10});
    });

    test('toJson roundtrips', () {
      final a = SecurityAlert.fromJson(json);
      final out = a.toJson();
      expect(out['status'], 'new');
      expect(out['alert_type'], 'brute_force');
    });
  });

  // ═══ State Tests ═════════════════════════════════════════════

  group('SecurityPolicyState', () {
    test('initial state', () {
      const s = SecurityPolicyInitial();
      expect(s, isA<SecurityPolicyState>());
    });

    test('loading state', () {
      const s = SecurityPolicyLoading();
      expect(s, isA<SecurityPolicyState>());
    });

    test('loaded state holds policy', () {
      final p = SecurityPolicy.fromJson({'id': 'p1', 'store_id': 's1', 'pin_min_length': 4});
      final s = SecurityPolicyLoaded(p);
      expect(s.policy.id, 'p1');
    });

    test('error state holds message', () {
      const s = SecurityPolicyError('fail');
      expect(s.message, 'fail');
    });
  });

  group('AuditLogListState', () {
    test('loaded state holds logs', () {
      final log = SecurityAuditLog.fromJson({'id': 'l1', 'store_id': 's1', 'action': 'login', 'user_type': 'staff'});
      final s = AuditLogListLoaded([log]);
      expect(s.logs.length, 1);
    });
  });

  group('DeviceListState', () {
    test('loaded state holds devices', () {
      final d = DeviceRegistration.fromJson({'id': 'd1', 'store_id': 's1', 'device_name': 'T1', 'hardware_id': 'H1'});
      final s = DeviceListLoaded([d]);
      expect(s.devices.length, 1);
    });
  });

  group('LoginAttemptsState', () {
    test('loaded state holds attempts', () {
      final a = LoginAttempt.fromJson({
        'id': 'a1',
        'store_id': 's1',
        'user_identifier': 'u1',
        'attempt_type': 'pin',
        'is_successful': true,
      });
      final s = LoginAttemptsLoaded([a]);
      expect(s.attempts.length, 1);
    });
  });

  // ═══ API Endpoints Tests ═════════════════════════════════════

  group('Security API Endpoints', () {
    test('policy endpoint', () {
      expect(ApiEndpoints.securityPolicy, '/security/policy');
    });

    test('audit logs endpoint', () {
      expect(ApiEndpoints.securityAuditLogs, '/security/audit-logs');
    });

    test('devices endpoint', () {
      expect(ApiEndpoints.securityDevices, '/security/devices');
    });

    test('device deactivate endpoint', () {
      expect(ApiEndpoints.securityDeviceDeactivate('abc'), '/security/devices/abc/deactivate');
    });

    test('device remote wipe endpoint', () {
      expect(ApiEndpoints.securityDeviceRemoteWipe('abc'), '/security/devices/abc/remote-wipe');
    });

    test('login attempts endpoint', () {
      expect(ApiEndpoints.securityLoginAttempts, '/security/login-attempts');
    });

    test('failed count endpoint', () {
      expect(ApiEndpoints.securityLoginAttemptsFailedCount, '/security/login-attempts/failed-count');
    });
  });

  // ═══ Cross-cutting Tests ═════════════════════════════════════

  group('Cross-cutting', () {
    test('all models have consistent toJson/fromJson', () {
      // DeviceRegistration
      final d = DeviceRegistration.fromJson({
        'id': 'd1',
        'store_id': 's1',
        'device_name': 'T',
        'hardware_id': 'H',
        'is_active': true,
        'remote_wipe_requested': false,
      });
      final dj = d.toJson();
      final d2 = DeviceRegistration.fromJson(dj);
      expect(d2.id, d.id);
      expect(d2.isActive, d.isActive);

      // LoginAttempt
      final la = LoginAttempt.fromJson({
        'id': 'la1',
        'store_id': 's1',
        'user_identifier': 'u',
        'attempt_type': 'password',
        'is_successful': false,
      });
      final laj = la.toJson();
      final la2 = LoginAttempt.fromJson(laj);
      expect(la2.attemptType, LoginAttemptType.password);
      expect(la2.isSuccessful, false);
    });

    test('sealed states are exhaustive', () {
      // SecurityPolicyState
      SecurityPolicyState s = const SecurityPolicyInitial();
      final label = switch (s) {
        SecurityPolicyInitial() => 'init',
        SecurityPolicyLoading() => 'load',
        SecurityPolicyLoaded() => 'ok',
        SecurityPolicyError() => 'err',
      };
      expect(label, 'init');

      // AuditLogListState
      AuditLogListState als = const AuditLogListInitial();
      final alLabel = switch (als) {
        AuditLogListInitial() => 'init',
        AuditLogListLoading() => 'load',
        AuditLogListLoaded() => 'ok',
        AuditLogListError() => 'err',
      };
      expect(alLabel, 'init');

      // DeviceListState
      DeviceListState dls = const DeviceListInitial();
      final dlLabel = switch (dls) {
        DeviceListInitial() => 'init',
        DeviceListLoading() => 'load',
        DeviceListLoaded() => 'ok',
        DeviceListError() => 'err',
      };
      expect(dlLabel, 'init');

      // LoginAttemptsState
      LoginAttemptsState las = const LoginAttemptsInitial();
      final laLabel = switch (las) {
        LoginAttemptsInitial() => 'init',
        LoginAttemptsLoading() => 'load',
        LoginAttemptsLoaded() => 'ok',
        LoginAttemptsError() => 'err',
      };
      expect(laLabel, 'init');
    });
  });
}
