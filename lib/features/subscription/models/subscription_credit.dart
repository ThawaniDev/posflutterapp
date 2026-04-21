class SubscriptionCredit {

  const SubscriptionCredit({
    required this.id,
    required this.storeSubscriptionId,
    required this.appliedBy,
    required this.amount,
    required this.reason,
    this.appliedAt,
  });

  factory SubscriptionCredit.fromJson(Map<String, dynamic> json) {
    return SubscriptionCredit(
      id: json['id'] as String,
      storeSubscriptionId: json['store_subscription_id'] as String,
      appliedBy: json['applied_by'] as String,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      reason: json['reason'] as String,
      appliedAt: json['applied_at'] != null ? DateTime.parse(json['applied_at'] as String) : null,
    );
  }
  final String id;
  final String storeSubscriptionId;
  final String appliedBy;
  final double amount;
  final String reason;
  final DateTime? appliedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_subscription_id': storeSubscriptionId,
      'applied_by': appliedBy,
      'amount': amount,
      'reason': reason,
      'applied_at': appliedAt?.toIso8601String(),
    };
  }

  SubscriptionCredit copyWith({
    String? id,
    String? storeSubscriptionId,
    String? appliedBy,
    double? amount,
    String? reason,
    DateTime? appliedAt,
  }) {
    return SubscriptionCredit(
      id: id ?? this.id,
      storeSubscriptionId: storeSubscriptionId ?? this.storeSubscriptionId,
      appliedBy: appliedBy ?? this.appliedBy,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionCredit && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SubscriptionCredit(id: $id, storeSubscriptionId: $storeSubscriptionId, appliedBy: $appliedBy, amount: $amount, reason: $reason, appliedAt: $appliedAt)';
}
