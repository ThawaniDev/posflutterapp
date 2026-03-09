enum SubscriptionResourceType {
  products('products'),
  staff('staff'),
  branches('branches'),
  transactionsMonth('transactions_month');

  const SubscriptionResourceType(this.value);
  final String value;

  static SubscriptionResourceType fromValue(String value) {
    return SubscriptionResourceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SubscriptionResourceType: $value'),
    );
  }

  static SubscriptionResourceType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
