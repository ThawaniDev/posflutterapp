enum UserRole {
  owner('owner'),
  chainManager('chain_manager'),
  branchManager('branch_manager'),
  cashier('cashier'),
  inventoryClerk('inventory_clerk'),
  accountant('accountant'),
  kitchenStaff('kitchen_staff');

  const UserRole(this.value);
  final String value;

  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid UserRole: $value'),
    );
  }

  static UserRole? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
