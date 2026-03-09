class SystemSetting {
  final String id;
  final String key;
  final Map<String, dynamic> value;
  final String? description;
  final String? updatedBy;
  final DateTime? updatedAt;

  const SystemSetting({
    required this.id,
    required this.key,
    required this.value,
    this.description,
    this.updatedBy,
    this.updatedAt,
  });

  factory SystemSetting.fromJson(Map<String, dynamic> json) {
    return SystemSetting(
      id: json['id'] as String,
      key: json['key'] as String,
      value: Map<String, dynamic>.from(json['value'] as Map),
      description: json['description'] as String?,
      updatedBy: json['updated_by'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'value': value,
      'description': description,
      'updated_by': updatedBy,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SystemSetting copyWith({
    String? id,
    String? key,
    Map<String, dynamic>? value,
    String? description,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return SystemSetting(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      description: description ?? this.description,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemSetting && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SystemSetting(id: $id, key: $key, value: $value, description: $description, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}
