class BusinessTypeIndustryConfig {

  const BusinessTypeIndustryConfig({
    required this.id,
    required this.businessTypeId,
    this.activeModules,
    this.defaultSettings,
    this.requiredProductFields,
  });

  factory BusinessTypeIndustryConfig.fromJson(Map<String, dynamic> json) {
    return BusinessTypeIndustryConfig(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      activeModules: json['active_modules'] != null ? (json['active_modules'] as List<dynamic>).map((e) => e as String).toList() : null,
      defaultSettings: json['default_settings'] != null ? Map<String, dynamic>.from(json['default_settings'] as Map) : null,
      requiredProductFields: json['required_product_fields'] != null ? Map<String, dynamic>.from(json['required_product_fields'] as Map) : null,
    );
  }
  final String id;
  final String businessTypeId;
  final List<String>? activeModules;
  final Map<String, dynamic>? defaultSettings;
  final Map<String, dynamic>? requiredProductFields;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'active_modules': activeModules,
      'default_settings': defaultSettings,
      'required_product_fields': requiredProductFields,
    };
  }

  BusinessTypeIndustryConfig copyWith({
    String? id,
    String? businessTypeId,
    List<String>? activeModules,
    Map<String, dynamic>? defaultSettings,
    Map<String, dynamic>? requiredProductFields,
  }) {
    return BusinessTypeIndustryConfig(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      activeModules: activeModules ?? this.activeModules,
      defaultSettings: defaultSettings ?? this.defaultSettings,
      requiredProductFields: requiredProductFields ?? this.requiredProductFields,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeIndustryConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeIndustryConfig(id: $id, businessTypeId: $businessTypeId, activeModules: $activeModules, defaultSettings: $defaultSettings, requiredProductFields: $requiredProductFields)';
}
