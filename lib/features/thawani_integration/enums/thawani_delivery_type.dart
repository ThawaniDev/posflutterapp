enum ThawaniDeliveryType {
  delivery('delivery'),
  pickup('pickup');

  const ThawaniDeliveryType(this.value);
  final String value;

  static ThawaniDeliveryType fromValue(String value) {
    return ThawaniDeliveryType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ThawaniDeliveryType: $value'),
    );
  }

  static ThawaniDeliveryType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
