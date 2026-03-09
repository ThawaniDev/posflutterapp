enum RoleAuditAction {
  roleCreated('role_created'),
  roleUpdated('role_updated'),
  permissionGranted('permission_granted'),
  permissionRevoked('permission_revoked');

  const RoleAuditAction(this.value);
  final String value;

  static RoleAuditAction fromValue(String value) {
    return RoleAuditAction.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid RoleAuditAction: $value'),
    );
  }

  static RoleAuditAction? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
