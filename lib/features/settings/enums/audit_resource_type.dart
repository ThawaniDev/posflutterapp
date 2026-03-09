enum AuditResourceType {
  order('order'),
  product('product'),
  staffUser('staff_user'),
  settings('settings');

  const AuditResourceType(this.value);
  final String value;

  static AuditResourceType fromValue(String value) {
    return AuditResourceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AuditResourceType: $value'),
    );
  }

  static AuditResourceType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
