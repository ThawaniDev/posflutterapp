class PurchaseOrderItem {
  const PurchaseOrderItem({
    required this.id,
    required this.purchaseOrderId,
    required this.productId,
    this.productName,
    required this.quantityOrdered,
    required this.unitCost,
    this.quantityReceived,
  });

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItem(
      id: json['id'] as String,
      purchaseOrderId: json['purchase_order_id'] as String,
      productId: json['product_id'] as String,
      productName: (json['product'] as Map<String, dynamic>?)?['name'] as String?,
      quantityOrdered: double.tryParse(json['quantity_ordered'].toString()) ?? 0.0,
      unitCost: double.tryParse(json['unit_cost'].toString()) ?? 0.0,
      quantityReceived: (json['quantity_received'] != null ? double.tryParse(json['quantity_received'].toString()) : null),
    );
  }
  final String id;
  final String purchaseOrderId;
  final String productId;
  final String? productName;
  final double quantityOrdered;
  final double unitCost;
  final double? quantityReceived;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchase_order_id': purchaseOrderId,
      'product_id': productId,
      'quantity_ordered': quantityOrdered,
      'unit_cost': unitCost,
      'quantity_received': quantityReceived,
    };
  }

  PurchaseOrderItem copyWith({
    String? id,
    String? purchaseOrderId,
    String? productId,
    double? quantityOrdered,
    double? unitCost,
    double? quantityReceived,
  }) {
    return PurchaseOrderItem(
      id: id ?? this.id,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      productId: productId ?? this.productId,
      quantityOrdered: quantityOrdered ?? this.quantityOrdered,
      unitCost: unitCost ?? this.unitCost,
      quantityReceived: quantityReceived ?? this.quantityReceived,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PurchaseOrderItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PurchaseOrderItem(id: $id, purchaseOrderId: $purchaseOrderId, productId: $productId, quantityOrdered: $quantityOrdered, unitCost: $unitCost, quantityReceived: $quantityReceived)';
}
