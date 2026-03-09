import 'package:thawani_pos/features/payments/enums/payment_method_key.dart';
import 'package:thawani_pos/features/payments/enums/refund_status.dart';

class Refund {
  final String id;
  final String returnId;
  final String? paymentId;
  final PaymentMethodKey method;
  final double amount;
  final String? referenceNumber;
  final RefundStatus? status;
  final String processedBy;
  final DateTime? createdAt;

  const Refund({
    required this.id,
    required this.returnId,
    this.paymentId,
    required this.method,
    required this.amount,
    this.referenceNumber,
    this.status,
    required this.processedBy,
    this.createdAt,
  });

  factory Refund.fromJson(Map<String, dynamic> json) {
    return Refund(
      id: json['id'] as String,
      returnId: json['return_id'] as String,
      paymentId: json['payment_id'] as String?,
      method: PaymentMethodKey.fromValue(json['method'] as String),
      amount: (json['amount'] as num).toDouble(),
      referenceNumber: json['reference_number'] as String?,
      status: RefundStatus.tryFromValue(json['status'] as String?),
      processedBy: json['processed_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'return_id': returnId,
      'payment_id': paymentId,
      'method': method.value,
      'amount': amount,
      'reference_number': referenceNumber,
      'status': status?.value,
      'processed_by': processedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Refund copyWith({
    String? id,
    String? returnId,
    String? paymentId,
    PaymentMethodKey? method,
    double? amount,
    String? referenceNumber,
    RefundStatus? status,
    String? processedBy,
    DateTime? createdAt,
  }) {
    return Refund(
      id: id ?? this.id,
      returnId: returnId ?? this.returnId,
      paymentId: paymentId ?? this.paymentId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      processedBy: processedBy ?? this.processedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Refund && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Refund(id: $id, returnId: $returnId, paymentId: $paymentId, method: $method, amount: $amount, referenceNumber: $referenceNumber, ...)';
}
