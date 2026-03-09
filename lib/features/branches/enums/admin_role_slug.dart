enum AdminRoleSlug {
  superAdmin('super_admin'),
  platformManager('platform_manager'),
  supportAgent('support_agent'),
  financeAdmin('finance_admin'),
  integrationManager('integration_manager'),
  sales('sales'),
  viewer('viewer');

  const AdminRoleSlug(this.value);
  final String value;

  static AdminRoleSlug fromValue(String value) {
    return AdminRoleSlug.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AdminRoleSlug: $value'),
    );
  }

  static AdminRoleSlug? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
