enum PurchaseType {
  oneTime('one_time'),
  subscription('subscription');

  const PurchaseType(this.value);
  final String value;

  static PurchaseType fromValue(String value) {
    return PurchaseType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PurchaseType: $value'),
    );
  }

  static PurchaseType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
