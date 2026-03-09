import 'package:thawani_pos/features/delivery_integration/enums/delivery_auth_method.dart';

class DeliveryPlatform {
  final String id;
  final String name;
  final String slug;
  final String? logoUrl;
  final DeliveryAuthMethod authMethod;
  final bool? isActive;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DeliveryPlatform({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
    required this.authMethod,
    this.isActive,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryPlatform.fromJson(Map<String, dynamic> json) {
    return DeliveryPlatform(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logoUrl: json['logo_url'] as String?,
      authMethod: DeliveryAuthMethod.fromValue(json['auth_method'] as String),
      isActive: json['is_active'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo_url': logoUrl,
      'auth_method': authMethod.value,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DeliveryPlatform copyWith({
    String? id,
    String? name,
    String? slug,
    String? logoUrl,
    DeliveryAuthMethod? authMethod,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryPlatform(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      logoUrl: logoUrl ?? this.logoUrl,
      authMethod: authMethod ?? this.authMethod,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryPlatform && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeliveryPlatform(id: $id, name: $name, slug: $slug, logoUrl: $logoUrl, authMethod: $authMethod, isActive: $isActive, ...)';
}
