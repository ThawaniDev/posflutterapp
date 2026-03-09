import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:thawani_pos/features/delivery_integration/enums/menu_sync_status.dart';

class DeliveryMenuSyncLog {
  final String id;
  final String storeId;
  final DeliveryConfigPlatform platform;
  final MenuSyncStatus status;
  final int? itemsSynced;
  final int? itemsFailed;
  final Map<String, dynamic>? errorDetails;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const DeliveryMenuSyncLog({
    required this.id,
    required this.storeId,
    required this.platform,
    required this.status,
    this.itemsSynced,
    this.itemsFailed,
    this.errorDetails,
    this.startedAt,
    this.completedAt,
  });

  factory DeliveryMenuSyncLog.fromJson(Map<String, dynamic> json) {
    return DeliveryMenuSyncLog(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      platform: DeliveryConfigPlatform.fromValue(json['platform'] as String),
      status: MenuSyncStatus.fromValue(json['status'] as String),
      itemsSynced: (json['items_synced'] as num?)?.toInt(),
      itemsFailed: (json['items_failed'] as num?)?.toInt(),
      errorDetails: json['error_details'] != null ? Map<String, dynamic>.from(json['error_details'] as Map) : null,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'platform': platform.value,
      'status': status.value,
      'items_synced': itemsSynced,
      'items_failed': itemsFailed,
      'error_details': errorDetails,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  DeliveryMenuSyncLog copyWith({
    String? id,
    String? storeId,
    DeliveryConfigPlatform? platform,
    MenuSyncStatus? status,
    int? itemsSynced,
    int? itemsFailed,
    Map<String, dynamic>? errorDetails,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return DeliveryMenuSyncLog(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      itemsSynced: itemsSynced ?? this.itemsSynced,
      itemsFailed: itemsFailed ?? this.itemsFailed,
      errorDetails: errorDetails ?? this.errorDetails,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryMenuSyncLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeliveryMenuSyncLog(id: $id, storeId: $storeId, platform: $platform, status: $status, itemsSynced: $itemsSynced, itemsFailed: $itemsFailed, ...)';
}
