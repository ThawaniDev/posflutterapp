class PaymentEmailLog {
  final String id;
  final String? providerPaymentId;
  final String? invoiceId;
  final String? emailType;
  final String? recipientEmail;
  final String? subject;
  final String? status;
  final String? errorMessage;
  final String? mailtrapMessageId;
  final DateTime? createdAt;

  const PaymentEmailLog({
    required this.id,
    this.providerPaymentId,
    this.invoiceId,
    this.emailType,
    this.recipientEmail,
    this.subject,
    this.status,
    this.errorMessage,
    this.mailtrapMessageId,
    this.createdAt,
  });

  factory PaymentEmailLog.fromJson(Map<String, dynamic> json) {
    return PaymentEmailLog(
      id: json['id'] as String,
      providerPaymentId: json['provider_payment_id'] as String?,
      invoiceId: json['invoice_id'] as String?,
      emailType: json['email_type'] as String?,
      recipientEmail: json['recipient_email'] as String?,
      subject: json['subject'] as String?,
      status: json['status'] as String?,
      errorMessage: json['error_message'] as String?,
      mailtrapMessageId: json['mailtrap_message_id'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_payment_id': providerPaymentId,
      'invoice_id': invoiceId,
      'email_type': emailType,
      'recipient_email': recipientEmail,
      'subject': subject,
      'status': status,
      'error_message': errorMessage,
      'mailtrap_message_id': mailtrapMessageId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentEmailLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PaymentEmailLog(id: $id, type: $emailType, status: $status)';
}
