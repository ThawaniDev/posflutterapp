import 'package:wameedpos/features/sync/enums/sync_conflict_resolution.dart';

class SyncConflict {

  const SyncConflict({
    required this.id,
    required this.storeId,
    required this.tableName,
    required this.recordId,
    required this.localData,
    required this.cloudData,
    this.resolution,
    this.resolvedBy,
    this.detectedAt,
    this.resolvedAt,
  });

  factory SyncConflict.fromJson(Map<String, dynamic> json) {
    return SyncConflict(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      tableName: json['table_name'] as String,
      recordId: json['record_id'] as String,
      localData: json['local_data'] != null ? Map<String, dynamic>.from(json['local_data'] as Map) : {},
      cloudData: json['cloud_data'] != null ? Map<String, dynamic>.from(json['cloud_data'] as Map) : {},
      resolution: SyncConflictResolution.tryFromValue(json['resolution'] as String?),
      resolvedBy: json['resolved_by'] as String?,
      detectedAt: json['detected_at'] != null ? DateTime.parse(json['detected_at'] as String) : null,
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String tableName;
  final String recordId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> cloudData;
  final SyncConflictResolution? resolution;
  final String? resolvedBy;
  final DateTime? detectedAt;
  final DateTime? resolvedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'table_name': tableName,
      'record_id': recordId,
      'local_data': localData,
      'cloud_data': cloudData,
      'resolution': resolution?.value,
      'resolved_by': resolvedBy,
      'detected_at': detectedAt?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }
}
