class BakeryRecipe {
  final String id;
  final String storeId;
  final String productId;
  final String name;
  final int expectedYield;
  final int? prepTimeMinutes;
  final int? bakeTimeMinutes;
  final int? bakeTemperatureC;
  final String? instructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BakeryRecipe({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.name,
    required this.expectedYield,
    this.prepTimeMinutes,
    this.bakeTimeMinutes,
    this.bakeTemperatureC,
    this.instructions,
    this.createdAt,
    this.updatedAt,
  });

  factory BakeryRecipe.fromJson(Map<String, dynamic> json) {
    return BakeryRecipe(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      expectedYield: (json['expected_yield'] as num).toInt(),
      prepTimeMinutes: (json['prep_time_minutes'] as num?)?.toInt(),
      bakeTimeMinutes: (json['bake_time_minutes'] as num?)?.toInt(),
      bakeTemperatureC: (json['bake_temperature_c'] as num?)?.toInt(),
      instructions: json['instructions'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'name': name,
      'expected_yield': expectedYield,
      'prep_time_minutes': prepTimeMinutes,
      'bake_time_minutes': bakeTimeMinutes,
      'bake_temperature_c': bakeTemperatureC,
      'instructions': instructions,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BakeryRecipe copyWith({
    String? id,
    String? storeId,
    String? productId,
    String? name,
    int? expectedYield,
    int? prepTimeMinutes,
    int? bakeTimeMinutes,
    int? bakeTemperatureC,
    String? instructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BakeryRecipe(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      expectedYield: expectedYield ?? this.expectedYield,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      bakeTimeMinutes: bakeTimeMinutes ?? this.bakeTimeMinutes,
      bakeTemperatureC: bakeTemperatureC ?? this.bakeTemperatureC,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BakeryRecipe && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BakeryRecipe(id: $id, storeId: $storeId, productId: $productId, name: $name, expectedYield: $expectedYield, prepTimeMinutes: $prepTimeMinutes, ...)';
}
