class PlanAddOn {
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final double monthlyPrice;
  final String? description;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlanAddOn({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.monthlyPrice,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PlanAddOn.fromJson(Map<String, dynamic> json) {
    return PlanAddOn(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      monthlyPrice: (json['monthly_price'] as num).toDouble(),
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'slug': slug,
      'monthly_price': monthlyPrice,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PlanAddOn copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    double? monthlyPrice,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlanAddOn(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanAddOn && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlanAddOn(id: $id, name: $name, nameAr: $nameAr, slug: $slug, monthlyPrice: $monthlyPrice, description: $description, ...)';
}
