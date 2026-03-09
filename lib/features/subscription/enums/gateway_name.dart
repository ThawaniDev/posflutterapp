enum GatewayName {
  thawaniPay('thawani_pay'),
  stripe('stripe'),
  moyasar('moyasar');

  const GatewayName(this.value);
  final String value;

  static GatewayName fromValue(String value) {
    return GatewayName.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GatewayName: $value'),
    );
  }

  static GatewayName? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
