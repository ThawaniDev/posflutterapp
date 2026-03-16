import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/security/models/device_registration.dart';
import 'package:thawani_pos/features/security/models/login_attempt.dart';
import 'package:thawani_pos/features/security/models/security_audit_log.dart';
import 'package:thawani_pos/features/security/models/security_policy.dart';
import 'package:thawani_pos/features/security/providers/security_state.dart';
import 'package:thawani_pos/features/security/repositories/security_repository.dart';

// ─── Security Policy Provider ───────────────────────────────

final securityPolicyProvider = StateNotifierProvider<SecurityPolicyNotifier, SecurityPolicyState>(
  (ref) => SecurityPolicyNotifier(ref.watch(securityRepositoryProvider)),
);

class SecurityPolicyNotifier extends StateNotifier<SecurityPolicyState> {
  final SecurityRepository _repo;

  SecurityPolicyNotifier(this._repo) : super(const SecurityPolicyInitial());

  Future<void> loadPolicy(String storeId) async {
    state = const SecurityPolicyLoading();
    try {
      final res = await _repo.getPolicy(storeId: storeId);
      final data = res['data'] as Map<String, dynamic>;
      state = SecurityPolicyLoaded(SecurityPolicy.fromJson(data));
    } catch (e) {
      state = SecurityPolicyError(e.toString());
    }
  }

  Future<void> updatePolicy(String storeId, Map<String, dynamic> data) async {
    state = const SecurityPolicyLoading();
    try {
      final res = await _repo.updatePolicy(storeId: storeId, data: data);
      final d = res['data'] as Map<String, dynamic>;
      state = SecurityPolicyLoaded(SecurityPolicy.fromJson(d));
    } catch (e) {
      state = SecurityPolicyError(e.toString());
    }
  }
}

// ─── Audit Log Provider ────────────────────────────────────

final auditLogListProvider = StateNotifierProvider<AuditLogListNotifier, AuditLogListState>(
  (ref) => AuditLogListNotifier(ref.watch(securityRepositoryProvider)),
);

class AuditLogListNotifier extends StateNotifier<AuditLogListState> {
  final SecurityRepository _repo;

  AuditLogListNotifier(this._repo) : super(const AuditLogListInitial());

  Future<void> loadLogs(String storeId, {String? action, String? severity}) async {
    state = const AuditLogListLoading();
    try {
      final res = await _repo.listAuditLogs(storeId: storeId, action: action, severity: severity);
      final raw = res['data'] as Map<String, dynamic>;
      final list = (raw['data'] as List).map((e) => SecurityAuditLog.fromJson(e as Map<String, dynamic>)).toList();
      state = AuditLogListLoaded(list);
    } catch (e) {
      state = AuditLogListError(e.toString());
    }
  }
}

// ─── Device List Provider ──────────────────────────────────

final deviceListProvider = StateNotifierProvider<DeviceListNotifier, DeviceListState>(
  (ref) => DeviceListNotifier(ref.watch(securityRepositoryProvider)),
);

class DeviceListNotifier extends StateNotifier<DeviceListState> {
  final SecurityRepository _repo;

  DeviceListNotifier(this._repo) : super(const DeviceListInitial());

  Future<void> loadDevices(String storeId, {bool? activeOnly}) async {
    state = const DeviceListLoading();
    try {
      final res = await _repo.listDevices(storeId: storeId, activeOnly: activeOnly);
      final items = (res['data'] as List).map((e) => DeviceRegistration.fromJson(e as Map<String, dynamic>)).toList();
      state = DeviceListLoaded(items);
    } catch (e) {
      state = DeviceListError(e.toString());
    }
  }
}

// ─── Login Attempts Provider ───────────────────────────────

final loginAttemptsProvider = StateNotifierProvider<LoginAttemptsNotifier, LoginAttemptsState>(
  (ref) => LoginAttemptsNotifier(ref.watch(securityRepositoryProvider)),
);

class LoginAttemptsNotifier extends StateNotifier<LoginAttemptsState> {
  final SecurityRepository _repo;

  LoginAttemptsNotifier(this._repo) : super(const LoginAttemptsInitial());

  Future<void> loadAttempts(String storeId, {String? attemptType}) async {
    state = const LoginAttemptsLoading();
    try {
      final res = await _repo.listLoginAttempts(storeId: storeId, attemptType: attemptType);
      final raw = res['data'] as Map<String, dynamic>;
      final list = (raw['data'] as List).map((e) => LoginAttempt.fromJson(e as Map<String, dynamic>)).toList();
      state = LoginAttemptsLoaded(list);
    } catch (e) {
      state = LoginAttemptsError(e.toString());
    }
  }
}
