enum SecurityAuditAction {
  login('login'),
  logout('logout'),
  pinOverride('pin_override'),
  failedLogin('failed_login'),
  settingsChange('settings_change'),
  remoteWipe('remote_wipe');

  const SecurityAuditAction(this.value);
  final String value;

  static SecurityAuditAction fromValue(String value) {
    return SecurityAuditAction.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SecurityAuditAction: $value'),
    );
  }

  static SecurityAuditAction? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
