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
    this.isDefault = false,
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
  });

  factory PosLayoutTemplate.fromJson(Map<String, dynamic> json) {
    return PosLayoutTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String? ?? '',
      layoutKey: json['layout_key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      description: json['description'] as String?,
      previewImageUrl: json['preview_image_url'] as String?,
      config: Map<String, dynamic>.from(json['config'] as Map? ?? {}),
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
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
  final bool isDefault;
  final bool isActive;
  final int sortOrder;
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

  @override
  bool operator ==(Object other) => identical(this, other) || other is PosLayoutTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
