import 'package:thawani_pos/features/settings/enums/database_backup_status.dart';
import 'package:thawani_pos/features/settings/enums/database_backup_type.dart';

class DatabaseBackup {
  final String id;
  final DatabaseBackupType backupType;
  final String filePath;
  final int? fileSizeBytes;
  final DatabaseBackupStatus status;
  final String? errorMessage;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const DatabaseBackup({
    required this.id,
    required this.backupType,
    required this.filePath,
    this.fileSizeBytes,
    required this.status,
    this.errorMessage,
    this.startedAt,
    this.completedAt,
  });

  factory DatabaseBackup.fromJson(Map<String, dynamic> json) {
    return DatabaseBackup(
      id: json['id'] as String,
      backupType: DatabaseBackupType.fromValue(json['backup_type'] as String),
      filePath: json['file_path'] as String,
      fileSizeBytes: (json['file_size_bytes'] as num?)?.toInt(),
      status: DatabaseBackupStatus.fromValue(json['status'] as String),
      errorMessage: json['error_message'] as String?,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'backup_type': backupType.value,
      'file_path': filePath,
      'file_size_bytes': fileSizeBytes,
      'status': status.value,
      'error_message': errorMessage,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  DatabaseBackup copyWith({
    String? id,
    DatabaseBackupType? backupType,
    String? filePath,
    int? fileSizeBytes,
    DatabaseBackupStatus? status,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return DatabaseBackup(
      id: id ?? this.id,
      backupType: backupType ?? this.backupType,
      filePath: filePath ?? this.filePath,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseBackup && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DatabaseBackup(id: $id, backupType: $backupType, filePath: $filePath, fileSizeBytes: $fileSizeBytes, status: $status, errorMessage: $errorMessage, ...)';
}
