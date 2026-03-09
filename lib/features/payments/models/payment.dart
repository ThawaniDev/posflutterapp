import 'package:thawani_pos/features/payments/enums/payment_method_key.dart';

class Payment {
  final String id;
  final String transactionId;
  final PaymentMethodKey method;
  final double amount;
  final double? cashTendered;
  final double? changeGiven;
  final double? tipAmount;
  final String? cardBrand;
  final String? cardLastFour;
  final String? cardAuthCode;
  final String? cardReference;
  final String? giftCardCode;
  final String? couponCode;
  final int? loyaltyPointsUsed;
  final DateTime? createdAt;

  const Payment({
    required this.id,
    required this.transactionId,
    required this.method,
    required this.amount,
    this.cashTendered,
    this.changeGiven,
    this.tipAmount,
    this.cardBrand,
    this.cardLastFour,
    this.cardAuthCode,
    this.cardReference,
    this.giftCardCode,
    this.couponCode,
    this.loyaltyPointsUsed,
    this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      method: PaymentMethodKey.fromValue(json['method'] as String),
      amount: (json['amount'] as num).toDouble(),
      cashTendered: (json['cash_tendered'] as num?)?.toDouble(),
      changeGiven: (json['change_given'] as num?)?.toDouble(),
      tipAmount: (json['tip_amount'] as num?)?.toDouble(),
      cardBrand: json['card_brand'] as String?,
      cardLastFour: json['card_last_four'] as String?,
      cardAuthCode: json['card_auth_code'] as String?,
      cardReference: json['card_reference'] as String?,
      giftCardCode: json['gift_card_code'] as String?,
      couponCode: json['coupon_code'] as String?,
      loyaltyPointsUsed: (json['loyalty_points_used'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'method': method.value,
      'amount': amount,
      'cash_tendered': cashTendered,
      'change_given': changeGiven,
      'tip_amount': tipAmount,
      'card_brand': cardBrand,
      'card_last_four': cardLastFour,
      'card_auth_code': cardAuthCode,
      'card_reference': cardReference,
      'gift_card_code': giftCardCode,
      'coupon_code': couponCode,
      'loyalty_points_used': loyaltyPointsUsed,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Payment copyWith({
    String? id,
    String? transactionId,
    PaymentMethodKey? method,
    double? amount,
    double? cashTendered,
    double? changeGiven,
    double? tipAmount,
    String? cardBrand,
    String? cardLastFour,
    String? cardAuthCode,
    String? cardReference,
    String? giftCardCode,
    String? couponCode,
    int? loyaltyPointsUsed,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      cashTendered: cashTendered ?? this.cashTendered,
      changeGiven: changeGiven ?? this.changeGiven,
      tipAmount: tipAmount ?? this.tipAmount,
      cardBrand: cardBrand ?? this.cardBrand,
      cardLastFour: cardLastFour ?? this.cardLastFour,
      cardAuthCode: cardAuthCode ?? this.cardAuthCode,
      cardReference: cardReference ?? this.cardReference,
      giftCardCode: giftCardCode ?? this.giftCardCode,
      couponCode: couponCode ?? this.couponCode,
      loyaltyPointsUsed: loyaltyPointsUsed ?? this.loyaltyPointsUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Payment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Payment(id: $id, transactionId: $transactionId, method: $method, amount: $amount, cashTendered: $cashTendered, changeGiven: $changeGiven, ...)';
}
