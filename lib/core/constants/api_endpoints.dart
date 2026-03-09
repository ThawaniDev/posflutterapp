class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String loginPin = '/auth/login/pin';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';

  // Catalog
  static const String products = '/catalog/products';
  static const String categories = '/catalog/categories';
  static const String suppliers = '/catalog/suppliers';
  static const String barcodes = '/catalog/barcodes';

  // Inventory
  static const String stockLevels = '/inventory/stock-levels';
  static const String stockAdjustments = '/inventory/adjustments';
  static const String stockTransfers = '/inventory/transfers';
  static const String purchaseOrders = '/inventory/purchase-orders';

  // POS
  static const String posSessions = '/pos/sessions';
  static const String transactions = '/pos/transactions';
  static const String heldCarts = '/pos/held-carts';

  // Orders
  static const String orders = '/orders';
  static const String returns = '/orders/returns';

  // Payments
  static const String payments = '/payments';
  static const String cashSessions = '/payments/cash-sessions';
  static const String giftCards = '/payments/gift-cards';

  // Customers
  static const String customers = '/customers';
  static const String customerGroups = '/customers/groups';
  static const String loyalty = '/customers/loyalty';

  // Reports
  static const String dailySales = '/reports/daily-sales';
  static const String productSales = '/reports/product-sales';

  // Staff
  static const String staffUsers = '/staff/users';
  static const String attendance = '/staff/attendance';

  // Settings
  static const String settings = '/settings';
  static const String featureFlags = '/settings/feature-flags';

  // Notifications
  static const String notifications = '/notifications';
  static const String fcmTokens = '/notifications/fcm-tokens';
}
