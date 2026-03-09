class ProductSupplier {
  final String id;
  final String productId;
  final String supplierId;
  final double? costPrice;
  final int? leadTimeDays;
  final String? supplierSku;
  final DateTime? createdAt;

  const ProductSupplier({
    required this.id,
    required this.productId,
    required this.supplierId,
    this.costPrice,
    this.leadTimeDays,
    this.supplierSku,
    this.createdAt,
  });

  factory ProductSupplier.fromJson(Map<String, dynamic> json) {
    return ProductSupplier(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      supplierId: json['supplier_id'] as String,
      costPrice: (json['cost_price'] as num?)?.toDouble(),
      leadTimeDays: (json['lead_time_days'] as num?)?.toInt(),
      supplierSku: json['supplier_sku'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'supplier_id': supplierId,
      'cost_price': costPrice,
      'lead_time_days': leadTimeDays,
      'supplier_sku': supplierSku,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProductSupplier copyWith({
    String? id,
    String? productId,
    String? supplierId,
    double? costPrice,
    int? leadTimeDays,
    String? supplierSku,
    DateTime? createdAt,
  }) {
    return ProductSupplier(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      costPrice: costPrice ?? this.costPrice,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      supplierSku: supplierSku ?? this.supplierSku,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSupplier && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductSupplier(id: $id, productId: $productId, supplierId: $supplierId, costPrice: $costPrice, leadTimeDays: $leadTimeDays, supplierSku: $supplierSku, ...)';
}
