import 'package:thawani_pos/features/branches/enums/business_type.dart';

class Store {
  final String id;
  final String organizationId;
  final String name;
  final String? nameAr;
  final String slug;
  final String? branchCode;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? email;
  final String? timezone;
  final String? currency;
  final String? locale;
  final BusinessType? businessType;
  final bool? isActive;
  final bool? isMainBranch;
  final int? storageUsedMb;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Store({
    required this.id,
    required this.organizationId,
    required this.name,
    this.nameAr,
    required this.slug,
    this.branchCode,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.timezone,
    this.currency,
    this.locale,
    this.businessType,
    this.isActive,
    this.isMainBranch,
    this.storageUsedMb,
    this.createdAt,
    this.updatedAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String,
      branchCode: json['branch_code'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      timezone: json['timezone'] as String?,
      currency: json['currency'] as String?,
      locale: json['locale'] as String?,
      businessType: BusinessType.tryFromValue(json['business_type'] as String?),
      isActive: json['is_active'] as bool?,
      isMainBranch: json['is_main_branch'] as bool?,
      storageUsedMb: (json['storage_used_mb'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'name_ar': nameAr,
      'slug': slug,
      'branch_code': branchCode,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'timezone': timezone,
      'currency': currency,
      'locale': locale,
      'business_type': businessType?.value,
      'is_active': isActive,
      'is_main_branch': isMainBranch,
      'storage_used_mb': storageUsedMb,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Store copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? nameAr,
    String? slug,
    String? branchCode,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? timezone,
    String? currency,
    String? locale,
    BusinessType? businessType,
    bool? isActive,
    bool? isMainBranch,
    int? storageUsedMb,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Store(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      branchCode: branchCode ?? this.branchCode,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      locale: locale ?? this.locale,
      businessType: businessType ?? this.businessType,
      isActive: isActive ?? this.isActive,
      isMainBranch: isMainBranch ?? this.isMainBranch,
      storageUsedMb: storageUsedMb ?? this.storageUsedMb,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Store(id: $id, organizationId: $organizationId, name: $name, nameAr: $nameAr, slug: $slug, branchCode: $branchCode, ...)';
}
