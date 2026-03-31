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
  static const String posTerminals = '/pos/terminals';
  static const String posTerminalAdd = '/pos/terminals/add';
  static const String posTerminalEdit = '/pos/terminals/:id/edit';

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
  static const String cashManagement = '/cash-management';
  static const String expenses = '/expenses';
  static const String giftCards = '/gift-cards';
  static const String financialReconciliation = '/finance/reconciliation';
  static const String dailySummary = '/finance/daily-summary';

  // Customers
  static const String customers = '/customers';

  // Labels
  static const String labels = '/labels';
  static const String labelDesigner = '/labels/designer';
  static const String labelHistory = '/labels/history';
  static const String labelPrintQueue = '/labels/print-queue';

  // Reports
  static const String reports = '/reports';
  static const String reportsSalesSummary = '/reports/sales-summary';
  static const String reportsHourlySales = '/reports/hourly-sales';
  static const String reportsProductPerformance = '/reports/product-performance';
  static const String reportsCategoryBreakdown = '/reports/category-breakdown';
  static const String reportsPaymentMethods = '/reports/payment-methods';
  static const String reportsStaffPerformance = '/reports/staff-performance';
  static const String reportsInventory = '/reports/inventory';
  static const String reportsFinancial = '/reports/financial';
  static const String reportsCustomers = '/reports/customers';

  // Settings
  static const String settings = '/settings';
  static const String localization = '/settings/localization';

  // Branches
  static const String branches = '/branches';

  // Accounting
  static const String accounting = '/accounting';
  static const String accountingMappings = '/accounting/mappings';
  static const String accountingExportHistory = '/accounting/export-history';
  static const String accountingAutoExport = '/accounting/auto-export';

  // Promotions
  static const String promotions = '/promotions';
  static const String promotionAnalytics = '/promotions/analytics';

  // Thawani Pay
  static const String thawaniPay = '/thawani-pay';

  // Delivery
  static const String delivery = '/delivery';
  static const String deliveryConfig = '/delivery/config';
  static const String deliveryOrderDetail = '/delivery/orders';
  static const String deliveryMenuSync = '/delivery/menu-sync';
  static const String deliveryWebhookLogs = '/delivery/webhook-logs';
  static const String deliveryStatusPushLogs = '/delivery/status-push-logs';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationPreferences = '/notifications/preferences';

  // Support
  static const String support = '/support';
  static const String supportCreate = '/support/create';
  static const String supportKb = '/support/kb';

  // Staff
  static const String staff = '/staff';
  static const String staffMembers = '/staff/members';
  static const String staffMembersCreate = '/staff/members/create';
  static const String staffRoles = '/staff/roles';
  static const String staffRoleDetail = '/staff/roles/detail'; // + /:id
  static const String staffRoleCreate = '/staff/roles/create';
  static const String staffAttendance = '/staff/attendance';
  static const String staffShifts = '/staff/shifts';
  static const String staffCommission = '/staff/commission'; // + /:id

  // Onboarding & Store Setup
  static const String onboarding = '/onboarding';
  static const String storeSettings = '/store/settings'; // + /:storeId
  static const String workingHours = '/store/working-hours'; // + /:storeId

  // Subscription
  static const String planSelection = '/subscription/plans';
  static const String subscriptionStatus = '/subscription/status';
  static const String billingHistory = '/subscription/billing';
  static const String invoiceDetail = '/subscription/invoices'; // + /:id
  static const String planComparison = '/subscription/compare';
  static const String subscriptionAddOns = '/subscription/add-ons';

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

  // ─── P15: Financial Operations ──────────────────────────────────
  static const String adminFinOps = '/admin/financial-operations';
  static const String adminFinOpsPayments = '/admin/financial-operations/payments';
  static const String adminFinOpsPaymentDetail = '/admin/financial-operations/payments/detail'; // + /:id
  static const String adminFinOpsRefunds = '/admin/financial-operations/refunds';
  static const String adminFinOpsCashSessions = '/admin/financial-operations/cash-sessions';
  static const String adminFinOpsExpenses = '/admin/financial-operations/expenses';
  static const String adminFinOpsGiftCards = '/admin/financial-operations/gift-cards';
  static const String adminFinOpsAccounting = '/admin/financial-operations/accounting';
  static const String adminFinOpsThawani = '/admin/financial-operations/thawani';
  static const String adminFinOpsSalesReports = '/admin/financial-operations/sales-reports';

  // ─── P16: Infrastructure & Operations ───────────────────────────
  static const String adminInfrastructure = '/admin/infrastructure';
  static const String adminInfraQueues = '/admin/infrastructure/queues';
  static const String adminInfraFailedJobs = '/admin/infrastructure/failed-jobs';
  static const String adminInfraHealth = '/admin/infrastructure/health';
  static const String adminInfraScheduledTasks = '/admin/infrastructure/scheduled-tasks';
  static const String adminInfraMetrics = '/admin/infrastructure/metrics';
  static const String adminInfraStorage = '/admin/infrastructure/storage';

  // ─── P17: Provider Roles & Permissions ──────────────────────────
  static const String adminProviderRoles = '/admin/provider-roles';
  static const String adminProviderRoleTemplates = '/admin/provider-roles/templates';
  static const String adminProviderRoleTemplateDetail = '/admin/provider-roles/templates/detail'; // + /:id
  static const String adminProviderPermissions = '/admin/provider-roles/permissions';

  // ─── P6: Analytics & Reporting ──────────────────────────────────
  static const String adminAnalyticsDashboard = '/admin/analytics';
  static const String adminAnalyticsRevenue = '/admin/analytics/revenue';
  static const String adminAnalyticsStores = '/admin/analytics/stores';
  static const String adminAnalyticsSubscriptions = '/admin/analytics/subscriptions';
  static const String adminAnalyticsFeatures = '/admin/analytics/features';
  static const String adminAnalyticsSystemHealth = '/admin/analytics/system-health';

  // ─── P7: Support Tickets ────────────────────────────────────────
  static const String adminSupportTickets = '/admin/support/tickets';
  static const String adminCannedResponses = '/admin/support/canned-responses';

  // ─── P8: System Configuration / Feature Flags ───────────────────
  static const String adminFeatureFlags = '/admin/feature-flags';
  static const String adminFeatureFlagDetail = '/admin/feature-flags/detail'; // + /:flagId

  // ─── P9: Notification Templates ─────────────────────────────────
  static const String adminNotificationTemplates = '/admin/notifications/templates';
  static const String adminNotificationLogs = '/admin/notifications/logs';

  // ─── P10: Log Monitoring / A-B Tests ────────────────────────────
  static const String adminABTests = '/admin/ab-tests';
  static const String adminABTestDetail = '/admin/ab-tests/detail'; // + /:testId
  static const String adminABTestResults = '/admin/ab-tests/results'; // + /:testId
  static const String adminPlatformEvents = '/admin/platform-events';

  // ─── P11: Content & Onboarding ──────────────────────────────────
  static const String adminCmsPages = '/admin/content/pages';
  static const String adminCmsPageDetail = '/admin/content/pages/detail'; // + /:pageId
  static const String adminArticles = '/admin/content/articles';
  static const String adminAnnouncements = '/admin/content/announcements';

  // ─── P13: Marketplace / Delivery ────────────────────────────────
  static const String adminMarketplaceStores = '/admin/marketplace/stores';
  static const String adminMarketplaceSettlements = '/admin/marketplace/settlements';

  // ─── P14: Deployment / App Updates ──────────────────────────────
  static const String adminDeploymentOverview = '/admin/deployment';
  static const String adminDeploymentReleases = '/admin/deployment/releases';

  // ─── P15B: Security Center ──────────────────────────────────────
  static const String adminSecurityOverview = '/admin/security';
  static const String adminSecurityAlerts = '/admin/security/alerts';
  static const String adminSecurityAlertList = '/admin/security/alert-list';
  static const String adminActivityLogList = '/admin/security/activity-log';
  static const String adminUserActivity = '/admin/security/user-activity'; // + /:userId

  // ─── Data Management ───────────────────────────────────────────
  static const String adminDataManagement = '/admin/data-management';
  static const String adminDatabaseBackups = '/admin/data-management/backups';

  // ─── Health Dashboard ──────────────────────────────────────────
  static const String adminHealthDashboard = '/admin/health-dashboard';

  // ─── ZATCA Compliance ──────────────────────────────────────────
  static const String zatcaDashboard = '/zatca';
  static const String zatcaEnrollment = '/zatca/enrollment';
  static const String zatcaInvoices = '/zatca/invoices';
  static const String zatcaVatReport = '/zatca/vat-report';

  // ─── Sync ────────────────────────────────────────────────────
  static const String syncDashboard = '/sync';
  static const String syncConflicts = '/sync/conflicts';

  // ─── Hardware ───────────────────────────────────────────────
  static const String hardwareDashboard = '/hardware';

  // ─── Security ──────────────────────────────────────────────
  static const String securityDashboard = '/security';

  // ─── Backup & Recovery ────────────────────────────────────
  static const String backupDashboard = '/backup';

  // ─── Mobile Companion ─────────────────────────────────────
  static const String companionDashboard = '/companion';

  // ─── POS Customization ──────────────────────────────────
  static const String customizationDashboard = '/customization';

  // ─── Layout Builder ─────────────────────────────────────
  static const String layoutTemplates = '/layout-templates';
  static const String layoutBuilder = '/layout-builder';

  // ─── Marketplace ────────────────────────────────────────
  static const String marketplace = '/marketplace';
  static const String myPurchases = '/marketplace/purchases';

  // ─── Auto Updates ───────────────────────────────────────
  static const String autoUpdateDashboard = '/auto-update';

  // ─── Accessibility ──────────────────────────────────────
  static const String accessibilityDashboard = '/accessibility';

  // ─── Nice-to-Have ─────────────────────────────────────
  static const String niceToHaveDashboard = '/nice-to-have';

  // ─── Industry Workflows ─────────────────────────────────
  static const String industryPharmacy = '/industry/pharmacy';
  static const String industryJewelry = '/industry/jewelry';
  static const String industryElectronics = '/industry/electronics';
  static const String industryFlorist = '/industry/florist';
  static const String industryBakery = '/industry/bakery';
  static const String industryRestaurant = '/industry/restaurant';
}
