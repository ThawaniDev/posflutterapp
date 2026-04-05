class StockLevel {
  final String id;
  final String storeId;
  final String productId;
  final String? productName;
  final double quantity;
  final double? reservedQuantity;
  final double? reorderPoint;
  final double? maxStockLevel;
  final double? averageCost;
  final int? syncVersion;
  final DateTime? updatedAt;

  const StockLevel({
    required this.id,
    required this.storeId,
    required this.productId,
    this.productName,
    required this.quantity,
    this.reservedQuantity,
    this.reorderPoint,
    this.maxStockLevel,
    this.averageCost,
    this.syncVersion,
    this.updatedAt,
  });

  factory StockLevel.fromJson(Map<String, dynamic> json) {
    return StockLevel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      productName: (json['product'] as Map<String, dynamic>?)?['name'] as String?,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      reservedQuantity: (json['reserved_quantity'] != null ? double.tryParse(json['reserved_quantity'].toString()) : null),
      reorderPoint: (json['reorder_point'] != null ? double.tryParse(json['reorder_point'].toString()) : null),
      maxStockLevel: (json['max_stock_level'] != null ? double.tryParse(json['max_stock_level'].toString()) : null),
      averageCost: (json['average_cost'] != null ? double.tryParse(json['average_cost'].toString()) : null),
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'quantity': quantity,
      'reserved_quantity': reservedQuantity,
      'reorder_point': reorderPoint,
      'max_stock_level': maxStockLevel,
      'average_cost': averageCost,
      'sync_version': syncVersion,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StockLevel copyWith({
    String? id,
    String? storeId,
    String? productId,
    String? productName,
    double? quantity,
    double? reservedQuantity,
    double? reorderPoint,
    double? maxStockLevel,
    double? averageCost,
    int? syncVersion,
    DateTime? updatedAt,
  }) {
    return StockLevel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      reorderPoint: reorderPoint ?? this.reorderPoint,
      maxStockLevel: maxStockLevel ?? this.maxStockLevel,
      averageCost: averageCost ?? this.averageCost,
      syncVersion: syncVersion ?? this.syncVersion,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StockLevel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StockLevel(id: $id, storeId: $storeId, productId: $productId, quantity: $quantity, reservedQuantity: $reservedQuantity, reorderPoint: $reorderPoint, ...)';
}
