class Debit {

  const Debit({
    required this.id,
    required this.organizationId,
    required this.storeId,
    required this.customerId,
    this.referenceNumber,
    required this.debitType,
    required this.source,
    this.description,
    this.descriptionAr,
    required this.amount,
    required this.remainingBalance,
    required this.status,
    this.notes,
    this.syncVersion,
    this.customer,
    this.createdByName,
    this.allocatedByName,
    this.allocatedAt,
    this.createdAt,
    this.updatedAt,
    this.allocations = const [],
  });

  factory Debit.fromJson(Map<String, dynamic> json) {
    return Debit(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String,
      referenceNumber: json['reference_number'] as String?,
      debitType: json['debit_type'] as String,
      source: json['source'] as String,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      remainingBalance: double.tryParse(json['remaining_balance'].toString()) ?? 0.0,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      syncVersion: json['sync_version'] as int?,
      customer: json['customer'] != null ? DebitCustomer.fromJson(json['customer'] as Map<String, dynamic>) : null,
      createdByName: json['created_by_name'] as String?,
      allocatedByName: json['allocated_by_name'] as String?,
      allocatedAt: json['allocated_at'] != null ? DateTime.parse(json['allocated_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      allocations:
          (json['allocations'] as List<dynamic>?)
              ?.map((item) => DebitAllocation.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  final String id;
  final String organizationId;
  final String storeId;
  final String customerId;
  final String? referenceNumber;
  final String debitType;
  final String source;
  final String? description;
  final String? descriptionAr;
  final double amount;
  final double remainingBalance;
  final String status;
  final String? notes;
  final int? syncVersion;
  final DebitCustomer? customer;
  final String? createdByName;
  final String? allocatedByName;
  final DateTime? allocatedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<DebitAllocation> allocations;

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': organizationId,
    'store_id': storeId,
    'customer_id': customerId,
    'reference_number': referenceNumber,
    'debit_type': debitType,
    'source': source,
    'description': description,
    'description_ar': descriptionAr,
    'amount': amount,
    'remaining_balance': remainingBalance,
    'status': status,
    'notes': notes,
    'sync_version': syncVersion,
    'created_by_name': createdByName,
    'allocated_by_name': allocatedByName,
    'allocated_at': allocatedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'allocations': allocations.map((a) => a.toJson()).toList(),
  };

  Debit copyWith({
    String? id,
    String? status,
    double? amount,
    double? remainingBalance,
    String? notes,
    String? description,
    String? descriptionAr,
    List<DebitAllocation>? allocations,
  }) {
    return Debit(
      id: id ?? this.id,
      organizationId: organizationId,
      storeId: storeId,
      customerId: customerId,
      referenceNumber: referenceNumber,
      debitType: debitType,
      source: source,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      amount: amount ?? this.amount,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      syncVersion: syncVersion,
      customer: customer,
      createdByName: createdByName,
      allocatedByName: allocatedByName,
      allocatedAt: allocatedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      allocations: allocations ?? this.allocations,
    );
  }

  bool get isFullyAllocated => remainingBalance <= 0.01;
  bool get isPending => status == 'pending';
  bool get isPartiallyAllocated => status == 'partially_allocated';
  bool get isAllocated => status == 'fully_allocated' || status == 'partially_allocated';
  bool get isReversed => status == 'reversed';
  bool get canAllocate => isPending || isPartiallyAllocated;
  bool get canEdit => isPending || isPartiallyAllocated;
  bool get canReverse => !isReversed;
  bool get canDelete => isPending && allocations.isEmpty;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Debit && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DebitCustomer {

  const DebitCustomer({required this.id, required this.name, this.phone, this.email});

  factory DebitCustomer.fromJson(Map<String, dynamic> json) {
    return DebitCustomer(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }
  final String id;
  final String name;
  final String? phone;
  final String? email;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone, 'email': email};
}

class DebitAllocation {

  const DebitAllocation({
    required this.id,
    required this.debitId,
    required this.orderId,
    this.orderNumber,
    required this.amount,
    this.notes,
    this.allocatedByName,
    this.allocatedAt,
  });

  factory DebitAllocation.fromJson(Map<String, dynamic> json) {
    return DebitAllocation(
      id: json['id'] as String,
      debitId: json['debit_id'] as String,
      orderId: json['order_id'] as String,
      orderNumber: json['order_number'] as String?,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      notes: json['notes'] as String?,
      allocatedByName: json['allocated_by_name'] as String?,
      allocatedAt: json['allocated_at'] != null ? DateTime.parse(json['allocated_at'] as String) : null,
    );
  }
  final String id;
  final String debitId;
  final String orderId;
  final String? orderNumber;
  final double amount;
  final String? notes;
  final String? allocatedByName;
  final DateTime? allocatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'debit_id': debitId,
    'order_id': orderId,
    'order_number': orderNumber,
    'amount': amount,
    'notes': notes,
    'allocated_by_name': allocatedByName,
    'allocated_at': allocatedAt?.toIso8601String(),
  };

  @override
  bool operator ==(Object other) => identical(this, other) || other is DebitAllocation && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DebitSummary {

  const DebitSummary({
    required this.totalDebits,
    required this.pendingCount,
    required this.pendingAmount,
    required this.partiallyAllocatedCount,
    required this.fullyAllocatedCount,
    required this.reversedCount,
    required this.totalAllocated,
  });

  factory DebitSummary.fromJson(Map<String, dynamic> json) {
    return DebitSummary(
      totalDebits: double.tryParse(json['total_debits'].toString()) ?? 0.0,
      pendingCount: json['pending_count'] as int? ?? 0,
      pendingAmount: double.tryParse(json['pending_amount'].toString()) ?? 0.0,
      partiallyAllocatedCount: json['partially_allocated_count'] as int? ?? 0,
      fullyAllocatedCount: json['fully_allocated_count'] as int? ?? 0,
      reversedCount: json['reversed_count'] as int? ?? 0,
      totalAllocated: double.tryParse(json['total_allocated'].toString()) ?? 0.0,
    );
  }
  final double totalDebits;
  final int pendingCount;
  final double pendingAmount;
  final int partiallyAllocatedCount;
  final int fullyAllocatedCount;
  final int reversedCount;
  final double totalAllocated;

  double get unallocatedAmount => totalDebits - totalAllocated;
}
