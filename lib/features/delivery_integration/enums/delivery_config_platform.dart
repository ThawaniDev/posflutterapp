enum DeliveryConfigPlatform {
  hungerstation('hungerstation'),
  jahez('jahez'),
  marsool('marsool');

  const DeliveryConfigPlatform(this.value);
  final String value;

  static DeliveryConfigPlatform fromValue(String value) {
    return DeliveryConfigPlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeliveryConfigPlatform: $value'),
    );
  }

  static DeliveryConfigPlatform? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
