import 'package:wameedpos/features/security/enums/role_audit_action.dart';

class RoleAuditLog {
  final String id;
  final String storeId;
  final String userId;
  final RoleAuditAction action;
  final int? roleId;
  final Map<String, dynamic>? details;
  final DateTime? createdAt;

  const RoleAuditLog({
    required this.id,
    required this.storeId,
    required this.userId,
    required this.action,
    this.roleId,
    this.details,
    this.createdAt,
  });

  factory RoleAuditLog.fromJson(Map<String, dynamic> json) {
    return RoleAuditLog(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String,
      action: RoleAuditAction.fromValue(json['action'] as String),
      roleId: (json['role_id'] as num?)?.toInt(),
      details: json['details'] != null ? Map<String, dynamic>.from(json['details'] as Map) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_id': userId,
      'action': action.value,
      'role_id': roleId,
      'details': details,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  RoleAuditLog copyWith({
    String? id,
    String? storeId,
    String? userId,
    RoleAuditAction? action,
    int? roleId,
    Map<String, dynamic>? details,
    DateTime? createdAt,
  }) {
    return RoleAuditLog(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      roleId: roleId ?? this.roleId,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is RoleAuditLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'RoleAuditLog(id: $id, storeId: $storeId, userId: $userId, action: $action, roleId: $roleId, details: $details, ...)';
}
