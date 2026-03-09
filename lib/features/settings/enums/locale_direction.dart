enum LocaleDirection {
  ltr('ltr'),
  rtl('rtl');

  const LocaleDirection(this.value);
  final String value;

  static LocaleDirection fromValue(String value) {
    return LocaleDirection.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid LocaleDirection: $value'),
    );
  }

  static LocaleDirection? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
