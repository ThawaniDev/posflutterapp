import 'package:wameedpos/features/notifications/enums/notification_channel.dart';

class NotificationPreference {
  const NotificationPreference({
    required this.id,
    required this.userId,
    required this.eventKey,
    required this.channel,
    this.isEnabled,
    this.perCategoryChannels,
    this.soundEnabled,
    this.emailDigest,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.preferences,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? categoryChannels;
    if (json['per_category_channels'] != null) {
      final raw = Map<String, dynamic>.from(json['per_category_channels'] as Map);
      categoryChannels = raw.map((key, value) => MapEntry(key, (value as List).map((e) => e as String).toList()));
    }

    return NotificationPreference(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      eventKey: json['event_key'] as String? ?? '',
      channel: NotificationChannel.fromValue(json['channel'] as String? ?? 'in_app'),
      isEnabled: json['is_enabled'] as bool?,
      perCategoryChannels: categoryChannels,
      soundEnabled: json['sound_enabled'] as bool?,
      emailDigest: json['email_digest'] as String?,
      quietHoursStart: json['quiet_hours_start'] as String?,
      quietHoursEnd: json['quiet_hours_end'] as String?,
      preferences: json['preferences'] != null ? Map<String, dynamic>.from(json['preferences'] as Map) : null,
    );
  }
  final String id;
  final String userId;
  final String eventKey;
  final NotificationChannel channel;
  final bool? isEnabled;
  final Map<String, List<String>>? perCategoryChannels;
  final bool? soundEnabled;
  final String? emailDigest;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final Map<String, dynamic>? preferences;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_key': eventKey,
      'channel': channel.value,
      'is_enabled': isEnabled,
      if (perCategoryChannels != null) 'per_category_channels': perCategoryChannels,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (emailDigest != null) 'email_digest': emailDigest,
      if (quietHoursStart != null) 'quiet_hours_start': quietHoursStart,
      if (quietHoursEnd != null) 'quiet_hours_end': quietHoursEnd,
      if (preferences != null) 'preferences': preferences,
    };
  }

  NotificationPreference copyWith({
    String? id,
    String? userId,
    String? eventKey,
    NotificationChannel? channel,
    bool? isEnabled,
    Map<String, List<String>>? perCategoryChannels,
    bool? soundEnabled,
    String? emailDigest,
    String? quietHoursStart,
    String? quietHoursEnd,
    Map<String, dynamic>? preferences,
  }) {
    return NotificationPreference(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventKey: eventKey ?? this.eventKey,
      channel: channel ?? this.channel,
      isEnabled: isEnabled ?? this.isEnabled,
      perCategoryChannels: perCategoryChannels ?? this.perCategoryChannels,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      emailDigest: emailDigest ?? this.emailDigest,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationPreference && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'NotificationPreference(id: $id, userId: $userId, eventKey: $eventKey, channel: $channel, isEnabled: $isEnabled)';
}
