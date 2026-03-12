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
  static const String staffRoles = '/staff/roles';
  static const String staffRoleDetail = '/staff/roles/detail'; // + /:id
  static const String staffRoleCreate = '/staff/roles/create';

  // Onboarding & Store Setup
  static const String onboarding = '/onboarding';
  static const String storeSettings = '/store/settings'; // + /:storeId
  static const String workingHours = '/store/working-hours'; // + /:storeId

  // Subscription
  static const String planSelection = '/subscription/plans';
  static const String subscriptionStatus = '/subscription/status';
  static const String billingHistory = '/subscription/billing';
}
