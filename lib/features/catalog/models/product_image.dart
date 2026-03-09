class ProductImage {
  final String id;
  final String productId;
  final String imageUrl;
  final int? sortOrder;
  final DateTime? createdAt;

  const ProductImage({
    required this.id,
    required this.productId,
    required this.imageUrl,
    this.sortOrder,
    this.createdAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      imageUrl: json['image_url'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProductImage copyWith({
    String? id,
    String? productId,
    String? imageUrl,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return ProductImage(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      imageUrl: imageUrl ?? this.imageUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductImage && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductImage(id: $id, productId: $productId, imageUrl: $imageUrl, sortOrder: $sortOrder, createdAt: $createdAt)';
}
