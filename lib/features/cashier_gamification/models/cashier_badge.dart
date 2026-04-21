class CashierBadge {

  const CashierBadge({
    required this.id,
    required this.storeId,
    required this.slug,
    required this.nameEn,
    required this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    required this.icon,
    required this.color,
    required this.triggerType,
    required this.triggerThreshold,
    required this.period,
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory CashierBadge.fromJson(Map<String, dynamic> json) {
    return CashierBadge(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      slug: json['slug'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      icon: json['icon'] as String? ?? '🏅',
      color: json['color'] as String? ?? '#FD8209',
      triggerType: json['trigger_type'] as String,
      triggerThreshold: (json['trigger_threshold'] as num).toDouble(),
      period: json['period'] as String,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String slug;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String icon;
  final String color;
  final String triggerType;
  final double triggerThreshold;
  final String period;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name_en': nameEn,
      'name_ar': nameAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'icon': icon,
      'color': color,
      'trigger_type': triggerType,
      'trigger_threshold': triggerThreshold,
      'period': period,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CashierBadge && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
