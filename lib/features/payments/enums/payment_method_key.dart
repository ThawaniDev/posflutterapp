enum PaymentMethodKey {
  cash('cash'),
  cardMada('card_mada'),
  cardVisa('card_visa'),
  cardMastercard('card_mastercard'),
  storeCredit('store_credit'),
  giftCard('gift_card'),
  mobilePayment('mobile_payment');

  const PaymentMethodKey(this.value);
  final String value;

  static PaymentMethodKey fromValue(String value) {
    return PaymentMethodKey.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PaymentMethodKey: $value'),
    );
  }

  static PaymentMethodKey? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
