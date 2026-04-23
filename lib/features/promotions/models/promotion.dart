import 'package:wameedpos/features/promotions/enums/promotion_type.dart';

class BundleProductEntry {
  const BundleProductEntry({required this.productId, this.quantity = 1});
  final String productId;
  final int quantity;

  Map<String, dynamic> toJson() => {'product_id': productId, 'quantity': quantity};
}

class Promotion {
  const Promotion({
    required this.id,
    required this.organizationId,
    required this.name,
    this.description,
    required this.type,
    this.discountValue,
    this.buyQuantity,
    this.getQuantity,
    this.getDiscountPercent,
    this.bundlePrice,
    this.minOrderTotal,
    this.minItemQuantity,
    this.validFrom,
    this.validTo,
    this.activeDays = const [],
    this.activeTimeFrom,
    this.activeTimeTo,
    this.maxUses,
    this.maxUsesPerCustomer,
    this.isStackable,
    this.isActive,
    this.isCoupon,
    this.usageCount,
    this.syncVersion,
    this.createdAt,
    this.updatedAt,
    this.productIds = const [],
    this.categoryIds = const [],
    this.customerGroupIds = const [],
    this.bundleProducts = const [],
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: PromotionType.fromValue(json['type'] as String),
      discountValue: (json['discount_value'] != null ? double.tryParse(json['discount_value'].toString()) : null),
      buyQuantity: (json['buy_quantity'] as num?)?.toInt(),
      getQuantity: (json['get_quantity'] as num?)?.toInt(),
      getDiscountPercent: (json['get_discount_percent'] != null
          ? double.tryParse(json['get_discount_percent'].toString())
          : null),
      bundlePrice: (json['bundle_price'] != null ? double.tryParse(json['bundle_price'].toString()) : null),
      minOrderTotal: (json['min_order_total'] != null ? double.tryParse(json['min_order_total'].toString()) : null),
      minItemQuantity: (json['min_item_quantity'] as num?)?.toInt(),
      validFrom: json['valid_from'] != null ? DateTime.parse(json['valid_from'] as String) : null,
      validTo: json['valid_to'] != null ? DateTime.parse(json['valid_to'] as String) : null,
      activeDays: json['active_days'] != null ? List<String>.from(json['active_days'] as List) : const [],
      activeTimeFrom: json['active_time_from'] as String?,
      activeTimeTo: json['active_time_to'] as String?,
      maxUses: (json['max_uses'] as num?)?.toInt(),
      maxUsesPerCustomer: (json['max_uses_per_customer'] as num?)?.toInt(),
      isStackable: json['is_stackable'] as bool?,
      isActive: json['is_active'] as bool?,
      isCoupon: json['is_coupon'] as bool?,
      usageCount: (json['usage_count'] as num?)?.toInt(),
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      productIds: json['product_ids'] != null ? List<String>.from(json['product_ids'] as List) : const [],
      categoryIds: json['category_ids'] != null ? List<String>.from(json['category_ids'] as List) : const [],
      customerGroupIds: json['customer_group_ids'] != null ? List<String>.from(json['customer_group_ids'] as List) : const [],
      bundleProducts: json['bundle_products'] != null
          ? (json['bundle_products'] as List)
                .map(
                  (e) =>
                      BundleProductEntry(productId: e['product_id'] as String, quantity: (e['quantity'] as num?)?.toInt() ?? 1),
                )
                .toList()
          : const [],
    );
  }
  final String id;
  final String organizationId;
  final String name;
  final String? description;
  final PromotionType type;
  final double? discountValue;
  final int? buyQuantity;
  final int? getQuantity;
  final double? getDiscountPercent;
  final double? bundlePrice;
  final double? minOrderTotal;
  final int? minItemQuantity;
  final DateTime? validFrom;
  final DateTime? validTo;
  final List<String> activeDays;
  final String? activeTimeFrom;
  final String? activeTimeTo;
  final int? maxUses;
  final int? maxUsesPerCustomer;
  final bool? isStackable;
  final bool? isActive;
  final bool? isCoupon;
  final int? usageCount;
  final int? syncVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> productIds;
  final List<String> categoryIds;
  final List<String> customerGroupIds;
  final List<BundleProductEntry> bundleProducts;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'description': description,
      'type': type.value,
      'discount_value': discountValue,
      'buy_quantity': buyQuantity,
      'get_quantity': getQuantity,
      'get_discount_percent': getDiscountPercent,
      'bundle_price': bundlePrice,
      'min_order_total': minOrderTotal,
      'min_item_quantity': minItemQuantity,
      'valid_from': validFrom?.toIso8601String(),
      'valid_to': validTo?.toIso8601String(),
      'active_days': activeDays,
      'active_time_from': activeTimeFrom,
      'active_time_to': activeTimeTo,
      'max_uses': maxUses,
      'max_uses_per_customer': maxUsesPerCustomer,
      'is_stackable': isStackable,
      'is_active': isActive,
      'is_coupon': isCoupon,
      'usage_count': usageCount,
      'sync_version': syncVersion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Promotion copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? description,
    PromotionType? type,
    double? discountValue,
    int? buyQuantity,
    int? getQuantity,
    double? getDiscountPercent,
    double? bundlePrice,
    double? minOrderTotal,
    int? minItemQuantity,
    DateTime? validFrom,
    DateTime? validTo,
    List<String>? activeDays,
    String? activeTimeFrom,
    String? activeTimeTo,
    int? maxUses,
    int? maxUsesPerCustomer,
    bool? isStackable,
    bool? isActive,
    bool? isCoupon,
    int? usageCount,
    int? syncVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      discountValue: discountValue ?? this.discountValue,
      buyQuantity: buyQuantity ?? this.buyQuantity,
      getQuantity: getQuantity ?? this.getQuantity,
      getDiscountPercent: getDiscountPercent ?? this.getDiscountPercent,
      bundlePrice: bundlePrice ?? this.bundlePrice,
      minOrderTotal: minOrderTotal ?? this.minOrderTotal,
      minItemQuantity: minItemQuantity ?? this.minItemQuantity,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      activeDays: activeDays ?? this.activeDays,
      activeTimeFrom: activeTimeFrom ?? this.activeTimeFrom,
      activeTimeTo: activeTimeTo ?? this.activeTimeTo,
      maxUses: maxUses ?? this.maxUses,
      maxUsesPerCustomer: maxUsesPerCustomer ?? this.maxUsesPerCustomer,
      isStackable: isStackable ?? this.isStackable,
      isActive: isActive ?? this.isActive,
      isCoupon: isCoupon ?? this.isCoupon,
      usageCount: usageCount ?? this.usageCount,
      syncVersion: syncVersion ?? this.syncVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Promotion && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Promotion(id: $id, organizationId: $organizationId, name: $name, description: $description, type: $type, discountValue: $discountValue, ...)';
}
