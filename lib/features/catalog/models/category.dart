class Category {
  final String id;
  final String organizationId;
  final String? parentId;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? imageUrl;
  final int? sortOrder;
  final bool? isActive;
  final int? syncVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.organizationId,
    this.parentId,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.imageUrl,
    this.sortOrder,
    this.isActive,
    this.syncVersion,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      parentId: json['parent_id'] as String?,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      imageUrl: json['image_url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'parent_id': parentId,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'is_active': isActive,
      'sync_version': syncVersion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Category copyWith({
    String? id,
    String? organizationId,
    String? parentId,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? imageUrl,
    int? sortOrder,
    bool? isActive,
    int? syncVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      imageUrl: imageUrl ?? this.imageUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      syncVersion: syncVersion ?? this.syncVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Category(id: $id, organizationId: $organizationId, parentId: $parentId, name: $name, nameAr: $nameAr, imageUrl: $imageUrl, ...)';
}
