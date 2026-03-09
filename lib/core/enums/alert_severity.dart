enum AlertSeverity {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const AlertSeverity(this.value);
  final String value;

  static AlertSeverity fromValue(String value) {
    return AlertSeverity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AlertSeverity: $value'),
    );
  }

  static AlertSeverity? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
