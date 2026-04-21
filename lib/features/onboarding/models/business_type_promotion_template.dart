import 'package:wameedpos/features/catalog/enums/business_promotion_type.dart';
import 'package:wameedpos/features/promotions/enums/promotion_applies_to.dart';

class BusinessTypePromotionTemplate {

  const BusinessTypePromotionTemplate({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    this.description,
    required this.promotionType,
    this.discountValue,
    this.appliesTo,
    this.timeStart,
    this.timeEnd,
    this.activeDays,
    this.minimumOrder,
    this.sortOrder,
  });

  factory BusinessTypePromotionTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypePromotionTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      description: json['description'] as String?,
      promotionType: BusinessPromotionType.fromValue(json['promotion_type'] as String),
      discountValue: (json['discount_value'] != null ? double.tryParse(json['discount_value'].toString()) : null),
      appliesTo: PromotionAppliesTo.tryFromValue(json['applies_to'] as String?),
      timeStart: json['time_start'] as String?,
      timeEnd: json['time_end'] as String?,
      activeDays: json['active_days'] != null ? Map<String, dynamic>.from(json['active_days'] as Map) : null,
      minimumOrder: (json['minimum_order'] != null ? double.tryParse(json['minimum_order'].toString()) : null),
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final String? description;
  final BusinessPromotionType promotionType;
  final double? discountValue;
  final PromotionAppliesTo? appliesTo;
  final String? timeStart;
  final String? timeEnd;
  final Map<String, dynamic>? activeDays;
  final double? minimumOrder;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'promotion_type': promotionType.value,
      'discount_value': discountValue,
      'applies_to': appliesTo?.value,
      'time_start': timeStart,
      'time_end': timeEnd,
      'active_days': activeDays,
      'minimum_order': minimumOrder,
      'sort_order': sortOrder,
    };
  }

  BusinessTypePromotionTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    String? description,
    BusinessPromotionType? promotionType,
    double? discountValue,
    PromotionAppliesTo? appliesTo,
    String? timeStart,
    String? timeEnd,
    Map<String, dynamic>? activeDays,
    double? minimumOrder,
    int? sortOrder,
  }) {
    return BusinessTypePromotionTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      promotionType: promotionType ?? this.promotionType,
      discountValue: discountValue ?? this.discountValue,
      appliesTo: appliesTo ?? this.appliesTo,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      activeDays: activeDays ?? this.activeDays,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessTypePromotionTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BusinessTypePromotionTemplate(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, description: $description, promotionType: $promotionType, ...)';
}
