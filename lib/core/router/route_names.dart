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

  // Admin Panel
  static const String adminStores = '/admin/stores';
  static const String adminStoreDetail = '/admin/stores'; // + /:id
  static const String adminRegistrations = '/admin/registrations';
  static const String adminNotes = '/admin/notes'; // + /:organizationId

  // Admin Panel – Platform Roles (P2)
  static const String adminRoles = '/admin/roles';
  static const String adminRoleDetail = '/admin/roles/detail'; // + /:roleId
  static const String adminRoleCreate = '/admin/roles/create';
  static const String adminTeam = '/admin/team';
  static const String adminTeamUserDetail = '/admin/team/detail'; // + /:userId
  static const String adminTeamUserCreate = '/admin/team/create';
  static const String adminActivityLog = '/admin/activity-log';
  static const String adminPermissions = '/admin/permissions';

  // Admin Panel – Package & Subscription (P3)
  static const String adminPlans = '/admin/plans';
  static const String adminPlanDetail = '/admin/plans/detail'; // + /:planId
  static const String adminPlanCreate = '/admin/plans/create';
  static const String adminAddOns = '/admin/add-ons';
  static const String adminDiscounts = '/admin/discounts';
  static const String adminDiscountDetail = '/admin/discounts/detail'; // + /:discountId
  static const String adminSubscriptions = '/admin/subscriptions';
  static const String adminSubscriptionDetail = '/admin/subscriptions/detail'; // + /:subId
  static const String adminInvoices = '/admin/invoices';
  static const String adminInvoiceDetail = '/admin/invoices/detail'; // + /:invoiceId
  static const String adminRevenueDashboard = '/admin/revenue-dashboard';

  // ─── P4: User Management ──────────────────────────────────────
  static const String adminProviderUsers = '/admin/users/provider';
  static const String adminProviderUserDetail = '/admin/users/provider/detail'; // + /:userId
  static const String adminAdminUsers = '/admin/users/admins';
  static const String adminAdminUserDetail = '/admin/users/admins/detail'; // + /:userId
  static const String adminAdminUserCreate = '/admin/users/admins/create';

  // ─── P5: Billing & Finance ──────────────────────────────────────
  static const String adminBillingInvoices = '/admin/billing/invoices';
  static const String adminBillingInvoiceDetail = '/admin/billing/invoices/detail'; // + /:invoiceId
  static const String adminBillingCreateInvoice = '/admin/billing/invoices/create';
  static const String adminBillingFailedPayments = '/admin/billing/failed-payments';
  static const String adminBillingRetryRules = '/admin/billing/retry-rules';
  static const String adminBillingRevenue = '/admin/billing/revenue';
  static const String adminBillingGateways = '/admin/billing/gateways';
  static const String adminBillingGatewayDetail = '/admin/billing/gateways/detail'; // + /:gatewayId
  static const String adminBillingGatewayCreate = '/admin/billing/gateways/create';
  static const String adminBillingHardwareSales = '/admin/billing/hardware-sales';
  static const String adminBillingHardwareSaleDetail = '/admin/billing/hardware-sales/detail'; // + /:saleId
  static const String adminBillingHardwareSaleCreate = '/admin/billing/hardware-sales/create';
  static const String adminBillingImplementationFees = '/admin/billing/implementation-fees';
  static const String adminBillingImplementationFeeDetail = '/admin/billing/implementation-fees/detail'; // + /:feeId
  static const String adminBillingImplementationFeeCreate = '/admin/billing/implementation-fees/create';
}
