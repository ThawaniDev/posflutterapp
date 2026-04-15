import 'package:wameedpos/features/payments/enums/installment_payment_status.dart';
import 'package:wameedpos/features/payments/enums/installment_provider.dart';

/// Tracks the lifecycle of a single installment payment.
class InstallmentPayment {
  final String id;
  final String storeId;
  final String? transactionId;
  final String? paymentId;
  final InstallmentProvider provider;
  final InstallmentPaymentStatus status;
  final double amount;
  final String currency;
  final int? installmentCount;
  final String? checkoutUrl;
  final String? providerOrderId;
  final String? providerCheckoutId;
  final String? providerPaymentId;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? errorCode;
  final String? errorMessage;
  final String? initiatedAt;
  final String? completedAt;
  final String? createdAt;
  final String? updatedAt;

  const InstallmentPayment({
    required this.id,
    required this.storeId,
    required this.provider,
    required this.status,
    required this.amount,
    this.transactionId,
    this.paymentId,
    this.currency = 'SAR',
    this.installmentCount,
    this.checkoutUrl,
    this.providerOrderId,
    this.providerCheckoutId,
    this.providerPaymentId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.errorCode,
    this.errorMessage,
    this.initiatedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory InstallmentPayment.fromJson(Map<String, dynamic> json) {
    return InstallmentPayment(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      transactionId: json['transaction_id'] as String?,
      paymentId: json['payment_id'] as String?,
      provider: InstallmentProvider.fromValue(json['provider'] as String),
      status: InstallmentPaymentStatus.fromValue(json['status'] as String),
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      currency: json['currency'] as String? ?? 'SAR',
      installmentCount: json['installment_count'] as int?,
      checkoutUrl: json['checkout_url'] as String?,
      providerOrderId: json['provider_order_id'] as String?,
      providerCheckoutId: json['provider_checkout_id'] as String?,
      providerPaymentId: json['provider_payment_id'] as String?,
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      customerEmail: json['customer_email'] as String?,
      errorCode: json['error_code'] as String?,
      errorMessage: json['error_message'] as String?,
      initiatedAt: json['initiated_at'] as String?,
      completedAt: json['completed_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'transaction_id': transactionId,
    'payment_id': paymentId,
    'provider': provider.value,
    'status': status.value,
    'amount': amount,
    'currency': currency,
    'installment_count': installmentCount,
    'checkout_url': checkoutUrl,
    'provider_order_id': providerOrderId,
    'provider_checkout_id': providerCheckoutId,
    'provider_payment_id': providerPaymentId,
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'customer_email': customerEmail,
    'error_code': errorCode,
    'error_message': errorMessage,
  };

  InstallmentPayment copyWith({
    String? id,
    String? storeId,
    String? transactionId,
    String? paymentId,
    InstallmentProvider? provider,
    InstallmentPaymentStatus? status,
    double? amount,
    String? currency,
    int? installmentCount,
    String? checkoutUrl,
    String? providerOrderId,
    String? providerCheckoutId,
    String? providerPaymentId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? errorCode,
    String? errorMessage,
  }) {
    return InstallmentPayment(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      transactionId: transactionId ?? this.transactionId,
      paymentId: paymentId ?? this.paymentId,
      provider: provider ?? this.provider,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      installmentCount: installmentCount ?? this.installmentCount,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      providerOrderId: providerOrderId ?? this.providerOrderId,
      providerCheckoutId: providerCheckoutId ?? this.providerCheckoutId,
      providerPaymentId: providerPaymentId ?? this.providerPaymentId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is InstallmentPayment && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
