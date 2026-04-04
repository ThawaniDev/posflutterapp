import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/security/models/device_registration.dart';
import 'package:thawani_pos/features/security/models/login_attempt.dart';
import 'package:thawani_pos/features/security/models/security_audit_log.dart';
import 'package:thawani_pos/features/security/models/security_incident.dart';
import 'package:thawani_pos/features/security/models/security_policy.dart';
import 'package:thawani_pos/features/security/models/security_session.dart';
import 'package:thawani_pos/features/security/providers/security_state.dart';
import 'package:thawani_pos/features/security/repositories/security_repository.dart';

// ─── Security Overview Provider ─────────────────────────────

final securityOverviewProvider = StateNotifierProvider<SecurityOverviewNotifier, SecurityOverviewState>(
  (ref) => SecurityOverviewNotifier(ref.watch(securityRepositoryProvider)),
);

class SecurityOverviewNotifier extends StateNotifier<SecurityOverviewState> {
  final SecurityRepository _repo;

  SecurityOverviewNotifier(this._repo) : super(const SecurityOverviewInitial());

  Future<void> load(String storeId) async {
    state = const SecurityOverviewLoading();
    try {
      final res = await _repo.getOverview(storeId: storeId);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      state = SecurityOverviewLoaded(data);
    } catch (e) {
      state = SecurityOverviewError(e.toString());
    }
  }
}

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

// ─── Sessions Provider ─────────────────────────────────────

final sessionListProvider = StateNotifierProvider<SessionListNotifier, SessionListState>(
  (ref) => SessionListNotifier(ref.watch(securityRepositoryProvider)),
);

class SessionListNotifier extends StateNotifier<SessionListState> {
  final SecurityRepository _repo;

  SessionListNotifier(this._repo) : super(const SessionListInitial());

  Future<void> loadSessions(String storeId, {String? status}) async {
    state = const SessionListLoading();
    try {
      final res = await _repo.listSessions(storeId: storeId, status: status);
      final items = (res['data'] as List?)?.map((e) => SecuritySession.fromJson(e as Map<String, dynamic>)).toList() ?? [];
      state = SessionListLoaded(items);
    } catch (e) {
      state = SessionListError(e.toString());
    }
  }
}

// ─── Incidents Provider ────────────────────────────────────

final incidentListProvider = StateNotifierProvider<IncidentListNotifier, IncidentListState>(
  (ref) => IncidentListNotifier(ref.watch(securityRepositoryProvider)),
);

class IncidentListNotifier extends StateNotifier<IncidentListState> {
  final SecurityRepository _repo;

  IncidentListNotifier(this._repo) : super(const IncidentListInitial());

  Future<void> loadIncidents(String storeId, {String? severity, bool? isResolved}) async {
    state = const IncidentListLoading();
    try {
      final res = await _repo.listIncidents(storeId: storeId, severity: severity, isResolved: isResolved);
      final raw = res['data'] as Map<String, dynamic>;
      final items = (raw['data'] as List?)?.map((e) => SecurityIncident.fromJson(e as Map<String, dynamic>)).toList() ?? [];
      state = IncidentListLoaded(items);
    } catch (e) {
      state = IncidentListError(e.toString());
    }
  }
}

// ─── Security Action Provider ──────────────────────────────

final securityActionProvider = StateNotifierProvider<SecurityActionNotifier, SecurityActionState>(
  (ref) => SecurityActionNotifier(ref.watch(securityRepositoryProvider)),
);

class SecurityActionNotifier extends StateNotifier<SecurityActionState> {
  final SecurityRepository _repo;

  SecurityActionNotifier(this._repo) : super(const SecurityActionInitial());

  Future<void> deactivateDevice(String deviceId) async {
    state = const SecurityActionLoading();
    try {
      await _repo.deactivateDevice(deviceId: deviceId);
      state = const SecurityActionSuccess('Device deactivated');
    } catch (e) {
      state = SecurityActionError(e.toString());
    }
  }

  Future<void> requestRemoteWipe(String deviceId) async {
    state = const SecurityActionLoading();
    try {
      await _repo.requestRemoteWipe(deviceId: deviceId);
      state = const SecurityActionSuccess('Remote wipe requested');
    } catch (e) {
      state = SecurityActionError(e.toString());
    }
  }

  Future<void> endSession(String sessionId) async {
    state = const SecurityActionLoading();
    try {
      await _repo.endSession(sessionId: sessionId);
      state = const SecurityActionSuccess('Session ended');
    } catch (e) {
      state = SecurityActionError(e.toString());
    }
  }

  Future<void> endAllSessions(String storeId) async {
    state = const SecurityActionLoading();
    try {
      await _repo.endAllSessions(storeId: storeId);
      state = const SecurityActionSuccess('All sessions ended');
    } catch (e) {
      state = SecurityActionError(e.toString());
    }
  }

  Future<void> resolveIncident(String incidentId, {String? resolutionNotes}) async {
    state = const SecurityActionLoading();
    try {
      await _repo.resolveIncident(incidentId: incidentId, resolutionNotes: resolutionNotes);
      state = const SecurityActionSuccess('Incident resolved');
    } catch (e) {
      state = SecurityActionError(e.toString());
    }
  }

  void reset() => state = const SecurityActionInitial();
}
