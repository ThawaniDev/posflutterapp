class ReturnItem {
  final String id;
  final String returnId;
  final String orderItemId;
  final String productId;
  final double quantity;
  final double unitPrice;
  final double refundAmount;
  final bool? restoreStock;

  const ReturnItem({
    required this.id,
    required this.returnId,
    required this.orderItemId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.refundAmount,
    this.restoreStock,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      id: json['id'] as String,
      returnId: json['return_id'] as String,
      orderItemId: json['order_item_id'] as String,
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      refundAmount: (json['refund_amount'] as num).toDouble(),
      restoreStock: json['restore_stock'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'return_id': returnId,
      'order_item_id': orderItemId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'refund_amount': refundAmount,
      'restore_stock': restoreStock,
    };
  }

  ReturnItem copyWith({
    String? id,
    String? returnId,
    String? orderItemId,
    String? productId,
    double? quantity,
    double? unitPrice,
    double? refundAmount,
    bool? restoreStock,
  }) {
    return ReturnItem(
      id: id ?? this.id,
      returnId: returnId ?? this.returnId,
      orderItemId: orderItemId ?? this.orderItemId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      refundAmount: refundAmount ?? this.refundAmount,
      restoreStock: restoreStock ?? this.restoreStock,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReturnItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ReturnItem(id: $id, returnId: $returnId, orderItemId: $orderItemId, productId: $productId, quantity: $quantity, unitPrice: $unitPrice, ...)';
}
