enum BuybackPaymentMethod {
  cash('cash'),
  bankTransfer('bank_transfer'),
  creditNote('credit_note');

  const BuybackPaymentMethod(this.value);
  final String value;

  static BuybackPaymentMethod fromValue(String value) {
    return BuybackPaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BuybackPaymentMethod: $value'),
    );
  }

  static BuybackPaymentMethod? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
