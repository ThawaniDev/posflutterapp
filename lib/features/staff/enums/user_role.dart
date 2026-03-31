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

  String get label {
    switch (this) {
      case UserRole.owner:
        return 'Owner';
      case UserRole.chainManager:
        return 'Chain Manager';
      case UserRole.branchManager:
        return 'Branch Manager';
      case UserRole.cashier:
        return 'Cashier';
      case UserRole.inventoryClerk:
        return 'Inventory Clerk';
      case UserRole.accountant:
        return 'Accountant';
      case UserRole.kitchenStaff:
        return 'Kitchen Staff';
    }
  }

  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere((e) => e.value == value, orElse: () => throw ArgumentError('Invalid UserRole: $value'));
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
