class AppRelease {
  const AppRelease({
    required this.id,
    required this.versionNumber,
    required this.platform,
    required this.channel,
    this.downloadUrl,
    this.storeUrl,
    this.buildNumber,
    this.submissionStatus,
    this.releaseNotes,
    this.releaseNotesAr,
    this.isForceUpdate = false,
    this.minSupportedVersion,
    this.rolloutPercentage = 0,
    this.isActive = true,
    this.releasedAt,
    this.fileChecksum,
    this.fileSizeBytes,
    this.createdAt,
    this.updatedAt,
  });

  factory AppRelease.fromJson(Map<String, dynamic> json) {
    return AppRelease(
      id: json['id'] as String,
      versionNumber: json['version_number'] as String,
      platform: json['platform'] as String,
      channel: json['channel'] as String? ?? 'stable',
      downloadUrl: json['download_url'] as String?,
      storeUrl: json['store_url'] as String?,
      // build_number is stored as VARCHAR(20) in DB — accept both int and string
      buildNumber: json['build_number']?.toString(),
      submissionStatus: json['submission_status'] as String?,
      releaseNotes: json['release_notes'] as String?,
      releaseNotesAr: json['release_notes_ar'] as String?,
      isForceUpdate: json['is_force_update'] as bool? ?? false,
      minSupportedVersion: json['min_supported_version'] as String?,
      rolloutPercentage: json['rollout_percentage'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      releasedAt: json['released_at'] != null ? DateTime.parse(json['released_at'] as String) : null,
      fileChecksum: json['checksum'] as String? ?? json['file_checksum'] as String?,
      fileSizeBytes: json['file_size_bytes'] as int?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String versionNumber;
  final String platform;
  final String channel;
  final String? downloadUrl;
  final String? storeUrl;

  /// Stored as VARCHAR in DB — serialised as string to avoid parse errors.
  final String? buildNumber;
  final String? submissionStatus;
  final String? releaseNotes;
  final String? releaseNotesAr;
  final bool isForceUpdate;
  final String? minSupportedVersion;
  final int rolloutPercentage;
  final bool isActive;
  final DateTime? releasedAt;

  /// SHA-256 checksum of the binary (stored at upload time). Used by app to
  /// verify download integrity before installation.
  final String? fileChecksum;
  final int? fileSizeBytes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version_number': versionNumber,
      'platform': platform,
      'channel': channel,
      if (downloadUrl != null) 'download_url': downloadUrl,
      if (storeUrl != null) 'store_url': storeUrl,
      if (buildNumber != null) 'build_number': buildNumber,
      if (submissionStatus != null) 'submission_status': submissionStatus,
      if (releaseNotes != null) 'release_notes': releaseNotes,
      if (releaseNotesAr != null) 'release_notes_ar': releaseNotesAr,
      'is_force_update': isForceUpdate,
      if (minSupportedVersion != null) 'min_supported_version': minSupportedVersion,
      'rollout_percentage': rolloutPercentage,
      'is_active': isActive,
      if (releasedAt != null) 'released_at': releasedAt!.toIso8601String(),
      if (fileChecksum != null) 'checksum': fileChecksum,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
    };
  }
}
