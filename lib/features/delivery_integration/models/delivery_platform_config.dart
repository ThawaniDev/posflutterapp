import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';

class DeliveryPlatformConfig {

  const DeliveryPlatformConfig({
    required this.id,
    required this.storeId,
    required this.platform,
    this.apiKey = '',
    this.merchantId,
    this.webhookSecret,
    this.branchIdOnPlatform,
    this.isEnabled = false,
    this.autoAccept = false,
    this.autoAcceptTimeoutSeconds = 300,
    this.throttleLimit,
    this.maxDailyOrders,
    this.dailyOrderCount = 0,
    this.syncMenuOnProductChange = false,
    this.menuSyncIntervalHours,
    this.operatingHoursSynced = false,
    this.operatingHoursJson,
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
      // api_key is intentionally hidden by the server for security; treat as always empty
      apiKey: '',
      merchantId: json['merchant_id'] as String?,
      webhookSecret: json['webhook_secret'] as String?,
      branchIdOnPlatform: json['branch_id_on_platform'] as String?,
      isEnabled: json['is_enabled'] as bool? ?? false,
      autoAccept: json['auto_accept'] as bool? ?? false,
      autoAcceptTimeoutSeconds: (json['auto_accept_timeout_seconds'] as num?)?.toInt() ?? 300,
      throttleLimit: (json['throttle_limit'] as num?)?.toInt(),
      maxDailyOrders: (json['max_daily_orders'] as num?)?.toInt(),
      dailyOrderCount: (json['daily_order_count'] as num?)?.toInt() ?? 0,
      syncMenuOnProductChange: json['sync_menu_on_product_change'] as bool? ?? false,
      menuSyncIntervalHours: (json['menu_sync_interval_hours'] as num?)?.toInt(),
      operatingHoursSynced: json['operating_hours_synced'] as bool? ?? false,
      operatingHoursJson: json['operating_hours_json'] != null
          ? List<Map<String, dynamic>>.from(
              (json['operating_hours_json'] as List).map((e) => Map<String, dynamic>.from(e as Map)),
            )
          : null,
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
  final String id;
  final String storeId;
  final DeliveryConfigPlatform platform;
  /// Always empty from server (hidden for security). Only populated locally before sending to API.
  final String apiKey;
  final String? merchantId;
  final String? webhookSecret;
  final String? branchIdOnPlatform;
  final bool isEnabled;
  final bool autoAccept;
  final int autoAcceptTimeoutSeconds;
  final int? throttleLimit;
  final int? maxDailyOrders;
  final int dailyOrderCount;
  final bool syncMenuOnProductChange;
  final int? menuSyncIntervalHours;
  final bool operatingHoursSynced;
  final List<Map<String, dynamic>>? operatingHoursJson;
  final String? webhookUrl;
  final String status;
  final DateTime? lastMenuSyncAt;
  final DateTime? lastOrderReceivedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'platform': platform.value,
      'merchant_id': merchantId,
      'webhook_secret': webhookSecret,
      'branch_id_on_platform': branchIdOnPlatform,
      'is_enabled': isEnabled,
      'auto_accept': autoAccept,
      'auto_accept_timeout_seconds': autoAcceptTimeoutSeconds,
      'throttle_limit': throttleLimit,
      'max_daily_orders': maxDailyOrders,
      'daily_order_count': dailyOrderCount,
      'sync_menu_on_product_change': syncMenuOnProductChange,
      'menu_sync_interval_hours': menuSyncIntervalHours,
      'operating_hours_synced': operatingHoursSynced,
      if (operatingHoursJson != null) 'operating_hours_json': operatingHoursJson,
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
      'DeliveryPlatformConfig(id: $id, storeId: $storeId, platform: $platform, merchantId: $merchantId, status: $status)';
}
