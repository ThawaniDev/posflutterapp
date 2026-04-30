class StocktakeItem {
  const StocktakeItem({
    required this.id,
    required this.stocktakeId,
    required this.productId,
    this.productName,
    this.productSku,
    required this.expectedQty,
    this.countedQty,
    this.variance,
    this.costImpact,
    this.notes,
    this.countedAt,
  });

  factory StocktakeItem.fromJson(Map<String, dynamic> json) {
    return StocktakeItem(
      id: json['id'] as String,
      stocktakeId: json['stocktake_id'] as String,
      productId: json['product_id'] as String,
      productName: (json['product'] as Map<String, dynamic>?)?['name'] as String?,
      productSku: (json['product'] as Map<String, dynamic>?)?['sku'] as String?,
      expectedQty: double.tryParse(json['expected_qty'].toString()) ?? 0.0,
      countedQty: json['counted_qty'] != null ? double.tryParse(json['counted_qty'].toString()) : null,
      variance: json['variance'] != null ? double.tryParse(json['variance'].toString()) : null,
      costImpact: json['cost_impact'] != null ? double.tryParse(json['cost_impact'].toString()) : null,
      notes: json['notes'] as String?,
      countedAt: json['counted_at'] != null ? DateTime.parse(json['counted_at'] as String) : null,
    );
  }

  final String id;
  final String stocktakeId;
  final String productId;
  final String? productName;
  final String? productSku;
  final double expectedQty;
  final double? countedQty;
  final double? variance;
  final double? costImpact;
  final String? notes;
  final DateTime? countedAt;

  bool get isCounted => countedQty != null;
  bool get hasVariance => variance != null && variance != 0;
  bool get isOverage => (variance ?? 0) > 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'stocktake_id': stocktakeId,
    'product_id': productId,
    'expected_qty': expectedQty,
    'counted_qty': countedQty,
    'variance': variance,
    'cost_impact': costImpact,
    'notes': notes,
    'counted_at': countedAt?.toIso8601String(),
  };

  StocktakeItem copyWith({
    String? id,
    String? stocktakeId,
    String? productId,
    String? productName,
    String? productSku,
    double? expectedQty,
    double? countedQty,
    double? variance,
    double? costImpact,
    String? notes,
    DateTime? countedAt,
  }) {
    return StocktakeItem(
      id: id ?? this.id,
      stocktakeId: stocktakeId ?? this.stocktakeId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productSku: productSku ?? this.productSku,
      expectedQty: expectedQty ?? this.expectedQty,
      countedQty: countedQty ?? this.countedQty,
      variance: variance ?? this.variance,
      costImpact: costImpact ?? this.costImpact,
      notes: notes ?? this.notes,
      countedAt: countedAt ?? this.countedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StocktakeItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StocktakeItem(id: $id, productId: $productId, expectedQty: $expectedQty, countedQty: $countedQty, variance: $variance)';
}
