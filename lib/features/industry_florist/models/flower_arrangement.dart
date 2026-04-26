class FlowerArrangement {
  const FlowerArrangement({
    required this.id,
    required this.storeId,
    required this.name,
    this.occasion,
    required this.itemsJson,
    required this.totalPrice,
    this.isTemplate,
    this.createdAt,
  });

  factory FlowerArrangement.fromJson(Map<String, dynamic> json) {
    return FlowerArrangement(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      occasion: json['occasion'] as String?,
      itemsJson: (json['items_json'] as Map<String, dynamic>?) ?? {},
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      isTemplate: json['is_template'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String name;
  final String? occasion;
  final Map<String, dynamic> itemsJson;
  final double totalPrice;
  final bool? isTemplate;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'occasion': occasion,
      'items_json': itemsJson,
      'total_price': totalPrice,
      'is_template': isTemplate,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  FlowerArrangement copyWith({
    String? id,
    String? storeId,
    String? name,
    String? occasion,
    Map<String, dynamic>? itemsJson,
    double? totalPrice,
    bool? isTemplate,
    DateTime? createdAt,
  }) {
    return FlowerArrangement(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      occasion: occasion ?? this.occasion,
      itemsJson: itemsJson ?? this.itemsJson,
      totalPrice: totalPrice ?? this.totalPrice,
      isTemplate: isTemplate ?? this.isTemplate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is FlowerArrangement && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FlowerArrangement(id: $id, storeId: $storeId, name: $name, occasion: $occasion, itemsJson: $itemsJson, totalPrice: $totalPrice, ...)';
}
