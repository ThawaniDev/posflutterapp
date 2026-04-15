import 'package:wameedpos/features/branches/enums/admin_role_slug.dart';

class AdminRole {
  final String id;
  final String name;
  final AdminRoleSlug slug;
  final String? description;
  final bool? isSystem;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminRole({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.isSystem,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminRole.fromJson(Map<String, dynamic> json) {
    return AdminRole(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: AdminRoleSlug.fromValue(json['slug'] as String),
      description: json['description'] as String?,
      isSystem: json['is_system'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug.value,
      'description': description,
      'is_system': isSystem,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AdminRole copyWith({
    String? id,
    String? name,
    AdminRoleSlug? slug,
    String? description,
    bool? isSystem,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminRole(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminRole && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AdminRole(id: $id, name: $name, slug: $slug, description: $description, isSystem: $isSystem, createdAt: $createdAt, ...)';
}
