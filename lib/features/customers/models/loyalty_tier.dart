class LoyaltyTier {

  const LoyaltyTier({
    required this.id,
    required this.storeId,
    required this.tierNameAr,
    required this.tierNameEn,
    required this.tierOrder,
    required this.minPoints,
    this.benefits,
    this.iconUrl,
    this.createdAt,
  });

  factory LoyaltyTier.fromJson(Map<String, dynamic> json) {
    return LoyaltyTier(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      tierNameAr: json['tier_name_ar'] as String,
      tierNameEn: json['tier_name_en'] as String,
      tierOrder: (json['tier_order'] as num).toInt(),
      minPoints: (json['min_points'] as num).toInt(),
      benefits: json['benefits'] != null ? Map<String, dynamic>.from(json['benefits'] as Map) : null,
      iconUrl: json['icon_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String tierNameAr;
  final String tierNameEn;
  final int tierOrder;
  final int minPoints;
  final Map<String, dynamic>? benefits;
  final String? iconUrl;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'tier_name_ar': tierNameAr,
      'tier_name_en': tierNameEn,
      'tier_order': tierOrder,
      'min_points': minPoints,
      'benefits': benefits,
      'icon_url': iconUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  LoyaltyTier copyWith({
    String? id,
    String? storeId,
    String? tierNameAr,
    String? tierNameEn,
    int? tierOrder,
    int? minPoints,
    Map<String, dynamic>? benefits,
    String? iconUrl,
    DateTime? createdAt,
  }) {
    return LoyaltyTier(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      tierNameAr: tierNameAr ?? this.tierNameAr,
      tierNameEn: tierNameEn ?? this.tierNameEn,
      tierOrder: tierOrder ?? this.tierOrder,
      minPoints: minPoints ?? this.minPoints,
      benefits: benefits ?? this.benefits,
      iconUrl: iconUrl ?? this.iconUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyTier && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LoyaltyTier(id: $id, storeId: $storeId, tierNameAr: $tierNameAr, tierNameEn: $tierNameEn, tierOrder: $tierOrder, minPoints: $minPoints, ...)';
}
