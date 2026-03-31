enum MarketplacePricingType {
  free('free'),
  oneTime('one_time'),
  subscription('subscription');

  const MarketplacePricingType(this.value);
  final String value;

  static MarketplacePricingType fromValue(String value) {
    return MarketplacePricingType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid MarketplacePricingType: $value'),
    );
  }

  static MarketplacePricingType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
