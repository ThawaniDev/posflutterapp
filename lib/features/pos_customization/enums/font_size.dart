enum FontSize {
  small('small'),
  medium('medium'),
  large('large'),
  extraLarge('extra-large');

  const FontSize(this.value);
  final String value;

  static FontSize fromValue(String value) {
    return FontSize.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid FontSize: $value'),
    );
  }

  static FontSize? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
