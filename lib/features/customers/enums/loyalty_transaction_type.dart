enum LoyaltyTransactionType {
  earn('earn'),
  redeem('redeem'),
  adjust('adjust'),
  expire('expire');

  const LoyaltyTransactionType(this.value);
  final String value;

  static LoyaltyTransactionType fromValue(String value) {
    return LoyaltyTransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid LoyaltyTransactionType: $value'),
    );
  }

  static LoyaltyTransactionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
