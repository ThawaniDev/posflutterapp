class CfdThemePackageVisibility {

  const CfdThemePackageVisibility({
    required this.cfdThemeId,
    required this.subscriptionPlanId,
  });

  factory CfdThemePackageVisibility.fromJson(Map<String, dynamic> json) {
    return CfdThemePackageVisibility(
      cfdThemeId: json['cfd_theme_id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
    );
  }
  final String cfdThemeId;
  final String subscriptionPlanId;

  Map<String, dynamic> toJson() {
    return {
      'cfd_theme_id': cfdThemeId,
      'subscription_plan_id': subscriptionPlanId,
    };
  }

  CfdThemePackageVisibility copyWith({
    String? cfdThemeId,
    String? subscriptionPlanId,
  }) {
    return CfdThemePackageVisibility(
      cfdThemeId: cfdThemeId ?? this.cfdThemeId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CfdThemePackageVisibility && other.cfdThemeId == cfdThemeId && other.subscriptionPlanId == subscriptionPlanId;

  @override
  int get hashCode => cfdThemeId.hashCode ^ subscriptionPlanId.hashCode;

  @override
  String toString() => 'CfdThemePackageVisibility(cfdThemeId: $cfdThemeId, subscriptionPlanId: $subscriptionPlanId)';
}
