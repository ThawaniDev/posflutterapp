class ProductSalesSummary {
  final String id;
  final String storeId;
  final String productId;
  final DateTime date;
  final double? quantitySold;
  final double? revenue;
  final double? cost;
  final double? discountAmount;
  final double? taxAmount;
  final double? returnQuantity;
  final double? returnAmount;

  const ProductSalesSummary({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.date,
    this.quantitySold,
    this.revenue,
    this.cost,
    this.discountAmount,
    this.taxAmount,
    this.returnQuantity,
    this.returnAmount,
  });

  factory ProductSalesSummary.fromJson(Map<String, dynamic> json) {
    return ProductSalesSummary(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      date: DateTime.parse(json['date'] as String),
      quantitySold: (json['quantity_sold'] != null ? double.tryParse(json['quantity_sold'].toString()) : null),
      revenue: (json['revenue'] != null ? double.tryParse(json['revenue'].toString()) : null),
      cost: (json['cost'] != null ? double.tryParse(json['cost'].toString()) : null),
      discountAmount: (json['discount_amount'] != null ? double.tryParse(json['discount_amount'].toString()) : null),
      taxAmount: (json['tax_amount'] != null ? double.tryParse(json['tax_amount'].toString()) : null),
      returnQuantity: (json['return_quantity'] != null ? double.tryParse(json['return_quantity'].toString()) : null),
      returnAmount: (json['return_amount'] != null ? double.tryParse(json['return_amount'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'date': date.toIso8601String(),
      'quantity_sold': quantitySold,
      'revenue': revenue,
      'cost': cost,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'return_quantity': returnQuantity,
      'return_amount': returnAmount,
    };
  }

  ProductSalesSummary copyWith({
    String? id,
    String? storeId,
    String? productId,
    DateTime? date,
    double? quantitySold,
    double? revenue,
    double? cost,
    double? discountAmount,
    double? taxAmount,
    double? returnQuantity,
    double? returnAmount,
  }) {
    return ProductSalesSummary(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      date: date ?? this.date,
      quantitySold: quantitySold ?? this.quantitySold,
      revenue: revenue ?? this.revenue,
      cost: cost ?? this.cost,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      returnQuantity: returnQuantity ?? this.returnQuantity,
      returnAmount: returnAmount ?? this.returnAmount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSalesSummary && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductSalesSummary(id: $id, storeId: $storeId, productId: $productId, date: $date, quantitySold: $quantitySold, revenue: $revenue, ...)';
}
