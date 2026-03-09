import 'package:thawani_pos/features/notifications/enums/announcement_type.dart';

class PlatformAnnouncement {
  final String id;
  final AnnouncementType type;
  final String title;
  final String titleAr;
  final String body;
  final String bodyAr;
  final Map<String, dynamic> targetFilter;
  final DateTime displayStartAt;
  final DateTime displayEndAt;
  final bool? isBanner;
  final bool? sendPush;
  final bool? sendEmail;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlatformAnnouncement({
    required this.id,
    required this.type,
    required this.title,
    required this.titleAr,
    required this.body,
    required this.bodyAr,
    required this.targetFilter,
    required this.displayStartAt,
    required this.displayEndAt,
    this.isBanner,
    this.sendPush,
    this.sendEmail,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PlatformAnnouncement.fromJson(Map<String, dynamic> json) {
    return PlatformAnnouncement(
      id: json['id'] as String,
      type: AnnouncementType.fromValue(json['type'] as String),
      title: json['title'] as String,
      titleAr: json['title_ar'] as String,
      body: json['body'] as String,
      bodyAr: json['body_ar'] as String,
      targetFilter: Map<String, dynamic>.from(json['target_filter'] as Map),
      displayStartAt: DateTime.parse(json['display_start_at'] as String),
      displayEndAt: DateTime.parse(json['display_end_at'] as String),
      isBanner: json['is_banner'] as bool?,
      sendPush: json['send_push'] as bool?,
      sendEmail: json['send_email'] as bool?,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'title': title,
      'title_ar': titleAr,
      'body': body,
      'body_ar': bodyAr,
      'target_filter': targetFilter,
      'display_start_at': displayStartAt.toIso8601String(),
      'display_end_at': displayEndAt.toIso8601String(),
      'is_banner': isBanner,
      'send_push': sendPush,
      'send_email': sendEmail,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PlatformAnnouncement copyWith({
    String? id,
    AnnouncementType? type,
    String? title,
    String? titleAr,
    String? body,
    String? bodyAr,
    Map<String, dynamic>? targetFilter,
    DateTime? displayStartAt,
    DateTime? displayEndAt,
    bool? isBanner,
    bool? sendPush,
    bool? sendEmail,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlatformAnnouncement(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      body: body ?? this.body,
      bodyAr: bodyAr ?? this.bodyAr,
      targetFilter: targetFilter ?? this.targetFilter,
      displayStartAt: displayStartAt ?? this.displayStartAt,
      displayEndAt: displayEndAt ?? this.displayEndAt,
      isBanner: isBanner ?? this.isBanner,
      sendPush: sendPush ?? this.sendPush,
      sendEmail: sendEmail ?? this.sendEmail,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformAnnouncement && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlatformAnnouncement(id: $id, type: $type, title: $title, titleAr: $titleAr, body: $body, bodyAr: $bodyAr, ...)';
}
