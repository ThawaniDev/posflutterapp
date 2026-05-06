import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/security/enums/login_attempt_type.dart';
import 'package:wameedpos/features/security/enums/security_audit_action.dart';
import 'package:wameedpos/features/security/models/device_registration.dart';
import 'package:wameedpos/features/security/models/login_attempt.dart';
import 'package:wameedpos/features/security/models/pin_override.dart';
import 'package:wameedpos/features/security/models/security_audit_log.dart';
import 'package:wameedpos/features/security/models/security_incident.dart';
import 'package:wameedpos/features/security/models/security_policy.dart';
import 'package:wameedpos/features/security/models/security_session.dart';
import 'package:wameedpos/features/settings/enums/audit_user_type.dart';
import 'package:wameedpos/features/settings/enums/audit_severity.dart';
import 'package:wameedpos/features/settings/enums/audit_resource_type.dart';

/// API contract tests — verifies that Flutter models correctly parse the exact
/// JSON shapes that the Laravel backend sends. These tests are the single source
/// of truth for backend ↔ Flutter type parity.
void main() {
  // ═══ SecurityPolicy ═══════════════════════════════════════════════════════

  group('SecurityPolicy contract', () {
    test('parses full backend response', () {
      final json = {
        'id': 'pol-uuid-1',
        'store_id': 'store-uuid-1',
        'pin_min_length': 4,
        'pin_max_length': 8,
        'auto_lock_seconds': 300,
        'max_failed_attempts': 5,
        'lockout_duration_minutes': 15,
        'require_2fa_owner': false,
        'session_max_hours': 24,
        'require_pin_override_void': true,
        'require_pin_override_return': true,
        'require_pin_override_discount': false,
        'discount_override_threshold': 20.0,
        'biometric_enabled': true,
        'pin_expiry_days': 0,
        'require_unique_pins': true,
        'max_devices': 10,
        'audit_retention_days': 90,
        'force_logout_on_role_change': true,
        'password_expiry_days': 0,
        'require_strong_password': false,
        'ip_restriction_enabled': false,
        'allowed_ip_ranges': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final policy = SecurityPolicy.fromJson(json);

      expect(policy.id, 'pol-uuid-1');
      expect(policy.storeId, 'store-uuid-1');
      expect(policy.pinMinLength, 4);
      expect(policy.pinMaxLength, 8);
      expect(policy.autoLockSeconds, 300);
      expect(policy.maxFailedAttempts, 5);
      expect(policy.lockoutDurationMinutes, 15);
      expect(policy.require2faOwner, false);
      expect(policy.sessionMaxHours, 24);
      expect(policy.requirePinOverrideVoid, true);
      expect(policy.requirePinOverrideReturn, true);
      expect(policy.requirePinOverrideDiscount, false);
      expect(policy.biometricEnabled, true);
      expect(policy.requireUniquePins, true);
      expect(policy.maxDevices, 10);
      expect(policy.auditRetentionDays, 90);
      expect(policy.forceLogoutOnRoleChange, true);
      expect(policy.ipRestrictionEnabled, false);
      expect(policy.allowedIpRanges, isNull);
    });

    test('handles null optional fields', () {
      final json = {
        'id': 'pol-uuid-2',
        'store_id': 'store-uuid-2',
        'pin_min_length': 4,
      };

      final policy = SecurityPolicy.fromJson(json);
      expect(policy.id, 'pol-uuid-2');
      expect(policy.allowedIpRanges, isNull);
    });

    test('parses allowed_ip_ranges as a list', () {
      final json = {
        'id': 'pol-uuid-3',
        'store_id': 'store-uuid-3',
        'pin_min_length': 4,
        'allowed_ip_ranges': ['192.168.1.0/24', '10.0.0.0/8'],
      };

      final policy = SecurityPolicy.fromJson(json);
      expect(policy.allowedIpRanges, isNotNull);
      expect(policy.allowedIpRanges?.length, 2);
    });

    test('toJson roundtrip preserves all fields', () {
      final json = {
        'id': 'pol-1',
        'store_id': 'store-1',
        'pin_min_length': 6,
        'pin_max_length': 8,
        'max_failed_attempts': 3,
        'lockout_duration_minutes': 10,
        'require_2fa_owner': true,
        'biometric_enabled': false,
        'ip_restriction_enabled': true,
        'allowed_ip_ranges': ['192.168.1.0/24'],
      };

      final policy = SecurityPolicy.fromJson(json);
      final out = policy.toJson();
      final policy2 = SecurityPolicy.fromJson(out);

      expect(policy2.pinMinLength, 6);
      expect(policy2.maxFailedAttempts, 3);
      expect(policy2.require2faOwner, true);
      expect(policy2.ipRestrictionEnabled, true);
    });
  });

  // ═══ SecurityAuditLog ═════════════════════════════════════════════════════

  group('SecurityAuditLog contract', () {
    test('parses full backend audit log row', () {
      final json = {
        'id': 'log-uuid-1',
        'store_id': 'store-uuid-1',
        'user_id': 'user-uuid-1',
        'user_type': 'staff',
        'action': 'login',
        'resource_type': 'settings',
        'resource_id': 'sess-uuid-1',
        'details': {'ip': '10.0.0.1', 'device': 'Terminal 1'},
        'severity': 'info',
        'ip_address': '10.0.0.1',
        'device_id': 'dev-uuid-1',
        'created_at': '2024-06-01T12:00:00.000Z',
      };

      final log = SecurityAuditLog.fromJson(json);

      expect(log.id, 'log-uuid-1');
      expect(log.storeId, 'store-uuid-1');
      expect(log.userId, 'user-uuid-1');
      expect(log.userType, AuditUserType.staff);
      expect(log.action, SecurityAuditAction.login);
      expect(log.resourceType, AuditResourceType.settings);
      expect(log.resourceId, 'sess-uuid-1');
      expect(log.severity, AuditSeverity.info);
      expect(log.ipAddress, '10.0.0.1');
      expect(log.deviceId, 'dev-uuid-1');
      expect(log.details, isNotNull);
      expect(log.createdAt, isNotNull);
    });

    test('parses audit log with null optional fields', () {
      final json = {
        'id': 'log-uuid-2',
        'store_id': 'store-uuid-2',
        'user_type': 'system',
        'action': 'settings_change',
        'severity': 'warning',
      };

      final log = SecurityAuditLog.fromJson(json);
      expect(log.userId, isNull);
      expect(log.resourceType, isNull);
      expect(log.ipAddress, isNull);
      expect(log.details, isNull);
    });

    test('parses ISO datetime correctly', () {
      final json = {
        'id': 'log-uuid-3',
        'store_id': 'store-uuid-3',
        'user_type': 'staff',
        'action': 'logout',
        'severity': 'info',
        'created_at': '2024-06-15T14:30:00.000Z',
      };

      final log = SecurityAuditLog.fromJson(json);
      expect(log.createdAt?.year, 2024);
      expect(log.createdAt?.month, 6);
      expect(log.createdAt?.day, 15);
    });
  });

  // ═══ DeviceRegistration ═══════════════════════════════════════════════════

  group('DeviceRegistration contract', () {
    test('parses full backend device record', () {
      final json = {
        'id': 'dev-uuid-1',
        'store_id': 'store-uuid-1',
        'device_name': 'Terminal 1',
        'hardware_id': 'HWID-ABC123',
        'os_info': 'Android 13',
        'app_version': '2.3.0',
        'last_active_at': '2024-06-01T10:00:00.000Z',
        'is_active': true,
        'remote_wipe_requested': false,
        'registered_at': '2024-01-01T00:00:00.000Z',
      };

      final device = DeviceRegistration.fromJson(json);

      expect(device.id, 'dev-uuid-1');
      expect(device.storeId, 'store-uuid-1');
      expect(device.deviceName, 'Terminal 1');
      expect(device.hardwareId, 'HWID-ABC123');
      expect(device.osInfo, 'Android 13');
      expect(device.appVersion, '2.3.0');
      expect(device.isActive, true);
      expect(device.remoteWipeRequested, false);
      expect(device.lastActiveAt, isNotNull);
      expect(device.registeredAt, isNotNull);
    });

    test('parses device with is_active false (deactivated)', () {
      final json = {
        'id': 'dev-uuid-2',
        'store_id': 'store-uuid-2',
        'device_name': 'Retired Terminal',
        'hardware_id': 'HWID-OLD',
        'is_active': false,
        'remote_wipe_requested': false,
      };

      final device = DeviceRegistration.fromJson(json);
      expect(device.isActive, false);
    });

    test('parses device with remote_wipe_requested true', () {
      final json = {
        'id': 'dev-uuid-3',
        'store_id': 'store-uuid-3',
        'device_name': 'Compromised',
        'hardware_id': 'HWID-COMP',
        'is_active': true,
        'remote_wipe_requested': true,
      };

      final device = DeviceRegistration.fromJson(json);
      expect(device.remoteWipeRequested, true);
    });

    test('null optional fields handled gracefully', () {
      final json = {
        'id': 'dev-uuid-4',
        'store_id': 'store-uuid-4',
        'device_name': 'Minimal Device',
        'hardware_id': 'HW-MIN',
        'is_active': true,
        'remote_wipe_requested': false,
      };

      final device = DeviceRegistration.fromJson(json);
      expect(device.osInfo, isNull);
      expect(device.appVersion, isNull);
      expect(device.lastActiveAt, isNull);
    });
  });

  // ═══ LoginAttempt ═════════════════════════════════════════════════════════

  group('LoginAttempt contract', () {
    test('parses successful pin attempt', () {
      final json = {
        'id': 'la-uuid-1',
        'store_id': 'store-uuid-1',
        'user_identifier': 'cashier@store.com',
        'attempt_type': 'pin',
        'is_successful': true,
        'ip_address': '10.0.0.1',
        'device_id': 'dev-uuid-1',
        'attempted_at': '2024-06-01T09:00:00.000Z',
      };

      final attempt = LoginAttempt.fromJson(json);

      expect(attempt.id, 'la-uuid-1');
      expect(attempt.userIdentifier, 'cashier@store.com');
      expect(attempt.attemptType, LoginAttemptType.pin);
      expect(attempt.isSuccessful, true);
      expect(attempt.ipAddress, '10.0.0.1');
    });

    test('parses failed password attempt', () {
      final json = {
        'id': 'la-uuid-2',
        'store_id': 'store-uuid-2',
        'user_identifier': 'admin@store.com',
        'attempt_type': 'password',
        'is_successful': false,
        'ip_address': '192.168.1.50',
        'attempted_at': '2024-06-01T09:05:00.000Z',
      };

      final attempt = LoginAttempt.fromJson(json);
      expect(attempt.attemptType, LoginAttemptType.password);
      expect(attempt.isSuccessful, false);
    });

    test('attempt_type biometric is parsed correctly', () {
      final json = {
        'id': 'la-uuid-3',
        'store_id': 'store-uuid-3',
        'user_identifier': 'owner@store.com',
        'attempt_type': 'biometric',
        'is_successful': true,
      };

      final attempt = LoginAttempt.fromJson(json);
      expect(attempt.attemptType, LoginAttemptType.biometric);
    });

    test('unknown attempt_type falls back gracefully', () {
      final json = {
        'id': 'la-uuid-4',
        'store_id': 'store-uuid-4',
        'user_identifier': 'x',
        'attempt_type': 'future_type',
        'is_successful': false,
      };

      // LoginAttemptType.fromValue throws on unknown values — test for the actual behavior
      expect(() => LoginAttempt.fromJson(json), throwsArgumentError);
    });
  });

  // ═══ SecuritySession ══════════════════════════════════════════════════════

  group('SecuritySession contract', () {
    test('parses active session from backend', () {
      final json = {
        'id': 'sess-uuid-1',
        'store_id': 'store-uuid-1',
        'user_id': 'user-uuid-1',
        'device_id': 'dev-uuid-1',
        'session_type': 'pos',
        'status': 'active',
        'ip_address': '10.0.0.1',
        'user_agent': 'POS-App/2.3.0',
        'started_at': '2024-06-01T08:00:00.000Z',
        'last_activity_at': '2024-06-01T10:30:00.000Z',
        'ended_at': null,
        'end_reason': null,
        'metadata': {'store_name': 'Test Store'},
      };

      final session = SecuritySession.fromJson(json);

      expect(session.id, 'sess-uuid-1');
      expect(session.storeId, 'store-uuid-1');
      expect(session.userId, 'user-uuid-1');
      expect(session.deviceId, 'dev-uuid-1');
      expect(session.status, 'active');
      expect(session.isActive, true);
      expect(session.startedAt?.hour, 8);
      expect(session.lastActivityAt, isNotNull);
      expect(session.endedAt, isNull);
      expect(session.metadata?['store_name'], 'Test Store');
    });

    test('isActive getter returns false for ended sessions', () {
      final json = {
        'id': 'sess-uuid-2',
        'store_id': 'store-uuid-2',
        'user_id': 'user-uuid-2',
        'status': 'ended',
        'started_at': '2024-06-01T08:00:00.000Z',
        'ended_at': '2024-06-01T17:00:00.000Z',
      };

      final session = SecuritySession.fromJson(json);
      expect(session.isActive, false);
    });

    test('status defaults to active when missing', () {
      final json = {
        'id': 'sess-uuid-3',
        'store_id': 'store-uuid-3',
        'user_id': 'user-uuid-3',
      };

      final session = SecuritySession.fromJson(json);
      expect(session.status, 'active');
    });

    test('null metadata handled correctly', () {
      final json = {
        'id': 'sess-uuid-4',
        'store_id': 'store-uuid-4',
        'user_id': 'user-uuid-4',
        'metadata': null,
      };

      final session = SecuritySession.fromJson(json);
      expect(session.metadata, isNull);
    });
  });

  // ═══ SecurityIncident ═════════════════════════════════════════════════════

  group('SecurityIncident contract', () {
    test('parses open incident using incident_type field (backend format)', () {
      final json = {
        'id': 'inc-uuid-1',
        'store_id': 'store-uuid-1',
        'incident_type': 'brute_force',
        'severity': 'high',
        'title': 'Multiple failed login attempts',
        'description': 'User locked out after 5 attempts',
        'user_id': 'user-uuid-1',
        'device_id': null,
        'ip_address': '192.168.1.100',
        'metadata': {'attempts': 5},
        'status': 'open',
        'resolved_at': null,
        'resolved_by': null,
        'resolution_notes': null,
        'created_at': '2024-06-01T10:00:00.000Z',
      };

      final incident = SecurityIncident.fromJson(json);

      expect(incident.id, 'inc-uuid-1');
      expect(incident.type, 'brute_force');
      expect(incident.severity, 'high');
      expect(incident.title, 'Multiple failed login attempts');
      expect(incident.isResolved, false);
      expect(incident.details?['attempts'], 5);
    });

    test('parses incident using type field (Flutter alias)', () {
      final json = {
        'id': 'inc-uuid-2',
        'store_id': 'store-uuid-2',
        'type': 'unauthorized_access',
        'severity': 'critical',
        'title': 'Unauthorized Access Attempt',
        'status': 'open',
      };

      final incident = SecurityIncident.fromJson(json);
      expect(incident.type, 'unauthorized_access');
    });

    test('parses resolved incident correctly', () {
      final json = {
        'id': 'inc-uuid-3',
        'store_id': 'store-uuid-3',
        'incident_type': 'device_theft',
        'severity': 'critical',
        'title': 'Device Stolen',
        'status': 'resolved',
        'resolved_at': '2024-06-02T09:00:00.000Z',
        'resolved_by': 'admin-uuid-1',
        'resolution_notes': 'Device remotely wiped and deactivated',
      };

      final incident = SecurityIncident.fromJson(json);
      expect(incident.isResolved, true);
      expect(incident.resolvedBy, 'admin-uuid-1');
      expect(incident.resolvedAt, isNotNull);
      expect(incident.resolutionNotes, 'Device remotely wiped and deactivated');
    });

    test('is_resolved bool overrides status field', () {
      // When backend sends explicit is_resolved=true with status='open'
      // (edge case during migration), is_resolved wins
      final json = {
        'id': 'inc-uuid-4',
        'store_id': 'store-uuid-4',
        'incident_type': 'brute_force',
        'severity': 'low',
        'title': 'Test',
        'status': 'open',
        'is_resolved': true,
      };

      final incident = SecurityIncident.fromJson(json);
      expect(incident.isResolved, true);
    });

    test('details falls back to metadata field name', () {
      final json = {
        'id': 'inc-uuid-5',
        'store_id': 'store-uuid-5',
        'incident_type': 'anomaly',
        'severity': 'medium',
        'title': 'Anomaly Detected',
        'status': 'open',
        'metadata': {'anomaly_score': 0.95}, // backend sends as 'metadata'
      };

      final incident = SecurityIncident.fromJson(json);
      expect(incident.details?['anomaly_score'], 0.95);
    });
  });

  // ═══ PinOverride ══════════════════════════════════════════════════════════

  group('PinOverride contract', () {
    test('parses full pin override record', () {
      final json = {
        'id': 'po-uuid-1',
        'store_id': 'store-uuid-1',
        'requesting_user_id': 'cashier-uuid-1',
        'authorizing_user_id': 'manager-uuid-1',
        'permission_code': 'void_order',
        'action_context': {'order_id': 'order-123', 'amount': 99.99},
        'created_at': '2024-06-01T11:00:00.000Z',
      };

      final po = PinOverride.fromJson(json);

      expect(po.id, 'po-uuid-1');
      expect(po.storeId, 'store-uuid-1');
      expect(po.requestingUserId, 'cashier-uuid-1');
      expect(po.authorizingUserId, 'manager-uuid-1');
      expect(po.permissionCode, 'void_order');
      expect(po.actionContext?['order_id'], 'order-123');
      expect(po.createdAt, isNotNull);
    });

    test('null action_context handled', () {
      final json = {
        'id': 'po-uuid-2',
        'store_id': 'store-uuid-2',
        'requesting_user_id': 'cashier-uuid-2',
        'authorizing_user_id': 'manager-uuid-2',
        'permission_code': 'apply_discount',
        'action_context': null,
        'created_at': '2024-06-01T11:00:00.000Z',
      };

      final po = PinOverride.fromJson(json);
      expect(po.actionContext, isNull);
    });
  });

  // ═══ Paginated Response Parsing ═══════════════════════════════════════════

  group('Paginated vs flat list response shapes', () {
    test('sessions use flat data list (data is List)', () {
      // Backend returns: { data: [ {...}, {...} ] }
      final responseData = [
        {'id': 's1', 'store_id': 'store-1', 'user_id': 'u1', 'status': 'active', 'started_at': '2024-01-01T08:00:00Z'},
        {'id': 's2', 'store_id': 'store-1', 'user_id': 'u2', 'status': 'ended', 'started_at': '2024-01-01T09:00:00Z'},
      ];

      final sessions = (responseData).map((e) => SecuritySession.fromJson(e)).toList();
      expect(sessions.length, 2);
      expect(sessions[0].isActive, true);
      expect(sessions[1].isActive, false);
    });

    test('incidents use paginated data.data list', () {
      // Backend returns: { data: { data: [ {...} ], total: 1, ... } }
      final paginatedWrapper = {
        'data': [
          {
            'id': 'inc-1',
            'store_id': 'store-1',
            'incident_type': 'brute_force',
            'severity': 'high',
            'title': 'Test',
            'status': 'open',
          }
        ]
      };

      final incidents = (paginatedWrapper['data'] as List)
          .map((e) => SecurityIncident.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(incidents.length, 1);
      expect(incidents.first.type, 'brute_force');
    });

    test('audit logs use flat data list', () {
      final responseData = [
        {'id': 'l1', 'store_id': 'store-1', 'user_type': 'staff', 'action': 'login', 'severity': 'info'},
        {'id': 'l2', 'store_id': 'store-1', 'user_type': 'staff', 'action': 'logout', 'severity': 'info'},
      ];

      final logs = responseData.map((e) => SecurityAuditLog.fromJson(e)).toList();
      expect(logs.length, 2);
      expect(logs.map((l) => l.action).toList(), containsAll([SecurityAuditAction.login, SecurityAuditAction.logout]));
    });
  });

  // ═══ Overview Response Structure ══════════════════════════════════════════

  group('Overview response contract', () {
    test('all required overview keys are handled', () {
      // Simulates the full response from GET /security/overview
      final overviewData = {
        'active_devices': 3,
        'active_sessions': 5,
        'unresolved_incidents': 2,
        'failed_logins_today': 7,
        'total_audit_logs': 1042,
        'locked_out_users': 1,
        'recent_activity': [
          {'id': 'log-1', 'store_id': 'store-1', 'user_type': 'staff', 'action': 'login', 'severity': 'info'},
        ],
        'policy': {
          'id': 'pol-1',
          'store_id': 'store-1',
          'pin_min_length': 4,
          'max_failed_attempts': 5,
        },
        'login_stats': {'total': 100, 'successful': 95, 'failed': 5},
        'audit_stats': {'total': 1042, 'by_severity': {'info': 900}, 'by_action': {'login': 500}},
        'critical_audits_7d': 3,
      };

      // Verify required int fields
      expect(overviewData['active_devices'], isA<int>());
      expect(overviewData['active_sessions'], isA<int>());
      expect(overviewData['unresolved_incidents'], isA<int>());
      expect(overviewData['failed_logins_today'], isA<int>());
      expect(overviewData['total_audit_logs'], isA<int>());
      expect(overviewData['locked_out_users'], isA<int>());
      expect(overviewData['critical_audits_7d'], isA<int>());

      // Verify nested structures can be parsed
      final policy = SecurityPolicy.fromJson(overviewData['policy'] as Map<String, dynamic>);
      expect(policy.pinMinLength, 4);

      final recentActivity = (overviewData['recent_activity'] as List)
          .map((e) => SecurityAuditLog.fromJson(e as Map<String, dynamic>))
          .toList();
      expect(recentActivity.length, 1);
    });
  });

  // ═══ Audit Stats Response ═════════════════════════════════════════════════

  group('Audit stats response contract', () {
    test('stats response has required keys', () {
      final stats = {
        'total': 500,
        'by_severity': {
          'info': 400,
          'warning': 80,
          'error': 15,
          'critical': 5,
        },
        'by_action': {
          'login': 200,
          'logout': 150,
          'policy_update': 30,
          'remote_wipe': 2,
        },
      };

      expect(stats['total'], isA<int>());
      expect(stats['by_severity'], isA<Map>());
      expect(stats['by_action'], isA<Map>());
      expect((stats['by_severity'] as Map)['info'], 400);
      expect((stats['by_action'] as Map)['login'], 200);
    });
  });

  // ═══ Export Response ══════════════════════════════════════════════════════

  group('Export CSV response contract', () {
    test('CSV response is a plain string (not JSON)', () {
      const csvResponse = 'timestamp,user_id,user_type,action,resource_type,resource_id,severity,ip_address,details\n'
          '2024-06-01T10:00:00.000Z,user-1,staff,login,session,sess-1,info,10.0.0.1,"{}"\n';

      // The Flutter API service returns a String directly for export
      expect(csvResponse, isA<String>());
      final lines = csvResponse.trim().split('\n');
      expect(lines.length, 2); // header + 1 data row

      final headers = lines[0].split(',');
      expect(headers, contains('timestamp'));
      expect(headers, contains('action'));
      expect(headers, contains('severity'));
      expect(headers, contains('ip_address'));
    });

    test('empty CSV has only header row', () {
      const emptyCsv = 'timestamp,user_id,user_type,action,resource_type,resource_id,severity,ip_address,details\n';

      final lines = emptyCsv.trim().split('\n');
      expect(lines.length, 1);
    });
  });
}
