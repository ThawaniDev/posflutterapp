/// App release info exposed to provider apps (read-only).
class AppReleaseInfo {
  const AppReleaseInfo({
    required this.id,
    required this.versionNumber,
    required this.isForceUpdate,
    required this.rolloutPercentage,
    this.platform,
    this.channel,
    this.buildNumber,
    this.downloadUrl,
    this.storeUrl,
    this.releaseNotes,
    this.releaseNotesAr,
    this.minSupportedVersion,
    this.submissionStatus,
    this.releasedAt,
    this.createdAt,
  });

  factory AppReleaseInfo.fromJson(Map<String, dynamic> json) {
    return AppReleaseInfo(
      id: json['id'] as String,
      versionNumber: json['version_number'] as String,
      platform: json['platform'] as String?,
      channel: json['channel'] as String?,
      isForceUpdate: (json['is_force_update'] as bool?) ?? false,
      rolloutPercentage: (json['rollout_percentage'] as num?)?.toInt() ?? 0,
      buildNumber: json['build_number'] as String?,
      downloadUrl: json['download_url'] as String?,
      storeUrl: json['store_url'] as String?,
      releaseNotes: json['release_notes'] as String?,
      releaseNotesAr: json['release_notes_ar'] as String?,
      minSupportedVersion: json['min_supported_version'] as String?,
      submissionStatus: json['submission_status'] as String?,
      releasedAt: json['released_at'] != null ? DateTime.tryParse(json['released_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  final String id;
  final String versionNumber;
  final String? platform;
  final String? channel;
  final bool isForceUpdate;
  final int rolloutPercentage;
  final String? buildNumber;
  final String? downloadUrl;
  final String? storeUrl;
  final String? releaseNotes;
  final String? releaseNotesAr;
  final String? minSupportedVersion;
  final String? submissionStatus;
  final DateTime? releasedAt;
  final DateTime? createdAt;
}
