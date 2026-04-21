class DefaultRoleTemplate {

  const DefaultRoleTemplate({
    required this.id,
    required this.name,
    this.nameAr,
    required this.slug,
    this.description,
    this.descriptionAr,
    this.createdAt,
    this.updatedAt,
  });

  factory DefaultRoleTemplate.fromJson(Map<String, dynamic> json) {
    return DefaultRoleTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String name;
  final String? nameAr;
  final String slug;
  final String? description;
  final String? descriptionAr;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'slug': slug,
      'description': description,
      'description_ar': descriptionAr,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  DefaultRoleTemplate copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    String? description,
    String? descriptionAr,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DefaultRoleTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultRoleTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DefaultRoleTemplate(id: $id, name: $name, nameAr: $nameAr, slug: $slug, description: $description, descriptionAr: $descriptionAr, ...)';
}
