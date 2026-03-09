class LabelTemplatePackageVisibility {
  final String labelLayoutTemplateId;
  final String subscriptionPlanId;

  const LabelTemplatePackageVisibility({
    required this.labelLayoutTemplateId,
    required this.subscriptionPlanId,
  });

  factory LabelTemplatePackageVisibility.fromJson(Map<String, dynamic> json) {
    return LabelTemplatePackageVisibility(
      labelLayoutTemplateId: json['label_layout_template_id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label_layout_template_id': labelLayoutTemplateId,
      'subscription_plan_id': subscriptionPlanId,
    };
  }

  LabelTemplatePackageVisibility copyWith({
    String? labelLayoutTemplateId,
    String? subscriptionPlanId,
  }) {
    return LabelTemplatePackageVisibility(
      labelLayoutTemplateId: labelLayoutTemplateId ?? this.labelLayoutTemplateId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelTemplatePackageVisibility && other.labelLayoutTemplateId == labelLayoutTemplateId && other.subscriptionPlanId == subscriptionPlanId;

  @override
  int get hashCode => labelLayoutTemplateId.hashCode ^ subscriptionPlanId.hashCode;

  @override
  String toString() => 'LabelTemplatePackageVisibility(labelLayoutTemplateId: $labelLayoutTemplateId, subscriptionPlanId: $subscriptionPlanId)';
}
