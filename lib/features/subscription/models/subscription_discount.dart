import 'package:wameedpos/features/promotions/enums/discount_type.dart';

class SubscriptionDiscount {
  final String id;
  final String code;
  final DiscountType type;
  final double value;
  final int? maxUses;
  final int? timesUsed;
  final DateTime? validFrom;
  final DateTime? validTo;
  final Map<String, dynamic>? applicablePlanIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionDiscount({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.maxUses,
    this.timesUsed,
    this.validFrom,
    this.validTo,
    this.applicablePlanIds,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionDiscount.fromJson(Map<String, dynamic> json) {
    return SubscriptionDiscount(
      id: json['id'] as String,
      code: json['code'] as String,
      type: DiscountType.fromValue(json['type'] as String),
      value: double.tryParse(json['value'].toString()) ?? 0.0,
      maxUses: (json['max_uses'] as num?)?.toInt(),
      timesUsed: (json['times_used'] as num?)?.toInt(),
      validFrom: json['valid_from'] != null ? DateTime.parse(json['valid_from'] as String) : null,
      validTo: json['valid_to'] != null ? DateTime.parse(json['valid_to'] as String) : null,
      applicablePlanIds: json['applicable_plan_ids'] != null
          ? Map<String, dynamic>.from(json['applicable_plan_ids'] as Map)
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'type': type.value,
      'value': value,
      'max_uses': maxUses,
      'times_used': timesUsed,
      'valid_from': validFrom?.toIso8601String(),
      'valid_to': validTo?.toIso8601String(),
      'applicable_plan_ids': applicablePlanIds,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SubscriptionDiscount copyWith({
    String? id,
    String? code,
    DiscountType? type,
    double? value,
    int? maxUses,
    int? timesUsed,
    DateTime? validFrom,
    DateTime? validTo,
    Map<String, dynamic>? applicablePlanIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionDiscount(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      value: value ?? this.value,
      maxUses: maxUses ?? this.maxUses,
      timesUsed: timesUsed ?? this.timesUsed,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      applicablePlanIds: applicablePlanIds ?? this.applicablePlanIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SubscriptionDiscount && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SubscriptionDiscount(id: $id, code: $code, type: $type, value: $value, maxUses: $maxUses, timesUsed: $timesUsed, ...)';
}
