class BusinessTypeGiftRegistryType {

  const BusinessTypeGiftRegistryType({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    this.description,
    this.icon,
    this.defaultExpiryDays,
    this.allowPublicSharing,
    this.allowPartialFulfilment,
    this.requireMinimumItems,
    this.minimumItemsCount,
    this.sortOrder,
  });

  factory BusinessTypeGiftRegistryType.fromJson(Map<String, dynamic> json) {
    return BusinessTypeGiftRegistryType(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      defaultExpiryDays: (json['default_expiry_days'] as num?)?.toInt(),
      allowPublicSharing: json['allow_public_sharing'] as bool?,
      allowPartialFulfilment: json['allow_partial_fulfilment'] as bool?,
      requireMinimumItems: json['require_minimum_items'] as bool?,
      minimumItemsCount: (json['minimum_items_count'] as num?)?.toInt(),
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final String? description;
  final String? icon;
  final int? defaultExpiryDays;
  final bool? allowPublicSharing;
  final bool? allowPartialFulfilment;
  final bool? requireMinimumItems;
  final int? minimumItemsCount;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'icon': icon,
      'default_expiry_days': defaultExpiryDays,
      'allow_public_sharing': allowPublicSharing,
      'allow_partial_fulfilment': allowPartialFulfilment,
      'require_minimum_items': requireMinimumItems,
      'minimum_items_count': minimumItemsCount,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeGiftRegistryType copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    String? description,
    String? icon,
    int? defaultExpiryDays,
    bool? allowPublicSharing,
    bool? allowPartialFulfilment,
    bool? requireMinimumItems,
    int? minimumItemsCount,
    int? sortOrder,
  }) {
    return BusinessTypeGiftRegistryType(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      defaultExpiryDays: defaultExpiryDays ?? this.defaultExpiryDays,
      allowPublicSharing: allowPublicSharing ?? this.allowPublicSharing,
      allowPartialFulfilment: allowPartialFulfilment ?? this.allowPartialFulfilment,
      requireMinimumItems: requireMinimumItems ?? this.requireMinimumItems,
      minimumItemsCount: minimumItemsCount ?? this.minimumItemsCount,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeGiftRegistryType && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeGiftRegistryType(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, description: $description, icon: $icon, ...)';
}
