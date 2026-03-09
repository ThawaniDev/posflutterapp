enum AppReleaseChannel {
  stable('stable'),
  beta('beta'),
  testflight('testflight'),
  internalTest('internal_test');

  const AppReleaseChannel(this.value);
  final String value;

  static AppReleaseChannel fromValue(String value) {
    return AppReleaseChannel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AppReleaseChannel: $value'),
    );
  }

  static AppReleaseChannel? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
