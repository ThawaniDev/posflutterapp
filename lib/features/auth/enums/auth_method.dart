enum AuthMethod {
  pin('pin'),
  nfc('nfc'),
  biometric('biometric');

  const AuthMethod(this.value);
  final String value;

  static AuthMethod fromValue(String value) {
    return AuthMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AuthMethod: $value'),
    );
  }

  static AuthMethod? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
