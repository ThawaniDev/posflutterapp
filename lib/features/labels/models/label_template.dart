class LabelTemplate {
  final String id;
  final String organizationId;
  final String name;
  final double labelWidthMm;
  final double labelHeightMm;
  final Map<String, dynamic> layoutJson;
  final bool? isPreset;
  final bool? isDefault;
  final String? createdBy;
  final int? syncVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LabelTemplate({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.labelWidthMm,
    required this.labelHeightMm,
    required this.layoutJson,
    this.isPreset,
    this.isDefault,
    this.createdBy,
    this.syncVersion,
    this.createdAt,
    this.updatedAt,
  });

  factory LabelTemplate.fromJson(Map<String, dynamic> json) {
    return LabelTemplate(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      labelWidthMm: double.tryParse(json['label_width_mm'].toString()) ?? 0.0,
      labelHeightMm: double.tryParse(json['label_height_mm'].toString()) ?? 0.0,
      layoutJson: Map<String, dynamic>.from(json['layout_json'] as Map),
      isPreset: json['is_preset'] as bool?,
      isDefault: json['is_default'] as bool?,
      createdBy: json['created_by'] as String?,
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'label_width_mm': labelWidthMm,
      'label_height_mm': labelHeightMm,
      'layout_json': layoutJson,
      'is_preset': isPreset,
      'is_default': isDefault,
      'created_by': createdBy,
      'sync_version': syncVersion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  LabelTemplate copyWith({
    String? id,
    String? organizationId,
    String? name,
    double? labelWidthMm,
    double? labelHeightMm,
    Map<String, dynamic>? layoutJson,
    bool? isPreset,
    bool? isDefault,
    String? createdBy,
    int? syncVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabelTemplate(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      labelWidthMm: labelWidthMm ?? this.labelWidthMm,
      labelHeightMm: labelHeightMm ?? this.labelHeightMm,
      layoutJson: layoutJson ?? this.layoutJson,
      isPreset: isPreset ?? this.isPreset,
      isDefault: isDefault ?? this.isDefault,
      createdBy: createdBy ?? this.createdBy,
      syncVersion: syncVersion ?? this.syncVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LabelTemplate(id: $id, organizationId: $organizationId, name: $name, labelWidthMm: $labelWidthMm, labelHeightMm: $labelHeightMm, layoutJson: $layoutJson, ...)';
}
