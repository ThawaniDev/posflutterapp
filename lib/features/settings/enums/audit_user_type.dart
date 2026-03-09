enum AuditUserType {
  staff('staff'),
  owner('owner'),
  system('system');

  const AuditUserType(this.value);
  final String value;

  static AuditUserType fromValue(String value) {
    return AuditUserType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AuditUserType: $value'),
    );
  }

  static AuditUserType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
