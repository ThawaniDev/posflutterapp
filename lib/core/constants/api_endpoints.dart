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
  static const String stockMovements = '/inventory/stock-movements';
  static const String goodsReceipts = '/inventory/goods-receipts';
  static const String stockAdjustments = '/inventory/stock-adjustments';
  static const String stockTransfers = '/inventory/stock-transfers';
  static const String purchaseOrders = '/inventory/purchase-orders';
  static const String recipes = '/inventory/recipes';

  // POS
  static const String posSessions = '/pos/sessions';
  static const String transactions = '/pos/transactions';
  static const String heldCarts = '/pos/held-carts';

  // Orders
  static const String orders = '/orders';
  static const String returns = '/orders/returns';

  // Payments
  static const String payments = '/payments';
  static const String cashSessions = '/cash-sessions';
  static const String cashEvents = '/cash-events';
  static const String expenses = '/expenses';
  static const String giftCards = '/gift-cards';

  // Customers
  static const String customers = '/customers';
  static const String customerGroups = '/customers/groups';
  static const String loyalty = '/customers/loyalty';

  // Labels
  static const String labelTemplates = '/labels/templates';
  static const String labelPresets = '/labels/templates/presets';
  static const String labelPrintHistory = '/labels/print-history';

  // Reports
  static const String dailySales = '/reports/daily-sales';
  static const String productSales = '/reports/product-sales';
  static const String salesSummary = '/reports/sales-summary';
  static const String productPerformance = '/reports/product-performance';
  static const String categoryBreakdown = '/reports/category-breakdown';
  static const String staffPerformance = '/reports/staff-performance';
  static const String hourlySales = '/reports/hourly-sales';
  static const String paymentMethods = '/reports/payment-methods';
  static const String dashboard = '/reports/dashboard';

  // Staff
  static const String staffUsers = '/staff/users';
  static const String staffMembers = '/staff/members';
  static String staffMemberById(String id) => '/staff/members/$id';
  static String staffMemberPin(String id) => '/staff/members/$id/pin';
  static String staffMemberNfc(String id) => '/staff/members/$id/nfc';
  static String staffMemberCommissions(String id) => '/staff/members/$id/commissions';
  static String staffMemberCommissionConfig(String id) => '/staff/members/$id/commission-config';
  static String staffMemberActivityLog(String id) => '/staff/members/$id/activity-log';
  static const String attendance = '/staff/attendance';
  static const String attendanceClock = '/staff/attendance/clock';
  static const String shifts = '/staff/shifts';
  static String shiftById(String id) => '/staff/shifts/$id';
  static const String shiftTemplates = '/staff/shift-templates';
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
  static const String notificationUnreadCount = '/notifications/unread-count';
  static const String notificationReadAll = '/notifications/read-all';
  static String notificationMarkRead(String id) => '/notifications/$id/read';
  static String notificationDelete(String id) => '/notifications/$id';
  static const String notificationPreferences = '/notifications/preferences';
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

  // Promotions & Coupons
  static const String promotions = '/promotions';
  static String promotionById(String id) => '/promotions/$id';
  static String promotionToggle(String id) => '/promotions/$id/toggle';
  static String promotionGenerateCoupons(String id) => '/promotions/$id/generate-coupons';
  static String promotionAnalytics(String id) => '/promotions/$id/analytics';
  static const String couponValidate = '/coupons/validate';
  static const String couponRedeem = '/coupons/redeem';

  // Accounting
  static const String accountingStatus = '/accounting/status';
  static const String accountingConnect = '/accounting/connect';
  static const String accountingDisconnect = '/accounting/disconnect';
  static const String accountingRefreshToken = '/accounting/refresh-token';
  static const String accountingPosAccountKeys = '/accounting/pos-account-keys';
  static const String accountingMapping = '/accounting/mapping';
  static String accountingMappingDelete(String id) => '/accounting/mapping/$id';
  static const String accountingExports = '/accounting/exports';
  static String accountingExportById(String id) => '/accounting/exports/$id';
  static String accountingExportRetry(String id) => '/accounting/exports/$id/retry';
  static const String accountingAutoExport = '/accounting/auto-export';
}
