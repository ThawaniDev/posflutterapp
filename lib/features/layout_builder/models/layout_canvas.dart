class LayoutCanvas {

  const LayoutCanvas({
    required this.id,
    required this.storeId,
    required this.name,
    this.gridColumns = 12,
    this.gridRows = 8,
    this.themeOverrides = const {},
    this.isActive = true,
    this.version = 1,
    this.placements = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory LayoutCanvas.fromJson(Map<String, dynamic> json) {
    return LayoutCanvas(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      gridColumns: (json['grid_columns'] as num?)?.toInt() ?? 12,
      gridRows: (json['grid_rows'] as num?)?.toInt() ?? 8,
      themeOverrides: Map<String, dynamic>.from(json['theme_overrides'] as Map? ?? {}),
      isActive: json['is_active'] as bool? ?? true,
      version: (json['version'] as num?)?.toInt() ?? 1,
      placements: (json['placements'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String name;
  final int gridColumns;
  final int gridRows;
  final Map<String, dynamic> themeOverrides;
  final bool isActive;
  final int version;
  final List<Map<String, dynamic>> placements;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'grid_columns': gridColumns,
      'grid_rows': gridRows,
      'theme_overrides': themeOverrides,
      'is_active': isActive,
      'version': version,
      'placements': placements,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  LayoutCanvas copyWith({
    String? id,
    String? storeId,
    String? name,
    int? gridColumns,
    int? gridRows,
    Map<String, dynamic>? themeOverrides,
    bool? isActive,
    int? version,
    List<Map<String, dynamic>>? placements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LayoutCanvas(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      gridColumns: gridColumns ?? this.gridColumns,
      gridRows: gridRows ?? this.gridRows,
      themeOverrides: themeOverrides ?? this.themeOverrides,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      placements: placements ?? this.placements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is LayoutCanvas && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
