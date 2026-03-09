enum GatewayEnvironment {
  sandbox('sandbox'),
  production('production');

  const GatewayEnvironment(this.value);
  final String value;

  static GatewayEnvironment fromValue(String value) {
    return GatewayEnvironment.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GatewayEnvironment: $value'),
    );
  }

  static GatewayEnvironment? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
