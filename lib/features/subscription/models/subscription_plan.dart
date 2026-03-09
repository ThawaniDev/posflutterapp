class SubscriptionPlan {
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final double monthlyPrice;
  final double annualPrice;
  final int? trialDays;
  final int? gracePeriodDays;
  final bool? isActive;
  final bool? isHighlighted;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.monthlyPrice,
    required this.annualPrice,
    this.trialDays,
    this.gracePeriodDays,
    this.isActive,
    this.isHighlighted,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      monthlyPrice: (json['monthly_price'] as num).toDouble(),
      annualPrice: (json['annual_price'] as num).toDouble(),
      trialDays: (json['trial_days'] as num?)?.toInt(),
      gracePeriodDays: (json['grace_period_days'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      isHighlighted: json['is_highlighted'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
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
      'annual_price': annualPrice,
      'trial_days': trialDays,
      'grace_period_days': gracePeriodDays,
      'is_active': isActive,
      'is_highlighted': isHighlighted,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SubscriptionPlan copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    double? monthlyPrice,
    double? annualPrice,
    int? trialDays,
    int? gracePeriodDays,
    bool? isActive,
    bool? isHighlighted,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      annualPrice: annualPrice ?? this.annualPrice,
      trialDays: trialDays ?? this.trialDays,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      isActive: isActive ?? this.isActive,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionPlan && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SubscriptionPlan(id: $id, name: $name, nameAr: $nameAr, slug: $slug, monthlyPrice: $monthlyPrice, annualPrice: $annualPrice, ...)';
}
