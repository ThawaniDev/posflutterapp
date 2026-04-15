import 'package:wameedpos/features/orders/enums/external_order_type.dart';
import 'package:wameedpos/features/thawani_integration/enums/sync_status.dart';
import 'package:wameedpos/features/pos_terminal/enums/transaction_status.dart';
import 'package:wameedpos/features/pos_terminal/enums/transaction_type.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction_item.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/zatca/enums/zatca_compliance_status.dart';

class Transaction {
  final String id;
  final String organizationId;
  final String storeId;
  final String registerId;
  final String posSessionId;
  final String cashierId;
  final String? customerId;
  final String transactionNumber;
  final TransactionType type;
  final TransactionStatus status;
  final double subtotal;
  final double? discountAmount;
  final double taxAmount;
  final double? tipAmount;
  final double totalAmount;
  final bool? isTaxExempt;
  final String? returnTransactionId;
  final ExternalOrderType? externalType;
  final String? externalId;
  final String? notes;
  final String? zatcaUuid;
  final String? zatcaHash;
  final String? zatcaQrCode;
  final ZatcaComplianceStatus? zatcaStatus;
  final SyncStatus? syncStatus;
  final int? syncVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<TransactionItem>? items;
  final List<Payment>? payments;
  final DateTime? deletedAt;

  const Transaction({
    required this.id,
    required this.organizationId,
    required this.storeId,
    required this.registerId,
    required this.posSessionId,
    required this.cashierId,
    this.customerId,
    required this.transactionNumber,
    required this.type,
    required this.status,
    required this.subtotal,
    this.discountAmount,
    required this.taxAmount,
    this.tipAmount,
    required this.totalAmount,
    this.isTaxExempt,
    this.returnTransactionId,
    this.externalType,
    this.externalId,
    this.notes,
    this.zatcaUuid,
    this.zatcaHash,
    this.zatcaQrCode,
    this.zatcaStatus,
    this.syncStatus,
    this.syncVersion,
    this.items,
    this.payments,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      storeId: json['store_id'] as String,
      registerId: json['register_id'] as String,
      posSessionId: json['pos_session_id'] as String,
      cashierId: json['cashier_id'] as String,
      customerId: json['customer_id'] as String?,
      transactionNumber: json['transaction_number'] as String,
      type: TransactionType.fromValue(json['type'] as String),
      status: TransactionStatus.fromValue(json['status'] as String),
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      discountAmount: (json['discount_amount'] != null ? double.tryParse(json['discount_amount'].toString()) : null),
      taxAmount: double.tryParse(json['tax_amount'].toString()) ?? 0.0,
      tipAmount: (json['tip_amount'] != null ? double.tryParse(json['tip_amount'].toString()) : null),
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      isTaxExempt: json['is_tax_exempt'] as bool?,
      returnTransactionId: json['return_transaction_id'] as String?,
      externalType: ExternalOrderType.tryFromValue(json['external_type'] as String?),
      externalId: json['external_id'] as String?,
      notes: json['notes'] as String?,
      zatcaUuid: json['zatca_uuid'] as String?,
      zatcaHash: json['zatca_hash'] as String?,
      zatcaQrCode: json['zatca_qr_code'] as String?,
      zatcaStatus: ZatcaComplianceStatus.tryFromValue(json['zatca_status'] as String?),
      syncStatus: SyncStatus.tryFromValue(json['sync_status'] as String?),
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      items: json['items'] != null
          ? (json['items'] as List).map((j) => TransactionItem.fromJson(j as Map<String, dynamic>)).toList()
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List).map((j) => Payment.fromJson(j as Map<String, dynamic>)).toList()
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'store_id': storeId,
      'register_id': registerId,
      'pos_session_id': posSessionId,
      'cashier_id': cashierId,
      'customer_id': customerId,
      'transaction_number': transactionNumber,
      'type': type.value,
      'status': status.value,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'tip_amount': tipAmount,
      'total_amount': totalAmount,
      'is_tax_exempt': isTaxExempt,
      'return_transaction_id': returnTransactionId,
      'external_type': externalType?.value,
      'external_id': externalId,
      'notes': notes,
      'zatca_uuid': zatcaUuid,
      'zatca_hash': zatcaHash,
      'zatca_qr_code': zatcaQrCode,
      'zatca_status': zatcaStatus?.value,
      'sync_status': syncStatus?.value,
      'sync_version': syncVersion,
      if (items != null) 'items': items!.map((i) => i.toJson()).toList(),
      if (payments != null) 'payments': payments!.map((p) => p.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Transaction copyWith({
    String? id,
    String? organizationId,
    String? storeId,
    String? registerId,
    String? posSessionId,
    String? cashierId,
    String? customerId,
    String? transactionNumber,
    TransactionType? type,
    TransactionStatus? status,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? tipAmount,
    double? totalAmount,
    bool? isTaxExempt,
    String? returnTransactionId,
    ExternalOrderType? externalType,
    String? externalId,
    String? notes,
    String? zatcaUuid,
    String? zatcaHash,
    String? zatcaQrCode,
    ZatcaComplianceStatus? zatcaStatus,
    SyncStatus? syncStatus,
    int? syncVersion,
    List<TransactionItem>? items,
    List<Payment>? payments,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      storeId: storeId ?? this.storeId,
      registerId: registerId ?? this.registerId,
      posSessionId: posSessionId ?? this.posSessionId,
      cashierId: cashierId ?? this.cashierId,
      customerId: customerId ?? this.customerId,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      isTaxExempt: isTaxExempt ?? this.isTaxExempt,
      returnTransactionId: returnTransactionId ?? this.returnTransactionId,
      externalType: externalType ?? this.externalType,
      externalId: externalId ?? this.externalId,
      notes: notes ?? this.notes,
      zatcaUuid: zatcaUuid ?? this.zatcaUuid,
      zatcaHash: zatcaHash ?? this.zatcaHash,
      zatcaQrCode: zatcaQrCode ?? this.zatcaQrCode,
      zatcaStatus: zatcaStatus ?? this.zatcaStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      items: items ?? this.items,
      payments: payments ?? this.payments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Transaction && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Transaction(id: $id, organizationId: $organizationId, storeId: $storeId, registerId: $registerId, posSessionId: $posSessionId, cashierId: $cashierId, ...)';
}
