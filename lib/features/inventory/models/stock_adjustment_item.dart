class StockAdjustmentItem {

  const StockAdjustmentItem({
    required this.id,
    required this.stockAdjustmentId,
    required this.productId,
    required this.quantity,
    this.unitCost,
  });

  factory StockAdjustmentItem.fromJson(Map<String, dynamic> json) {
    return StockAdjustmentItem(
      id: json['id'] as String,
      stockAdjustmentId: json['stock_adjustment_id'] as String,
      productId: json['product_id'] as String,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      unitCost: (json['unit_cost'] != null ? double.tryParse(json['unit_cost'].toString()) : null),
    );
  }
  final String id;
  final String stockAdjustmentId;
  final String productId;
  final double quantity;
  final double? unitCost;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_adjustment_id': stockAdjustmentId,
      'product_id': productId,
      'quantity': quantity,
      'unit_cost': unitCost,
    };
  }

  StockAdjustmentItem copyWith({
    String? id,
    String? stockAdjustmentId,
    String? productId,
    double? quantity,
    double? unitCost,
  }) {
    return StockAdjustmentItem(
      id: id ?? this.id,
      stockAdjustmentId: stockAdjustmentId ?? this.stockAdjustmentId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockAdjustmentItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StockAdjustmentItem(id: $id, stockAdjustmentId: $stockAdjustmentId, productId: $productId, quantity: $quantity, unitCost: $unitCost)';
}
