class LayoutPackageVisibility {

  const LayoutPackageVisibility({
    required this.posLayoutTemplateId,
    required this.subscriptionPlanId,
  });

  factory LayoutPackageVisibility.fromJson(Map<String, dynamic> json) {
    return LayoutPackageVisibility(
      posLayoutTemplateId: json['pos_layout_template_id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
    );
  }
  final String posLayoutTemplateId;
  final String subscriptionPlanId;

  Map<String, dynamic> toJson() {
    return {
      'pos_layout_template_id': posLayoutTemplateId,
      'subscription_plan_id': subscriptionPlanId,
    };
  }

  LayoutPackageVisibility copyWith({
    String? posLayoutTemplateId,
    String? subscriptionPlanId,
  }) {
    return LayoutPackageVisibility(
      posLayoutTemplateId: posLayoutTemplateId ?? this.posLayoutTemplateId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutPackageVisibility && other.posLayoutTemplateId == posLayoutTemplateId && other.subscriptionPlanId == subscriptionPlanId;

  @override
  int get hashCode => posLayoutTemplateId.hashCode ^ subscriptionPlanId.hashCode;

  @override
  String toString() => 'LayoutPackageVisibility(posLayoutTemplateId: $posLayoutTemplateId, subscriptionPlanId: $subscriptionPlanId)';
}
