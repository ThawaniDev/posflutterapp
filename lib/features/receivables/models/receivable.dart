class Receivable {
  final String id;
  final String organizationId;
  final String storeId;
  final String customerId;
  final String? referenceNumber;
  final String receivableType;
  final String source;
  final String? description;
  final String? descriptionAr;
  final double amount;
  final double remainingBalance;
  final String status;
  final DateTime? dueDate;
  final String? notes;
  final int? syncVersion;
  final ReceivableCustomer? customer;
  final String? createdByName;
  final String? settledByName;
  final DateTime? settledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ReceivablePayment> payments;
  final List<ReceivableLog> logs;

  const Receivable({
    required this.id,
    required this.organizationId,
    required this.storeId,
    required this.customerId,
    this.referenceNumber,
    required this.receivableType,
    required this.source,
    this.description,
    this.descriptionAr,
    required this.amount,
    required this.remainingBalance,
    required this.status,
    this.dueDate,
    this.notes,
    this.syncVersion,
    this.customer,
    this.createdByName,
    this.settledByName,
    this.settledAt,
    this.createdAt,
    this.updatedAt,
    this.payments = const [],
    this.logs = const [],
  });

  factory Receivable.fromJson(Map<String, dynamic> json) {
    return Receivable(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String,
      referenceNumber: json['reference_number'] as String?,
      receivableType: json['receivable_type'] as String,
      source: json['source'] as String,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      remainingBalance: double.tryParse(json['remaining_balance'].toString()) ?? 0.0,
      status: json['status'] as String,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      notes: json['notes'] as String?,
      syncVersion: json['sync_version'] as int?,
      customer: json['customer'] != null ? ReceivableCustomer.fromJson(json['customer'] as Map<String, dynamic>) : null,
      createdByName: json['created_by_name'] as String?,
      settledByName: json['settled_by_name'] as String?,
      settledAt: json['settled_at'] != null ? DateTime.parse(json['settled_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((item) => ReceivablePayment.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      logs: (json['logs'] as List<dynamic>?)?.map((item) => ReceivableLog.fromJson(item as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization_id': organizationId,
    'store_id': storeId,
    'customer_id': customerId,
    'reference_number': referenceNumber,
    'receivable_type': receivableType,
    'source': source,
    'description': description,
    'description_ar': descriptionAr,
    'amount': amount,
    'remaining_balance': remainingBalance,
    'status': status,
    'due_date': dueDate?.toIso8601String(),
    'notes': notes,
    'sync_version': syncVersion,
    'created_by_name': createdByName,
    'settled_by_name': settledByName,
    'settled_at': settledAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'payments': payments.map((a) => a.toJson()).toList(),
    'logs': logs.map((l) => l.toJson()).toList(),
  };

  Receivable copyWith({
    String? id,
    String? status,
    double? amount,
    double? remainingBalance,
    DateTime? dueDate,
    String? notes,
    String? description,
    String? descriptionAr,
    List<ReceivablePayment>? payments,
    List<ReceivableLog>? logs,
  }) {
    return Receivable(
      id: id ?? this.id,
      organizationId: organizationId,
      storeId: storeId,
      customerId: customerId,
      referenceNumber: referenceNumber,
      receivableType: receivableType,
      source: source,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      amount: amount ?? this.amount,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      syncVersion: syncVersion,
      customer: customer,
      createdByName: createdByName,
      settledByName: settledByName,
      settledAt: settledAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      payments: payments ?? this.payments,
      logs: logs ?? this.logs,
    );
  }

  bool get isFullyPaid => remainingBalance <= 0.01;
  bool get isPending => status == 'pending';
  bool get isPartiallyPaid => status == 'partially_paid';
  bool get isReversed => status == 'reversed';
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && !isFullyPaid && !isReversed;
  bool get canRecordPayment => isPending || isPartiallyPaid;
  bool get canEdit => isPending || isPartiallyPaid;
  bool get canReverse => !isReversed;
  bool get canDelete => isPending && payments.isEmpty;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Receivable && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ReceivableCustomer {
  final String id;
  final String name;
  final String? phone;

  const ReceivableCustomer({required this.id, required this.name, this.phone});

  factory ReceivableCustomer.fromJson(Map<String, dynamic> json) {
    return ReceivableCustomer(id: json['id'] as String, name: json['name'] as String, phone: json['phone'] as String?);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone};
}

class ReceivablePayment {
  final String id;
  final String receivableId;
  final String? orderId;
  final String? orderNumber;
  final String? paymentMethod;
  final double amount;
  final String? notes;
  final String? settledByName;
  final DateTime? settledAt;

  const ReceivablePayment({
    required this.id,
    required this.receivableId,
    this.orderId,
    this.orderNumber,
    this.paymentMethod,
    required this.amount,
    this.notes,
    this.settledByName,
    this.settledAt,
  });

  factory ReceivablePayment.fromJson(Map<String, dynamic> json) {
    return ReceivablePayment(
      id: json['id'] as String,
      receivableId: json['receivable_id'] as String,
      orderId: json['order_id'] as String?,
      orderNumber: json['order_number'] as String?,
      paymentMethod: json['payment_method'] as String?,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      notes: json['notes'] as String?,
      settledByName: json['settled_by_name'] as String?,
      settledAt: json['settled_at'] != null ? DateTime.parse(json['settled_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'receivable_id': receivableId,
    'order_id': orderId,
    'order_number': orderNumber,
    'payment_method': paymentMethod,
    'amount': amount,
    'notes': notes,
    'settled_by_name': settledByName,
    'settled_at': settledAt?.toIso8601String(),
  };

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReceivablePayment && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ReceivableLog {
  final String id;
  final String receivableId;
  final String event;
  final String? fromValue;
  final String? toValue;
  final double? amount;
  final String? note;
  final Map<String, dynamic>? meta;
  final String? actorId;
  final String? actorName;
  final DateTime? createdAt;

  const ReceivableLog({
    required this.id,
    required this.receivableId,
    required this.event,
    this.fromValue,
    this.toValue,
    this.amount,
    this.note,
    this.meta,
    this.actorId,
    this.actorName,
    this.createdAt,
  });

  factory ReceivableLog.fromJson(Map<String, dynamic> json) {
    return ReceivableLog(
      id: json['id'] as String,
      receivableId: json['receivable_id'] as String,
      event: json['event'] as String,
      fromValue: json['from_value'] as String?,
      toValue: json['to_value'] as String?,
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
      note: json['note'] as String?,
      meta: json['meta'] as Map<String, dynamic>?,
      actorId: json['actor_id'] as String?,
      actorName: json['actor_name'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'receivable_id': receivableId,
    'event': event,
    'from_value': fromValue,
    'to_value': toValue,
    'amount': amount,
    'note': note,
    'meta': meta,
    'actor_id': actorId,
    'actor_name': actorName,
    'created_at': createdAt?.toIso8601String(),
  };
}

class ReceivableSummary {
  final double totalReceivables;
  final int pendingCount;
  final double pendingAmount;
  final int partiallyPaidCount;
  final int fullyPaidCount;
  final int reversedCount;
  final int overdueCount;
  final double totalPaid;

  const ReceivableSummary({
    required this.totalReceivables,
    required this.pendingCount,
    required this.pendingAmount,
    required this.partiallyPaidCount,
    required this.fullyPaidCount,
    required this.reversedCount,
    required this.overdueCount,
    required this.totalPaid,
  });

  factory ReceivableSummary.fromJson(Map<String, dynamic> json) {
    return ReceivableSummary(
      totalReceivables: double.tryParse(json['total_receivables'].toString()) ?? 0.0,
      pendingCount: json['pending_count'] as int? ?? 0,
      pendingAmount: double.tryParse(json['pending_amount'].toString()) ?? 0.0,
      partiallyPaidCount: json['partially_paid_count'] as int? ?? 0,
      fullyPaidCount: json['fully_paid_count'] as int? ?? 0,
      reversedCount: json['reversed_count'] as int? ?? 0,
      overdueCount: json['overdue_count'] as int? ?? 0,
      totalPaid: double.tryParse(json['total_paid'].toString()) ?? 0.0,
    );
  }

  double get outstandingAmount => totalReceivables - totalPaid;
}
