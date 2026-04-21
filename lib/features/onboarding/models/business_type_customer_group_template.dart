class BusinessTypeCustomerGroupTemplate {

  const BusinessTypeCustomerGroupTemplate({
    required this.id,
    required this.businessTypeId,
    required this.name,
    required this.nameAr,
    this.description,
    this.discountPercentage,
    this.creditLimit,
    this.paymentTermsDays,
    this.isDefaultGroup,
    this.sortOrder,
  });

  factory BusinessTypeCustomerGroupTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeCustomerGroupTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      description: json['description'] as String?,
      discountPercentage: (json['discount_percentage'] != null ? double.tryParse(json['discount_percentage'].toString()) : null),
      creditLimit: (json['credit_limit'] != null ? double.tryParse(json['credit_limit'].toString()) : null),
      paymentTermsDays: (json['payment_terms_days'] as num?)?.toInt(),
      isDefaultGroup: json['is_default_group'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String businessTypeId;
  final String name;
  final String nameAr;
  final String? description;
  final double? discountPercentage;
  final double? creditLimit;
  final int? paymentTermsDays;
  final bool? isDefaultGroup;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'discount_percentage': discountPercentage,
      'credit_limit': creditLimit,
      'payment_terms_days': paymentTermsDays,
      'is_default_group': isDefaultGroup,
      'sort_order': sortOrder,
    };
  }

  BusinessTypeCustomerGroupTemplate copyWith({
    String? id,
    String? businessTypeId,
    String? name,
    String? nameAr,
    String? description,
    double? discountPercentage,
    double? creditLimit,
    int? paymentTermsDays,
    bool? isDefaultGroup,
    int? sortOrder,
  }) {
    return BusinessTypeCustomerGroupTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      creditLimit: creditLimit ?? this.creditLimit,
      paymentTermsDays: paymentTermsDays ?? this.paymentTermsDays,
      isDefaultGroup: isDefaultGroup ?? this.isDefaultGroup,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeCustomerGroupTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeCustomerGroupTemplate(id: $id, businessTypeId: $businessTypeId, name: $name, nameAr: $nameAr, description: $description, discountPercentage: $discountPercentage, ...)';
}
