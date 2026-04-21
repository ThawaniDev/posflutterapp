class StockTransferItem {

  const StockTransferItem({
    required this.id,
    required this.stockTransferId,
    required this.productId,
    required this.quantitySent,
    this.quantityReceived,
  });

  factory StockTransferItem.fromJson(Map<String, dynamic> json) {
    return StockTransferItem(
      id: json['id'] as String,
      stockTransferId: json['stock_transfer_id'] as String,
      productId: json['product_id'] as String,
      quantitySent: double.tryParse(json['quantity_sent'].toString()) ?? 0.0,
      quantityReceived: (json['quantity_received'] != null ? double.tryParse(json['quantity_received'].toString()) : null),
    );
  }
  final String id;
  final String stockTransferId;
  final String productId;
  final double quantitySent;
  final double? quantityReceived;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_transfer_id': stockTransferId,
      'product_id': productId,
      'quantity_sent': quantitySent,
      'quantity_received': quantityReceived,
    };
  }

  StockTransferItem copyWith({
    String? id,
    String? stockTransferId,
    String? productId,
    double? quantitySent,
    double? quantityReceived,
  }) {
    return StockTransferItem(
      id: id ?? this.id,
      stockTransferId: stockTransferId ?? this.stockTransferId,
      productId: productId ?? this.productId,
      quantitySent: quantitySent ?? this.quantitySent,
      quantityReceived: quantityReceived ?? this.quantityReceived,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockTransferItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StockTransferItem(id: $id, stockTransferId: $stockTransferId, productId: $productId, quantitySent: $quantitySent, quantityReceived: $quantityReceived)';
}
