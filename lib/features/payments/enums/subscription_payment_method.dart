enum SubscriptionPaymentMethod {
  creditCard('credit_card'),
  mada('mada'),
  bankTransfer('bank_transfer');

  const SubscriptionPaymentMethod(this.value);
  final String value;

  static SubscriptionPaymentMethod fromValue(String value) {
    return SubscriptionPaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SubscriptionPaymentMethod: $value'),
    );
  }

  static SubscriptionPaymentMethod? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
