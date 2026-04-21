class RecipeIngredient {

  const RecipeIngredient({
    required this.id,
    required this.recipeId,
    required this.ingredientProductId,
    required this.quantity,
    this.unit,
    this.wastePercent,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String,
      ingredientProductId: json['ingredient_product_id'] as String,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      unit: json['unit'] as String?,
      wastePercent: (json['waste_percent'] != null ? double.tryParse(json['waste_percent'].toString()) : null),
    );
  }
  final String id;
  final String recipeId;
  final String ingredientProductId;
  final double quantity;
  final String? unit;
  final double? wastePercent;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'ingredient_product_id': ingredientProductId,
      'quantity': quantity,
      'unit': unit,
      'waste_percent': wastePercent,
    };
  }

  RecipeIngredient copyWith({
    String? id,
    String? recipeId,
    String? ingredientProductId,
    double? quantity,
    String? unit,
    double? wastePercent,
  }) {
    return RecipeIngredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      ingredientProductId: ingredientProductId ?? this.ingredientProductId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      wastePercent: wastePercent ?? this.wastePercent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeIngredient && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'RecipeIngredient(id: $id, recipeId: $recipeId, ingredientProductId: $ingredientProductId, quantity: $quantity, unit: $unit, wastePercent: $wastePercent)';
}
