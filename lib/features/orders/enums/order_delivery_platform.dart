enum OrderDeliveryPlatform {
  hungerstation('hungerstation'),
  jahez('jahez'),
  marsool('marsool'),
  internal('internal'),
  phone('phone');

  const OrderDeliveryPlatform(this.value);
  final String value;

  static OrderDeliveryPlatform fromValue(String value) {
    return OrderDeliveryPlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid OrderDeliveryPlatform: $value'),
    );
  }

  static OrderDeliveryPlatform? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
