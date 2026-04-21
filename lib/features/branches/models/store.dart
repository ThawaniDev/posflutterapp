import 'package:wameedpos/features/branches/enums/business_type.dart';

class Store {

  const Store({
    required this.id,
    required this.organizationId,
    required this.name,
    this.nameAr,
    required this.slug,
    this.branchCode,
    this.description,
    this.descriptionAr,
    this.address,
    this.city,
    this.region,
    this.postalCode,
    this.country,
    this.googleMapsUrl,
    this.latitude,
    this.longitude,
    this.phone,
    this.secondaryPhone,
    this.email,
    this.contactPerson,
    this.managerId,
    this.manager,
    this.timezone,
    this.currency,
    this.locale,
    this.businessType,
    this.isActive = true,
    this.isMainBranch = false,
    this.isWarehouse = false,
    this.acceptsOnlineOrders = false,
    this.acceptsReservations = false,
    this.hasDelivery = false,
    this.hasPickup = false,
    this.openingDate,
    this.closingDate,
    this.maxRegisters,
    this.maxStaff,
    this.areaSqm,
    this.seatingCapacity,
    this.crNumber,
    this.vatNumber,
    this.municipalLicense,
    this.licenseExpiryDate,
    this.socialLinks,
    this.extraMetadata,
    this.logoUrl,
    this.coverImageUrl,
    this.internalNotes,
    this.sortOrder = 0,
    this.storageUsedMb,
    this.staffCount,
    this.registerCount,
    this.settings,
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
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      googleMapsUrl: json['google_maps_url'] as String?,
      latitude: double.tryParse(json['latitude'] as String? ?? ''),
      longitude: double.tryParse(json['longitude'] as String? ?? ''),
      phone: json['phone'] as String?,
      secondaryPhone: json['secondary_phone'] as String?,
      email: json['email'] as String?,
      contactPerson: json['contact_person'] as String?,
      managerId: json['manager_id'] as String?,
      manager: json['manager'] is Map ? json['manager'] as Map<String, dynamic> : null,
      timezone: json['timezone'] as String?,
      currency: json['currency'] as String?,
      locale: json['locale'] as String?,
      businessType: BusinessType.tryFromValue(json['business_type'] as String?),
      isActive: json['is_active'] as bool? ?? true,
      isMainBranch: json['is_main_branch'] as bool? ?? false,
      isWarehouse: json['is_warehouse'] as bool? ?? false,
      acceptsOnlineOrders: json['accepts_online_orders'] as bool? ?? false,
      acceptsReservations: json['accepts_reservations'] as bool? ?? false,
      hasDelivery: json['has_delivery'] as bool? ?? false,
      hasPickup: json['has_pickup'] as bool? ?? false,
      openingDate: json['opening_date'] as String?,
      closingDate: json['closing_date'] as String?,
      maxRegisters: (json['max_registers'] as num?)?.toInt(),
      maxStaff: (json['max_staff'] as num?)?.toInt(),
      areaSqm: (json['area_sqm'] != null ? double.tryParse(json['area_sqm'].toString()) : null),
      seatingCapacity: (json['seating_capacity'] as num?)?.toInt(),
      crNumber: json['cr_number'] as String?,
      vatNumber: json['vat_number'] as String?,
      municipalLicense: json['municipal_license'] as String?,
      licenseExpiryDate: json['license_expiry_date'] as String?,
      socialLinks: json['social_links'] is Map ? json['social_links'] as Map<String, dynamic> : null,
      extraMetadata: json['extra_metadata'] is Map ? json['extra_metadata'] as Map<String, dynamic> : null,
      logoUrl: json['logo_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      internalNotes: json['internal_notes'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      storageUsedMb: (json['storage_used_mb'] as num?)?.toInt(),
      staffCount: (json['staff_count'] as num?)?.toInt(),
      registerCount: (json['register_count'] as num?)?.toInt(),
      settings: json['settings'] is Map ? json['settings'] as Map<String, dynamic> : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String organizationId;
  final String name;
  final String? nameAr;
  final String slug;
  final String? branchCode;
  final String? description;
  final String? descriptionAr;
  final String? address;
  final String? city;
  final String? region;
  final String? postalCode;
  final String? country;
  final String? googleMapsUrl;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? secondaryPhone;
  final String? email;
  final String? contactPerson;
  final String? managerId;
  final Map<String, dynamic>? manager;
  final String? timezone;
  final String? currency;
  final String? locale;
  final BusinessType? businessType;
  final bool isActive;
  final bool isMainBranch;
  final bool isWarehouse;
  final bool acceptsOnlineOrders;
  final bool acceptsReservations;
  final bool hasDelivery;
  final bool hasPickup;
  final String? openingDate;
  final String? closingDate;
  final int? maxRegisters;
  final int? maxStaff;
  final double? areaSqm;
  final int? seatingCapacity;
  final String? crNumber;
  final String? vatNumber;
  final String? municipalLicense;
  final String? licenseExpiryDate;
  final Map<String, dynamic>? socialLinks;
  final Map<String, dynamic>? extraMetadata;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? internalNotes;
  final int sortOrder;
  final int? storageUsedMb;
  final int? staffCount;
  final int? registerCount;
  final Map<String, dynamic>? settings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (branchCode != null) 'branch_code': branchCode,
      if (description != null) 'description': description,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (region != null) 'region': region,
      if (postalCode != null) 'postal_code': postalCode,
      if (country != null) 'country': country,
      if (googleMapsUrl != null) 'google_maps_url': googleMapsUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (secondaryPhone != null) 'secondary_phone': secondaryPhone,
      if (email != null) 'email': email,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (managerId != null) 'manager_id': managerId,
      if (timezone != null) 'timezone': timezone,
      if (currency != null) 'currency': currency,
      if (locale != null) 'locale': locale,
      if (businessType != null) 'business_type': businessType?.value,
      'is_active': isActive,
      'is_main_branch': isMainBranch,
      'is_warehouse': isWarehouse,
      'accepts_online_orders': acceptsOnlineOrders,
      'accepts_reservations': acceptsReservations,
      'has_delivery': hasDelivery,
      'has_pickup': hasPickup,
      if (openingDate != null) 'opening_date': openingDate,
      if (closingDate != null) 'closing_date': closingDate,
      if (maxRegisters != null) 'max_registers': maxRegisters,
      if (maxStaff != null) 'max_staff': maxStaff,
      if (areaSqm != null) 'area_sqm': areaSqm,
      if (seatingCapacity != null) 'seating_capacity': seatingCapacity,
      if (crNumber != null) 'cr_number': crNumber,
      if (vatNumber != null) 'vat_number': vatNumber,
      if (municipalLicense != null) 'municipal_license': municipalLicense,
      if (licenseExpiryDate != null) 'license_expiry_date': licenseExpiryDate,
      if (socialLinks != null) 'social_links': socialLinks,
      if (extraMetadata != null) 'extra_metadata': extraMetadata,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (coverImageUrl != null) 'cover_image_url': coverImageUrl,
      if (internalNotes != null) 'internal_notes': internalNotes,
      'sort_order': sortOrder,
    };
  }

  Store copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? nameAr,
    String? slug,
    String? branchCode,
    String? description,
    String? descriptionAr,
    String? address,
    String? city,
    String? region,
    String? postalCode,
    String? country,
    String? googleMapsUrl,
    double? latitude,
    double? longitude,
    String? phone,
    String? secondaryPhone,
    String? email,
    String? contactPerson,
    String? managerId,
    Map<String, dynamic>? manager,
    String? timezone,
    String? currency,
    String? locale,
    BusinessType? businessType,
    bool? isActive,
    bool? isMainBranch,
    bool? isWarehouse,
    bool? acceptsOnlineOrders,
    bool? acceptsReservations,
    bool? hasDelivery,
    bool? hasPickup,
    String? openingDate,
    String? closingDate,
    int? maxRegisters,
    int? maxStaff,
    double? areaSqm,
    int? seatingCapacity,
    String? crNumber,
    String? vatNumber,
    String? municipalLicense,
    String? licenseExpiryDate,
    Map<String, dynamic>? socialLinks,
    Map<String, dynamic>? extraMetadata,
    String? logoUrl,
    String? coverImageUrl,
    String? internalNotes,
    int? sortOrder,
    int? storageUsedMb,
    int? staffCount,
    int? registerCount,
    Map<String, dynamic>? settings,
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
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      email: email ?? this.email,
      contactPerson: contactPerson ?? this.contactPerson,
      managerId: managerId ?? this.managerId,
      manager: manager ?? this.manager,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      locale: locale ?? this.locale,
      businessType: businessType ?? this.businessType,
      isActive: isActive ?? this.isActive,
      isMainBranch: isMainBranch ?? this.isMainBranch,
      isWarehouse: isWarehouse ?? this.isWarehouse,
      acceptsOnlineOrders: acceptsOnlineOrders ?? this.acceptsOnlineOrders,
      acceptsReservations: acceptsReservations ?? this.acceptsReservations,
      hasDelivery: hasDelivery ?? this.hasDelivery,
      hasPickup: hasPickup ?? this.hasPickup,
      openingDate: openingDate ?? this.openingDate,
      closingDate: closingDate ?? this.closingDate,
      maxRegisters: maxRegisters ?? this.maxRegisters,
      maxStaff: maxStaff ?? this.maxStaff,
      areaSqm: areaSqm ?? this.areaSqm,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      crNumber: crNumber ?? this.crNumber,
      vatNumber: vatNumber ?? this.vatNumber,
      municipalLicense: municipalLicense ?? this.municipalLicense,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      socialLinks: socialLinks ?? this.socialLinks,
      extraMetadata: extraMetadata ?? this.extraMetadata,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      internalNotes: internalNotes ?? this.internalNotes,
      sortOrder: sortOrder ?? this.sortOrder,
      storageUsedMb: storageUsedMb ?? this.storageUsedMb,
      staffCount: staffCount ?? this.staffCount,
      registerCount: registerCount ?? this.registerCount,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Store && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Store(id: $id, name: $name, isMainBranch: $isMainBranch, isActive: $isActive)';
}
