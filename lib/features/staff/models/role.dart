class Role {
  final int id;
  final String storeId;
  final String name;
  final String displayName;
  final String guardName;
  final bool? isPredefined;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Role({
    required this.id,
    required this.storeId,
    required this.name,
    required this.displayName,
    required this.guardName,
    this.isPredefined,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: (json['id'] as num).toInt(),
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      guardName: json['guard_name'] as String,
      isPredefined: json['is_predefined'] as bool?,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'display_name': displayName,
      'guard_name': guardName,
      'is_predefined': isPredefined,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Role copyWith({
    int? id,
    String? storeId,
    String? name,
    String? displayName,
    String? guardName,
    bool? isPredefined,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      guardName: guardName ?? this.guardName,
      isPredefined: isPredefined ?? this.isPredefined,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Role && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Role(id: $id, storeId: $storeId, name: $name, displayName: $displayName, guardName: $guardName, isPredefined: $isPredefined, ...)';
}
