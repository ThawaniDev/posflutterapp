enum PosTheme {
  light('light'),
  dark('dark'),
  custom('custom');

  const PosTheme(this.value);
  final String value;

  static PosTheme fromValue(String value) {
    return PosTheme.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PosTheme: $value'),
    );
  }

  static PosTheme? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
