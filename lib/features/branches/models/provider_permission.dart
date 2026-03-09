class ProviderPermission {
  final String id;
  final String name;
  final String? description;
  final String? descriptionAr;
  final bool? isActive;
  final DateTime? createdAt;

  const ProviderPermission({
    required this.id,
    required this.name,
    this.description,
    this.descriptionAr,
    this.isActive,
    this.createdAt,
  });

  factory ProviderPermission.fromJson(Map<String, dynamic> json) {
    return ProviderPermission(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'description_ar': descriptionAr,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProviderPermission copyWith({
    String? id,
    String? name,
    String? description,
    String? descriptionAr,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ProviderPermission(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderPermission && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProviderPermission(id: $id, name: $name, description: $description, descriptionAr: $descriptionAr, isActive: $isActive, createdAt: $createdAt)';
}
