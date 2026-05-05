enum PaymentMethodKey {
  cash('cash'),
  card('card'),
  cardMada('card_mada'),
  cardVisa('card_visa'),
  cardMastercard('card_mastercard'),
  mada('mada'),
  applePay('apple_pay'),
  stcPay('stc_pay'),
  storeCredit('store_credit'),
  giftCard('gift_card'),
  mobilePayment('mobile_payment'),
  loyaltyPoints('loyalty_points'),
  bankTransfer('bank_transfer'),
  tabby('tabby'),
  tamara('tamara'),
  mispay('mispay'),
  madfu('madfu'),
  softPos('soft_pos'),
  other('other');

  const PaymentMethodKey(this.value);
  final String value;

  /// Tolerant parser: unknown values fall back to [PaymentMethodKey.other]
  /// so a transaction response with a new/server-defined method never breaks
  /// the client.
  static PaymentMethodKey fromValue(String value) {
    return PaymentMethodKey.values.firstWhere((e) => e.value == value, orElse: () => PaymentMethodKey.other);
  }

  static PaymentMethodKey? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return PaymentMethodKey.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
