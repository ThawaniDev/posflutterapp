import 'package:wameedpos/features/customers/enums/waste_reason_category.dart';

class BusinessTypeWasteReasonTemplate {
  final String id;
  final String businessTypeId;
  final String reasonCode;
  final String name;
  final String nameAr;
  final WasteReasonCategory category;
  final String? description;
  final bool? requiresApproval;
  final bool? affectsCostReporting;
  final int? sortOrder;

  const BusinessTypeWasteReasonTemplate({
    required this.id,
    required this.businessTypeId,
    required this.reasonCode,
    required this.name,
    required this.nameAr,
    required this.category,
    this.description,
    this.requiresApproval,
    this.affectsCostReporting,
    this.sortOrder,
  });

  factory BusinessTypeWasteReasonTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeWasteReasonTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      reasonCode: json['reason_code'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      category: WasteReasonCategory.fromValue(json['category'] as String),
      description: json['description'] as String?,
      requiresApproval: json['requires_approval'] as bool?,
      affectsCostReporting: json['affects_cost_reporting'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'reason_code': reasonCode,
      'name': name,
      'name_ar': nameAr,
      'category': category.value,
      'description': description,
      'requires_approval': requiresApproval,
      'affects_cost_reporting': affectsCostReporting,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeWasteReasonTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? reasonCode,
    String? name,
    String? nameAr,
    WasteReasonCategory? category,
    String? description,
    bool? requiresApproval,
    bool? affectsCostReporting,
    int? sortOrder,
  }) {
    return BusinessTypeWasteReasonTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      reasonCode: reasonCode ?? this.reasonCode,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      category: category ?? this.category,
      description: description ?? this.description,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      affectsCostReporting: affectsCostReporting ?? this.affectsCostReporting,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessTypeWasteReasonTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'BusinessTypeWasteReasonTemplate(id: $id, businessTypeId: $businessTypeId, reasonCode: $reasonCode, name: $name, nameAr: $nameAr, category: $category, ...)';
}
