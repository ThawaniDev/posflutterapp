class UpdateHistory {
  final int? id;
  final String fromVersion;
  final String toVersion;
  final String updateType; // full, delta, rollback
  final String status; // downloaded, installing, completed, failed, rolled_back
  final int? downloadSizeBytes;
  final String? backupId;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? completedAt;

  const UpdateHistory({
    this.id,
    required this.fromVersion,
    required this.toVersion,
    required this.updateType,
    required this.status,
    this.downloadSizeBytes,
    this.backupId,
    this.errorMessage,
    required this.startedAt,
    this.completedAt,
  });

  factory UpdateHistory.fromJson(Map<String, dynamic> json) {
    return UpdateHistory(
      id: json['id'] as int?,
      fromVersion: json['from_version'] as String,
      toVersion: json['to_version'] as String,
      updateType: json['update_type'] as String,
      status: json['status'] as String,
      downloadSizeBytes: json['download_size_bytes'] as int?,
      backupId: json['backup_id'] as String?,
      errorMessage: json['error_message'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'from_version': fromVersion,
      'to_version': toVersion,
      'update_type': updateType,
      'status': status,
      if (downloadSizeBytes != null) 'download_size_bytes': downloadSizeBytes,
      if (backupId != null) 'backup_id': backupId,
      if (errorMessage != null) 'error_message': errorMessage,
      'started_at': startedAt.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }

  UpdateHistory copyWith({
    int? id,
    String? fromVersion,
    String? toVersion,
    String? updateType,
    String? status,
    int? downloadSizeBytes,
    String? backupId,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return UpdateHistory(
      id: id ?? this.id,
      fromVersion: fromVersion ?? this.fromVersion,
      toVersion: toVersion ?? this.toVersion,
      updateType: updateType ?? this.updateType,
      status: status ?? this.status,
      downloadSizeBytes: downloadSizeBytes ?? this.downloadSizeBytes,
      backupId: backupId ?? this.backupId,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
