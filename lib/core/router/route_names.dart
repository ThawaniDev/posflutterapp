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
  static const String posSessions = '/pos/sessions';

  // Catalog
  static const String products = '/products';
  static const String productsAdd = '/products/add';
  static const String productsEdit = '/products'; // + /:id
  static const String categories = '/categories';
  static const String suppliers = '/suppliers';

  // Inventory
  static const String inventory = '/inventory';
  static const String stockLevels = '/inventory/stock-levels';
  static const String stockMovements = '/inventory/stock-movements';
  static const String goodsReceipts = '/inventory/goods-receipts';
  static const String goodsReceiptsAdd = '/inventory/goods-receipts/add';
  static const String stockAdjustments = '/inventory/stock-adjustments';
  static const String stockTransfers = '/inventory/stock-transfers';
  static const String purchaseOrders = '/inventory/purchase-orders';
  static const String recipes = '/inventory/recipes';

  // Orders
  static const String orders = '/orders';

  // Payments
  static const String cashSessions = '/cash-sessions';

  // Customers
  static const String customers = '/customers';

  // Labels
  static const String labels = '/labels';

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
