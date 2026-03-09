class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String? variantId;
  final String productName;
  final String? productNameAr;
  final double quantity;
  final double unitPrice;
  final double? discountAmount;
  final double? taxAmount;
  final double total;
  final String? notes;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.productName,
    this.productNameAr,
    required this.quantity,
    required this.unitPrice,
    this.discountAmount,
    this.taxAmount,
    required this.total,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      variantId: json['variant_id'] as String?,
      productName: json['product_name'] as String,
      productNameAr: json['product_name_ar'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      taxAmount: (json['tax_amount'] as num?)?.toDouble(),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'variant_id': variantId,
      'product_name': productName,
      'product_name_ar': productNameAr,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'total': total,
      'notes': notes,
    };
  }

  OrderItem copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? variantId,
    String? productName,
    String? productNameAr,
    double? quantity,
    double? unitPrice,
    double? discountAmount,
    double? taxAmount,
    double? total,
    String? notes,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      productNameAr: productNameAr ?? this.productNameAr,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      total: total ?? this.total,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OrderItem(id: $id, orderId: $orderId, productId: $productId, variantId: $variantId, productName: $productName, productNameAr: $productNameAr, ...)';
}
