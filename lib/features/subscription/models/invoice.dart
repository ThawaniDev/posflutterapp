import 'package:thawani_pos/features/zatca/enums/invoice_status.dart';
import 'package:thawani_pos/features/subscription/models/invoice_line_item.dart';

class Invoice {
  final String id;
  final String? storeSubscriptionId;
  final String? invoiceNumber;
  final double amount;
  final double? tax;
  final double total;
  final String? currency;
  final String? description;
  final InvoiceStatus? status;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final String? pdfUrl;
  final List<InvoiceLineItem>? lineItems;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Invoice({
    required this.id,
    this.storeSubscriptionId,
    this.invoiceNumber,
    required this.amount,
    this.tax,
    required this.total,
    this.currency,
    this.description,
    this.status,
    this.dueDate,
    this.paidAt,
    this.pdfUrl,
    this.lineItems,
    this.createdAt,
    this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      storeSubscriptionId: json['store_subscription_id'] as String?,
      invoiceNumber: json['invoice_number'] as String?,
      amount: (json['amount'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      total: (json['total'] as num).toDouble(),
      currency: json['currency'] as String?,
      description: json['description'] as String?,
      status: json['status'] != null ? InvoiceStatus.fromValue(json['status'] as String) : null,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      pdfUrl: json['pdf_url'] as String?,
      lineItems: json['line_items'] != null
          ? (json['line_items'] as List).map((e) => InvoiceLineItem.fromJson(Map<String, dynamic>.from(e as Map))).toList()
          : null,
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
      'currency': currency,
      'description': description,
      'status': status?.value,
      'due_date': dueDate?.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'pdf_url': pdfUrl,
      'line_items': lineItems?.map((e) => e.toJson()).toList(),
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
    String? currency,
    String? description,
    InvoiceStatus? status,
    DateTime? dueDate,
    DateTime? paidAt,
    String? pdfUrl,
    List<InvoiceLineItem>? lineItems,
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
      currency: currency ?? this.currency,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paidAt: paidAt ?? this.paidAt,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      lineItems: lineItems ?? this.lineItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Invoice && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Invoice(id: $id, invoiceNumber: $invoiceNumber, amount: $amount, total: $total)';
}
