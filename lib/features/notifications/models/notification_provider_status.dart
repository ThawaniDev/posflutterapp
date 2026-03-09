import 'package:thawani_pos/features/notifications/enums/notification_channel.dart';
import 'package:thawani_pos/features/notifications/enums/notification_provider.dart';

class NotificationProviderStatus {
  final String id;
  final NotificationProvider provider;
  final NotificationChannel channel;
  final bool? isEnabled;
  final int? priority;
  final bool? isHealthy;
  final DateTime? lastSuccessAt;
  final DateTime? lastFailureAt;
  final int? failureCount24h;
  final int? successCount24h;
  final int? avgLatencyMs;
  final String? disabledReason;
  final DateTime? updatedAt;

  const NotificationProviderStatus({
    required this.id,
    required this.provider,
    required this.channel,
    this.isEnabled,
    this.priority,
    this.isHealthy,
    this.lastSuccessAt,
    this.lastFailureAt,
    this.failureCount24h,
    this.successCount24h,
    this.avgLatencyMs,
    this.disabledReason,
    this.updatedAt,
  });

  factory NotificationProviderStatus.fromJson(Map<String, dynamic> json) {
    return NotificationProviderStatus(
      id: json['id'] as String,
      provider: NotificationProvider.fromValue(json['provider'] as String),
      channel: NotificationChannel.fromValue(json['channel'] as String),
      isEnabled: json['is_enabled'] as bool?,
      priority: (json['priority'] as num?)?.toInt(),
      isHealthy: json['is_healthy'] as bool?,
      lastSuccessAt: json['last_success_at'] != null ? DateTime.parse(json['last_success_at'] as String) : null,
      lastFailureAt: json['last_failure_at'] != null ? DateTime.parse(json['last_failure_at'] as String) : null,
      failureCount24h: (json['failure_count_24h'] as num?)?.toInt(),
      successCount24h: (json['success_count_24h'] as num?)?.toInt(),
      avgLatencyMs: (json['avg_latency_ms'] as num?)?.toInt(),
      disabledReason: json['disabled_reason'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider.value,
      'channel': channel.value,
      'is_enabled': isEnabled,
      'priority': priority,
      'is_healthy': isHealthy,
      'last_success_at': lastSuccessAt?.toIso8601String(),
      'last_failure_at': lastFailureAt?.toIso8601String(),
      'failure_count_24h': failureCount24h,
      'success_count_24h': successCount24h,
      'avg_latency_ms': avgLatencyMs,
      'disabled_reason': disabledReason,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NotificationProviderStatus copyWith({
    String? id,
    NotificationProvider? provider,
    NotificationChannel? channel,
    bool? isEnabled,
    int? priority,
    bool? isHealthy,
    DateTime? lastSuccessAt,
    DateTime? lastFailureAt,
    int? failureCount24h,
    int? successCount24h,
    int? avgLatencyMs,
    String? disabledReason,
    DateTime? updatedAt,
  }) {
    return NotificationProviderStatus(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      channel: channel ?? this.channel,
      isEnabled: isEnabled ?? this.isEnabled,
      priority: priority ?? this.priority,
      isHealthy: isHealthy ?? this.isHealthy,
      lastSuccessAt: lastSuccessAt ?? this.lastSuccessAt,
      lastFailureAt: lastFailureAt ?? this.lastFailureAt,
      failureCount24h: failureCount24h ?? this.failureCount24h,
      successCount24h: successCount24h ?? this.successCount24h,
      avgLatencyMs: avgLatencyMs ?? this.avgLatencyMs,
      disabledReason: disabledReason ?? this.disabledReason,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationProviderStatus && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NotificationProviderStatus(id: $id, provider: $provider, channel: $channel, isEnabled: $isEnabled, priority: $priority, isHealthy: $isHealthy, ...)';
}
