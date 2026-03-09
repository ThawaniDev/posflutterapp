enum RegisterPlatform {
  windows('windows'),
  macos('macos'),
  ios('ios'),
  android('android');

  const RegisterPlatform(this.value);
  final String value;

  static RegisterPlatform fromValue(String value) {
    return RegisterPlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid RegisterPlatform: $value'),
    );
  }

  static RegisterPlatform? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
