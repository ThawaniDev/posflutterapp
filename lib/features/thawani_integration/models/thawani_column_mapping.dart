class ThawaniColumnMapping {
  final String id;
  final String entityType;
  final String thawaniField;
  final String wameedField;
  final String transformType;
  final Map<String, dynamic>? transformConfig;
  final bool isActive;

  const ThawaniColumnMapping({
    required this.id,
    required this.entityType,
    required this.thawaniField,
    required this.wameedField,
    required this.transformType,
    this.transformConfig,
    required this.isActive,
  });

  factory ThawaniColumnMapping.fromJson(Map<String, dynamic> json) {
    return ThawaniColumnMapping(
      id: json['id']?.toString() ?? '',
      entityType: json['entity_type'] as String? ?? '',
      thawaniField: json['thawani_field'] as String? ?? '',
      wameedField: json['wameed_field'] as String? ?? '',
      transformType: json['transform_type'] as String? ?? 'direct',
      transformConfig: json['transform_config'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
