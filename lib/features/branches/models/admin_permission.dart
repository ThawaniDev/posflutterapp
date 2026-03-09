class AdminPermission {
  final String id;
  final String name;
  final String? description;
  final DateTime? createdAt;

  const AdminPermission({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
  });

  factory AdminPermission.fromJson(Map<String, dynamic> json) {
    return AdminPermission(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  AdminPermission copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return AdminPermission(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminPermission && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdminPermission(id: $id, name: $name, description: $description, createdAt: $createdAt)';
}
