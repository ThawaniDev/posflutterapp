class WidgetPlacement {
  final String id;
  final String canvasId;
  final String widgetId;
  final int gridX;
  final int gridY;
  final int gridWidth;
  final int gridHeight;
  final int sortOrder;
  final Map<String, dynamic> config;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WidgetPlacement({
    required this.id,
    required this.canvasId,
    required this.widgetId,
    required this.gridX,
    required this.gridY,
    required this.gridWidth,
    required this.gridHeight,
    this.sortOrder = 0,
    required this.config,
    this.createdAt,
    this.updatedAt,
  });

  factory WidgetPlacement.fromJson(Map<String, dynamic> json) {
    return WidgetPlacement(
      id: json['id'] as String,
      canvasId: json['canvas_id'] as String,
      widgetId: json['widget_id'] as String,
      gridX: (json['grid_x'] as num).toInt(),
      gridY: (json['grid_y'] as num).toInt(),
      gridWidth: (json['grid_width'] as num).toInt(),
      gridHeight: (json['grid_height'] as num).toInt(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      config: Map<String, dynamic>.from(json['config'] as Map? ?? {}),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'canvas_id': canvasId,
      'widget_id': widgetId,
      'grid_x': gridX,
      'grid_y': gridY,
      'grid_width': gridWidth,
      'grid_height': gridHeight,
      'sort_order': sortOrder,
      'config': config,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  WidgetPlacement copyWith({
    String? id,
    String? canvasId,
    String? widgetId,
    int? gridX,
    int? gridY,
    int? gridWidth,
    int? gridHeight,
    int? sortOrder,
    Map<String, dynamic>? config,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WidgetPlacement(
      id: id ?? this.id,
      canvasId: canvasId ?? this.canvasId,
      widgetId: widgetId ?? this.widgetId,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
      gridWidth: gridWidth ?? this.gridWidth,
      gridHeight: gridHeight ?? this.gridHeight,
      sortOrder: sortOrder ?? this.sortOrder,
      config: config ?? this.config,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is WidgetPlacement && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
