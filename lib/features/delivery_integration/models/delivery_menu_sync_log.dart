import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/enums/menu_sync_status.dart';

class DeliveryMenuSyncLog {

  const DeliveryMenuSyncLog({
    required this.id,
    required this.storeId,
    required this.platform,
    required this.status,
    this.itemsSynced,
    this.itemsFailed,
    this.errorDetails,
    this.triggeredBy,
    this.syncType,
    this.durationSeconds,
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
      triggeredBy: json['triggered_by'] as String?,
      syncType: json['sync_type'] as String?,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final DeliveryConfigPlatform platform;
  final MenuSyncStatus status;
  final int? itemsSynced;
  final int? itemsFailed;
  final Map<String, dynamic>? errorDetails;
  final String? triggeredBy;
  final String? syncType;
  final int? durationSeconds;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'platform': platform.value,
      'status': status.value,
      'items_synced': itemsSynced,
      'items_failed': itemsFailed,
      'error_details': errorDetails,
      'triggered_by': triggeredBy,
      'sync_type': syncType,
      'duration_seconds': durationSeconds,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeliveryMenuSyncLog && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
