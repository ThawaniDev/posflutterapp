enum PaymentMethodCategory {
  cash('cash'),
  card('card'),
  digital('digital'),
  credit('credit');

  const PaymentMethodCategory(this.value);
  final String value;

  static PaymentMethodCategory fromValue(String value) {
    return PaymentMethodCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PaymentMethodCategory: $value'),
    );
  }

  static PaymentMethodCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
