import 'package:thawani_pos/features/security/models/device_registration.dart';
import 'package:thawani_pos/features/security/models/login_attempt.dart';
import 'package:thawani_pos/features/security/models/security_audit_log.dart';
import 'package:thawani_pos/features/security/models/security_incident.dart';
import 'package:thawani_pos/features/security/models/security_policy.dart';
import 'package:thawani_pos/features/security/models/security_session.dart';

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
  final SecurityPolicy policy;
  const SecurityPolicyLoaded(this.policy);
}

final class SecurityPolicyError extends SecurityPolicyState {
  final String message;
  const SecurityPolicyError(this.message);
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
  final List<SecurityAuditLog> logs;
  const AuditLogListLoaded(this.logs);
}

final class AuditLogListError extends AuditLogListState {
  final String message;
  const AuditLogListError(this.message);
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
  final List<DeviceRegistration> devices;
  const DeviceListLoaded(this.devices);
}

final class DeviceListError extends DeviceListState {
  final String message;
  const DeviceListError(this.message);
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
  final List<LoginAttempt> attempts;
  const LoginAttemptsLoaded(this.attempts);
}

final class LoginAttemptsError extends LoginAttemptsState {
  final String message;
  const LoginAttemptsError(this.message);
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
  final Map<String, dynamic> overview;
  const SecurityOverviewLoaded(this.overview);
}

final class SecurityOverviewError extends SecurityOverviewState {
  final String message;
  const SecurityOverviewError(this.message);
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
  final List<SecuritySession> sessions;
  const SessionListLoaded(this.sessions);
}

final class SessionListError extends SessionListState {
  final String message;
  const SessionListError(this.message);
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
  final List<SecurityIncident> incidents;
  const IncidentListLoaded(this.incidents);
}

final class IncidentListError extends IncidentListState {
  final String message;
  const IncidentListError(this.message);
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
  final String message;
  const SecurityActionSuccess(this.message);
}

final class SecurityActionError extends SecurityActionState {
  final String message;
  const SecurityActionError(this.message);
}
