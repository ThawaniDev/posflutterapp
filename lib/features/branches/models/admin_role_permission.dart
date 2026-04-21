class AdminRolePermission {

  const AdminRolePermission({
    required this.adminRoleId,
    required this.adminPermissionId,
  });

  factory AdminRolePermission.fromJson(Map<String, dynamic> json) {
    return AdminRolePermission(
      adminRoleId: json['admin_role_id'] as String,
      adminPermissionId: json['admin_permission_id'] as String,
    );
  }
  final String adminRoleId;
  final String adminPermissionId;

  Map<String, dynamic> toJson() {
    return {
      'admin_role_id': adminRoleId,
      'admin_permission_id': adminPermissionId,
    };
  }

  AdminRolePermission copyWith({
    String? adminRoleId,
    String? adminPermissionId,
  }) {
    return AdminRolePermission(
      adminRoleId: adminRoleId ?? this.adminRoleId,
      adminPermissionId: adminPermissionId ?? this.adminPermissionId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminRolePermission && other.adminRoleId == adminRoleId && other.adminPermissionId == adminPermissionId;

  @override
  int get hashCode => adminRoleId.hashCode ^ adminPermissionId.hashCode;

  @override
  String toString() => 'AdminRolePermission(adminRoleId: $adminRoleId, adminPermissionId: $adminPermissionId)';
}
