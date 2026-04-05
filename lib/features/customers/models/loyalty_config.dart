class LoyaltyConfig {
  final String id;
  final String organizationId;
  final double? pointsPerSar;
  final double? sarPerPoint;
  final int? minRedemptionPoints;
  final int? pointsExpiryMonths;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LoyaltyConfig({
    required this.id,
    required this.organizationId,
    this.pointsPerSar,
    this.sarPerPoint,
    this.minRedemptionPoints,
    this.pointsExpiryMonths,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory LoyaltyConfig.fromJson(Map<String, dynamic> json) {
    return LoyaltyConfig(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      pointsPerSar: (json['points_per_sar'] != null ? double.tryParse(json['points_per_sar'].toString()) : null),
      sarPerPoint: (json['sar_per_point'] != null ? double.tryParse(json['sar_per_point'].toString()) : null),
      minRedemptionPoints: (json['min_redemption_points'] as num?)?.toInt(),
      pointsExpiryMonths: (json['points_expiry_months'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'points_per_sar': pointsPerSar,
      'sar_per_point': sarPerPoint,
      'min_redemption_points': minRedemptionPoints,
      'points_expiry_months': pointsExpiryMonths,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  LoyaltyConfig copyWith({
    String? id,
    String? organizationId,
    double? pointsPerSar,
    double? sarPerPoint,
    int? minRedemptionPoints,
    int? pointsExpiryMonths,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LoyaltyConfig(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      pointsPerSar: pointsPerSar ?? this.pointsPerSar,
      sarPerPoint: sarPerPoint ?? this.sarPerPoint,
      minRedemptionPoints: minRedemptionPoints ?? this.minRedemptionPoints,
      pointsExpiryMonths: pointsExpiryMonths ?? this.pointsExpiryMonths,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LoyaltyConfig(id: $id, organizationId: $organizationId, pointsPerSar: $pointsPerSar, sarPerPoint: $sarPerPoint, minRedemptionPoints: $minRedemptionPoints, pointsExpiryMonths: $pointsExpiryMonths, ...)';
}
