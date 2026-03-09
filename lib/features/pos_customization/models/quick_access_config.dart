class QuickAccessConfig {
  final String id;
  final String storeId;
  final int? gridRows;
  final int? gridCols;
  final Map<String, dynamic> buttonsJson;
  final int? syncVersion;
  final DateTime? updatedAt;

  const QuickAccessConfig({
    required this.id,
    required this.storeId,
    this.gridRows,
    this.gridCols,
    required this.buttonsJson,
    this.syncVersion,
    this.updatedAt,
  });

  factory QuickAccessConfig.fromJson(Map<String, dynamic> json) {
    return QuickAccessConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      gridRows: (json['grid_rows'] as num?)?.toInt(),
      gridCols: (json['grid_cols'] as num?)?.toInt(),
      buttonsJson: Map<String, dynamic>.from(json['buttons_json'] as Map),
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'grid_rows': gridRows,
      'grid_cols': gridCols,
      'buttons_json': buttonsJson,
      'sync_version': syncVersion,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  QuickAccessConfig copyWith({
    String? id,
    String? storeId,
    int? gridRows,
    int? gridCols,
    Map<String, dynamic>? buttonsJson,
    int? syncVersion,
    DateTime? updatedAt,
  }) {
    return QuickAccessConfig(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      gridRows: gridRows ?? this.gridRows,
      gridCols: gridCols ?? this.gridCols,
      buttonsJson: buttonsJson ?? this.buttonsJson,
      syncVersion: syncVersion ?? this.syncVersion,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickAccessConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'QuickAccessConfig(id: $id, storeId: $storeId, gridRows: $gridRows, gridCols: $gridCols, buttonsJson: $buttonsJson, syncVersion: $syncVersion, ...)';
}
