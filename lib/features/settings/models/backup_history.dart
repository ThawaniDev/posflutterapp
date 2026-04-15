import 'package:wameedpos/features/settings/enums/backup_history_status.dart';
import 'package:wameedpos/features/settings/enums/backup_type.dart';

class BackupHistory {
  final String id;
  final String storeId;
  final String terminalId;
  final BackupType backupType;
  final String storageLocation;
  final String? localPath;
  final String? cloudKey;
  final int fileSizeBytes;
  final int dbVersion;
  final int? recordsCount;
  final bool? isVerified;
  final bool? isEncrypted;
  final BackupHistoryStatus? status;
  final String? errorMessage;
  final DateTime? createdAt;

  const BackupHistory({
    required this.id,
    required this.storeId,
    required this.terminalId,
    required this.backupType,
    required this.storageLocation,
    this.localPath,
    this.cloudKey,
    required this.fileSizeBytes,
    required this.dbVersion,
    this.recordsCount,
    this.isVerified,
    this.isEncrypted,
    this.status,
    this.errorMessage,
    this.createdAt,
  });

  factory BackupHistory.fromJson(Map<String, dynamic> json) {
    return BackupHistory(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String,
      backupType: BackupType.fromValue(json['backup_type'] as String),
      storageLocation: json['storage_location'] as String,
      localPath: json['local_path'] as String?,
      cloudKey: json['cloud_key'] as String?,
      fileSizeBytes: (json['file_size_bytes'] as num).toInt(),
      dbVersion: (json['db_version'] as num).toInt(),
      recordsCount: (json['records_count'] as num?)?.toInt(),
      isVerified: json['is_verified'] as bool?,
      isEncrypted: json['is_encrypted'] as bool?,
      status: BackupHistoryStatus.tryFromValue(json['status'] as String?),
      errorMessage: json['error_message'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'backup_type': backupType.value,
      'storage_location': storageLocation,
      'local_path': localPath,
      'cloud_key': cloudKey,
      'file_size_bytes': fileSizeBytes,
      'db_version': dbVersion,
      'records_count': recordsCount,
      'is_verified': isVerified,
      'is_encrypted': isEncrypted,
      'status': status?.value,
      'error_message': errorMessage,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  BackupHistory copyWith({
    String? id,
    String? storeId,
    String? terminalId,
    BackupType? backupType,
    String? storageLocation,
    String? localPath,
    String? cloudKey,
    int? fileSizeBytes,
    int? dbVersion,
    int? recordsCount,
    bool? isVerified,
    bool? isEncrypted,
    BackupHistoryStatus? status,
    String? errorMessage,
    DateTime? createdAt,
  }) {
    return BackupHistory(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      backupType: backupType ?? this.backupType,
      storageLocation: storageLocation ?? this.storageLocation,
      localPath: localPath ?? this.localPath,
      cloudKey: cloudKey ?? this.cloudKey,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      dbVersion: dbVersion ?? this.dbVersion,
      recordsCount: recordsCount ?? this.recordsCount,
      isVerified: isVerified ?? this.isVerified,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BackupHistory && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BackupHistory(id: $id, storeId: $storeId, terminalId: $terminalId, backupType: $backupType, storageLocation: $storageLocation, localPath: $localPath, ...)';
}
