import 'package:thawani_pos/features/notifications/enums/notification_channel.dart';

class NotificationPreference {
  final String id;
  final String userId;
  final String eventKey;
  final NotificationChannel channel;
  final bool? isEnabled;

  const NotificationPreference({
    required this.id,
    required this.userId,
    required this.eventKey,
    required this.channel,
    this.isEnabled,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      eventKey: json['event_key'] as String,
      channel: NotificationChannel.fromValue(json['channel'] as String),
      isEnabled: json['is_enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_key': eventKey,
      'channel': channel.value,
      'is_enabled': isEnabled,
    };
  }

  NotificationPreference copyWith({
    String? id,
    String? userId,
    String? eventKey,
    NotificationChannel? channel,
    bool? isEnabled,
  }) {
    return NotificationPreference(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventKey: eventKey ?? this.eventKey,
      channel: channel ?? this.channel,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreference && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NotificationPreference(id: $id, userId: $userId, eventKey: $eventKey, channel: $channel, isEnabled: $isEnabled)';
}
