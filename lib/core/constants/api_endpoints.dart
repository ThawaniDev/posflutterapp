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
  static const String roles = '/staff/roles';
  static const String userPermissions = '/staff/roles/user-permissions';
  static const String permissions = '/staff/permissions';
  static const String permissionsGrouped = '/staff/permissions/grouped';
  static const String permissionsModules = '/staff/permissions/modules';
  static const String permissionsPinProtected = '/staff/permissions/pin-protected';
  static const String pinOverride = '/staff/pin-override';
  static const String pinOverrideCheck = '/staff/pin-override/check';
  static const String pinOverrideHistory = '/staff/pin-override/history';

  // Settings
  static const String settings = '/settings';
  static const String featureFlags = '/settings/feature-flags';

  // Notifications
  static const String notifications = '/notifications';
  static const String fcmTokens = '/notifications/fcm-tokens';

  // Store (Core)
  static const String storesMine = '/core/stores/mine';
  static const String stores = '/core/stores';
  static String storeById(String id) => '/core/stores/$id';
  static String storeSettings(String id) => '/core/stores/$id/settings';
  static String storeWorkingHours(String id) => '/core/stores/$id/working-hours';
  static String storeApplyBusinessType(String id) => '/core/stores/$id/business-type';
  static const String businessTypes = '/core/business-types';

  // Onboarding
  static const String onboardingSteps = '/core/onboarding/steps';
  static const String onboardingProgress = '/core/onboarding/progress';
  static const String onboardingCompleteStep = '/core/onboarding/complete-step';
  static const String onboardingSkip = '/core/onboarding/skip';
  static const String onboardingChecklist = '/core/onboarding/checklist';
  static const String onboardingDismissChecklist = '/core/onboarding/dismiss-checklist';
  static const String onboardingReset = '/core/onboarding/reset';

  // Subscription
  static const String subscriptionPlans = '/subscription/plans';
  static const String subscriptionAddOns = '/subscription/add-ons';
  static const String subscriptionCurrent = '/subscription/current';
  static const String subscriptionSubscribe = '/subscription/subscribe';
  static const String subscriptionChangePlan = '/subscription/change-plan';
  static const String subscriptionCancel = '/subscription/cancel';
  static const String subscriptionResume = '/subscription/resume';
  static const String subscriptionUsage = '/subscription/usage';
  static const String subscriptionCheckFeature = '/subscription/check-feature';
  static const String subscriptionCheckLimit = '/subscription/check-limit';
  static const String subscriptionInvoices = '/subscription/invoices';
}
