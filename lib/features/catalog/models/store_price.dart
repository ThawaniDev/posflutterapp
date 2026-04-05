class StorePrice {
  final String id;
  final String storeId;
  final String productId;
  final double sellPrice;
  final DateTime? validFrom;
  final DateTime? validTo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StorePrice({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.sellPrice,
    this.validFrom,
    this.validTo,
    this.createdAt,
    this.updatedAt,
  });

  factory StorePrice.fromJson(Map<String, dynamic> json) {
    return StorePrice(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      sellPrice: double.tryParse(json['sell_price'].toString()) ?? 0.0,
      validFrom: json['valid_from'] != null ? DateTime.parse(json['valid_from'] as String) : null,
      validTo: json['valid_to'] != null ? DateTime.parse(json['valid_to'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'sell_price': sellPrice,
      'valid_from': validFrom?.toIso8601String(),
      'valid_to': validTo?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StorePrice copyWith({
    String? id,
    String? storeId,
    String? productId,
    double? sellPrice,
    DateTime? validFrom,
    DateTime? validTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StorePrice(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      sellPrice: sellPrice ?? this.sellPrice,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorePrice && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StorePrice(id: $id, storeId: $storeId, productId: $productId, sellPrice: $sellPrice, validFrom: $validFrom, validTo: $validTo, ...)';
}
