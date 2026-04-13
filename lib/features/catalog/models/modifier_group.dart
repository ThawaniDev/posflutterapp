class ModifierGroup {
  final String id;
  final String? productId;
  final String name;
  final String? nameAr;
  final bool? isRequired;
  final int? minSelect;
  final int? maxSelect;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ModifierGroup({
    required this.id,
    this.productId,
    required this.name,
    this.nameAr,
    this.isRequired,
    this.minSelect,
    this.maxSelect,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ModifierGroup.fromJson(Map<String, dynamic> json) {
    return ModifierGroup(
      id: json['id'] as String,
      productId: json['product_id'] as String?,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      isRequired: json['is_required'] as bool?,
      minSelect: (json['min_select'] as num?)?.toInt(),
      maxSelect: (json['max_select'] as num?)?.toInt(),
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'name_ar': nameAr,
      'is_required': isRequired,
      'min_select': minSelect,
      'max_select': maxSelect,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ModifierGroup copyWith({
    String? id,
    String? productId,
    String? name,
    String? nameAr,
    bool? isRequired,
    int? minSelect,
    int? maxSelect,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ModifierGroup(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      isRequired: isRequired ?? this.isRequired,
      minSelect: minSelect ?? this.minSelect,
      maxSelect: maxSelect ?? this.maxSelect,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ModifierGroup && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ModifierGroup(id: $id, productId: $productId, name: $name, nameAr: $nameAr, isRequired: $isRequired, minSelect: $minSelect, ...)';
}
