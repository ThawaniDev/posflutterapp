class FeatureFlag {

  const FeatureFlag({
    required this.id,
    required this.flagKey,
    this.isEnabled,
    this.rolloutPercentage,
    this.targetPlanIds,
    this.targetStoreIds,
    this.description,
    this.updatedAt,
  });

  factory FeatureFlag.fromJson(Map<String, dynamic> json) {
    return FeatureFlag(
      id: json['id'] as String,
      flagKey: json['flag_key'] as String,
      isEnabled: json['is_enabled'] as bool?,
      rolloutPercentage: (json['rollout_percentage'] as num?)?.toInt(),
      targetPlanIds: json['target_plan_ids'] != null ? Map<String, dynamic>.from(json['target_plan_ids'] as Map) : null,
      targetStoreIds: json['target_store_ids'] != null ? Map<String, dynamic>.from(json['target_store_ids'] as Map) : null,
      description: json['description'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String flagKey;
  final bool? isEnabled;
  final int? rolloutPercentage;
  final Map<String, dynamic>? targetPlanIds;
  final Map<String, dynamic>? targetStoreIds;
  final String? description;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flag_key': flagKey,
      'is_enabled': isEnabled,
      'rollout_percentage': rolloutPercentage,
      'target_plan_ids': targetPlanIds,
      'target_store_ids': targetStoreIds,
      'description': description,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  FeatureFlag copyWith({
    String? id,
    String? flagKey,
    bool? isEnabled,
    int? rolloutPercentage,
    Map<String, dynamic>? targetPlanIds,
    Map<String, dynamic>? targetStoreIds,
    String? description,
    DateTime? updatedAt,
  }) {
    return FeatureFlag(
      id: id ?? this.id,
      flagKey: flagKey ?? this.flagKey,
      isEnabled: isEnabled ?? this.isEnabled,
      rolloutPercentage: rolloutPercentage ?? this.rolloutPercentage,
      targetPlanIds: targetPlanIds ?? this.targetPlanIds,
      targetStoreIds: targetStoreIds ?? this.targetStoreIds,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureFlag && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FeatureFlag(id: $id, flagKey: $flagKey, isEnabled: $isEnabled, rolloutPercentage: $rolloutPercentage, targetPlanIds: $targetPlanIds, targetStoreIds: $targetStoreIds, ...)';
}
