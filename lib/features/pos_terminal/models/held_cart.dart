class HeldCart {

  const HeldCart({
    required this.id,
    required this.storeId,
    required this.registerId,
    required this.cashierId,
    this.customerId,
    required this.cartData,
    this.label,
    this.heldAt,
    this.recalledAt,
    this.recalledBy,
    this.createdAt,
  });

  factory HeldCart.fromJson(Map<String, dynamic> json) {
    return HeldCart(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      registerId: json['register_id'] as String,
      cashierId: json['cashier_id'] as String,
      customerId: json['customer_id'] as String?,
      cartData: Map<String, dynamic>.from(json['cart_data'] as Map),
      label: json['label'] as String?,
      heldAt: json['held_at'] != null ? DateTime.parse(json['held_at'] as String) : null,
      recalledAt: json['recalled_at'] != null ? DateTime.parse(json['recalled_at'] as String) : null,
      recalledBy: json['recalled_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String registerId;
  final String cashierId;
  final String? customerId;
  final Map<String, dynamic> cartData;
  final String? label;
  final DateTime? heldAt;
  final DateTime? recalledAt;
  final String? recalledBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'register_id': registerId,
      'cashier_id': cashierId,
      'customer_id': customerId,
      'cart_data': cartData,
      'label': label,
      'held_at': heldAt?.toIso8601String(),
      'recalled_at': recalledAt?.toIso8601String(),
      'recalled_by': recalledBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  HeldCart copyWith({
    String? id,
    String? storeId,
    String? registerId,
    String? cashierId,
    String? customerId,
    Map<String, dynamic>? cartData,
    String? label,
    DateTime? heldAt,
    DateTime? recalledAt,
    String? recalledBy,
    DateTime? createdAt,
  }) {
    return HeldCart(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      registerId: registerId ?? this.registerId,
      cashierId: cashierId ?? this.cashierId,
      customerId: customerId ?? this.customerId,
      cartData: cartData ?? this.cartData,
      label: label ?? this.label,
      heldAt: heldAt ?? this.heldAt,
      recalledAt: recalledAt ?? this.recalledAt,
      recalledBy: recalledBy ?? this.recalledBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeldCart && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'HeldCart(id: $id, storeId: $storeId, registerId: $registerId, cashierId: $cashierId, customerId: $customerId, cartData: $cartData, ...)';
}
