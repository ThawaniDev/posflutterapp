enum SubscriptionInterval {
  monthly('monthly'),
  yearly('yearly');

  const SubscriptionInterval(this.value);
  final String value;

  static SubscriptionInterval fromValue(String value) {
    return SubscriptionInterval.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SubscriptionInterval: $value'),
    );
  }

  static SubscriptionInterval? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
