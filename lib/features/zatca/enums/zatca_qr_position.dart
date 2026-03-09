enum ZatcaQrPosition {
  header('header'),
  footer('footer');

  const ZatcaQrPosition(this.value);
  final String value;

  static ZatcaQrPosition fromValue(String value) {
    return ZatcaQrPosition.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ZatcaQrPosition: $value'),
    );
  }

  static ZatcaQrPosition? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
