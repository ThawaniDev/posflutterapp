import 'package:thawani_pos/features/zatca/enums/invoice_status.dart';

class Invoice {
  final String id;
  final String storeSubscriptionId;
  final String invoiceNumber;
  final double amount;
  final double? tax;
  final double total;
  final InvoiceStatus status;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? pdfUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Invoice({
    required this.id,
    required this.storeSubscriptionId,
    required this.invoiceNumber,
    required this.amount,
    this.tax,
    required this.total,
    required this.status,
    required this.dueDate,
    this.paidAt,
    this.pdfUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      storeSubscriptionId: json['store_subscription_id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      amount: (json['amount'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      total: (json['total'] as num).toDouble(),
      status: InvoiceStatus.fromValue(json['status'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      pdfUrl: json['pdf_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_subscription_id': storeSubscriptionId,
      'invoice_number': invoiceNumber,
      'amount': amount,
      'tax': tax,
      'total': total,
      'status': status.value,
      'due_date': dueDate.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'pdf_url': pdfUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Invoice copyWith({
    String? id,
    String? storeSubscriptionId,
    String? invoiceNumber,
    double? amount,
    double? tax,
    double? total,
    InvoiceStatus? status,
    DateTime? dueDate,
    DateTime? paidAt,
    String? pdfUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      storeSubscriptionId: storeSubscriptionId ?? this.storeSubscriptionId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      amount: amount ?? this.amount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paidAt: paidAt ?? this.paidAt,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invoice && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Invoice(id: $id, storeSubscriptionId: $storeSubscriptionId, invoiceNumber: $invoiceNumber, amount: $amount, tax: $tax, total: $total, ...)';
}
