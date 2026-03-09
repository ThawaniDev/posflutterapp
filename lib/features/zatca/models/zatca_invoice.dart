import 'package:thawani_pos/features/zatca/enums/zatca_invoice_type.dart';
import 'package:thawani_pos/features/zatca/enums/zatca_submission_status.dart';

class ZatcaInvoice {
  final String id;
  final String storeId;
  final String orderId;
  final String invoiceNumber;
  final ZatcaInvoiceType invoiceType;
  final String invoiceXml;
  final String invoiceHash;
  final String previousInvoiceHash;
  final String digitalSignature;
  final String qrCodeData;
  final double totalAmount;
  final double vatAmount;
  final ZatcaSubmissionStatus? submissionStatus;
  final String? zatcaResponseCode;
  final String? zatcaResponseMessage;
  final DateTime? submittedAt;
  final DateTime? createdAt;

  const ZatcaInvoice({
    required this.id,
    required this.storeId,
    required this.orderId,
    required this.invoiceNumber,
    required this.invoiceType,
    required this.invoiceXml,
    required this.invoiceHash,
    required this.previousInvoiceHash,
    required this.digitalSignature,
    required this.qrCodeData,
    required this.totalAmount,
    required this.vatAmount,
    this.submissionStatus,
    this.zatcaResponseCode,
    this.zatcaResponseMessage,
    this.submittedAt,
    this.createdAt,
  });

  factory ZatcaInvoice.fromJson(Map<String, dynamic> json) {
    return ZatcaInvoice(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      orderId: json['order_id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      invoiceType: ZatcaInvoiceType.fromValue(json['invoice_type'] as String),
      invoiceXml: json['invoice_xml'] as String,
      invoiceHash: json['invoice_hash'] as String,
      previousInvoiceHash: json['previous_invoice_hash'] as String,
      digitalSignature: json['digital_signature'] as String,
      qrCodeData: json['qr_code_data'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      vatAmount: (json['vat_amount'] as num).toDouble(),
      submissionStatus: ZatcaSubmissionStatus.tryFromValue(json['submission_status'] as String?),
      zatcaResponseCode: json['zatca_response_code'] as String?,
      zatcaResponseMessage: json['zatca_response_message'] as String?,
      submittedAt: json['submitted_at'] != null ? DateTime.parse(json['submitted_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'order_id': orderId,
      'invoice_number': invoiceNumber,
      'invoice_type': invoiceType.value,
      'invoice_xml': invoiceXml,
      'invoice_hash': invoiceHash,
      'previous_invoice_hash': previousInvoiceHash,
      'digital_signature': digitalSignature,
      'qr_code_data': qrCodeData,
      'total_amount': totalAmount,
      'vat_amount': vatAmount,
      'submission_status': submissionStatus?.value,
      'zatca_response_code': zatcaResponseCode,
      'zatca_response_message': zatcaResponseMessage,
      'submitted_at': submittedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ZatcaInvoice copyWith({
    String? id,
    String? storeId,
    String? orderId,
    String? invoiceNumber,
    ZatcaInvoiceType? invoiceType,
    String? invoiceXml,
    String? invoiceHash,
    String? previousInvoiceHash,
    String? digitalSignature,
    String? qrCodeData,
    double? totalAmount,
    double? vatAmount,
    ZatcaSubmissionStatus? submissionStatus,
    String? zatcaResponseCode,
    String? zatcaResponseMessage,
    DateTime? submittedAt,
    DateTime? createdAt,
  }) {
    return ZatcaInvoice(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      orderId: orderId ?? this.orderId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceType: invoiceType ?? this.invoiceType,
      invoiceXml: invoiceXml ?? this.invoiceXml,
      invoiceHash: invoiceHash ?? this.invoiceHash,
      previousInvoiceHash: previousInvoiceHash ?? this.previousInvoiceHash,
      digitalSignature: digitalSignature ?? this.digitalSignature,
      qrCodeData: qrCodeData ?? this.qrCodeData,
      totalAmount: totalAmount ?? this.totalAmount,
      vatAmount: vatAmount ?? this.vatAmount,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      zatcaResponseCode: zatcaResponseCode ?? this.zatcaResponseCode,
      zatcaResponseMessage: zatcaResponseMessage ?? this.zatcaResponseMessage,
      submittedAt: submittedAt ?? this.submittedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZatcaInvoice && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ZatcaInvoice(id: $id, storeId: $storeId, orderId: $orderId, invoiceNumber: $invoiceNumber, invoiceType: $invoiceType, invoiceXml: $invoiceXml, ...)';
}
