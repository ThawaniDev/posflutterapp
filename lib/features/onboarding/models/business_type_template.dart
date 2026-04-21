class BusinessTypeTemplate {

  const BusinessTypeTemplate({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.icon,
    required this.templateJson,
    this.sampleProductsJson,
    this.isActive,
    this.displayOrder,
    this.createdAt,
  });

  factory BusinessTypeTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeTemplate(
      id: json['id'] as String,
      code: json['code'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      icon: json['icon'] as String,
      templateJson: Map<String, dynamic>.from(json['template_json'] as Map),
      sampleProductsJson: json['sample_products_json'] != null ? Map<String, dynamic>.from(json['sample_products_json'] as Map) : null,
      isActive: json['is_active'] as bool?,
      displayOrder: (json['display_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String code;
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String icon;
  final Map<String, dynamic> templateJson;
  final Map<String, dynamic>? sampleProductsJson;
  final bool? isActive;
  final int? displayOrder;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'icon': icon,
      'template_json': templateJson,
      'sample_products_json': sampleProductsJson,
      'is_active': isActive,
      'display_order': displayOrder,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  BusinessTypeTemplate copyWith({
    String? id,
    String? code,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    String? icon,
    Map<String, dynamic>? templateJson,
    Map<String, dynamic>? sampleProductsJson,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return BusinessTypeTemplate(
      id: id ?? this.id,
      code: code ?? this.code,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      icon: icon ?? this.icon,
      templateJson: templateJson ?? this.templateJson,
      sampleProductsJson: sampleProductsJson ?? this.sampleProductsJson,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeTemplate(id: $id, code: $code, nameAr: $nameAr, nameEn: $nameEn, descriptionAr: $descriptionAr, descriptionEn: $descriptionEn, ...)';
}
