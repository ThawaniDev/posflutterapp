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
  });

  factory AppRelease.fromJson(Map<String, dynamic> json) {
    return AppRelease(
      id: json['id'] as String,
      versionNumber: json['version_number'] as String,
      platform: json['platform'] as String,
      channel: json['channel'] as String? ?? 'stable',
      downloadUrl: json['download_url'] as String?,
      storeUrl: json['store_url'] as String?,
      buildNumber: json['build_number'] as int?,
      submissionStatus: json['submission_status'] as String?,
      releaseNotes: json['release_notes'] as String?,
      releaseNotesAr: json['release_notes_ar'] as String?,
      isForceUpdate: json['is_force_update'] as bool? ?? false,
      minSupportedVersion: json['min_supported_version'] as String?,
      rolloutPercentage: json['rollout_percentage'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      releasedAt: json['released_at'] != null ? DateTime.parse(json['released_at'] as String) : null,
    );
  }
  final String id;
  final String versionNumber;
  final String platform;
  final String channel;
  final String? downloadUrl;
  final String? storeUrl;
  final int? buildNumber;
  final String? submissionStatus;
  final String? releaseNotes;
  final String? releaseNotesAr;
  final bool isForceUpdate;
  final String? minSupportedVersion;
  final int rolloutPercentage;
  final bool isActive;
  final DateTime? releasedAt;

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
    };
  }
}
