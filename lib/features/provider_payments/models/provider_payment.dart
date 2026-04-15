import 'package:wameedpos/features/provider_payments/enums/payment_purpose.dart';
import 'package:wameedpos/features/provider_payments/enums/provider_payment_status.dart';
import 'package:wameedpos/features/provider_payments/models/payment_email_log.dart';

class ProviderPayment {
  final String id;
  final String? organizationId;
  final String? invoiceId;
  final PaymentPurpose? purpose;
  final String? purposeLabel;
  final double amount;
  final double taxAmount;
  final double totalAmount;
  final String? currency;
  final ProviderPaymentStatus status;
  final String? gateway;
  final String? tranRef;
  final String? tranType;
  final String? cartId;
  final String? responseStatus;
  final String? responseCode;
  final String? responseMessage;
  final String? cardType;
  final String? cardScheme;
  final String? paymentDescription;
  final String? paymentMethod;
  final bool confirmationEmailSent;
  final DateTime? confirmationEmailSentAt;
  final String? confirmationEmailError;
  final bool invoiceGenerated;
  final DateTime? invoiceGeneratedAt;
  final bool ipnReceived;
  final DateTime? ipnReceivedAt;
  final double? refundAmount;
  final String? refundTranRef;
  final String? refundReason;
  final DateTime? refundedAt;
  final String? notes;
  final String? redirectUrl;
  final List<PaymentEmailLog>? emailLogs;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProviderPayment({
    required this.id,
    this.organizationId,
    this.invoiceId,
    this.purpose,
    this.purposeLabel,
    required this.amount,
    this.taxAmount = 0,
    required this.totalAmount,
    this.currency,
    required this.status,
    this.gateway,
    this.tranRef,
    this.tranType,
    this.cartId,
    this.responseStatus,
    this.responseCode,
    this.responseMessage,
    this.cardType,
    this.cardScheme,
    this.paymentDescription,
    this.paymentMethod,
    this.confirmationEmailSent = false,
    this.confirmationEmailSentAt,
    this.confirmationEmailError,
    this.invoiceGenerated = false,
    this.invoiceGeneratedAt,
    this.ipnReceived = false,
    this.ipnReceivedAt,
    this.refundAmount,
    this.refundTranRef,
    this.refundReason,
    this.refundedAt,
    this.notes,
    this.redirectUrl,
    this.emailLogs,
    this.createdAt,
    this.updatedAt,
  });

