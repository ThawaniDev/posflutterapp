import 'package:wameedpos/features/delivery_integration/enums/delivery_sync_status.dart';

class StoreDeliveryPlatform {

  const StoreDeliveryPlatform({
    required this.id,
    required this.storeId,
    required this.deliveryPlatformId,
    required this.credentials,
    this.inboundApiKey,
    this.isEnabled,
    this.syncStatus,
    this.lastSyncAt,
    this.lastError,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreDeliveryPlatform.fromJson(Map<String, dynamic> json) {
    return StoreDeliveryPlatform(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      deliveryPlatformId: json['delivery_platform_id'] as String,
      credentials: Map<String, dynamic>.from(json['credentials'] as Map),
      inboundApiKey: json['inbound_api_key'] as String?,
      isEnabled: json['is_enabled'] as bool?,
      syncStatus: DeliverySyncStatus.tryFromValue(json['sync_status'] as String?),
      lastSyncAt: json['last_sync_at'] != null ? DateTime.parse(json['last_sync_at'] as String) : null,
      lastError: json['last_error'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String deliveryPlatformId;
  final Map<String, dynamic> credentials;
  final String? inboundApiKey;
  final bool? isEnabled;
  final DeliverySyncStatus? syncStatus;
  final DateTime? lastSyncAt;
  final String? lastError;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'delivery_platform_id': deliveryPlatformId,
      'credentials': credentials,
      'inbound_api_key': inboundApiKey,
      'is_enabled': isEnabled,
      'sync_status': syncStatus?.value,
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'last_error': lastError,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StoreDeliveryPlatform copyWith({
    String? id,
    String? storeId,
    String? deliveryPlatformId,
    Map<String, dynamic>? credentials,
    String? inboundApiKey,
    bool? isEnabled,
    DeliverySyncStatus? syncStatus,
    DateTime? lastSyncAt,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreDeliveryPlatform(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      deliveryPlatformId: deliveryPlatformId ?? this.deliveryPlatformId,
      credentials: credentials ?? this.credentials,
      inboundApiKey: inboundApiKey ?? this.inboundApiKey,
      isEnabled: isEnabled ?? this.isEnabled,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreDeliveryPlatform && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StoreDeliveryPlatform(id: $id, storeId: $storeId, deliveryPlatformId: $deliveryPlatformId, credentials: $credentials, inboundApiKey: $inboundApiKey, isEnabled: $isEnabled, ...)';
}
