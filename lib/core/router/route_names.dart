class Routes {
  Routes._();

  // Auth
  static const String login = '/login';
  static const String loginPin = '/login/pin';
  static const String register = '/register';

  // Main
  static const String dashboard = '/dashboard';
  static const String pos = '/pos';
  static const String posCheckout = '/pos/checkout';
  static const String posShiftOpen = '/pos/shift/open';

  // Catalog
  static const String products = '/products';
  static const String productsAdd = '/products/add';
  static const String categories = '/categories';

  // Inventory
  static const String inventory = '/inventory';
  static const String stockAdjustments = '/inventory/adjustments';

  // Orders
  static const String orders = '/orders';

  // Customers
  static const String customers = '/customers';

  // Reports
  static const String reports = '/reports';

  // Settings
  static const String settings = '/settings';

  // Staff
  static const String staff = '/staff';
}
