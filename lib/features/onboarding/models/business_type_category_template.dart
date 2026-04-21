class BusinessTypeCategoryTemplate {

  const BusinessTypeCategoryTemplate({
    required this.id,
    required this.businessTypeId,
    required this.categoryName,
    required this.categoryNameAr,
    this.sortOrder,
  });

  factory BusinessTypeCategoryTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeCategoryTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      categoryName: json['category_name'] as String,
      categoryNameAr: json['category_name_ar'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String businessTypeId;
  final String categoryName;
  final String categoryNameAr;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'category_name': categoryName,
      'category_name_ar': categoryNameAr,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeCategoryTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? categoryName,
    String? categoryNameAr,
    int? sortOrder,
  }) {
    return BusinessTypeCategoryTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      categoryName: categoryName ?? this.categoryName,
      categoryNameAr: categoryNameAr ?? this.categoryNameAr,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeCategoryTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeCategoryTemplate(id: $id, businessTypeId: $businessTypeId, categoryName: $categoryName, categoryNameAr: $categoryNameAr, sortOrder: $sortOrder)';
}
