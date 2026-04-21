class OrderItemModifier {

  const OrderItemModifier({
    required this.id,
    required this.orderItemId,
    this.modifierOptionId,
    required this.modifierName,
    this.modifierNameAr,
    this.priceAdjustment,
  });

  factory OrderItemModifier.fromJson(Map<String, dynamic> json) {
    return OrderItemModifier(
      id: json['id'] as String,
      orderItemId: json['order_item_id'] as String,
      modifierOptionId: json['modifier_option_id'] as String?,
      modifierName: json['modifier_name'] as String,
      modifierNameAr: json['modifier_name_ar'] as String?,
      priceAdjustment: (json['price_adjustment'] != null ? double.tryParse(json['price_adjustment'].toString()) : null),
    );
  }
  final String id;
  final String orderItemId;
  final String? modifierOptionId;
  final String modifierName;
  final String? modifierNameAr;
  final double? priceAdjustment;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_item_id': orderItemId,
      'modifier_option_id': modifierOptionId,
      'modifier_name': modifierName,
      'modifier_name_ar': modifierNameAr,
      'price_adjustment': priceAdjustment,
    };
  }

  OrderItemModifier copyWith({
    String? id,
    String? orderItemId,
    String? modifierOptionId,
    String? modifierName,
    String? modifierNameAr,
    double? priceAdjustment,
  }) {
    return OrderItemModifier(
      id: id ?? this.id,
      orderItemId: orderItemId ?? this.orderItemId,
      modifierOptionId: modifierOptionId ?? this.modifierOptionId,
      modifierName: modifierName ?? this.modifierName,
      modifierNameAr: modifierNameAr ?? this.modifierNameAr,
      priceAdjustment: priceAdjustment ?? this.priceAdjustment,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemModifier && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OrderItemModifier(id: $id, orderItemId: $orderItemId, modifierOptionId: $modifierOptionId, modifierName: $modifierName, modifierNameAr: $modifierNameAr, priceAdjustment: $priceAdjustment)';
}
