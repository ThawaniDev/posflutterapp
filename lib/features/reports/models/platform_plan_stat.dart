class PlatformPlanStat {

  const PlatformPlanStat({
    required this.id,
    required this.subscriptionPlanId,
    required this.date,
    required this.activeCount,
    required this.trialCount,
    required this.churnedCount,
    required this.mrr,
  });

  factory PlatformPlanStat.fromJson(Map<String, dynamic> json) {
    return PlatformPlanStat(
      id: json['id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
      date: DateTime.parse(json['date'] as String),
      activeCount: (json['active_count'] as num).toInt(),
      trialCount: (json['trial_count'] as num).toInt(),
      churnedCount: (json['churned_count'] as num).toInt(),
      mrr: double.tryParse(json['mrr'].toString()) ?? 0.0,
    );
  }
  final String id;
  final String subscriptionPlanId;
  final DateTime date;
  final int activeCount;
  final int trialCount;
  final int churnedCount;
  final double mrr;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_plan_id': subscriptionPlanId,
      'date': date.toIso8601String(),
      'active_count': activeCount,
      'trial_count': trialCount,
      'churned_count': churnedCount,
      'mrr': mrr,
    };
  }

  PlatformPlanStat copyWith({
    String? id,
    String? subscriptionPlanId,
    DateTime? date,
    int? activeCount,
    int? trialCount,
    int? churnedCount,
    double? mrr,
  }) {
    return PlatformPlanStat(
      id: id ?? this.id,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      date: date ?? this.date,
      activeCount: activeCount ?? this.activeCount,
      trialCount: trialCount ?? this.trialCount,
      churnedCount: churnedCount ?? this.churnedCount,
      mrr: mrr ?? this.mrr,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformPlanStat && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlatformPlanStat(id: $id, subscriptionPlanId: $subscriptionPlanId, date: $date, activeCount: $activeCount, trialCount: $trialCount, churnedCount: $churnedCount, ...)';
}
