class BundleProduct {

  const BundleProduct({
    required this.id,
    required this.promotionId,
    required this.productId,
    this.quantity,
  });

  factory BundleProduct.fromJson(Map<String, dynamic> json) {
    return BundleProduct(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num?)?.toInt(),
    );
  }
  final String id;
  final String promotionId;
  final String productId;
  final int? quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotion_id': promotionId,
      'product_id': productId,
      'quantity': quantity,
    };
  }

  BundleProduct copyWith({
    String? id,
    String? promotionId,
    String? productId,
    int? quantity,
  }) {
    return BundleProduct(
      id: id ?? this.id,
      promotionId: promotionId ?? this.promotionId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BundleProduct && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BundleProduct(id: $id, promotionId: $promotionId, productId: $productId, quantity: $quantity)';
}
