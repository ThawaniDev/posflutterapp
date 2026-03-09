class PromotionUsageLog {
  final String id;
  final String promotionId;
  final String? couponCodeId;
  final String orderId;
  final String? customerId;
  final double discountAmount;
  final DateTime? createdAt;

  const PromotionUsageLog({
    required this.id,
    required this.promotionId,
    this.couponCodeId,
    required this.orderId,
    this.customerId,
    required this.discountAmount,
    this.createdAt,
  });

  factory PromotionUsageLog.fromJson(Map<String, dynamic> json) {
    return PromotionUsageLog(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      couponCodeId: json['coupon_code_id'] as String?,
      orderId: json['order_id'] as String,
      customerId: json['customer_id'] as String?,
      discountAmount: (json['discount_amount'] as num).toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotion_id': promotionId,
      'coupon_code_id': couponCodeId,
      'order_id': orderId,
      'customer_id': customerId,
      'discount_amount': discountAmount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  PromotionUsageLog copyWith({
    String? id,
    String? promotionId,
    String? couponCodeId,
    String? orderId,
    String? customerId,
    double? discountAmount,
    DateTime? createdAt,
  }) {
    return PromotionUsageLog(
      id: id ?? this.id,
      promotionId: promotionId ?? this.promotionId,
      couponCodeId: couponCodeId ?? this.couponCodeId,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      discountAmount: discountAmount ?? this.discountAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromotionUsageLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PromotionUsageLog(id: $id, promotionId: $promotionId, couponCodeId: $couponCodeId, orderId: $orderId, customerId: $customerId, discountAmount: $discountAmount, ...)';
}
