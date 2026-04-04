import 'package:thawani_pos/features/settings/enums/audit_resource_type.dart';
import 'package:thawani_pos/features/settings/enums/audit_severity.dart';
import 'package:thawani_pos/features/settings/enums/audit_user_type.dart';
import 'package:thawani_pos/features/security/enums/security_audit_action.dart';

class SecurityAuditLog {
  final String id;
  final String storeId;
  final String? userId;
  final AuditUserType? userType;
  final SecurityAuditAction action;
  final AuditResourceType? resourceType;
  final String? resourceId;
  final Map<String, dynamic>? details;
  final AuditSeverity? severity;
  final String? ipAddress;
  final String? deviceId;
  final DateTime? createdAt;
  final String? requestMethod;
  final String? requestUrl;
  final int? responseCode;
  final int? durationMs;
  final String? userAgent;

  const SecurityAuditLog({
    required this.id,
    required this.storeId,
    this.userId,
    this.userType,
    required this.action,
    this.resourceType,
    this.resourceId,
    this.details,
    this.severity,
    this.ipAddress,
    this.deviceId,
    this.createdAt,
    this.requestMethod,
    this.requestUrl,
    this.responseCode,
    this.durationMs,
    this.userAgent,
  });

  factory SecurityAuditLog.fromJson(Map<String, dynamic> json) {
    return SecurityAuditLog(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String?,
      userType: AuditUserType.tryFromValue(json['user_type'] as String?),
      action: SecurityAuditAction.fromValue(json['action'] as String),
      resourceType: AuditResourceType.tryFromValue(json['resource_type'] as String?),
      resourceId: json['resource_id'] as String?,
      details: json['details'] != null ? Map<String, dynamic>.from(json['details'] as Map) : null,
      severity: AuditSeverity.tryFromValue(json['severity'] as String?),
      ipAddress: json['ip_address'] as String?,
      deviceId: json['device_id'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      requestMethod: json['request_method'] as String?,
      requestUrl: json['request_url'] as String?,
      responseCode: (json['response_code'] as num?)?.toInt(),
      durationMs: (json['duration_ms'] as num?)?.toInt(),
      userAgent: json['user_agent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_id': userId,
      'user_type': userType?.value,
      'action': action.value,
      'resource_type': resourceType?.value,
      'resource_id': resourceId,
      'details': details,
      'severity': severity?.value,
      'ip_address': ipAddress,
      'device_id': deviceId,
      'created_at': createdAt?.toIso8601String(),
      'request_method': requestMethod,
      'request_url': requestUrl,
      'response_code': responseCode,
      'duration_ms': durationMs,
      'user_agent': userAgent,
    };
  }

  SecurityAuditLog copyWith({
    String? id,
    String? storeId,
    String? userId,
    AuditUserType? userType,
    SecurityAuditAction? action,
    AuditResourceType? resourceType,
    String? resourceId,
    Map<String, dynamic>? details,
    AuditSeverity? severity,
    String? ipAddress,
    String? deviceId,
    DateTime? createdAt,
    String? requestMethod,
    String? requestUrl,
    int? responseCode,
    int? durationMs,
    String? userAgent,
  }) {
    return SecurityAuditLog(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      action: action ?? this.action,
      resourceType: resourceType ?? this.resourceType,
      resourceId: resourceId ?? this.resourceId,
      details: details ?? this.details,
      severity: severity ?? this.severity,
      ipAddress: ipAddress ?? this.ipAddress,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      requestMethod: requestMethod ?? this.requestMethod,
      requestUrl: requestUrl ?? this.requestUrl,
      responseCode: responseCode ?? this.responseCode,
      durationMs: durationMs ?? this.durationMs,
      userAgent: userAgent ?? this.userAgent,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SecurityAuditLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SecurityAuditLog(id: $id, storeId: $storeId, userId: $userId, userType: $userType, action: $action, resourceType: $resourceType, ...)';
}
