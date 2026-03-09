class SignagePlaylist {
  final String id;
  final String storeId;
  final String name;
  final Map<String, dynamic> slides;
  final Map<String, dynamic>? schedule;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SignagePlaylist({
    required this.id,
    required this.storeId,
    required this.name,
    required this.slides,
    this.schedule,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory SignagePlaylist.fromJson(Map<String, dynamic> json) {
    return SignagePlaylist(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      slides: Map<String, dynamic>.from(json['slides'] as Map),
      schedule: json['schedule'] != null ? Map<String, dynamic>.from(json['schedule'] as Map) : null,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'slides': slides,
      'schedule': schedule,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SignagePlaylist copyWith({
    String? id,
    String? storeId,
    String? name,
    Map<String, dynamic>? slides,
    Map<String, dynamic>? schedule,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SignagePlaylist(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      slides: slides ?? this.slides,
      schedule: schedule ?? this.schedule,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignagePlaylist && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SignagePlaylist(id: $id, storeId: $storeId, name: $name, slides: $slides, schedule: $schedule, isActive: $isActive, ...)';
}
