enum AuditSeverity {
  info('info'),
  warning('warning'),
  critical('critical');

  const AuditSeverity(this.value);
  final String value;

  static AuditSeverity fromValue(String value) {
    return AuditSeverity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AuditSeverity: $value'),
    );
  }

  static AuditSeverity? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
