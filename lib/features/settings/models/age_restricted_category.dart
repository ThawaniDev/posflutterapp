class AgeRestrictedCategory {
  final String id;
  final String categorySlug;
  final int minAge;
  final bool? isActive;

  const AgeRestrictedCategory({
    required this.id,
    required this.categorySlug,
    required this.minAge,
    this.isActive,
  });

  factory AgeRestrictedCategory.fromJson(Map<String, dynamic> json) {
    return AgeRestrictedCategory(
      id: json['id'] as String,
      categorySlug: json['category_slug'] as String,
      minAge: (json['min_age'] as num).toInt(),
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_slug': categorySlug,
      'min_age': minAge,
      'is_active': isActive,
    };
  }

  AgeRestrictedCategory copyWith({
    String? id,
    String? categorySlug,
    int? minAge,
    bool? isActive,
  }) {
    return AgeRestrictedCategory(
      id: id ?? this.id,
      categorySlug: categorySlug ?? this.categorySlug,
      minAge: minAge ?? this.minAge,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgeRestrictedCategory && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AgeRestrictedCategory(id: $id, categorySlug: $categorySlug, minAge: $minAge, isActive: $isActive)';
}
