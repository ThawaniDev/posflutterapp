import 'package:thawani_pos/features/branches/enums/business_type.dart';

class Organization {
  final String id;
  final String name;
  final String? nameAr;
  final String slug;
  final String? crNumber;
  final String? vatNumber;
  final BusinessType? businessType;
  final String? logoUrl;
  final String? country;
  final String? city;
  final String? address;
  final String? phone;
  final String? email;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Organization({
    required this.id,
    required this.name,
    this.nameAr,
    required this.slug,
    this.crNumber,
    this.vatNumber,
    this.businessType,
    this.logoUrl,
    this.country,
    this.city,
    this.address,
    this.phone,
    this.email,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String,
      crNumber: json['cr_number'] as String?,
      vatNumber: json['vat_number'] as String?,
      businessType: BusinessType.tryFromValue(json['business_type'] as String?),
      logoUrl: json['logo_url'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isActive: json['is_active'] as bool?,
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
      'cr_number': crNumber,
      'vat_number': vatNumber,
      'business_type': businessType?.value,
      'logo_url': logoUrl,
      'country': country,
      'city': city,
      'address': address,
      'phone': phone,
      'email': email,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Organization copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    String? crNumber,
    String? vatNumber,
    BusinessType? businessType,
    String? logoUrl,
    String? country,
    String? city,
    String? address,
    String? phone,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      crNumber: crNumber ?? this.crNumber,
      vatNumber: vatNumber ?? this.vatNumber,
      businessType: businessType ?? this.businessType,
      logoUrl: logoUrl ?? this.logoUrl,
      country: country ?? this.country,
      city: city ?? this.city,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Organization && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Organization(id: $id, name: $name, nameAr: $nameAr, slug: $slug, crNumber: $crNumber, vatNumber: $vatNumber, ...)';
}
