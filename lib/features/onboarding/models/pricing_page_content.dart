class PricingPageContent {
  final String id;
  final String subscriptionPlanId;
  final Map<String, dynamic> featureBulletList;
  final Map<String, dynamic> faq;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PricingPageContent({
    required this.id,
    required this.subscriptionPlanId,
    required this.featureBulletList,
    required this.faq,
    this.createdAt,
    this.updatedAt,
  });

  factory PricingPageContent.fromJson(Map<String, dynamic> json) {
    return PricingPageContent(
      id: json['id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
      featureBulletList: Map<String, dynamic>.from(json['feature_bullet_list'] as Map),
      faq: Map<String, dynamic>.from(json['faq'] as Map),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_plan_id': subscriptionPlanId,
      'feature_bullet_list': featureBulletList,
      'faq': faq,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PricingPageContent copyWith({
    String? id,
    String? subscriptionPlanId,
    Map<String, dynamic>? featureBulletList,
    Map<String, dynamic>? faq,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PricingPageContent(
      id: id ?? this.id,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      featureBulletList: featureBulletList ?? this.featureBulletList,
      faq: faq ?? this.faq,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PricingPageContent && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PricingPageContent(id: $id, subscriptionPlanId: $subscriptionPlanId, featureBulletList: $featureBulletList, faq: $faq, createdAt: $createdAt, updatedAt: $updatedAt)';
}
