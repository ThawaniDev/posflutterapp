class BackupScheduleSettings {
  const BackupScheduleSettings({
    required this.storeId,
    this.autoBackupEnabled = true,
    this.frequency = 'daily',
    this.retentionDays = 30,
    this.encryptBackups = false,
    this.localBackupEnabled = true,
    this.cloudBackupEnabled = true,
    this.backupHour = 2,
    this.totalBackups = 0,
    this.totalSizeBytes = 0,
    this.nextScheduled,
    this.lastBackup,
    this.lastAutoBackup,
  });

  factory BackupScheduleSettings.fromJson(Map<String, dynamic> json) {
    return BackupScheduleSettings(
      storeId: json['store_id'] as String? ?? '',
      autoBackupEnabled: json['auto_backup_enabled'] == true || json['auto_backup_enabled'] == 1,
      frequency: json['frequency'] as String? ?? 'daily',
      retentionDays: (json['retention_days'] as num?)?.toInt() ?? 30,
      encryptBackups: json['encrypt_backups'] == true || json['encrypt_backups'] == 1,
      localBackupEnabled: json['local_backup_enabled'] == true || json['local_backup_enabled'] == 1,
      cloudBackupEnabled: json['cloud_backup_enabled'] == true || json['cloud_backup_enabled'] == 1,
      backupHour: (json['backup_hour'] as num?)?.toInt() ?? 2,
      totalBackups: (json['total_backups'] as num?)?.toInt() ?? 0,
      totalSizeBytes: (json['total_size_bytes'] as num?)?.toInt() ?? 0,
      nextScheduled: json['next_scheduled'] != null ? DateTime.tryParse(json['next_scheduled'] as String) : null,
      lastBackup: json['last_backup'] as Map<String, dynamic>?,
      lastAutoBackup: json['last_auto_backup'] as Map<String, dynamic>?,
    );
  }

  final String storeId;
  final bool autoBackupEnabled;
  final String frequency;
  final int retentionDays;
  final bool encryptBackups;
  final bool localBackupEnabled;
  final bool cloudBackupEnabled;
  final int backupHour;
  final int totalBackups;
  final int totalSizeBytes;
  final DateTime? nextScheduled;
  final Map<String, dynamic>? lastBackup;
  final Map<String, dynamic>? lastAutoBackup;

  BackupScheduleSettings copyWith({
    String? storeId,
    bool? autoBackupEnabled,
    String? frequency,
    int? retentionDays,
    bool? encryptBackups,
    bool? localBackupEnabled,
    bool? cloudBackupEnabled,
    int? backupHour,
    int? totalBackups,
    int? totalSizeBytes,
    DateTime? nextScheduled,
    Map<String, dynamic>? lastBackup,
    Map<String, dynamic>? lastAutoBackup,
  }) {
    return BackupScheduleSettings(
      storeId: storeId ?? this.storeId,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      frequency: frequency ?? this.frequency,
      retentionDays: retentionDays ?? this.retentionDays,
      encryptBackups: encryptBackups ?? this.encryptBackups,
      localBackupEnabled: localBackupEnabled ?? this.localBackupEnabled,
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
      backupHour: backupHour ?? this.backupHour,
      totalBackups: totalBackups ?? this.totalBackups,
      totalSizeBytes: totalSizeBytes ?? this.totalSizeBytes,
      nextScheduled: nextScheduled ?? this.nextScheduled,
      lastBackup: lastBackup ?? this.lastBackup,
      lastAutoBackup: lastAutoBackup ?? this.lastAutoBackup,
    );
  }
}
