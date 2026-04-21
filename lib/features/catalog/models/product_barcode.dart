class ProductBarcode {

  const ProductBarcode({required this.id, this.productId, required this.barcode, this.isPrimary, this.createdAt});

  factory ProductBarcode.fromJson(Map<String, dynamic> json) {
    return ProductBarcode(
      id: json['id'] as String,
      productId: json['product_id'] as String?,
      barcode: json['barcode'] as String,
      isPrimary: json['is_primary'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String? productId;
  final String barcode;
  final bool? isPrimary;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'barcode': barcode,
      'is_primary': isPrimary,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProductBarcode copyWith({String? id, String? productId, String? barcode, bool? isPrimary, DateTime? createdAt}) {
    return ProductBarcode(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      barcode: barcode ?? this.barcode,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProductBarcode && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ProductBarcode(id: $id, productId: $productId, barcode: $barcode, isPrimary: $isPrimary, createdAt: $createdAt)';
}
