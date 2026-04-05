class ModifierOption {
  final String id;
  final String modifierGroupId;
  final String name;
  final String? nameAr;
  final double? priceAdjustment;
  final bool? isDefault;
  final int? sortOrder;
  final bool? isActive;
  final DateTime? createdAt;

  const ModifierOption({
    required this.id,
    required this.modifierGroupId,
    required this.name,
    this.nameAr,
    this.priceAdjustment,
    this.isDefault,
    this.sortOrder,
    this.isActive,
    this.createdAt,
  });

  factory ModifierOption.fromJson(Map<String, dynamic> json) {
    return ModifierOption(
      id: json['id'] as String,
      modifierGroupId: json['modifier_group_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      priceAdjustment: (json['price_adjustment'] != null ? double.tryParse(json['price_adjustment'].toString()) : null),
      isDefault: json['is_default'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modifier_group_id': modifierGroupId,
      'name': name,
      'name_ar': nameAr,
      'price_adjustment': priceAdjustment,
      'is_default': isDefault,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ModifierOption copyWith({
    String? id,
    String? modifierGroupId,
    String? name,
    String? nameAr,
    double? priceAdjustment,
    bool? isDefault,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ModifierOption(
      id: id ?? this.id,
      modifierGroupId: modifierGroupId ?? this.modifierGroupId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      priceAdjustment: priceAdjustment ?? this.priceAdjustment,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifierOption && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ModifierOption(id: $id, modifierGroupId: $modifierGroupId, name: $name, nameAr: $nameAr, priceAdjustment: $priceAdjustment, isDefault: $isDefault, ...)';
}
