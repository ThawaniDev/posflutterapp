class Customer {

  const Customer({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.dateOfBirth,
    this.loyaltyCode,
    this.loyaltyPoints,
    this.storeCreditBalance,
    this.groupId,
    this.taxRegistrationNumber,
    this.notes,
    this.totalSpend,
    this.visitCount,
    this.lastVisitAt,
    this.syncVersion,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth'] as String) : null,
      loyaltyCode: json['loyalty_code'] as String?,
      loyaltyPoints: (json['loyalty_points'] as num?)?.toInt(),
      storeCreditBalance: (json['store_credit_balance'] != null ? double.tryParse(json['store_credit_balance'].toString()) : null),
      groupId: json['group_id'] as String?,
      taxRegistrationNumber: json['tax_registration_number'] as String?,
      notes: json['notes'] as String?,
      totalSpend: (json['total_spend'] != null ? double.tryParse(json['total_spend'].toString()) : null),
      visitCount: (json['visit_count'] as num?)?.toInt(),
      lastVisitAt: json['last_visit_at'] != null ? DateTime.parse(json['last_visit_at'] as String) : null,
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }
  final String id;
  final String organizationId;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final DateTime? dateOfBirth;
  final String? loyaltyCode;
  final int? loyaltyPoints;
  final double? storeCreditBalance;
  final String? groupId;
  final String? taxRegistrationNumber;
  final String? notes;
  final double? totalSpend;
  final int? visitCount;
  final DateTime? lastVisitAt;
  final int? syncVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'loyalty_code': loyaltyCode,
      'loyalty_points': loyaltyPoints,
      'store_credit_balance': storeCreditBalance,
      'group_id': groupId,
      'tax_registration_number': taxRegistrationNumber,
      'notes': notes,
      'total_spend': totalSpend,
      'visit_count': visitCount,
      'last_visit_at': lastVisitAt?.toIso8601String(),
      'sync_version': syncVersion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Customer copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? phone,
    String? email,
    String? address,
    DateTime? dateOfBirth,
    String? loyaltyCode,
    int? loyaltyPoints,
    double? storeCreditBalance,
    String? groupId,
    String? taxRegistrationNumber,
    String? notes,
    double? totalSpend,
    int? visitCount,
    DateTime? lastVisitAt,
    int? syncVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      loyaltyCode: loyaltyCode ?? this.loyaltyCode,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      storeCreditBalance: storeCreditBalance ?? this.storeCreditBalance,
      groupId: groupId ?? this.groupId,
      taxRegistrationNumber: taxRegistrationNumber ?? this.taxRegistrationNumber,
      notes: notes ?? this.notes,
      totalSpend: totalSpend ?? this.totalSpend,
      visitCount: visitCount ?? this.visitCount,
      lastVisitAt: lastVisitAt ?? this.lastVisitAt,
      syncVersion: syncVersion ?? this.syncVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Customer(id: $id, organizationId: $organizationId, name: $name, phone: $phone, email: $email, address: $address, ...)';
}
