import 'package:wameedpos/features/notifications/enums/notification_channel.dart';
import 'package:wameedpos/features/notifications/enums/notification_delivery_status.dart';

class NotificationEventLog {
  final String id;
  final String notificationId;
  final NotificationChannel channel;
  final NotificationDeliveryStatus status;
  final String? errorMessage;
  final DateTime? sentAt;

  const NotificationEventLog({
    required this.id,
    required this.notificationId,
    required this.channel,
    required this.status,
    this.errorMessage,
    this.sentAt,
  });

  factory NotificationEventLog.fromJson(Map<String, dynamic> json) {
    return NotificationEventLog(
      id: json['id'] as String,
      notificationId: json['notification_id'] as String,
      channel: NotificationChannel.fromValue(json['channel'] as String),
      status: NotificationDeliveryStatus.fromValue(json['status'] as String),
      errorMessage: json['error_message'] as String?,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_id': notificationId,
      'channel': channel.value,
      'status': status.value,
      'error_message': errorMessage,
      'sent_at': sentAt?.toIso8601String(),
    };
  }

  NotificationEventLog copyWith({
    String? id,
    String? notificationId,
    NotificationChannel? channel,
    NotificationDeliveryStatus? status,
    String? errorMessage,
    DateTime? sentAt,
  }) {
    return NotificationEventLog(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationEventLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'NotificationEventLog(id: $id, notificationId: $notificationId, channel: $channel, status: $status, errorMessage: $errorMessage, sentAt: $sentAt)';
}
