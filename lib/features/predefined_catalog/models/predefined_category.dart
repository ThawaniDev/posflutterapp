class PredefinedCategory {

  const PredefinedCategory({
    required this.id,
    required this.businessTypeId,
    this.parentId,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.imageUrl,
    this.sortOrder,
    this.isActive = true,
    this.children = const [],
    this.productsCount,
    this.businessType,
    this.createdAt,
    this.updatedAt,
  });

  factory PredefinedCategory.fromJson(Map<String, dynamic> json) {
    return PredefinedCategory(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      parentId: json['parent_id'] as String?,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      imageUrl: json['image_url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      children: json['children'] != null
          ? (json['children'] as List).map((c) => PredefinedCategory.fromJson(c as Map<String, dynamic>)).toList()
          : const [],
      productsCount: (json['products_count'] as num?)?.toInt(),
      businessType: json['business_type'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String businessTypeId;
  final String? parentId;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? imageUrl;
  final int? sortOrder;
  final bool isActive;
  final List<PredefinedCategory> children;
  final int? productsCount;
  final Map<String, dynamic>? businessType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'parent_id': parentId,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }

  PredefinedCategory copyWith({
    String? id,
    String? businessTypeId,
    String? parentId,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? imageUrl,
    int? sortOrder,
    bool? isActive,
    List<PredefinedCategory>? children,
    int? productsCount,
    Map<String, dynamic>? businessType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PredefinedCategory(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      imageUrl: imageUrl ?? this.imageUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      children: children ?? this.children,
      productsCount: productsCount ?? this.productsCount,
      businessType: businessType ?? this.businessType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PredefinedCategory && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PredefinedCategory(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, productsCount: $productsCount)';
}
