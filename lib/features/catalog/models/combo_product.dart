class ComboProduct {
  final String id;
  final String productId;
  final String name;
  final double? comboPrice;
  final DateTime? createdAt;

  const ComboProduct({
    required this.id,
    required this.productId,
    required this.name,
    this.comboPrice,
    this.createdAt,
  });

  factory ComboProduct.fromJson(Map<String, dynamic> json) {
    return ComboProduct(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      comboPrice: (json['combo_price'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'combo_price': comboPrice,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ComboProduct copyWith({
    String? id,
    String? productId,
    String? name,
    double? comboPrice,
    DateTime? createdAt,
  }) {
    return ComboProduct(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      comboPrice: comboPrice ?? this.comboPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComboProduct && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ComboProduct(id: $id, productId: $productId, name: $name, comboPrice: $comboPrice, createdAt: $createdAt)';
}
