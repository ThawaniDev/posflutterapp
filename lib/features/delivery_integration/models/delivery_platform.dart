import 'package:wameedpos/features/delivery_integration/enums/delivery_auth_method.dart';

class DeliveryPlatform {
  final String id;
  final String name;
  final String? nameAr;
  final String slug;
  final String? logoUrl;
  final String? description;
  final String? descriptionAr;
  final DeliveryAuthMethod authMethod;
  final String? apiType;
  final String? baseUrl;
  final String? documentationUrl;
  final List<String>? supportedCountries;
  final double? defaultCommissionPercent;
  final bool isActive;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DeliveryPlatform({
    required this.id,
    required this.name,
    this.nameAr,
    required this.slug,
    this.logoUrl,
    this.description,
    this.descriptionAr,
    required this.authMethod,
    this.apiType,
    this.baseUrl,
    this.documentationUrl,
    this.supportedCountries,
    this.defaultCommissionPercent,
    this.isActive = true,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryPlatform.fromJson(Map<String, dynamic> json) {
    return DeliveryPlatform(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      authMethod: DeliveryAuthMethod.fromValue(json['auth_method'] as String),
      apiType: json['api_type'] as String?,
      baseUrl: json['base_url'] as String?,
      documentationUrl: json['documentation_url'] as String?,
      supportedCountries: json['supported_countries'] != null ? List<String>.from(json['supported_countries'] as List) : null,
      defaultCommissionPercent: (json['default_commission_percent'] != null
          ? double.tryParse(json['default_commission_percent'].toString())
          : null),
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'slug': slug,
      'logo_url': logoUrl,
      'description': description,
      'description_ar': descriptionAr,
      'auth_method': authMethod.value,
      'api_type': apiType,
      'base_url': baseUrl,
      'documentation_url': documentationUrl,
      'supported_countries': supportedCountries,
      'default_commission_percent': defaultCommissionPercent,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeliveryPlatform && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
