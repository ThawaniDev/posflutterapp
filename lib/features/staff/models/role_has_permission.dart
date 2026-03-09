class RoleHasPermission {
  final int permissionId;
  final int roleId;

  const RoleHasPermission({
    required this.permissionId,
    required this.roleId,
  });

  factory RoleHasPermission.fromJson(Map<String, dynamic> json) {
    return RoleHasPermission(
      permissionId: (json['permission_id'] as num).toInt(),
      roleId: (json['role_id'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permission_id': permissionId,
      'role_id': roleId,
    };
  }

  RoleHasPermission copyWith({
    int? permissionId,
    int? roleId,
  }) {
    return RoleHasPermission(
      permissionId: permissionId ?? this.permissionId,
      roleId: roleId ?? this.roleId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleHasPermission && other.permissionId == permissionId && other.roleId == roleId;

  @override
  int get hashCode => permissionId.hashCode ^ roleId.hashCode;

  @override
  String toString() => 'RoleHasPermission(permissionId: $permissionId, roleId: $roleId)';
}
