import 'package:thawani_pos/features/customers/enums/loyalty_program_type.dart';

class BusinessTypeLoyaltyConfig {
  final String id;
  final String businessTypeId;
  final LoyaltyProgramType programType;
  final double? earningRate;
  final double? redemptionValue;
  final int? minRedemptionPoints;
  final int? stampsCardSize;
  final double? cashbackPercentage;
  final int? pointsExpiryDays;
  final bool? enableTiers;
  final Map<String, dynamic>? tierDefinitions;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessTypeLoyaltyConfig({
    required this.id,
    required this.businessTypeId,
    required this.programType,
    this.earningRate,
    this.redemptionValue,
    this.minRedemptionPoints,
    this.stampsCardSize,
    this.cashbackPercentage,
    this.pointsExpiryDays,
    this.enableTiers,
    this.tierDefinitions,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessTypeLoyaltyConfig.fromJson(Map<String, dynamic> json) {
    return BusinessTypeLoyaltyConfig(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      programType: LoyaltyProgramType.fromValue(json['program_type'] as String),
      earningRate: (json['earning_rate'] as num?)?.toDouble(),
      redemptionValue: (json['redemption_value'] as num?)?.toDouble(),
      minRedemptionPoints: (json['min_redemption_points'] as num?)?.toInt(),
      stampsCardSize: (json['stamps_card_size'] as num?)?.toInt(),
      cashbackPercentage: (json['cashback_percentage'] as num?)?.toDouble(),
      pointsExpiryDays: (json['points_expiry_days'] as num?)?.toInt(),
      enableTiers: json['enable_tiers'] as bool?,
      tierDefinitions: json['tier_definitions'] != null ? Map<String, dynamic>.from(json['tier_definitions'] as Map) : null,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'program_type': programType.value,
      'earning_rate': earningRate,
      'redemption_value': redemptionValue,
      'min_redemption_points': minRedemptionPoints,
      'stamps_card_size': stampsCardSize,
      'cashback_percentage': cashbackPercentage,
      'points_expiry_days': pointsExpiryDays,
      'enable_tiers': enableTiers,
      'tier_definitions': tierDefinitions,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BusinessTypeLoyaltyConfig copyWith({
    String? id,
    String? businessTypeId,
    LoyaltyProgramType? programType,
    double? earningRate,
    double? redemptionValue,
    int? minRedemptionPoints,
    int? stampsCardSize,
    double? cashbackPercentage,
    int? pointsExpiryDays,
    bool? enableTiers,
    Map<String, dynamic>? tierDefinitions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessTypeLoyaltyConfig(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      programType: programType ?? this.programType,
      earningRate: earningRate ?? this.earningRate,
      redemptionValue: redemptionValue ?? this.redemptionValue,
      minRedemptionPoints: minRedemptionPoints ?? this.minRedemptionPoints,
      stampsCardSize: stampsCardSize ?? this.stampsCardSize,
      cashbackPercentage: cashbackPercentage ?? this.cashbackPercentage,
      pointsExpiryDays: pointsExpiryDays ?? this.pointsExpiryDays,
      enableTiers: enableTiers ?? this.enableTiers,
      tierDefinitions: tierDefinitions ?? this.tierDefinitions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeLoyaltyConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeLoyaltyConfig(id: $id, businessTypeId: $businessTypeId, programType: $programType, earningRate: $earningRate, redemptionValue: $redemptionValue, minRedemptionPoints: $minRedemptionPoints, ...)';
}
