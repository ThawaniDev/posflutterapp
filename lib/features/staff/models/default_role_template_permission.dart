class DefaultRoleTemplatePermission {
  final String id;
  final String defaultRoleTemplateId;
  final String providerPermissionId;

  const DefaultRoleTemplatePermission({
    required this.id,
    required this.defaultRoleTemplateId,
    required this.providerPermissionId,
  });

  factory DefaultRoleTemplatePermission.fromJson(Map<String, dynamic> json) {
    return DefaultRoleTemplatePermission(
      id: json['id'] as String,
      defaultRoleTemplateId: json['default_role_template_id'] as String,
      providerPermissionId: json['provider_permission_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'default_role_template_id': defaultRoleTemplateId,
      'provider_permission_id': providerPermissionId,
    };
  }

  DefaultRoleTemplatePermission copyWith({
    String? id,
    String? defaultRoleTemplateId,
    String? providerPermissionId,
  }) {
    return DefaultRoleTemplatePermission(
      id: id ?? this.id,
      defaultRoleTemplateId: defaultRoleTemplateId ?? this.defaultRoleTemplateId,
      providerPermissionId: providerPermissionId ?? this.providerPermissionId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultRoleTemplatePermission && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DefaultRoleTemplatePermission(id: $id, defaultRoleTemplateId: $defaultRoleTemplateId, providerPermissionId: $providerPermissionId)';
}
