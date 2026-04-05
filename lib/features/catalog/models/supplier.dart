class Supplier {
  final String id;
  final String organizationId;
  final String name;
  final String? phone;
  final String? email;
  final String? website;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? notes;
  final String? contactPerson;
  final String? taxNumber;
  final String? paymentTerms;
  final String? bankName;
  final String? bankAccount;
  final String? iban;
  final double? creditLimit;
  final double? outstandingBalance;
  final int? rating;
  final String? category;
  final bool? isActive;
  final int? productsCount;
  final int? returnsCount;
  final int? purchaseOrdersCount;
  final int? goodsReceiptsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Supplier({
    required this.id,
    required this.organizationId,
    required this.name,
    this.phone,
    this.email,
    this.website,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.notes,
    this.contactPerson,
    this.taxNumber,
    this.paymentTerms,
    this.bankName,
    this.bankAccount,
    this.iban,
    this.creditLimit,
    this.outstandingBalance,
    this.rating,
    this.category,
    this.isActive,
    this.productsCount,
    this.returnsCount,
    this.purchaseOrdersCount,
    this.goodsReceiptsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      notes: json['notes'] as String?,
      contactPerson: json['contact_person'] as String?,
      taxNumber: json['tax_number'] as String?,
      paymentTerms: json['payment_terms'] as String?,
      bankName: json['bank_name'] as String?,
      bankAccount: json['bank_account'] as String?,
      iban: json['iban'] as String?,
      creditLimit: (json['credit_limit'] != null ? double.tryParse(json['credit_limit'].toString()) : null),
      outstandingBalance: (json['outstanding_balance'] != null ? double.tryParse(json['outstanding_balance'].toString()) : null),
      rating: json['rating'] as int?,
      category: json['category'] as String?,
      isActive: json['is_active'] as bool?,
      productsCount: json['products_count'] as int?,
      returnsCount: json['returns_count'] as int?,
      purchaseOrdersCount: json['purchase_orders_count'] as int?,
      goodsReceiptsCount: json['goods_receipts_count'] as int?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'city': city,
      'country': country,
      'postal_code': postalCode,
      'notes': notes,
      'contact_person': contactPerson,
      'tax_number': taxNumber,
      'payment_terms': paymentTerms,
      'bank_name': bankName,
      'bank_account': bankAccount,
      'iban': iban,
      'credit_limit': creditLimit,
      'outstanding_balance': outstandingBalance,
      'rating': rating,
      'category': category,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Supplier copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    String? notes,
    String? contactPerson,
    String? taxNumber,
    String? paymentTerms,
    String? bankName,
    String? bankAccount,
    String? iban,
    double? creditLimit,
    double? outstandingBalance,
    int? rating,
    String? category,
    bool? isActive,
    int? productsCount,
    int? returnsCount,
    int? purchaseOrdersCount,
    int? goodsReceiptsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      notes: notes ?? this.notes,
      contactPerson: contactPerson ?? this.contactPerson,
      taxNumber: taxNumber ?? this.taxNumber,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      bankName: bankName ?? this.bankName,
      bankAccount: bankAccount ?? this.bankAccount,
      iban: iban ?? this.iban,
      creditLimit: creditLimit ?? this.creditLimit,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      productsCount: productsCount ?? this.productsCount,
      returnsCount: returnsCount ?? this.returnsCount,
      purchaseOrdersCount: purchaseOrdersCount ?? this.purchaseOrdersCount,
      goodsReceiptsCount: goodsReceiptsCount ?? this.goodsReceiptsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Supplier && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Supplier(id: $id, organizationId: $organizationId, name: $name, phone: $phone, email: $email, address: $address, ...)';
}
