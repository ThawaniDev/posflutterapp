class SubscriptionPlan {
  final String id;
  final String name;
  final String? nameAr;
  final String? slug;
  final String? description;
  final String? descriptionAr;
  final double monthlyPrice;
  final double? annualPrice;
  final int? trialDays;
  final int? gracePeriodDays;
  final bool isActive;
  final bool isHighlighted;
  final int? sortOrder;
  final List<Map<String, dynamic>>? features;
  final List<Map<String, dynamic>>? limits;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    this.nameAr,
    this.slug,
    this.description,
    this.descriptionAr,
    required this.monthlyPrice,
    this.annualPrice,
    this.trialDays,
    this.gracePeriodDays,
    this.isActive = true,
    this.isHighlighted = false,
    this.sortOrder,
    this.features,
    this.limits,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      monthlyPrice: double.tryParse(json['monthly_price'].toString()) ?? 0.0,
      annualPrice: json['annual_price'] != null ? double.tryParse(json['annual_price'].toString()) ?? 0.0 : null,
      trialDays: (json['trial_days'] as num?)?.toInt(),
      gracePeriodDays: (json['grace_period_days'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      features: json['features'] != null
          ? (json['features'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList()
          : null,
      limits: json['limits'] != null ? (json['limits'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList() : null,
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
      'description': description,
      'description_ar': descriptionAr,
      'monthly_price': monthlyPrice,
      'annual_price': annualPrice,
      'trial_days': trialDays,
      'grace_period_days': gracePeriodDays,
      'is_active': isActive,
      'is_highlighted': isHighlighted,
      'sort_order': sortOrder,
      'features': features,
      'limits': limits,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    String? description,
    String? descriptionAr,
    double? monthlyPrice,
    double? annualPrice,
    int? trialDays,
    int? gracePeriodDays,
    bool? isActive,
    bool? isHighlighted,
    int? sortOrder,
    List<Map<String, dynamic>>? features,
    List<Map<String, dynamic>>? limits,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      annualPrice: annualPrice ?? this.annualPrice,
      trialDays: trialDays ?? this.trialDays,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      isActive: isActive ?? this.isActive,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      sortOrder: sortOrder ?? this.sortOrder,
      features: features ?? this.features,
      limits: limits ?? this.limits,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SubscriptionPlan && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SubscriptionPlan(id: $id, name: $name, monthlyPrice: $monthlyPrice)';
}
