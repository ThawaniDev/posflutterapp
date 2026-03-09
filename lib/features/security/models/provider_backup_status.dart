import 'package:thawani_pos/features/branches/enums/provider_backup_status_enum.dart';

class ProviderBackupStatus {
  final String id;
  final String storeId;
  final String terminalId;
  final DateTime? lastSuccessfulSync;
  final DateTime? lastCloudBackup;
  final int? storageUsedBytes;
  final ProviderBackupStatusEnum? status;
  final DateTime? updatedAt;

  const ProviderBackupStatus({
    required this.id,
    required this.storeId,
    required this.terminalId,
    this.lastSuccessfulSync,
    this.lastCloudBackup,
    this.storageUsedBytes,
    this.status,
    this.updatedAt,
  });

  factory ProviderBackupStatus.fromJson(Map<String, dynamic> json) {
    return ProviderBackupStatus(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String,
      lastSuccessfulSync: json['last_successful_sync'] != null ? DateTime.parse(json['last_successful_sync'] as String) : null,
      lastCloudBackup: json['last_cloud_backup'] != null ? DateTime.parse(json['last_cloud_backup'] as String) : null,
      storageUsedBytes: (json['storage_used_bytes'] as num?)?.toInt(),
      status: ProviderBackupStatusEnum.tryFromValue(json['status'] as String?),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'last_successful_sync': lastSuccessfulSync?.toIso8601String(),
      'last_cloud_backup': lastCloudBackup?.toIso8601String(),
      'storage_used_bytes': storageUsedBytes,
      'status': status?.value,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProviderBackupStatus copyWith({
    String? id,
    String? storeId,
    String? terminalId,
    DateTime? lastSuccessfulSync,
    DateTime? lastCloudBackup,
    int? storageUsedBytes,
    ProviderBackupStatusEnum? status,
    DateTime? updatedAt,
  }) {
    return ProviderBackupStatus(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
      lastCloudBackup: lastCloudBackup ?? this.lastCloudBackup,
      storageUsedBytes: storageUsedBytes ?? this.storageUsedBytes,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderBackupStatus && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProviderBackupStatus(id: $id, storeId: $storeId, terminalId: $terminalId, lastSuccessfulSync: $lastSuccessfulSync, lastCloudBackup: $lastCloudBackup, storageUsedBytes: $storageUsedBytes, ...)';
}
