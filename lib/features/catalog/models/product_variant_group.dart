class ProductVariantGroup {

  const ProductVariantGroup({
    required this.id,
    required this.organizationId,
    required this.name,
    this.nameAr,
    this.createdAt,
  });

  factory ProductVariantGroup.fromJson(Map<String, dynamic> json) {
    return ProductVariantGroup(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String organizationId;
  final String name;
  final String? nameAr;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'name_ar': nameAr,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProductVariantGroup copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? nameAr,
    DateTime? createdAt,
  }) {
    return ProductVariantGroup(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantGroup && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductVariantGroup(id: $id, organizationId: $organizationId, name: $name, nameAr: $nameAr, createdAt: $createdAt)';
}
