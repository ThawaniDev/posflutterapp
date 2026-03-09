enum SubscriptionStatus {
  trial('trial'),
  active('active'),
  grace('grace'),
  cancelled('cancelled'),
  expired('expired');

  const SubscriptionStatus(this.value);
  final String value;

  static SubscriptionStatus fromValue(String value) {
    return SubscriptionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SubscriptionStatus: $value'),
    );
  }

  static SubscriptionStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
