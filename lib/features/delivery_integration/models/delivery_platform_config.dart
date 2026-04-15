import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';

class DeliveryPlatformConfig {
  final String id;
  final String storeId;
  final DeliveryConfigPlatform platform;
  final String apiKey;
  final String? merchantId;
  final String? webhookSecret;
  final String? branchIdOnPlatform;
  final bool isEnabled;
  final bool autoAccept;
  final int? throttleLimit;
  final int? maxDailyOrders;
  final int dailyOrderCount;
  final bool syncMenuOnProductChange;
  final int? menuSyncIntervalHours;
  final bool operatingHoursSynced;
  final String? webhookUrl;
  final String status;
  final DateTime? lastMenuSyncAt;
  final DateTime? lastOrderReceivedAt;
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
    this.isEnabled = false,
    this.autoAccept = false,
    this.throttleLimit,
    this.maxDailyOrders,
    this.dailyOrderCount = 0,
    this.syncMenuOnProductChange = false,
    this.menuSyncIntervalHours,
    this.operatingHoursSynced = false,
    this.webhookUrl,
    this.status = 'pending',
    this.lastMenuSyncAt,
    this.lastOrderReceivedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryPlatformConfig.fromJson(Map<String, dynamic> json) {
    return DeliveryPlatformConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      platform: DeliveryConfigPlatform.fromValue(json['platform'] as String),
      apiKey: json['api_key'] as String? ?? '',
      merchantId: json['merchant_id'] as String?,
      webhookSecret: json['webhook_secret'] as String?,
      branchIdOnPlatform: json['branch_id_on_platform'] as String?,
      isEnabled: json['is_enabled'] as bool? ?? false,
      autoAccept: json['auto_accept'] as bool? ?? false,
      throttleLimit: (json['throttle_limit'] as num?)?.toInt(),
      maxDailyOrders: (json['max_daily_orders'] as num?)?.toInt(),
      dailyOrderCount: (json['daily_order_count'] as num?)?.toInt() ?? 0,
      syncMenuOnProductChange: json['sync_menu_on_product_change'] as bool? ?? false,
      menuSyncIntervalHours: (json['menu_sync_interval_hours'] as num?)?.toInt(),
      operatingHoursSynced: json['operating_hours_synced'] as bool? ?? false,
      webhookUrl: json['webhook_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      lastMenuSyncAt: json['last_menu_sync_at'] != null ? DateTime.parse(json['last_menu_sync_at'] as String) : null,
      lastOrderReceivedAt: json['last_order_received_at'] != null
          ? DateTime.parse(json['last_order_received_at'] as String)
          : null,
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
      'max_daily_orders': maxDailyOrders,
      'daily_order_count': dailyOrderCount,
      'sync_menu_on_product_change': syncMenuOnProductChange,
      'menu_sync_interval_hours': menuSyncIntervalHours,
      'operating_hours_synced': operatingHoursSynced,
      'webhook_url': webhookUrl,
      'status': status,
      'last_menu_sync_at': lastMenuSyncAt?.toIso8601String(),
      'last_order_received_at': lastOrderReceivedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeliveryPlatformConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'DeliveryPlatformConfig(id: $id, storeId: $storeId, platform: $platform, apiKey: $apiKey, merchantId: $merchantId, webhookSecret: $webhookSecret, ...)';
}
