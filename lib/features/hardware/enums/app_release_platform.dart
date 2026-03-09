enum AppReleasePlatform {
  windows('windows'),
  macos('macos'),
  ios('ios'),
  android('android');

  const AppReleasePlatform(this.value);
  final String value;

  static AppReleasePlatform fromValue(String value) {
    return AppReleasePlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AppReleasePlatform: $value'),
    );
  }

  static AppReleasePlatform? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
