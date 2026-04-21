class StockBatch {

  const StockBatch({
    required this.id,
    required this.storeId,
    required this.productId,
    this.batchNumber,
    this.expiryDate,
    required this.quantity,
    this.unitCost,
    this.goodsReceiptId,
    this.createdAt,
  });

  factory StockBatch.fromJson(Map<String, dynamic> json) {
    return StockBatch(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      batchNumber: json['batch_number'] as String?,
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date'] as String) : null,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      unitCost: (json['unit_cost'] != null ? double.tryParse(json['unit_cost'].toString()) : null),
      goodsReceiptId: json['goods_receipt_id'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String productId;
  final String? batchNumber;
  final DateTime? expiryDate;
  final double quantity;
  final double? unitCost;
  final String? goodsReceiptId;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'batch_number': batchNumber,
      'expiry_date': expiryDate?.toIso8601String(),
      'quantity': quantity,
      'unit_cost': unitCost,
      'goods_receipt_id': goodsReceiptId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  StockBatch copyWith({
    String? id,
    String? storeId,
    String? productId,
    String? batchNumber,
    DateTime? expiryDate,
    double? quantity,
    double? unitCost,
    String? goodsReceiptId,
    DateTime? createdAt,
  }) {
    return StockBatch(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      goodsReceiptId: goodsReceiptId ?? this.goodsReceiptId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockBatch && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StockBatch(id: $id, storeId: $storeId, productId: $productId, batchNumber: $batchNumber, expiryDate: $expiryDate, quantity: $quantity, ...)';
}
