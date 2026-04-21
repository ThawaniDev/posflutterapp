class PromotionProduct {

  const PromotionProduct({
    required this.id,
    required this.promotionId,
    required this.productId,
  });

  factory PromotionProduct.fromJson(Map<String, dynamic> json) {
    return PromotionProduct(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      productId: json['product_id'] as String,
    );
  }
  final String id;
  final String promotionId;
  final String productId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotion_id': promotionId,
      'product_id': productId,
    };
  }

  PromotionProduct copyWith({
    String? id,
    String? promotionId,
    String? productId,
  }) {
    return PromotionProduct(
      id: id ?? this.id,
      promotionId: promotionId ?? this.promotionId,
      productId: productId ?? this.productId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromotionProduct && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PromotionProduct(id: $id, promotionId: $promotionId, productId: $productId)';
}
