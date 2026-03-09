import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';

class DeliveryPlatformConfig {
  final String id;
  final String storeId;
  final DeliveryConfigPlatform platform;
  final String apiKey;
  final String? merchantId;
  final String? webhookSecret;
  final String? branchIdOnPlatform;
  final bool? isEnabled;
  final bool? autoAccept;
  final int? throttleLimit;
  final DateTime? lastMenuSyncAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DeliveryPlatformConfig({
    required this.id,
    required this.storeId,
    required this.platform,
    required this.apiKey,
    this.merchantId,
    this.webhookSecret,
    this.branchIdOnPlatform,
    this.isEnabled,
    this.autoAccept,
    this.throttleLimit,
    this.lastMenuSyncAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryPlatformConfig.fromJson(Map<String, dynamic> json) {
    return DeliveryPlatformConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      platform: DeliveryConfigPlatform.fromValue(json['platform'] as String),
      apiKey: json['api_key'] as String,
      merchantId: json['merchant_id'] as String?,
      webhookSecret: json['webhook_secret'] as String?,
      branchIdOnPlatform: json['branch_id_on_platform'] as String?,
      isEnabled: json['is_enabled'] as bool?,
      autoAccept: json['auto_accept'] as bool?,
      throttleLimit: (json['throttle_limit'] as num?)?.toInt(),
      lastMenuSyncAt: json['last_menu_sync_at'] != null ? DateTime.parse(json['last_menu_sync_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'platform': platform.value,
      'api_key': apiKey,
      'merchant_id': merchantId,
      'webhook_secret': webhookSecret,
      'branch_id_on_platform': branchIdOnPlatform,
      'is_enabled': isEnabled,
      'auto_accept': autoAccept,
      'throttle_limit': throttleLimit,
      'last_menu_sync_at': lastMenuSyncAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DeliveryPlatformConfig copyWith({
    String? id,
    String? storeId,
    DeliveryConfigPlatform? platform,
    String? apiKey,
    String? merchantId,
    String? webhookSecret,
    String? branchIdOnPlatform,
    bool? isEnabled,
    bool? autoAccept,
    int? throttleLimit,
    DateTime? lastMenuSyncAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryPlatformConfig(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      platform: platform ?? this.platform,
      apiKey: apiKey ?? this.apiKey,
      merchantId: merchantId ?? this.merchantId,
      webhookSecret: webhookSecret ?? this.webhookSecret,
      branchIdOnPlatform: branchIdOnPlatform ?? this.branchIdOnPlatform,
      isEnabled: isEnabled ?? this.isEnabled,
      autoAccept: autoAccept ?? this.autoAccept,
      throttleLimit: throttleLimit ?? this.throttleLimit,
      lastMenuSyncAt: lastMenuSyncAt ?? this.lastMenuSyncAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryPlatformConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeliveryPlatformConfig(id: $id, storeId: $storeId, platform: $platform, apiKey: $apiKey, merchantId: $merchantId, webhookSecret: $webhookSecret, ...)';
}
