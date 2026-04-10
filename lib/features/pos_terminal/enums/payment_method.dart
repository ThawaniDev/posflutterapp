enum PaymentMethod {
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
  madfu('madfu');

  const PaymentMethod(this.value);
  final String value;

  static PaymentMethod fromValue(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PaymentMethod: $value'),
    );
  }

  static PaymentMethod? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }

  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.cardMada:
        return 'Mada Card';
      case PaymentMethod.cardVisa:
        return 'Visa Card';
      case PaymentMethod.cardMastercard:
        return 'Mastercard';
      case PaymentMethod.mada:
        return 'Mada';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.stcPay:
        return 'STC Pay';
      case PaymentMethod.storeCredit:
        return 'Store Credit';
      case PaymentMethod.giftCard:
        return 'Gift Card';
      case PaymentMethod.mobilePayment:
        return 'Mobile Payment';
      case PaymentMethod.loyaltyPoints:
        return 'Loyalty Points';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.tabby:
        return 'Tabby';
      case PaymentMethod.tamara:
        return 'Tamara';
      case PaymentMethod.mispay:
        return 'MisPay';
      case PaymentMethod.madfu:
        return 'Madfu';
    }
  }

  bool get isCardType =>
      this == PaymentMethod.card ||
      this == PaymentMethod.cardMada ||
      this == PaymentMethod.cardVisa ||
      this == PaymentMethod.cardMastercard ||
      this == PaymentMethod.mada;

  bool get isInstallment =>
      this == PaymentMethod.tabby || this == PaymentMethod.tamara || this == PaymentMethod.mispay || this == PaymentMethod.madfu;
}
