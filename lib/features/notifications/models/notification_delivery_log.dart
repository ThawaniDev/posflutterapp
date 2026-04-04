import 'package:thawani_pos/features/notifications/enums/notification_channel.dart';
import 'package:thawani_pos/features/notifications/enums/notification_delivery_status.dart';

class NotificationDeliveryLog {
  final String id;
  final String? notificationId;
  final NotificationChannel channel;
  final String provider;
  final String recipient;
  final NotificationDeliveryStatus status;
  final String? providerMessageId;
  final String? errorMessage;
  final int? latencyMs;
  final bool? isFallback;
  final Map<String, dynamic>? attemptedProviders;
  final DateTime? createdAt;
  final int? retryCount;
  final DateTime? nextRetryAt;
  final Map<String, dynamic>? requestPayload;
  final Map<String, dynamic>? responsePayload;

  const NotificationDeliveryLog({
    required this.id,
    this.notificationId,
    required this.channel,
    required this.provider,
    required this.recipient,
    required this.status,
    this.providerMessageId,
    this.errorMessage,
    this.latencyMs,
    this.isFallback,
    this.attemptedProviders,
    this.createdAt,
    this.retryCount,
    this.nextRetryAt,
    this.requestPayload,
    this.responsePayload,
  });

  factory NotificationDeliveryLog.fromJson(Map<String, dynamic> json) {
    return NotificationDeliveryLog(
      id: json['id'] as String,
      notificationId: json['notification_id'] as String?,
      channel: NotificationChannel.fromValue(json['channel'] as String),
      provider: json['provider'] as String,
      recipient: json['recipient'] as String,
      status: NotificationDeliveryStatus.fromValue(json['status'] as String),
      providerMessageId: json['provider_message_id'] as String?,
      errorMessage: json['error_message'] as String?,
      latencyMs: (json['latency_ms'] as num?)?.toInt(),
      isFallback: json['is_fallback'] as bool?,
      attemptedProviders: json['attempted_providers'] != null
          ? Map<String, dynamic>.from(json['attempted_providers'] as Map)
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      retryCount: (json['retry_count'] as num?)?.toInt(),
      nextRetryAt: json['next_retry_at'] != null ? DateTime.parse(json['next_retry_at'] as String) : null,
      requestPayload: json['request_payload'] != null ? Map<String, dynamic>.from(json['request_payload'] as Map) : null,
      responsePayload: json['response_payload'] != null ? Map<String, dynamic>.from(json['response_payload'] as Map) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_id': notificationId,
      'channel': channel.value,
      'provider': provider,
      'recipient': recipient,
      'status': status.value,
      'provider_message_id': providerMessageId,
      'error_message': errorMessage,
      'latency_ms': latencyMs,
      'is_fallback': isFallback,
      'attempted_providers': attemptedProviders,
      'created_at': createdAt?.toIso8601String(),
      'retry_count': retryCount,
      'next_retry_at': nextRetryAt?.toIso8601String(),
      'request_payload': requestPayload,
      'response_payload': responsePayload,
    };
  }

  NotificationDeliveryLog copyWith({
    String? id,
    String? notificationId,
    NotificationChannel? channel,
    String? provider,
    String? recipient,
    NotificationDeliveryStatus? status,
    String? providerMessageId,
    String? errorMessage,
    int? latencyMs,
    bool? isFallback,
    Map<String, dynamic>? attemptedProviders,
    DateTime? createdAt,
    int? retryCount,
    DateTime? nextRetryAt,
    Map<String, dynamic>? requestPayload,
    Map<String, dynamic>? responsePayload,
  }) {
    return NotificationDeliveryLog(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      channel: channel ?? this.channel,
      provider: provider ?? this.provider,
      recipient: recipient ?? this.recipient,
      status: status ?? this.status,
      providerMessageId: providerMessageId ?? this.providerMessageId,
      errorMessage: errorMessage ?? this.errorMessage,
      latencyMs: latencyMs ?? this.latencyMs,
      isFallback: isFallback ?? this.isFallback,
      attemptedProviders: attemptedProviders ?? this.attemptedProviders,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      requestPayload: requestPayload ?? this.requestPayload,
      responsePayload: responsePayload ?? this.responsePayload,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationDeliveryLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'NotificationDeliveryLog(id: $id, notificationId: $notificationId, channel: $channel, provider: $provider, recipient: $recipient, status: $status, ...)';
}
