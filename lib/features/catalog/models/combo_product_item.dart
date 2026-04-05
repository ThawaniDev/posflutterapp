class ComboProductItem {
  final String id;
  final String comboProductId;
  final String productId;
  final double quantity;
  final bool? isOptional;
  final DateTime? createdAt;

  const ComboProductItem({
    required this.id,
    required this.comboProductId,
    required this.productId,
    required this.quantity,
    this.isOptional,
    this.createdAt,
  });

  factory ComboProductItem.fromJson(Map<String, dynamic> json) {
    return ComboProductItem(
      id: json['id'] as String,
      comboProductId: json['combo_product_id'] as String,
      productId: json['product_id'] as String,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      isOptional: json['is_optional'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'combo_product_id': comboProductId,
      'product_id': productId,
      'quantity': quantity,
      'is_optional': isOptional,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ComboProductItem copyWith({
    String? id,
    String? comboProductId,
    String? productId,
    double? quantity,
    bool? isOptional,
    DateTime? createdAt,
  }) {
    return ComboProductItem(
      id: id ?? this.id,
      comboProductId: comboProductId ?? this.comboProductId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      isOptional: isOptional ?? this.isOptional,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComboProductItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ComboProductItem(id: $id, comboProductId: $comboProductId, productId: $productId, quantity: $quantity, isOptional: $isOptional, createdAt: $createdAt)';
}