  factory ProviderPayment.fromJson(Map<String, dynamic> json) {
    return ProviderPayment(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String?,
      invoiceId: json['invoice_id'] as String?,
      purpose: json['purpose'] != null ? PaymentPurpose.tryFromValue(json['purpose'] as String) : null,
      purposeLabel: json['purpose_label'] as String?,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      taxAmount: double.tryParse(json['tax_amount'].toString()) ?? 0.0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      currency: json['currency'] as String?,
      status: ProviderPaymentStatus.tryFromValue(json['status'] as String?) ?? ProviderPaymentStatus.pending,
      gateway: json['gateway'] as String?,
      tranRef: json['tran_ref'] as String?,
      tranType: json['tran_type'] as String?,
      cartId: json['cart_id'] as String?,
      responseStatus: json['response_status'] as String?,
      responseCode: json['response_code'] as String?,
      responseMessage: json['response_message'] as String?,
      cardType: json['card_type'] as String?,
      cardScheme: json['card_scheme'] as String?,
      paymentDescription: json['payment_description'] as String?,
      paymentMethod: json['payment_method'] as String?,
      confirmationEmailSent: json['confirmation_email_sent'] == true,
      confirmationEmailSentAt: json['confirmation_email_sent_at'] != null
          ? DateTime.parse(json['confirmation_email_sent_at'] as String)
          : null,
      confirmationEmailError: json['confirmation_email_error'] as String?,
      invoiceGenerated: json['invoice_generated'] == true,
      invoiceGeneratedAt: json['invoice_generated_at'] != null ? DateTime.parse(json['invoice_generated_at'] as String) : null,
      ipnReceived: json['ipn_received'] == true,
      ipnReceivedAt: json['ipn_received_at'] != null ? DateTime.parse(json['ipn_received_at'] as String) : null,
      refundAmount: json['refund_amount'] != null ? double.tryParse(json['refund_amount'].toString()) : null,
      refundTranRef: json['refund_tran_ref'] as String?,
      refundReason: json['refund_reason'] as String?,
      refundedAt: json['refunded_at'] != null ? DateTime.parse(json['refunded_at'] as String) : null,
      notes: json['notes'] as String?,
      redirectUrl: json['redirect_url'] as String?,
      emailLogs: json['email_logs'] != null
          ? (json['email_logs'] as List).map((e) => PaymentEmailLog.fromJson(Map<String, dynamic>.from(e as Map))).toList()
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'invoice_id': invoiceId,
      'purpose': purpose?.value,
      'purpose_label': purposeLabel,
      'amount': amount,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'currency': currency,
      'status': status.value,
      'gateway': gateway,
      'tran_ref': tranRef,
      'tran_type': tranType,
      'cart_id': cartId,
      'response_status': responseStatus,
      'response_code': responseCode,
      'response_message': responseMessage,
      'card_type': cardType,
      'card_scheme': cardScheme,
      'payment_description': paymentDescription,
      'payment_method': paymentMethod,
      'confirmation_email_sent': confirmationEmailSent,
      'confirmation_email_sent_at': confirmationEmailSentAt?.toIso8601String(),
      'confirmation_email_error': confirmationEmailError,
      'invoice_generated': invoiceGenerated,
      'invoice_generated_at': invoiceGeneratedAt?.toIso8601String(),
      'ipn_received': ipnReceived,
      'ipn_received_at': ipnReceivedAt?.toIso8601String(),
      'refund_amount': refundAmount,
      'refund_tran_ref': refundTranRef,
      'refund_reason': refundReason,
      'refunded_at': refundedAt?.toIso8601String(),
      'notes': notes,
      'redirect_url': redirectUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProviderPayment copyWith({
    String? id,
    String? organizationId,
    String? invoiceId,
    PaymentPurpose? purpose,
    String? purposeLabel,
    double? amount,
    double? taxAmount,
    double? totalAmount,
    String? currency,
    ProviderPaymentStatus? status,
    String? gateway,
    String? tranRef,
    String? tranType,
    String? cartId,
    String? responseStatus,
    String? responseCode,
    String? responseMessage,
    String? cardType,
    String? cardScheme,
    String? paymentDescription,
    String? paymentMethod,
    bool? confirmationEmailSent,
    DateTime? confirmationEmailSentAt,
    String? confirmationEmailError,
    bool? invoiceGenerated,
    DateTime? invoiceGeneratedAt,
    bool? ipnReceived,
    DateTime? ipnReceivedAt,
    double? refundAmount,
    String? refundTranRef,
    String? refundReason,
    DateTime? refundedAt,
    String? notes,
    String? redirectUrl,
    List<PaymentEmailLog>? emailLogs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProviderPayment(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      invoiceId: invoiceId ?? this.invoiceId,
      purpose: purpose ?? this.purpose,
      purposeLabel: purposeLabel ?? this.purposeLabel,
      amount: amount ?? this.amount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      gateway: gateway ?? this.gateway,
      tranRef: tranRef ?? this.tranRef,
      tranType: tranType ?? this.tranType,
      cartId: cartId ?? this.cartId,
      responseStatus: responseStatus ?? this.responseStatus,
      responseCode: responseCode ?? this.responseCode,
      responseMessage: responseMessage ?? this.responseMessage,
      cardType: cardType ?? this.cardType,
      cardScheme: cardScheme ?? this.cardScheme,
      paymentDescription: paymentDescription ?? this.paymentDescription,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      confirmationEmailSent: confirmationEmailSent ?? this.confirmationEmailSent,
      confirmationEmailSentAt: confirmationEmailSentAt ?? this.confirmationEmailSentAt,
      confirmationEmailError: confirmationEmailError ?? this.confirmationEmailError,
      invoiceGenerated: invoiceGenerated ?? this.invoiceGenerated,
      invoiceGeneratedAt: invoiceGeneratedAt ?? this.invoiceGeneratedAt,
      ipnReceived: ipnReceived ?? this.ipnReceived,
      ipnReceivedAt: ipnReceivedAt ?? this.ipnReceivedAt,
      refundAmount: refundAmount ?? this.refundAmount,
      refundTranRef: refundTranRef ?? this.refundTranRef,
      refundReason: refundReason ?? this.refundReason,
      refundedAt: refundedAt ?? this.refundedAt,
      notes: notes ?? this.notes,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      emailLogs: emailLogs ?? this.emailLogs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isSuccessful => status == ProviderPaymentStatus.completed;
  bool get isPending => status == ProviderPaymentStatus.pending;
  bool get canRefund => isSuccessful && refundAmount == null;

  String get formattedAmount => '${totalAmount.toStringAsFixed(2)} ${currency ?? 'SAR'}';

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProviderPayment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProviderPayment(id: $id, cartId: $cartId, status: ${status.value}, total: $totalAmount)';
}
