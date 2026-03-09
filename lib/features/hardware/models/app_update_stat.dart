import 'package:thawani_pos/features/hardware/enums/app_update_status.dart';

class AppUpdateStat {
  final String id;
  final String storeId;
  final String appReleaseId;
  final AppUpdateStatus status;
  final String? errorMessage;
  final DateTime? updatedAt;

  const AppUpdateStat({
    required this.id,
    required this.storeId,
    required this.appReleaseId,
    required this.status,
    this.errorMessage,
    this.updatedAt,
  });

  factory AppUpdateStat.fromJson(Map<String, dynamic> json) {
    return AppUpdateStat(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      appReleaseId: json['app_release_id'] as String,
      status: AppUpdateStatus.fromValue(json['status'] as String),
      errorMessage: json['error_message'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'app_release_id': appReleaseId,
      'status': status.value,
      'error_message': errorMessage,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AppUpdateStat copyWith({
    String? id,
    String? storeId,
    String? appReleaseId,
    AppUpdateStatus? status,
    String? errorMessage,
    DateTime? updatedAt,
  }) {
    return AppUpdateStat(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      appReleaseId: appReleaseId ?? this.appReleaseId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUpdateStat && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppUpdateStat(id: $id, storeId: $storeId, appReleaseId: $appReleaseId, status: $status, errorMessage: $errorMessage, updatedAt: $updatedAt)';
}
