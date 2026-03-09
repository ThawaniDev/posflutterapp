import 'package:thawani_pos/core/enums/alert_severity.dart';
import 'package:thawani_pos/features/security/enums/security_alert_status.dart';
import 'package:thawani_pos/features/settings/enums/security_alert_type.dart';

class SecurityAlert {
  final String id;
  final String? adminUserId;
  final SecurityAlertType alertType;
  final AlertSeverity severity;
  final Map<String, dynamic>? details;
  final SecurityAlertStatus status;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolutionNotes;
  final DateTime? createdAt;

  const SecurityAlert({
    required this.id,
    this.adminUserId,
    required this.alertType,
    required this.severity,
    this.details,
    required this.status,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
    this.createdAt,
  });

  factory SecurityAlert.fromJson(Map<String, dynamic> json) {
    return SecurityAlert(
      id: json['id'] as String,
      adminUserId: json['admin_user_id'] as String?,
      alertType: SecurityAlertType.fromValue(json['alert_type'] as String),
      severity: AlertSeverity.fromValue(json['severity'] as String),
      details: json['details'] != null ? Map<String, dynamic>.from(json['details'] as Map) : null,
      status: SecurityAlertStatus.fromValue(json['status'] as String),
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at'] as String) : null,
      resolvedBy: json['resolved_by'] as String?,
      resolutionNotes: json['resolution_notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_user_id': adminUserId,
      'alert_type': alertType.value,
      'severity': severity.value,
      'details': details,
      'status': status.value,
      'resolved_at': resolvedAt?.toIso8601String(),
      'resolved_by': resolvedBy,
      'resolution_notes': resolutionNotes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  SecurityAlert copyWith({
    String? id,
    String? adminUserId,
    SecurityAlertType? alertType,
    AlertSeverity? severity,
    Map<String, dynamic>? details,
    SecurityAlertStatus? status,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
    DateTime? createdAt,
  }) {
    return SecurityAlert(
      id: id ?? this.id,
      adminUserId: adminUserId ?? this.adminUserId,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      details: details ?? this.details,
      status: status ?? this.status,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecurityAlert && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SecurityAlert(id: $id, adminUserId: $adminUserId, alertType: $alertType, severity: $severity, details: $details, status: $status, ...)';
}
