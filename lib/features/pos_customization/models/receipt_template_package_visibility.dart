class ReceiptTemplatePackageVisibility {

  const ReceiptTemplatePackageVisibility({
    required this.receiptLayoutTemplateId,
    required this.subscriptionPlanId,
  });

  factory ReceiptTemplatePackageVisibility.fromJson(Map<String, dynamic> json) {
    return ReceiptTemplatePackageVisibility(
      receiptLayoutTemplateId: json['receipt_layout_template_id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
    );
  }
  final String receiptLayoutTemplateId;
  final String subscriptionPlanId;

  Map<String, dynamic> toJson() {
    return {
      'receipt_layout_template_id': receiptLayoutTemplateId,
      'subscription_plan_id': subscriptionPlanId,
    };
  }

  ReceiptTemplatePackageVisibility copyWith({
    String? receiptLayoutTemplateId,
    String? subscriptionPlanId,
  }) {
    return ReceiptTemplatePackageVisibility(
      receiptLayoutTemplateId: receiptLayoutTemplateId ?? this.receiptLayoutTemplateId,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptTemplatePackageVisibility && other.receiptLayoutTemplateId == receiptLayoutTemplateId && other.subscriptionPlanId == subscriptionPlanId;

  @override
  int get hashCode => receiptLayoutTemplateId.hashCode ^ subscriptionPlanId.hashCode;

  @override
  String toString() => 'ReceiptTemplatePackageVisibility(receiptLayoutTemplateId: $receiptLayoutTemplateId, subscriptionPlanId: $subscriptionPlanId)';
}
