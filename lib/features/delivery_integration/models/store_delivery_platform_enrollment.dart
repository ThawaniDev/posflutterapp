class StoreDeliveryPlatformEnrollment {

  const StoreDeliveryPlatformEnrollment({
    required this.id,
    required this.storeId,
    required this.platformSlug,
    this.merchantIdOnPlatform,
    this.isEnabled,
    this.autoAccept,
    this.commissionOverride,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreDeliveryPlatformEnrollment.fromJson(Map<String, dynamic> json) {
    return StoreDeliveryPlatformEnrollment(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      platformSlug: json['platform_slug'] as String,
      merchantIdOnPlatform: json['merchant_id_on_platform'] as String?,
      isEnabled: json['is_enabled'] as bool?,
      autoAccept: json['auto_accept'] as bool?,
      commissionOverride: (json['commission_override'] != null ? double.tryParse(json['commission_override'].toString()) : null),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String platformSlug;
  final String? merchantIdOnPlatform;
  final bool? isEnabled;
  final bool? autoAccept;
  final double? commissionOverride;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'platform_slug': platformSlug,
      'merchant_id_on_platform': merchantIdOnPlatform,
      'is_enabled': isEnabled,
      'auto_accept': autoAccept,
      'commission_override': commissionOverride,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StoreDeliveryPlatformEnrollment copyWith({
    String? id,
    String? storeId,
    String? platformSlug,
    String? merchantIdOnPlatform,
    bool? isEnabled,
    bool? autoAccept,
    double? commissionOverride,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreDeliveryPlatformEnrollment(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      platformSlug: platformSlug ?? this.platformSlug,
      merchantIdOnPlatform: merchantIdOnPlatform ?? this.merchantIdOnPlatform,
      isEnabled: isEnabled ?? this.isEnabled,
      autoAccept: autoAccept ?? this.autoAccept,
      commissionOverride: commissionOverride ?? this.commissionOverride,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreDeliveryPlatformEnrollment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StoreDeliveryPlatformEnrollment(id: $id, storeId: $storeId, platformSlug: $platformSlug, merchantIdOnPlatform: $merchantIdOnPlatform, isEnabled: $isEnabled, autoAccept: $autoAccept, ...)';
}
