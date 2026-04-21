class BackupHistory {

  const BackupHistory({
    required this.id,
    required this.storeId,
    this.terminalId,
    required this.backupType,
    this.storageLocation,
    this.localPath,
    this.cloudKey,
    this.fileSizeBytes = 0,
    this.checksum,
    this.dbVersion,
    this.recordsCount = 0,
    this.isVerified = false,
    this.isEncrypted = false,
    required this.status,
    this.errorMessage,
  });

  factory BackupHistory.fromJson(Map<String, dynamic> json) {
    return BackupHistory(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String?,
      backupType: json['backup_type'] as String,
      storageLocation: json['storage_location'] as String?,
      localPath: json['local_path'] as String?,
      cloudKey: json['cloud_key'] as String?,
      fileSizeBytes: (json['file_size_bytes'] as num?)?.toInt() ?? 0,
      checksum: json['checksum'] as String?,
      dbVersion: json['db_version'] as String?,
      recordsCount: (json['records_count'] as num?)?.toInt() ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      isEncrypted: json['is_encrypted'] as bool? ?? false,
      status: json['status'] as String,
      errorMessage: json['error_message'] as String?,
    );
  }
  final String id;
  final String storeId;
  final String? terminalId;
  final String backupType;
  final String? storageLocation;
  final String? localPath;
  final String? cloudKey;
  final int fileSizeBytes;
  final String? checksum;
  final String? dbVersion;
  final int recordsCount;
  final bool isVerified;
  final bool isEncrypted;
  final String status;
  final String? errorMessage;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'backup_type': backupType,
      'storage_location': storageLocation,
      'local_path': localPath,
      'cloud_key': cloudKey,
      'file_size_bytes': fileSizeBytes,
      'checksum': checksum,
      'db_version': dbVersion,
      'records_count': recordsCount,
      'is_verified': isVerified,
      'is_encrypted': isEncrypted,
      'status': status,
      'error_message': errorMessage,
    };
  }

  BackupHistory copyWith({
    String? id,
    String? storeId,
    String? terminalId,
    String? backupType,
    String? storageLocation,
    String? localPath,
    String? cloudKey,
    int? fileSizeBytes,
    String? checksum,
    String? dbVersion,
    int? recordsCount,
    bool? isVerified,
    bool? isEncrypted,
    String? status,
    String? errorMessage,
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
      checksum: checksum ?? this.checksum,
      dbVersion: dbVersion ?? this.dbVersion,
      recordsCount: recordsCount ?? this.recordsCount,
      isVerified: isVerified ?? this.isVerified,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BackupHistory && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
