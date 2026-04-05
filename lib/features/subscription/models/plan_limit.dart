class PlanLimit {
  final String id;
  final String subscriptionPlanId;
  final String limitKey;
  final int limitValue;
  final double? pricePerExtraUnit;

  const PlanLimit({
    required this.id,
    required this.subscriptionPlanId,
    required this.limitKey,
    required this.limitValue,
    this.pricePerExtraUnit,
  });

  factory PlanLimit.fromJson(Map<String, dynamic> json) {
    return PlanLimit(
      id: json['id'] as String,
      subscriptionPlanId: json['subscription_plan_id'] as String,
      limitKey: json['limit_key'] as String,
      limitValue: (json['limit_value'] as num).toInt(),
      pricePerExtraUnit: (json['price_per_extra_unit'] != null ? double.tryParse(json['price_per_extra_unit'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_plan_id': subscriptionPlanId,
      'limit_key': limitKey,
      'limit_value': limitValue,
      'price_per_extra_unit': pricePerExtraUnit,
    };
  }

  PlanLimit copyWith({
    String? id,
    String? subscriptionPlanId,
    String? limitKey,
    int? limitValue,
    double? pricePerExtraUnit,
  }) {
    return PlanLimit(
      id: id ?? this.id,
      subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      limitKey: limitKey ?? this.limitKey,
      limitValue: limitValue ?? this.limitValue,
      pricePerExtraUnit: pricePerExtraUnit ?? this.pricePerExtraUnit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanLimit && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlanLimit(id: $id, subscriptionPlanId: $subscriptionPlanId, limitKey: $limitKey, limitValue: $limitValue, pricePerExtraUnit: $pricePerExtraUnit)';
}
