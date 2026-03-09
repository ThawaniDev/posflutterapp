class AdminUserRole {
  final String adminUserId;
  final String adminRoleId;
  final DateTime? assignedAt;
  final String? assignedBy;

  const AdminUserRole({
    required this.adminUserId,
    required this.adminRoleId,
    this.assignedAt,
    this.assignedBy,
  });

  factory AdminUserRole.fromJson(Map<String, dynamic> json) {
    return AdminUserRole(
      adminUserId: json['admin_user_id'] as String,
      adminRoleId: json['admin_role_id'] as String,
      assignedAt: json['assigned_at'] != null ? DateTime.parse(json['assigned_at'] as String) : null,
      assignedBy: json['assigned_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_user_id': adminUserId,
      'admin_role_id': adminRoleId,
      'assigned_at': assignedAt?.toIso8601String(),
      'assigned_by': assignedBy,
    };
  }

  AdminUserRole copyWith({
    String? adminUserId,
    String? adminRoleId,
    DateTime? assignedAt,
    String? assignedBy,
  }) {
    return AdminUserRole(
      adminUserId: adminUserId ?? this.adminUserId,
      adminRoleId: adminRoleId ?? this.adminRoleId,
      assignedAt: assignedAt ?? this.assignedAt,
      assignedBy: assignedBy ?? this.assignedBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminUserRole && other.adminUserId == adminUserId && other.adminRoleId == adminRoleId && other.assignedAt == assignedAt && other.assignedBy == assignedBy;

  @override
  int get hashCode => adminUserId.hashCode ^ adminRoleId.hashCode ^ assignedAt.hashCode ^ assignedBy.hashCode;

  @override
  String toString() => 'AdminUserRole(adminUserId: $adminUserId, adminRoleId: $adminRoleId, assignedAt: $assignedAt, assignedBy: $assignedBy)';
}
