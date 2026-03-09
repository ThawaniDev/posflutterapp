class CouponCode {
  final String id;
  final String promotionId;
  final String code;
  final int? maxUses;
  final int? usageCount;
  final bool? isActive;
  final DateTime? createdAt;

  const CouponCode({
    required this.id,
    required this.promotionId,
    required this.code,
    this.maxUses,
    this.usageCount,
    this.isActive,
    this.createdAt,
  });

  factory CouponCode.fromJson(Map<String, dynamic> json) {
    return CouponCode(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      code: json['code'] as String,
      maxUses: (json['max_uses'] as num?)?.toInt(),
      usageCount: (json['usage_count'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotion_id': promotionId,
      'code': code,
      'max_uses': maxUses,
      'usage_count': usageCount,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CouponCode copyWith({
    String? id,
    String? promotionId,
    String? code,
    int? maxUses,
    int? usageCount,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return CouponCode(
      id: id ?? this.id,
      promotionId: promotionId ?? this.promotionId,
      code: code ?? this.code,
      maxUses: maxUses ?? this.maxUses,
      usageCount: usageCount ?? this.usageCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponCode && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CouponCode(id: $id, promotionId: $promotionId, code: $code, maxUses: $maxUses, usageCount: $usageCount, isActive: $isActive, ...)';
}
