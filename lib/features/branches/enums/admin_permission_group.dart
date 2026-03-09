enum AdminPermissionGroup {
  stores('Stores'),
  billing('Billing'),
  tickets('Tickets'),
  integrations('Integrations'),
  settings('Settings'),
  analytics('Analytics'),
  announcements('Announcements'),
  users('Users'),
  appUpdates('App Updates');

  const AdminPermissionGroup(this.value);
  final String value;

  static AdminPermissionGroup fromValue(String value) {
    return AdminPermissionGroup.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AdminPermissionGroup: $value'),
    );
  }

  static AdminPermissionGroup? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
