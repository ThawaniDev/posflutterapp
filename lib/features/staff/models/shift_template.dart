class ShiftTemplate {

  const ShiftTemplate({
    required this.id,
    required this.storeId,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.breakDurationMinutes = 0,
    this.color,
    this.isActive = true,
    this.createdAt,
  });

  factory ShiftTemplate.fromJson(Map<String, dynamic> json) {
    return ShiftTemplate(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      breakDurationMinutes: (json['break_duration_minutes'] as num?)?.toInt() ?? 0,
      color: json['color'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String name;
  final String startTime;
  final String endTime;
  final int breakDurationMinutes;
  final String? color;
  final bool isActive;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'break_duration_minutes': breakDurationMinutes,
      'color': color,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ShiftTemplate copyWith({
    String? id,
    String? storeId,
    String? name,
    String? startTime,
    String? endTime,
    int? breakDurationMinutes,
    String? color,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ShiftTemplate(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakDurationMinutes: breakDurationMinutes ?? this.breakDurationMinutes,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ShiftTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ShiftTemplate(id: $id, storeId: $storeId, name: $name, startTime: $startTime, endTime: $endTime, color: $color, ...)';
}
