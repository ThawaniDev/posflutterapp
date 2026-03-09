enum LayoutDirection {
  ltr('ltr'),
  rtl('rtl'),
  auto('auto');

  const LayoutDirection(this.value);
  final String value;

  static LayoutDirection fromValue(String value) {
    return LayoutDirection.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid LayoutDirection: $value'),
    );
  }

  static LayoutDirection? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
