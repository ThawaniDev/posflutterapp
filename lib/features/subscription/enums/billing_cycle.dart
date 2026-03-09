enum BillingCycle {
  monthly('monthly'),
  yearly('yearly');

  const BillingCycle(this.value);
  final String value;

  static BillingCycle fromValue(String value) {
    return BillingCycle.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BillingCycle: $value'),
    );
  }

  static BillingCycle? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
