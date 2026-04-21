class TemplateVersion {

  const TemplateVersion({
    required this.id,
    required this.canvasId,
    required this.versionNumber,
    this.label,
    required this.snapshot,
    this.createdBy,
    this.createdAt,
  });

  factory TemplateVersion.fromJson(Map<String, dynamic> json) {
    return TemplateVersion(
      id: json['id'] as String,
      canvasId: json['canvas_id'] as String,
      versionNumber: (json['version_number'] as num).toInt(),
      label: json['label'] as String?,
      snapshot: Map<String, dynamic>.from(json['snapshot'] as Map? ?? {}),
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String canvasId;
  final int versionNumber;
  final String? label;
  final Map<String, dynamic> snapshot;
  final String? createdBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'canvas_id': canvasId,
      'version_number': versionNumber,
      'label': label,
      'snapshot': snapshot,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is TemplateVersion && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
