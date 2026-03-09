class Theme {
  final String id;
  final String name;
  final String slug;
  final String primaryColor;
  final String secondaryColor;
  final String backgroundColor;
  final String textColor;
  final bool? isActive;
  final bool? isSystem;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Theme({
    required this.id,
    required this.name,
    required this.slug,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.isActive,
    this.isSystem,
    this.createdAt,
    this.updatedAt,
  });

  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      primaryColor: json['primary_color'] as String,
      secondaryColor: json['secondary_color'] as String,
      backgroundColor: json['background_color'] as String,
      textColor: json['text_color'] as String,
      isActive: json['is_active'] as bool?,
      isSystem: json['is_system'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'background_color': backgroundColor,
      'text_color': textColor,
      'is_active': isActive,
      'is_system': isSystem,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Theme copyWith({
    String? id,
    String? name,
    String? slug,
    String? primaryColor,
    String? secondaryColor,
    String? backgroundColor,
    String? textColor,
    bool? isActive,
    bool? isSystem,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Theme(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      isActive: isActive ?? this.isActive,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Theme && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Theme(id: $id, name: $name, slug: $slug, primaryColor: $primaryColor, secondaryColor: $secondaryColor, backgroundColor: $backgroundColor, ...)';
}
