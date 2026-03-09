import 'package:thawani_pos/features/notifications/enums/notification_channel.dart';

class NotificationTemplate {
  final String id;
  final String eventKey;
  final NotificationChannel channel;
  final String title;
  final String titleAr;
  final String body;
  final String bodyAr;
  final Map<String, dynamic> availableVariables;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationTemplate({
    required this.id,
    required this.eventKey,
    required this.channel,
    required this.title,
    required this.titleAr,
    required this.body,
    required this.bodyAr,
    required this.availableVariables,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationTemplate.fromJson(Map<String, dynamic> json) {
    return NotificationTemplate(
      id: json['id'] as String,
      eventKey: json['event_key'] as String,
      channel: NotificationChannel.fromValue(json['channel'] as String),
      title: json['title'] as String,
      titleAr: json['title_ar'] as String,
      body: json['body'] as String,
      bodyAr: json['body_ar'] as String,
      availableVariables: Map<String, dynamic>.from(json['available_variables'] as Map),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_key': eventKey,
      'channel': channel.value,
      'title': title,
      'title_ar': titleAr,
      'body': body,
      'body_ar': bodyAr,
      'available_variables': availableVariables,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NotificationTemplate copyWith({
    String? id,
    String? eventKey,
    NotificationChannel? channel,
    String? title,
    String? titleAr,
    String? body,
    String? bodyAr,
    Map<String, dynamic>? availableVariables,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationTemplate(
      id: id ?? this.id,
      eventKey: eventKey ?? this.eventKey,
      channel: channel ?? this.channel,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      body: body ?? this.body,
      bodyAr: bodyAr ?? this.bodyAr,
      availableVariables: availableVariables ?? this.availableVariables,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NotificationTemplate(id: $id, eventKey: $eventKey, channel: $channel, title: $title, titleAr: $titleAr, body: $body, ...)';
}
