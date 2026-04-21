class ProductVariant {

  const ProductVariant({
    required this.id,
    this.productId,
    required this.variantGroupId,
    required this.variantValue,
    this.variantValueAr,
    this.sku,
    this.barcode,
    this.priceAdjustment,
    this.imageUrl,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      productId: json['product_id'] as String?,
      variantGroupId: json['variant_group_id'] as String,
      variantValue: json['variant_value'] as String,
      variantValueAr: json['variant_value_ar'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      priceAdjustment: (json['price_adjustment'] != null ? double.tryParse(json['price_adjustment'].toString()) : null),
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String? productId;
  final String variantGroupId;
  final String variantValue;
  final String? variantValueAr;
  final String? sku;
  final String? barcode;
  final double? priceAdjustment;
  final String? imageUrl;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'variant_group_id': variantGroupId,
      'variant_value': variantValue,
      'variant_value_ar': variantValueAr,
      'sku': sku,
      'barcode': barcode,
      'price_adjustment': priceAdjustment,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProductVariant copyWith({
    String? id,
    String? productId,
    String? variantGroupId,
    String? variantValue,
    String? variantValueAr,
    String? sku,
    String? barcode,
    double? priceAdjustment,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantGroupId: variantGroupId ?? this.variantGroupId,
      variantValue: variantValue ?? this.variantValue,
      variantValueAr: variantValueAr ?? this.variantValueAr,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      priceAdjustment: priceAdjustment ?? this.priceAdjustment,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProductVariant && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ProductVariant(id: $id, productId: $productId, variantGroupId: $variantGroupId, variantValue: $variantValue, variantValueAr: $variantValueAr, sku: $sku, ...)';
}
