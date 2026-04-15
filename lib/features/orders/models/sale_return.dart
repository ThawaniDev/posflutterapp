import 'package:wameedpos/features/orders/enums/return_refund_method.dart';
import 'package:wameedpos/features/orders/enums/return_type.dart';

class SaleReturn {
  final String id;
  final String storeId;
  final String orderId;
  final String returnNumber;
  final ReturnType type;
  final String reasonCode;
  final ReturnRefundMethod refundMethod;
  final double subtotal;
  final double taxAmount;
  final double totalRefund;
  final String? notes;
  final String processedBy;
  final DateTime? createdAt;

  const SaleReturn({
    required this.id,
    required this.storeId,
    required this.orderId,
    required this.returnNumber,
    required this.type,
    required this.reasonCode,
    required this.refundMethod,
    required this.subtotal,
    required this.taxAmount,
    required this.totalRefund,
    this.notes,
    required this.processedBy,
    this.createdAt,
  });

  factory SaleReturn.fromJson(Map<String, dynamic> json) {
    return SaleReturn(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderId: json['order_id'] as String,
      returnNumber: json['return_number'] as String,
      type: ReturnType.fromValue(json['type'] as String),
      reasonCode: json['reason_code'] as String,
      refundMethod: ReturnRefundMethod.fromValue(json['refund_method'] as String),
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      taxAmount: double.tryParse(json['tax_amount'].toString()) ?? 0.0,
      totalRefund: double.tryParse(json['total_refund'].toString()) ?? 0.0,
      notes: json['notes'] as String?,
      processedBy: json['processed_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'order_id': orderId,
      'return_number': returnNumber,
      'type': type.value,
      'reason_code': reasonCode,
      'refund_method': refundMethod.value,
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'total_refund': totalRefund,
      'notes': notes,
      'processed_by': processedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  SaleReturn copyWith({
    String? id,
    String? storeId,
    String? orderId,
    String? returnNumber,
    ReturnType? type,
    String? reasonCode,
    ReturnRefundMethod? refundMethod,
    double? subtotal,
    double? taxAmount,
    double? totalRefund,
    String? notes,
    String? processedBy,
    DateTime? createdAt,
  }) {
    return SaleReturn(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      orderId: orderId ?? this.orderId,
      returnNumber: returnNumber ?? this.returnNumber,
      type: type ?? this.type,
      reasonCode: reasonCode ?? this.reasonCode,
      refundMethod: refundMethod ?? this.refundMethod,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      totalRefund: totalRefund ?? this.totalRefund,
      notes: notes ?? this.notes,
      processedBy: processedBy ?? this.processedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SaleReturn && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SaleReturn(id: $id, storeId: $storeId, orderId: $orderId, returnNumber: $returnNumber, type: $type, reasonCode: $reasonCode, ...)';
}
