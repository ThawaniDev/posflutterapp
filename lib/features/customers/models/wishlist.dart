class Wishlist {

  const Wishlist({
    required this.id,
    required this.storeId,
    required this.customerId,
    required this.productId,
    this.addedAt,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String,
      productId: json['product_id'] as String,
      addedAt: json['added_at'] != null ? DateTime.parse(json['added_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String customerId;
  final String productId;
  final DateTime? addedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'product_id': productId,
      'added_at': addedAt?.toIso8601String(),
    };
  }

  Wishlist copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? productId,
    DateTime? addedAt,
  }) {
    return Wishlist(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wishlist && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Wishlist(id: $id, storeId: $storeId, customerId: $customerId, productId: $productId, addedAt: $addedAt)';
}
