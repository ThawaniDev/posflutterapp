import 'package:wameedpos/features/customers/enums/store_credit_transaction_type.dart';

class StoreCreditTransaction {

  const StoreCreditTransaction({
    required this.id,
    required this.customerId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    this.orderId,
    this.paymentId,
    this.notes,
    this.performedBy,
    this.createdAt,
  });

  factory StoreCreditTransaction.fromJson(Map<String, dynamic> json) {
    return StoreCreditTransaction(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      type: StoreCreditTransactionType.fromValue(json['type'] as String),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      balanceAfter: double.tryParse(json['balance_after'].toString()) ?? 0.0,
      orderId: json['order_id'] as String?,
      paymentId: json['payment_id'] as String?,
      notes: json['notes'] as String?,
      performedBy: json['performed_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String customerId;
  final StoreCreditTransactionType type;
  final double amount;
  final double balanceAfter;
  final String? orderId;
  final String? paymentId;
  final String? notes;
  final String? performedBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'type': type.value,
      'amount': amount,
      'balance_after': balanceAfter,
      'order_id': orderId,
      'payment_id': paymentId,
      'notes': notes,
      'performed_by': performedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  StoreCreditTransaction copyWith({
    String? id,
    String? customerId,
    StoreCreditTransactionType? type,
    double? amount,
    double? balanceAfter,
    String? orderId,
    String? paymentId,
    String? notes,
    String? performedBy,
    DateTime? createdAt,
  }) {
    return StoreCreditTransaction(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      orderId: orderId ?? this.orderId,
      paymentId: paymentId ?? this.paymentId,
      notes: notes ?? this.notes,
      performedBy: performedBy ?? this.performedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StoreCreditTransaction && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StoreCreditTransaction(id: $id, customerId: $customerId, type: $type, amount: $amount, balanceAfter: $balanceAfter, orderId: $orderId, ...)';
}
