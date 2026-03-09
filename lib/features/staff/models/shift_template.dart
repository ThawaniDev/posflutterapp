class ShiftTemplate {
  final String id;
  final String storeId;
  final String name;
  final String startTime;
  final String endTime;
  final String? color;
  final DateTime? createdAt;

  const ShiftTemplate({
    required this.id,
    required this.storeId,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.color,
    this.createdAt,
  });

  factory ShiftTemplate.fromJson(Map<String, dynamic> json) {
    return ShiftTemplate(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      color: json['color'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'color': color,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ShiftTemplate copyWith({
    String? id,
    String? storeId,
    String? name,
    String? startTime,
    String? endTime,
    String? color,
    DateTime? createdAt,
  }) {
    return ShiftTemplate(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ShiftTemplate(id: $id, storeId: $storeId, name: $name, startTime: $startTime, endTime: $endTime, color: $color, ...)';
}
