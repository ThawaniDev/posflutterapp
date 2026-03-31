import 'package:thawani_pos/features/pos_terminal/enums/payment_method.dart';

class Payment {
  final String id;
  final String transactionId;
  final PaymentMethod method;
  final double amount;
  final double? cashTendered;
  final double? changeGiven;
  final double? tipAmount;
  final String? cardLastFour;
  final String? cardBrand;
  final String? cardAuthCode;
  final String? cardReferenceNumber;
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
    this.cardLastFour,
    this.cardBrand,
    this.cardAuthCode,
    this.cardReferenceNumber,
    this.giftCardCode,
    this.couponCode,
    this.loyaltyPointsUsed,
    this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      method: PaymentMethod.fromValue(json['method'] as String),
      amount: (json['amount'] as num).toDouble(),
      cashTendered: (json['cash_tendered'] as num?)?.toDouble(),
      changeGiven: (json['change_given'] as num?)?.toDouble(),
      tipAmount: (json['tip_amount'] as num?)?.toDouble(),
      cardLastFour: json['card_last_four'] as String?,
      cardBrand: json['card_brand'] as String?,
      cardAuthCode: json['card_auth_code'] as String?,
      cardReferenceNumber: json['card_reference_number'] as String?,
      giftCardCode: json['gift_card_code'] as String?,
      couponCode: json['coupon_code'] as String?,
      loyaltyPointsUsed: (json['loyalty_points_used'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method.value,
      'amount': amount,
      if (cashTendered != null) 'cash_tendered': cashTendered,
      if (changeGiven != null) 'change_given': changeGiven,
      if (tipAmount != null) 'tip_amount': tipAmount,
      if (cardLastFour != null) 'card_last_four': cardLastFour,
      if (cardBrand != null) 'card_brand': cardBrand,
      if (cardAuthCode != null) 'card_auth_code': cardAuthCode,
      if (cardReferenceNumber != null) 'card_reference_number': cardReferenceNumber,
      if (giftCardCode != null) 'gift_card_code': giftCardCode,
      if (couponCode != null) 'coupon_code': couponCode,
      if (loyaltyPointsUsed != null) 'loyalty_points_used': loyaltyPointsUsed,
    };
  }
}
