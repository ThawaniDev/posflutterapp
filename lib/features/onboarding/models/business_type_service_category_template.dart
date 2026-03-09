class BusinessTypeServiceCategoryTemplate {
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final int defaultDurationMinutes;
  final double? defaultPrice;
  final int? sortOrder;

  const BusinessTypeServiceCategoryTemplate({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    required this.defaultDurationMinutes,
    this.defaultPrice,
    this.sortOrder,
  });

  factory BusinessTypeServiceCategoryTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeServiceCategoryTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      defaultDurationMinutes: (json['default_duration_minutes'] as num).toInt(),
      defaultPrice: (json['default_price'] as num?)?.toDouble(),
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'default_duration_minutes': defaultDurationMinutes,
      'default_price': defaultPrice,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeServiceCategoryTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    int? defaultDurationMinutes,
    double? defaultPrice,
    int? sortOrder,
  }) {
    return BusinessTypeServiceCategoryTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      defaultDurationMinutes: defaultDurationMinutes ?? this.defaultDurationMinutes,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeServiceCategoryTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeServiceCategoryTemplate(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, defaultDurationMinutes: $defaultDurationMinutes, defaultPrice: $defaultPrice, ...)';
}
