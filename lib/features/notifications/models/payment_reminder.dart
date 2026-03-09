import 'package:thawani_pos/features/notifications/enums/reminder_channel.dart';
import 'package:thawani_pos/features/notifications/enums/reminder_type.dart';

class PaymentReminder {
  final String id;
  final String storeSubscriptionId;
  final ReminderType reminderType;
  final ReminderChannel channel;
  final DateTime? sentAt;

  const PaymentReminder({
    required this.id,
    required this.storeSubscriptionId,
    required this.reminderType,
    required this.channel,
    this.sentAt,
  });

  factory PaymentReminder.fromJson(Map<String, dynamic> json) {
    return PaymentReminder(
      id: json['id'] as String,
      storeSubscriptionId: json['store_subscription_id'] as String,
      reminderType: ReminderType.fromValue(json['reminder_type'] as String),
      channel: ReminderChannel.fromValue(json['channel'] as String),
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_subscription_id': storeSubscriptionId,
      'reminder_type': reminderType.value,
      'channel': channel.value,
      'sent_at': sentAt?.toIso8601String(),
    };
  }

  PaymentReminder copyWith({
    String? id,
    String? storeSubscriptionId,
    ReminderType? reminderType,
    ReminderChannel? channel,
    DateTime? sentAt,
  }) {
    return PaymentReminder(
      id: id ?? this.id,
      storeSubscriptionId: storeSubscriptionId ?? this.storeSubscriptionId,
      reminderType: reminderType ?? this.reminderType,
      channel: channel ?? this.channel,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentReminder && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PaymentReminder(id: $id, storeSubscriptionId: $storeSubscriptionId, reminderType: $reminderType, channel: $channel, sentAt: $sentAt)';
}
