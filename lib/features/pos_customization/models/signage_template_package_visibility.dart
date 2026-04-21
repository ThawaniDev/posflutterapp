class SignageTemplatePackageVisibility {

  const SignageTemplatePackageVisibility({
    required this.signageTemplateId,
    required this.subscriptionPlanId,
  });

  factory SignageTemplatePackageVisibility.fromJson(Map<String, dynamic> json) {
    return SignageTemplatePackageVisibility(
      signageTemplateId: json['signage_template_id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
    );
  }
  final String signageTemplateId;
  final String subscriptionPlanId;

  Map<String, dynamic> toJson() {
    return {
      'signage_template_id': signageTemplateId,
      'subscription_plan_id': subscriptionPlanId,
    };
  }

  SignageTemplatePackageVisibility copyWith({
    String? signageTemplateId,
    String? subscriptionPlanId,
  }) {
    return SignageTemplatePackageVisibility(
      signageTemplateId: signageTemplateId ?? this.signageTemplateId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignageTemplatePackageVisibility && other.signageTemplateId == signageTemplateId && other.subscriptionPlanId == subscriptionPlanId;

  @override
  int get hashCode => signageTemplateId.hashCode ^ subscriptionPlanId.hashCode;

  @override
  String toString() => 'SignageTemplatePackageVisibility(signageTemplateId: $signageTemplateId, subscriptionPlanId: $subscriptionPlanId)';
}
