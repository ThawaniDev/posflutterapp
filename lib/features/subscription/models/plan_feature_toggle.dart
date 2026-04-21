class PlanFeatureToggle {

  const PlanFeatureToggle({
    required this.id,
    required this.subscriptionPlanId,
    required this.featureKey,
    this.isEnabled,
  });

  factory PlanFeatureToggle.fromJson(Map<String, dynamic> json) {
    return PlanFeatureToggle(
      id: json['id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
      featureKey: json['feature_key'] as String,
      isEnabled: json['is_enabled'] as bool?,
    );
  }
  final String id;
  final String subscriptionPlanId;
  final String featureKey;
  final bool? isEnabled;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_plan_id': subscriptionPlanId,
      'feature_key': featureKey,
      'is_enabled': isEnabled,
    };
  }

  PlanFeatureToggle copyWith({
    String? id,
    String? subscriptionPlanId,
    String? featureKey,
    bool? isEnabled,
  }) {
    return PlanFeatureToggle(
      id: id ?? this.id,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      featureKey: featureKey ?? this.featureKey,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanFeatureToggle && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlanFeatureToggle(id: $id, subscriptionPlanId: $subscriptionPlanId, featureKey: $featureKey, isEnabled: $isEnabled)';
}
