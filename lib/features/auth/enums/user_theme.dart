enum UserTheme {
  systemDefault('default'),
  lightClassic('light_classic'),
  darkMode('dark_mode'),
  highContrast('high_contrast'),
  thawaniBrand('thawani_brand'),
  custom('custom');

  const UserTheme(this.value);
  final String value;

  static UserTheme fromValue(String value) {
    return UserTheme.values.firstWhere((e) => e.value == value, orElse: () => throw ArgumentError('Invalid UserTheme: $value'));
  }

  static UserTheme? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
