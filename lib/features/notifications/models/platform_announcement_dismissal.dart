class PlatformAnnouncementDismissal {

  const PlatformAnnouncementDismissal({
    required this.id,
    required this.announcementId,
    required this.storeId,
    this.dismissedAt,
  });

  factory PlatformAnnouncementDismissal.fromJson(Map<String, dynamic> json) {
    return PlatformAnnouncementDismissal(
      id: json['id'] as String,
      announcementId: json['announcement_id'] as String,
      storeId: json['store_id'] as String,
      dismissedAt: json['dismissed_at'] != null ? DateTime.parse(json['dismissed_at'] as String) : null,
    );
  }
  final String id;
  final String announcementId;
  final String storeId;
  final DateTime? dismissedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'announcement_id': announcementId,
      'store_id': storeId,
      'dismissed_at': dismissedAt?.toIso8601String(),
    };
  }

  PlatformAnnouncementDismissal copyWith({
    String? id,
    String? announcementId,
    String? storeId,
    DateTime? dismissedAt,
  }) {
    return PlatformAnnouncementDismissal(
      id: id ?? this.id,
      announcementId: announcementId ?? this.announcementId,
      storeId: storeId ?? this.storeId,
      dismissedAt: dismissedAt ?? this.dismissedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformAnnouncementDismissal && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlatformAnnouncementDismissal(id: $id, announcementId: $announcementId, storeId: $storeId, dismissedAt: $dismissedAt)';
}
