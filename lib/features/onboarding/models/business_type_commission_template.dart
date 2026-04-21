import 'package:wameedpos/features/catalog/enums/business_commission_type.dart';
import 'package:wameedpos/features/staff/enums/commission_applies_to.dart';

class BusinessTypeCommissionTemplate {

  const BusinessTypeCommissionTemplate({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    required this.commissionType,
    this.value,
    this.appliesTo,
    this.tierThresholds,
    this.sortOrder,
  });

  factory BusinessTypeCommissionTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeCommissionTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      commissionType: BusinessCommissionType.fromValue(json['commission_type'] as String),
      value: (json['value'] != null ? double.tryParse(json['value'].toString()) : null),
      appliesTo: CommissionAppliesTo.tryFromValue(json['applies_to'] as String?),
      tierThresholds: json['tier_thresholds'] != null ? Map<String, dynamic>.from(json['tier_thresholds'] as Map) : null,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final BusinessCommissionType commissionType;
  final double? value;
  final CommissionAppliesTo? appliesTo;
  final Map<String, dynamic>? tierThresholds;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'commission_type': commissionType.value,
      'value': value,
      'applies_to': appliesTo?.value,
      'tier_thresholds': tierThresholds,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeCommissionTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    BusinessCommissionType? commissionType,
    double? value,
    CommissionAppliesTo? appliesTo,
    Map<String, dynamic>? tierThresholds,
    int? sortOrder,
  }) {
    return BusinessTypeCommissionTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      commissionType: commissionType ?? this.commissionType,
      value: value ?? this.value,
      appliesTo: appliesTo ?? this.appliesTo,
      tierThresholds: tierThresholds ?? this.tierThresholds,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessTypeCommissionTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BusinessTypeCommissionTemplate(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, commissionType: $commissionType, value: $value, ...)';
}
