class CfdConfiguration {
  final String id;
  final String storeId;
  final bool? isEnabled;
  final int? targetMonitor;
  final Map<String, dynamic>? themeConfig;
  final Map<String, dynamic>? idleContent;
  final int? idleRotationSeconds;
  final DateTime? updatedAt;

  const CfdConfiguration({
    required this.id,
    required this.storeId,
    this.isEnabled,
    this.targetMonitor,
    this.themeConfig,
    this.idleContent,
    this.idleRotationSeconds,
    this.updatedAt,
  });

  factory CfdConfiguration.fromJson(Map<String, dynamic> json) {
    return CfdConfiguration(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      isEnabled: json['is_enabled'] as bool?,
      targetMonitor: (json['target_monitor'] as num?)?.toInt(),
      themeConfig: json['theme_config'] != null ? Map<String, dynamic>.from(json['theme_config'] as Map) : null,
      idleContent: json['idle_content'] != null ? Map<String, dynamic>.from(json['idle_content'] as Map) : null,
      idleRotationSeconds: (json['idle_rotation_seconds'] as num?)?.toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'is_enabled': isEnabled,
      'target_monitor': targetMonitor,
      'theme_config': themeConfig,
      'idle_content': idleContent,
      'idle_rotation_seconds': idleRotationSeconds,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CfdConfiguration copyWith({
    String? id,
    String? storeId,
    bool? isEnabled,
    int? targetMonitor,
    Map<String, dynamic>? themeConfig,
    Map<String, dynamic>? idleContent,
    int? idleRotationSeconds,
    DateTime? updatedAt,
  }) {
    return CfdConfiguration(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      isEnabled: isEnabled ?? this.isEnabled,
      targetMonitor: targetMonitor ?? this.targetMonitor,
      themeConfig: themeConfig ?? this.themeConfig,
      idleContent: idleContent ?? this.idleContent,
      idleRotationSeconds: idleRotationSeconds ?? this.idleRotationSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CfdConfiguration && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CfdConfiguration(id: $id, storeId: $storeId, isEnabled: $isEnabled, targetMonitor: $targetMonitor, themeConfig: $themeConfig, idleContent: $idleContent, ...)';
}
