enum SecurityAlertType {
  bruteForce('brute_force'),
  bulkExport('bulk_export'),
  unusualIp('unusual_ip'),
  permissionEscalation('permission_escalation'),
  afterHoursAccess('after_hours_access');

  const SecurityAlertType(this.value);
  final String value;

  static SecurityAlertType fromValue(String value) {
    return SecurityAlertType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SecurityAlertType: $value'),
    );
  }

  static SecurityAlertType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
