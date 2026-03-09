class ThemePackageVisibility {
  final String themeId;
  final String subscriptionPlanId;

  const ThemePackageVisibility({
    required this.themeId,
    required this.subscriptionPlanId,
  });

  factory ThemePackageVisibility.fromJson(Map<String, dynamic> json) {
    return ThemePackageVisibility(
      themeId: json['theme_id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme_id': themeId,
      'subscription_plan_id': subscriptionPlanId,
    };
  }

  ThemePackageVisibility copyWith({
    String? themeId,
    String? subscriptionPlanId,
  }) {
    return ThemePackageVisibility(
      themeId: themeId ?? this.themeId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemePackageVisibility && other.themeId == themeId && other.subscriptionPlanId == subscriptionPlanId;

  @override
  int get hashCode => themeId.hashCode ^ subscriptionPlanId.hashCode;

  @override
  String toString() => 'ThemePackageVisibility(themeId: $themeId, subscriptionPlanId: $subscriptionPlanId)';
}
