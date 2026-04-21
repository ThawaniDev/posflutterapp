class UpdateRollout {

  const UpdateRollout({
    required this.id,
    required this.version,
    required this.rolloutPercentage,
    this.isCritical,
    this.targetStores,
    this.pinnedStores,
    required this.releaseNotes,
    this.releasedAt,
  });

  factory UpdateRollout.fromJson(Map<String, dynamic> json) {
    return UpdateRollout(
      id: json['id'] as String,
      version: json['version'] as String,
      rolloutPercentage: (json['rollout_percentage'] as num).toInt(),
      isCritical: json['is_critical'] as bool?,
      targetStores: json['target_stores'] != null ? Map<String, dynamic>.from(json['target_stores'] as Map) : null,
      pinnedStores: json['pinned_stores'] != null ? Map<String, dynamic>.from(json['pinned_stores'] as Map) : null,
      releaseNotes: json['release_notes'] as String,
      releasedAt: json['released_at'] != null ? DateTime.parse(json['released_at'] as String) : null,
    );
  }
  final String id;
  final String version;
  final int rolloutPercentage;
  final bool? isCritical;
  final Map<String, dynamic>? targetStores;
  final Map<String, dynamic>? pinnedStores;
  final String releaseNotes;
  final DateTime? releasedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'rollout_percentage': rolloutPercentage,
      'is_critical': isCritical,
      'target_stores': targetStores,
      'pinned_stores': pinnedStores,
      'release_notes': releaseNotes,
      'released_at': releasedAt?.toIso8601String(),
    };
  }

  UpdateRollout copyWith({
    String? id,
    String? version,
    int? rolloutPercentage,
    bool? isCritical,
    Map<String, dynamic>? targetStores,
    Map<String, dynamic>? pinnedStores,
    String? releaseNotes,
    DateTime? releasedAt,
  }) {
    return UpdateRollout(
      id: id ?? this.id,
      version: version ?? this.version,
      rolloutPercentage: rolloutPercentage ?? this.rolloutPercentage,
      isCritical: isCritical ?? this.isCritical,
      targetStores: targetStores ?? this.targetStores,
      pinnedStores: pinnedStores ?? this.pinnedStores,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      releasedAt: releasedAt ?? this.releasedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateRollout && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UpdateRollout(id: $id, version: $version, rolloutPercentage: $rolloutPercentage, isCritical: $isCritical, targetStores: $targetStores, pinnedStores: $pinnedStores, ...)';
}
