class PosLayoutTemplate {

  const PosLayoutTemplate({
    required this.id,
    required this.businessTypeId,
    required this.layoutKey,
    required this.name,
    required this.nameAr,
    this.description,
    this.previewImageUrl,
    required this.config,
    this.isDefault,
    this.isActive,
    this.sortOrder,
    this.createdAt,
  });

  factory PosLayoutTemplate.fromJson(Map<String, dynamic> json) {
    return PosLayoutTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      layoutKey: json['layout_key'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      description: json['description'] as String?,
      previewImageUrl: json['preview_image_url'] as String?,
      config: Map<String, dynamic>.from(json['config'] as Map),
      isDefault: json['is_default'] as bool?,
      isActive: json['is_active'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String businessTypeId;
  final String layoutKey;
  final String name;
  final String nameAr;
  final String? description;
  final String? previewImageUrl;
  final Map<String, dynamic> config;
  final bool? isDefault;
  final bool? isActive;
  final int? sortOrder;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'layout_key': layoutKey,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'preview_image_url': previewImageUrl,
      'config': config,
      'is_default': isDefault,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  PosLayoutTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? layoutKey,
    String? name,
    String? nameAr,
    String? description,
    String? previewImageUrl,
    Map<String, dynamic>? config,
    bool? isDefault,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return PosLayoutTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      layoutKey: layoutKey ?? this.layoutKey,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      config: config ?? this.config,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PosLayoutTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PosLayoutTemplate(id: $id, businessTypeId: $businessTypeId, layoutKey: $layoutKey, name: $name, nameAr: $nameAr, description: $description, ...)';
}
