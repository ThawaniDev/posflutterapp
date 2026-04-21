class PromotionCategory {

  const PromotionCategory({
    required this.id,
    required this.promotionId,
    required this.categoryId,
  });

  factory PromotionCategory.fromJson(Map<String, dynamic> json) {
    return PromotionCategory(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      categoryId: json['category_id'] as String,
    );
  }
  final String id;
  final String promotionId;
  final String categoryId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotion_id': promotionId,
      'category_id': categoryId,
    };
  }

  PromotionCategory copyWith({
    String? id,
    String? promotionId,
    String? categoryId,
  }) {
    return PromotionCategory(
      id: id ?? this.id,
      promotionId: promotionId ?? this.promotionId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromotionCategory && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PromotionCategory(id: $id, promotionId: $promotionId, categoryId: $categoryId)';
}
