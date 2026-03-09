class PaymentRetryRule {
  final String id;
  final int maxRetries;
  final int retryIntervalHours;
  final int gracePeriodAfterFailureDays;
  final DateTime? updatedAt;

  const PaymentRetryRule({
    required this.id,
    required this.maxRetries,
    required this.retryIntervalHours,
    required this.gracePeriodAfterFailureDays,
    this.updatedAt,
  });

  factory PaymentRetryRule.fromJson(Map<String, dynamic> json) {
    return PaymentRetryRule(
      id: json['id'] as String,
      maxRetries: (json['max_retries'] as num).toInt(),
      retryIntervalHours: (json['retry_interval_hours'] as num).toInt(),
      gracePeriodAfterFailureDays: (json['grace_period_after_failure_days'] as num).toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'max_retries': maxRetries,
      'retry_interval_hours': retryIntervalHours,
      'grace_period_after_failure_days': gracePeriodAfterFailureDays,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PaymentRetryRule copyWith({
    String? id,
    int? maxRetries,
    int? retryIntervalHours,
    int? gracePeriodAfterFailureDays,
    DateTime? updatedAt,
  }) {
    return PaymentRetryRule(
      id: id ?? this.id,
      maxRetries: maxRetries ?? this.maxRetries,
      retryIntervalHours: retryIntervalHours ?? this.retryIntervalHours,
      gracePeriodAfterFailureDays: gracePeriodAfterFailureDays ?? this.gracePeriodAfterFailureDays,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentRetryRule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PaymentRetryRule(id: $id, maxRetries: $maxRetries, retryIntervalHours: $retryIntervalHours, gracePeriodAfterFailureDays: $gracePeriodAfterFailureDays, updatedAt: $updatedAt)';
}
