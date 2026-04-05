class GoodsReceiptItem {
  final String id;
  final String goodsReceiptId;
  final String productId;
  final double quantity;
  final double unitCost;
  final String? batchNumber;
  final DateTime? expiryDate;

  const GoodsReceiptItem({
    required this.id,
    required this.goodsReceiptId,
    required this.productId,
    required this.quantity,
    required this.unitCost,
    this.batchNumber,
    this.expiryDate,
  });

  factory GoodsReceiptItem.fromJson(Map<String, dynamic> json) {
    return GoodsReceiptItem(
      id: json['id'] as String,
      goodsReceiptId: json['goods_receipt_id'] as String,
      productId: json['product_id'] as String,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      unitCost: double.tryParse(json['unit_cost'].toString()) ?? 0.0,
      batchNumber: json['batch_number'] as String?,
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goods_receipt_id': goodsReceiptId,
      'product_id': productId,
      'quantity': quantity,
      'unit_cost': unitCost,
      'batch_number': batchNumber,
      'expiry_date': expiryDate?.toIso8601String(),
    };
  }

  GoodsReceiptItem copyWith({
    String? id,
    String? goodsReceiptId,
    String? productId,
    double? quantity,
    double? unitCost,
    String? batchNumber,
    DateTime? expiryDate,
  }) {
    return GoodsReceiptItem(
      id: id ?? this.id,
      goodsReceiptId: goodsReceiptId ?? this.goodsReceiptId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoodsReceiptItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GoodsReceiptItem(id: $id, goodsReceiptId: $goodsReceiptId, productId: $productId, quantity: $quantity, unitCost: $unitCost, batchNumber: $batchNumber, ...)';
}
