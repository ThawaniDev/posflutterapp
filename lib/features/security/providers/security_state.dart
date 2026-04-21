import 'package:wameedpos/features/security/models/device_registration.dart';
import 'package:wameedpos/features/security/models/login_attempt.dart';
import 'package:wameedpos/features/security/models/security_audit_log.dart';
import 'package:wameedpos/features/security/models/security_incident.dart';
import 'package:wameedpos/features/security/models/security_policy.dart';
import 'package:wameedpos/features/security/models/security_session.dart';

// ─── SecurityPolicy State ───────────────────────────────────

sealed class SecurityPolicyState {
  const SecurityPolicyState();
}

final class SecurityPolicyInitial extends SecurityPolicyState {
  const SecurityPolicyInitial();
}

final class SecurityPolicyLoading extends SecurityPolicyState {
  const SecurityPolicyLoading();
}

final class SecurityPolicyLoaded extends SecurityPolicyState {
  const SecurityPolicyLoaded(this.policy);
  final SecurityPolicy policy;
}

final class SecurityPolicyError extends SecurityPolicyState {
  const SecurityPolicyError(this.message);
  final String message;
}

// ─── AuditLog List State ────────────────────────────────────

sealed class AuditLogListState {
  const AuditLogListState();
}

final class AuditLogListInitial extends AuditLogListState {
  const AuditLogListInitial();
}

final class AuditLogListLoading extends AuditLogListState {
  const AuditLogListLoading();
}

final class AuditLogListLoaded extends AuditLogListState {
  const AuditLogListLoaded(this.logs);
  final List<SecurityAuditLog> logs;
}

final class AuditLogListError extends AuditLogListState {
  const AuditLogListError(this.message);
  final String message;
}

// ─── Device List State ──────────────────────────────────────

sealed class DeviceListState {
  const DeviceListState();
}

final class DeviceListInitial extends DeviceListState {
  const DeviceListInitial();
}

final class DeviceListLoading extends DeviceListState {
  const DeviceListLoading();
}

final class DeviceListLoaded extends DeviceListState {
  const DeviceListLoaded(this.devices);
  final List<DeviceRegistration> devices;
}

final class DeviceListError extends DeviceListState {
  const DeviceListError(this.message);
  final String message;
}

// ─── Login Attempts State ───────────────────────────────────

sealed class LoginAttemptsState {
  const LoginAttemptsState();
}

final class LoginAttemptsInitial extends LoginAttemptsState {
  const LoginAttemptsInitial();
}

final class LoginAttemptsLoading extends LoginAttemptsState {
  const LoginAttemptsLoading();
}

final class LoginAttemptsLoaded extends LoginAttemptsState {
  const LoginAttemptsLoaded(this.attempts);
  final List<LoginAttempt> attempts;
}

final class LoginAttemptsError extends LoginAttemptsState {
  const LoginAttemptsError(this.message);
  final String message;
}

// ─── Security Overview State ────────────────────────────────

sealed class SecurityOverviewState {
  const SecurityOverviewState();
}

final class SecurityOverviewInitial extends SecurityOverviewState {
  const SecurityOverviewInitial();
}

final class SecurityOverviewLoading extends SecurityOverviewState {
  const SecurityOverviewLoading();
}

final class SecurityOverviewLoaded extends SecurityOverviewState {
  const SecurityOverviewLoaded(this.overview);
  final Map<String, dynamic> overview;
}

final class SecurityOverviewError extends SecurityOverviewState {
  const SecurityOverviewError(this.message);
  final String message;
}

// ─── Sessions State ─────────────────────────────────────────

sealed class SessionListState {
  const SessionListState();
}

final class SessionListInitial extends SessionListState {
  const SessionListInitial();
}

final class SessionListLoading extends SessionListState {
  const SessionListLoading();
}

final class SessionListLoaded extends SessionListState {
  const SessionListLoaded(this.sessions);
  final List<SecuritySession> sessions;
}

final class SessionListError extends SessionListState {
  const SessionListError(this.message);
  final String message;
}

// ─── Incidents State ────────────────────────────────────────

sealed class IncidentListState {
  const IncidentListState();
}

final class IncidentListInitial extends IncidentListState {
  const IncidentListInitial();
}

final class IncidentListLoading extends IncidentListState {
  const IncidentListLoading();
}

final class IncidentListLoaded extends IncidentListState {
  const IncidentListLoaded(this.incidents);
  final List<SecurityIncident> incidents;
}

final class IncidentListError extends IncidentListState {
  const IncidentListError(this.message);
  final String message;
}

// ─── Security Action State ──────────────────────────────────

sealed class SecurityActionState {
  const SecurityActionState();
}

final class SecurityActionInitial extends SecurityActionState {
  const SecurityActionInitial();
}

final class SecurityActionLoading extends SecurityActionState {
  const SecurityActionLoading();
}

final class SecurityActionSuccess extends SecurityActionState {
  const SecurityActionSuccess(this.message);
  final String message;
}

final class SecurityActionError extends SecurityActionState {
  const SecurityActionError(this.message);
  final String message;
}
