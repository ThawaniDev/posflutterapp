class CustomRolePackageConfig {

  const CustomRolePackageConfig({
    required this.id,
    required this.subscriptionPlanId,
    this.isCustomRolesEnabled,
    required this.maxCustomRoles,
  });

  factory CustomRolePackageConfig.fromJson(Map<String, dynamic> json) {
    return CustomRolePackageConfig(
      id: json['id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
      isCustomRolesEnabled: json['is_custom_roles_enabled'] as bool?,
      maxCustomRoles: (json['max_custom_roles'] as num).toInt(),
    );
  }
  final String id;
  final String subscriptionPlanId;
  final bool? isCustomRolesEnabled;
  final int maxCustomRoles;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_plan_id': subscriptionPlanId,
      'is_custom_roles_enabled': isCustomRolesEnabled,
      'max_custom_roles': maxCustomRoles,
    };
  }

  CustomRolePackageConfig copyWith({
    String? id,
    String? subscriptionPlanId,
    bool? isCustomRolesEnabled,
    int? maxCustomRoles,
  }) {
    return CustomRolePackageConfig(
      id: id ?? this.id,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      isCustomRolesEnabled: isCustomRolesEnabled ?? this.isCustomRolesEnabled,
      maxCustomRoles: maxCustomRoles ?? this.maxCustomRoles,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomRolePackageConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CustomRolePackageConfig(id: $id, subscriptionPlanId: $subscriptionPlanId, isCustomRolesEnabled: $isCustomRolesEnabled, maxCustomRoles: $maxCustomRoles)';
}
