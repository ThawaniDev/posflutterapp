class Recipe {
  final String id;
  final String organizationId;
  final String productId;
  final String? name;
  final String? description;
  final String? productName;
  final double yieldQuantity;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Recipe({
    required this.id,
    required this.organizationId,
    required this.productId,
    this.name,
    this.description,
    this.productName,
    required this.yieldQuantity,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      productName: (json['product'] as Map<String, dynamic>?)?['name'] as String?,
      yieldQuantity: (json['yield_quantity'] as num).toDouble(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'product_id': productId,
      'yield_quantity': yieldQuantity,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Recipe copyWith({
    String? id,
    String? organizationId,
    String? productId,
    String? name,
    String? description,
    String? productName,
    double? yieldQuantity,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      productName: productName ?? this.productName,
      yieldQuantity: yieldQuantity ?? this.yieldQuantity,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Recipe && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Recipe(id: $id, organizationId: $organizationId, productId: $productId, yieldQuantity: $yieldQuantity, isActive: $isActive, createdAt: $createdAt, ...)';
}
