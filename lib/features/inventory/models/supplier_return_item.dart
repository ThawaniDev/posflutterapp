class SupplierReturnItem {
  final String id;
  final String supplierReturnId;
  final String productId;
  final String? productName;
  final String? productSku;
  final double quantity;
  final double unitCost;
  final String? reason;
  final String? batchNumber;

  const SupplierReturnItem({
    required this.id,
    required this.supplierReturnId,
    required this.productId,
    this.productName,
    this.productSku,
    required this.quantity,
    required this.unitCost,
    this.reason,
    this.batchNumber,
  });

  factory SupplierReturnItem.fromJson(Map<String, dynamic> json) {
    final productMap = json['product'] as Map<String, dynamic>?;

    return SupplierReturnItem(
      id: json['id'] as String,
      supplierReturnId: json['supplier_return_id'] as String,
      productId: json['product_id'] as String,
      productName: productMap?['name'] as String?,
      productSku: productMap?['sku'] as String?,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      unitCost: double.tryParse(json['unit_cost'].toString()) ?? 0.0,
      reason: json['reason'] as String?,
      batchNumber: json['batch_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier_return_id': supplierReturnId,
      'product_id': productId,
      'quantity': quantity,
      'unit_cost': unitCost,
      'reason': reason,
      'batch_number': batchNumber,
    };
  }

  SupplierReturnItem copyWith({
    String? id,
    String? supplierReturnId,
    String? productId,
    String? productName,
    String? productSku,
    double? quantity,
    double? unitCost,
    String? reason,
    String? batchNumber,
  }) {
    return SupplierReturnItem(
      id: id ?? this.id,
      supplierReturnId: supplierReturnId ?? this.supplierReturnId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productSku: productSku ?? this.productSku,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      reason: reason ?? this.reason,
      batchNumber: batchNumber ?? this.batchNumber,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SupplierReturnItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
