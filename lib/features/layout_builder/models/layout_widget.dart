class LayoutWidget {
  final String id;
  final String name;
  final String description;
  final String category;
  final String componentKey;
  final Map<String, dynamic> defaultConfig;
  final int minWidth;
  final int minHeight;
  final int maxWidth;
  final int maxHeight;
  final String? iconUrl;
  final bool isActive;
  final DateTime? createdAt;

  const LayoutWidget({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.componentKey,
    required this.defaultConfig,
    this.minWidth = 1,
    this.minHeight = 1,
    this.maxWidth = 12,
    this.maxHeight = 12,
    this.iconUrl,
    this.isActive = true,
    this.createdAt,
  });

  factory LayoutWidget.fromJson(Map<String, dynamic> json) {
    return LayoutWidget(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String,
      componentKey: json['component_key'] as String,
      defaultConfig: Map<String, dynamic>.from(json['default_config'] as Map? ?? {}),
      minWidth: (json['min_width'] as num?)?.toInt() ?? 1,
      minHeight: (json['min_height'] as num?)?.toInt() ?? 1,
      maxWidth: (json['max_width'] as num?)?.toInt() ?? 12,
      maxHeight: (json['max_height'] as num?)?.toInt() ?? 12,
      iconUrl: json['icon_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'component_key': componentKey,
      'default_config': defaultConfig,
      'min_width': minWidth,
      'min_height': minHeight,
      'max_width': maxWidth,
      'max_height': maxHeight,
      'icon_url': iconUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is LayoutWidget && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LayoutWidget(id: $id, name: $name, category: $category)';
}
