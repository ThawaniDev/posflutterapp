class PromotionCustomerGroup {

  const PromotionCustomerGroup({
    required this.id,
    required this.promotionId,
    required this.customerGroupId,
  });

  factory PromotionCustomerGroup.fromJson(Map<String, dynamic> json) {
    return PromotionCustomerGroup(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      customerGroupId: json['customer_group_id'] as String,
    );
  }
  final String id;
  final String promotionId;
  final String customerGroupId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotion_id': promotionId,
      'customer_group_id': customerGroupId,
    };
  }

  PromotionCustomerGroup copyWith({
    String? id,
    String? promotionId,
    String? customerGroupId,
  }) {
    return PromotionCustomerGroup(
      id: id ?? this.id,
      promotionId: promotionId ?? this.promotionId,
      customerGroupId: customerGroupId ?? this.customerGroupId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromotionCustomerGroup && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PromotionCustomerGroup(id: $id, promotionId: $promotionId, customerGroupId: $customerGroupId)';
}
