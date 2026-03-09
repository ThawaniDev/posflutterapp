enum LoginAttemptType {
  pin('pin'),
  password('password'),
  biometric('biometric'),
  twoFactor('two_factor');

  const LoginAttemptType(this.value);
  final String value;

  static LoginAttemptType fromValue(String value) {
    return LoginAttemptType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid LoginAttemptType: $value'),
    );
  }

  static LoginAttemptType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
