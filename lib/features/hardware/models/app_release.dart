import 'package:thawani_pos/features/hardware/enums/app_release_channel.dart';
import 'package:thawani_pos/features/hardware/enums/app_release_platform.dart';
import 'package:thawani_pos/features/hardware/enums/app_submission_status.dart';

class AppRelease {
  final String id;
  final String versionNumber;
  final AppReleasePlatform platform;
  final AppReleaseChannel channel;
  final String downloadUrl;
  final String? storeUrl;
  final String? buildNumber;
  final AppSubmissionStatus? submissionStatus;
  final String? releaseNotes;
  final String? releaseNotesAr;
  final bool? isForceUpdate;
  final String? minSupportedVersion;
  final int rolloutPercentage;
  final bool? isActive;
  final DateTime? releasedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppRelease({
    required this.id,
    required this.versionNumber,
    required this.platform,
    required this.channel,
    required this.downloadUrl,
    this.storeUrl,
    this.buildNumber,
    this.submissionStatus,
    this.releaseNotes,
    this.releaseNotesAr,
    this.isForceUpdate,
    this.minSupportedVersion,
    required this.rolloutPercentage,
    this.isActive,
    this.releasedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AppRelease.fromJson(Map<String, dynamic> json) {
    return AppRelease(
      id: json['id'] as String,
      versionNumber: json['version_number'] as String,
      platform: AppReleasePlatform.fromValue(json['platform'] as String),
      channel: AppReleaseChannel.fromValue(json['channel'] as String),
      downloadUrl: json['download_url'] as String,
      storeUrl: json['store_url'] as String?,
      buildNumber: json['build_number'] as String?,
      submissionStatus: AppSubmissionStatus.tryFromValue(json['submission_status'] as String?),
      releaseNotes: json['release_notes'] as String?,
      releaseNotesAr: json['release_notes_ar'] as String?,
      isForceUpdate: json['is_force_update'] as bool?,
      minSupportedVersion: json['min_supported_version'] as String?,
      rolloutPercentage: (json['rollout_percentage'] as num).toInt(),
      isActive: json['is_active'] as bool?,
      releasedAt: json['released_at'] != null ? DateTime.parse(json['released_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version_number': versionNumber,
      'platform': platform.value,
      'channel': channel.value,
      'download_url': downloadUrl,
      'store_url': storeUrl,
      'build_number': buildNumber,
      'submission_status': submissionStatus?.value,
      'release_notes': releaseNotes,
      'release_notes_ar': releaseNotesAr,
      'is_force_update': isForceUpdate,
      'min_supported_version': minSupportedVersion,
      'rollout_percentage': rolloutPercentage,
      'is_active': isActive,
      'released_at': releasedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AppRelease copyWith({
    String? id,
    String? versionNumber,
    AppReleasePlatform? platform,
    AppReleaseChannel? channel,
    String? downloadUrl,
    String? storeUrl,
    String? buildNumber,
    AppSubmissionStatus? submissionStatus,
    String? releaseNotes,
    String? releaseNotesAr,
    bool? isForceUpdate,
    String? minSupportedVersion,
    int? rolloutPercentage,
    bool? isActive,
    DateTime? releasedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppRelease(
      id: id ?? this.id,
      versionNumber: versionNumber ?? this.versionNumber,
      platform: platform ?? this.platform,
      channel: channel ?? this.channel,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      storeUrl: storeUrl ?? this.storeUrl,
      buildNumber: buildNumber ?? this.buildNumber,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      releaseNotesAr: releaseNotesAr ?? this.releaseNotesAr,
      isForceUpdate: isForceUpdate ?? this.isForceUpdate,
      minSupportedVersion: minSupportedVersion ?? this.minSupportedVersion,
      rolloutPercentage: rolloutPercentage ?? this.rolloutPercentage,
      isActive: isActive ?? this.isActive,
      releasedAt: releasedAt ?? this.releasedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppRelease && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppRelease(id: $id, versionNumber: $versionNumber, platform: $platform, channel: $channel, downloadUrl: $downloadUrl, storeUrl: $storeUrl, ...)';
}
