class ProviderLimitOverride {

  const ProviderLimitOverride({
    required this.id,
    required this.storeId,
    required this.limitKey,
    required this.overrideValue,
    this.reason,
    required this.setBy,
    this.expiresAt,
    this.createdAt,
  });

  factory ProviderLimitOverride.fromJson(Map<String, dynamic> json) {
    return ProviderLimitOverride(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      limitKey: json['limit_key'] as String,
      overrideValue: (json['override_value'] as num).toInt(),
      reason: json['reason'] as String?,
      setBy: json['set_by'] as String,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String limitKey;
  final int overrideValue;
  final String? reason;
  final String setBy;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'limit_key': limitKey,
      'override_value': overrideValue,
      'reason': reason,
      'set_by': setBy,
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProviderLimitOverride copyWith({
    String? id,
    String? storeId,
    String? limitKey,
    int? overrideValue,
    String? reason,
    String? setBy,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return ProviderLimitOverride(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      limitKey: limitKey ?? this.limitKey,
      overrideValue: overrideValue ?? this.overrideValue,
      reason: reason ?? this.reason,
      setBy: setBy ?? this.setBy,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderLimitOverride && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProviderLimitOverride(id: $id, storeId: $storeId, limitKey: $limitKey, overrideValue: $overrideValue, reason: $reason, setBy: $setBy, ...)';
}
