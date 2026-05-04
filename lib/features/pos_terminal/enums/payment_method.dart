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
  madfu('madfu'),
  softPos('soft_pos');

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

  /// Fallback English label (for non-UI contexts).
  String get label {
    return switch (this) {
      PaymentMethod.cash => 'Cash',
      PaymentMethod.card => 'Card',
      PaymentMethod.cardMada => 'Mada Card',
      PaymentMethod.cardVisa => 'Visa Card',
      PaymentMethod.cardMastercard => 'Mastercard',
      PaymentMethod.mada => 'Mada',
      PaymentMethod.applePay => 'Apple Pay',
      PaymentMethod.stcPay => 'STC Pay',
      PaymentMethod.storeCredit => 'Store Credit',
      PaymentMethod.giftCard => 'Gift Card',
      PaymentMethod.mobilePayment => 'Mobile Payment',
      PaymentMethod.loyaltyPoints => 'Loyalty Points',
      PaymentMethod.bankTransfer => 'Bank Transfer',
      PaymentMethod.tabby => 'Tabby',
      PaymentMethod.tamara => 'Tamara',
      PaymentMethod.mispay => 'MisPay',
      PaymentMethod.madfu => 'Madfu',
      PaymentMethod.softPos => 'SoftPOS',
    };
  }

  bool get isCardType =>
      this == PaymentMethod.card ||
      this == PaymentMethod.cardMada ||
      this == PaymentMethod.cardVisa ||
      this == PaymentMethod.cardMastercard ||
      this == PaymentMethod.mada;

  bool get isSoftPos => this == PaymentMethod.softPos;

  bool get isInstallment =>
      this == PaymentMethod.tabby || this == PaymentMethod.tamara || this == PaymentMethod.mispay || this == PaymentMethod.madfu;
}
