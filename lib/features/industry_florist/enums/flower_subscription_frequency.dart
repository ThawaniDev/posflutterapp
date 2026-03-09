enum FlowerSubscriptionFrequency {
  weekly('weekly'),
  biweekly('biweekly'),
  monthly('monthly');

  const FlowerSubscriptionFrequency(this.value);
  final String value;

  static FlowerSubscriptionFrequency fromValue(String value) {
    return FlowerSubscriptionFrequency.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid FlowerSubscriptionFrequency: $value'),
    );
  }

  static FlowerSubscriptionFrequency? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
