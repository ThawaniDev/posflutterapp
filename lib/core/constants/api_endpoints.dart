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
  static const String supplierReturns = '/inventory/supplier-returns';

  // POS
  static const String posBase = '/pos';
  static const String posSessions = '/pos/sessions';
  static const String transactions = '/pos/transactions';
  static const String heldCarts = '/pos/held-carts';
  static const String posTerminals = '/pos/terminals';

  // Orders
  static const String orders = '/orders';
  static const String returns = '/orders/returns';

  // Payments
  static const String payments = '/payments';
  static const String cashSessions = '/cash-sessions';
  static const String cashEvents = '/cash-events';
  static const String expenses = '/expenses';
  static const String giftCards = '/gift-cards';
  static const String financeDailySummary = '/finance/daily-summary';
  static const String financeReconciliation = '/finance/reconciliation';

  // Customers
  static const String customers = '/customers';
  static const String customerGroups = '/customers/groups';
  static const String loyalty = '/customers/loyalty';

  // Labels
  static const String labelTemplates = '/labels/templates';
  static const String labelPresets = '/labels/templates/presets';
  static const String labelPrintHistory = '/labels/print-history';

  // Owner Dashboard
  static const String ownerDashboardStats = '/owner-dashboard/stats';
  static const String ownerDashboardSalesTrend = '/owner-dashboard/sales-trend';
  static const String ownerDashboardTopProducts = '/owner-dashboard/top-products';
  static const String ownerDashboardLowStock = '/owner-dashboard/low-stock';
  static const String ownerDashboardActiveCashiers = '/owner-dashboard/active-cashiers';
  static const String ownerDashboardRecentOrders = '/owner-dashboard/recent-orders';
  static const String ownerDashboardFinancialSummary = '/owner-dashboard/financial-summary';
  static const String ownerDashboardHourlySales = '/owner-dashboard/hourly-sales';
  static const String ownerDashboardBranches = '/owner-dashboard/branches';
  static const String ownerDashboardStaffPerformance = '/owner-dashboard/staff-performance';

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
  static const String slowMovers = '/reports/products/slow-movers';
  static const String productMargin = '/reports/products/margin';
  static const String inventoryValuation = '/reports/inventory/valuation';
  static const String inventoryTurnover = '/reports/inventory/turnover';
  static const String inventoryShrinkage = '/reports/inventory/shrinkage';
  static const String inventoryLowStock = '/reports/inventory/low-stock';
  static const String financialDailyPl = '/reports/financial/daily-pl';
  static const String financialExpenses = '/reports/financial/expenses';
  static const String financialCashVariance = '/reports/financial/cash-variance';
  static const String topCustomers = '/reports/customers/top';
  static const String customerRetention = '/reports/customers/retention';
  static const String reportExport = '/reports/export';
  static const String reportSchedules = '/reports/schedules';
  static String reportScheduleDelete(String id) => '/reports/schedules/$id';

  // Staff
  static const String staffUsers = '/staff/users';
  static const String staffMembers = '/staff/members';
  static String staffMemberById(String id) => '/staff/members/$id';
  static String staffMemberPin(String id) => '/staff/members/$id/pin';
  static String staffMemberNfc(String id) => '/staff/members/$id/nfc';
  static String staffMemberCommissions(String id) => '/staff/members/$id/commissions';
  static String staffMemberCommissionConfig(String id) => '/staff/members/$id/commission-config';
  static String staffMemberActivityLog(String id) => '/staff/members/$id/activity-log';
  static String staffMemberBranchAssignments(String id) => '/staff/members/$id/branch-assignments';
  static String staffMemberLinkUser(String id) => '/staff/members/$id/link-user';
  static const String staffLinkableUsers = '/staff/members/linkable-users';
  static const String staffStats = '/staff/members/stats';
  static const String attendance = '/staff/attendance';
  static const String attendanceClock = '/staff/attendance/clock';
  static const String attendanceExport = '/staff/attendance/export';
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

  // Localization & Translations
  static const String locales = '/settings/locales';
  static const String translations = '/settings/translations';
  static const String translationsBulkImport = '/settings/translations/bulk-import';
  static const String exportTranslations = '/settings/export-translations';
  static const String translationOverrides = '/settings/translation-overrides';
  static String translationOverrideDelete(String id) => '/settings/translation-overrides/$id';
  static const String publishTranslations = '/settings/publish-translations';
  static const String translationVersions = '/settings/translation-versions';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationUnreadCount = '/notifications/unread-count';
  static const String notificationReadAll = '/notifications/read-all';
  static String notificationMarkRead(String id) => '/notifications/$id/read';
  static String notificationDelete(String id) => '/notifications/$id';
  static const String notificationPreferences = '/notifications/preferences';
  static const String fcmTokens = '/notifications/fcm-tokens';
  static const String notificationBatch = '/notifications/batch';
  static const String notificationBulkDelete = '/notifications/bulk';
  static const String notificationUnreadCountByCategory = '/notifications/unread-count-by-category';
  static const String notificationStats = '/notifications/stats';
  static const String notificationDeliveryLogs = '/notifications/delivery-logs';
  static const String notificationDeliveryStats = '/notifications/delivery-stats';
  static const String notificationSoundConfigs = '/notifications/sound-configs';
  static const String notificationSchedules = '/notifications/schedules';
  static String notificationScheduleCancel(String id) => '/notifications/schedules/$id/cancel';

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
  static String subscriptionInvoicePdf(String id) => '/subscription/invoices/$id/pdf';
  static const String subscriptionSyncEntitlements = '/subscription/sync/entitlements';
  static const String subscriptionStoreAddOns = '/subscription/store-add-ons';

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

  // ─── Admin: Platform Roles & RBAC (P2) ───────────────────────
  static const String adminRoles = '/admin/roles';
  static String adminRoleById(String id) => '/admin/roles/$id';
  static const String adminPermissions = '/admin/permissions';
  static const String adminTeam = '/admin/team';
  static String adminTeamUserById(String id) => '/admin/team/$id';
  static String adminTeamUserDeactivate(String id) => '/admin/team/$id/deactivate';
  static String adminTeamUserActivate(String id) => '/admin/team/$id/activate';
  static const String adminMe = '/admin/me';
  static const String adminActivityLog = '/admin/activity-log';

  // ─── Admin: Provider Management (P1) ────────────────────────
  static const String adminStores = '/admin/providers/stores';
  static const String adminStoresCreate = '/admin/providers/stores/create';
  static const String adminStoresExport = '/admin/providers/stores/export';
  static String adminStoreById(String id) => '/admin/providers/stores/$id';
  static String adminStoreMetrics(String id) => '/admin/providers/stores/$id/metrics';
  static String adminStoreSuspend(String id) => '/admin/providers/stores/$id/suspend';
  static String adminStoreActivate(String id) => '/admin/providers/stores/$id/activate';
  static String adminStoreLimits(String id) => '/admin/providers/stores/$id/limits';
  static String adminStoreLimitDelete(String storeId, String key) => '/admin/providers/stores/$storeId/limits/$key';
  static const String adminRegistrations = '/admin/providers/registrations';
  static String adminRegistrationApprove(String id) => '/admin/providers/registrations/$id/approve';
  static String adminRegistrationReject(String id) => '/admin/providers/registrations/$id/reject';
  static const String adminNotes = '/admin/providers/notes';
  static String adminNotesByOrg(String orgId) => '/admin/providers/notes/$orgId';

  // ─── Admin: Package & Subscription Management (P3) ──────────
  static const String adminPlans = '/admin/plans';
  static String adminPlanById(String id) => '/admin/plans/$id';
  static String adminPlanToggle(String id) => '/admin/plans/$id/toggle';
  static const String adminPlanCompare = '/admin/plans/compare';
  static const String adminAddOns = '/admin/add-ons';
  static String adminAddOnById(String id) => '/admin/add-ons/$id';
  static const String adminDiscounts = '/admin/discounts';
  static String adminDiscountById(String id) => '/admin/discounts/$id';
  static const String adminSubscriptions = '/admin/subscriptions';
  static String adminSubscriptionById(String id) => '/admin/subscriptions/$id';
  static const String adminInvoices = '/admin/invoices';
  static String adminInvoiceById(String id) => '/admin/invoices/$id';
  static const String adminRevenueDashboard = '/admin/revenue-dashboard';

  // ─── P4: User Management ──────────────────────────────────────
  static const String adminProviderUsers = '/admin/users/provider';
  static String adminProviderUserById(String id) => '/admin/users/provider/$id';
  static String adminProviderUserResetPassword(String id) => '/admin/users/provider/$id/reset-password';
  static String adminProviderUserForcePasswordChange(String id) => '/admin/users/provider/$id/force-password-change';
  static String adminProviderUserToggleActive(String id) => '/admin/users/provider/$id/toggle-active';
  static String adminProviderUserActivity(String id) => '/admin/users/provider/$id/activity';
  static const String adminAdminUsers = '/admin/users/admins';
  static String adminAdminUserById(String id) => '/admin/users/admins/$id';
  static String adminAdminUserReset2fa(String id) => '/admin/users/admins/$id/reset-2fa';
  static String adminAdminUserActivity(String id) => '/admin/users/admins/$id/activity';

  // ─── P5: Billing & Finance ──────────────────────────────────────
  static const String adminBillingInvoices = '/admin/billing/invoices';
  static String adminBillingInvoiceById(String id) => '/admin/billing/invoices/$id';
  static String adminBillingInvoiceMarkPaid(String id) => '/admin/billing/invoices/$id/mark-paid';
  static String adminBillingInvoiceRefund(String id) => '/admin/billing/invoices/$id/refund';
  static String adminBillingInvoicePdf(String id) => '/admin/billing/invoices/$id/pdf';
  static const String adminBillingFailedPayments = '/admin/billing/failed-payments';
  static String adminBillingRetryPayment(String id) => '/admin/billing/failed-payments/$id/retry';
  static const String adminBillingRetryRules = '/admin/billing/retry-rules';
  static const String adminBillingRevenue = '/admin/billing/revenue';
  static const String adminBillingGateways = '/admin/billing/gateways';
  static String adminBillingGatewayById(String id) => '/admin/billing/gateways/$id';
  static String adminBillingGatewayTest(String id) => '/admin/billing/gateways/$id/test';
  static const String adminBillingHardwareSales = '/admin/billing/hardware-sales';
  static String adminBillingHardwareSaleById(String id) => '/admin/billing/hardware-sales/$id';
  static const String adminBillingImplementationFees = '/admin/billing/implementation-fees';
  static String adminBillingImplementationFeeById(String id) => '/admin/billing/implementation-fees/$id';

  // ─── P6: Analytics & Reporting ────────────────────────────────
  static const String adminAnalyticsDashboard = '/admin/analytics/dashboard';
  static const String adminAnalyticsRevenue = '/admin/analytics/revenue';
  static const String adminAnalyticsSubscriptions = '/admin/analytics/subscriptions';
  static const String adminAnalyticsStores = '/admin/analytics/stores';
  static const String adminAnalyticsFeatures = '/admin/analytics/features';
  static const String adminAnalyticsSupport = '/admin/analytics/support';
  static const String adminAnalyticsSystemHealth = '/admin/analytics/system-health';
  static const String adminAnalyticsNotifications = '/admin/analytics/notifications';
  static const String adminAnalyticsDailyStats = '/admin/analytics/daily-stats';
  static const String adminAnalyticsPlanStats = '/admin/analytics/plan-stats';
  static const String adminAnalyticsFeatureStats = '/admin/analytics/feature-stats';
  static const String adminAnalyticsStoreHealth = '/admin/analytics/store-health';
  static const String adminAnalyticsExportRevenue = '/admin/analytics/export/revenue';
  static const String adminAnalyticsExportSubscriptions = '/admin/analytics/export/subscriptions';
  static const String adminAnalyticsExportStores = '/admin/analytics/export/stores';

  // ─── P7: Feature Flags & A/B Testing ─────────────────────────
  static const String adminFeatureFlags = '/admin/feature-flags';
  static String adminFeatureFlagById(String id) => '/admin/feature-flags/$id';
  static String adminFeatureFlagToggle(String id) => '/admin/feature-flags/$id/toggle';
  static const String adminABTests = '/admin/ab-tests';
  static String adminABTestById(String id) => '/admin/ab-tests/$id';
  static String adminABTestStart(String id) => '/admin/ab-tests/$id/start';
  static String adminABTestStop(String id) => '/admin/ab-tests/$id/stop';
  static String adminABTestResults(String id) => '/admin/ab-tests/$id/results';
  static String adminABTestVariants(String testId) => '/admin/ab-tests/$testId/variants';
  static String adminABTestVariantById(String testId, String variantId) => '/admin/ab-tests/$testId/variants/$variantId';

  // ─── P8: Content Management ──────────────────────────────────
  static const String adminCmsPages = '/admin/content/pages';
  static String adminCmsPageById(String id) => '/admin/content/pages/$id';
  static String adminCmsPagePublish(String id) => '/admin/content/pages/$id/publish';

  static const String adminArticles = '/admin/content/articles';
  static String adminArticleById(String id) => '/admin/content/articles/$id';
  static String adminArticlePublish(String id) => '/admin/content/articles/$id/publish';

  static const String adminAnnouncements = '/admin/content/announcements';
  static String adminAnnouncementById(String id) => '/admin/content/announcements/$id';

  static const String adminNotificationTemplates = '/admin/content/templates';
  static String adminNotificationTemplateById(String id) => '/admin/content/templates/$id';
  static String adminNotificationTemplateToggle(String id) => '/admin/content/templates/$id/toggle';

  // ─── P9: Platform Logs & Monitoring ──────────────────────
  static const String adminActivityLogs = '/admin/logs/activity';
  static String adminActivityLogById(String id) => '/admin/logs/activity/$id';

  static const String adminSecurityAlerts = '/admin/logs/security-alerts';
  static String adminSecurityAlertById(String id) => '/admin/logs/security-alerts/$id';
  static String adminSecurityAlertResolve(String id) => '/admin/logs/security-alerts/$id/resolve';

  static const String adminNotificationLogs = '/admin/logs/notifications';

  static const String adminPlatformEvents = '/admin/logs/events';
  static String adminPlatformEventById(String id) => '/admin/logs/events/$id';

  static const String adminHealthDashboard = '/admin/logs/health/dashboard';
  static const String adminHealthChecks = '/admin/logs/health/checks';

  static const String adminStoreHealth = '/admin/logs/store-health';

  // ═══ P10: Support Ticket System ═══════════════════════════
  static const String adminSupportTickets = '/admin/support/tickets';
  static String adminSupportTicketById(String id) => '/admin/support/tickets/$id';
  static String adminSupportTicketAssign(String id) => '/admin/support/tickets/$id/assign';
  static String adminSupportTicketStatus(String id) => '/admin/support/tickets/$id/status';
  static String adminTicketMessages(String id) => '/admin/support/tickets/$id/messages';
  static const String adminCannedResponses = '/admin/support/canned-responses';
  static String adminCannedResponseById(String id) => '/admin/support/canned-responses/$id';
  static String adminCannedResponseToggle(String id) => '/admin/support/canned-responses/$id/toggle';

  // ═══ P11: Marketplace Management ════════════════════════════
  static const String adminMarketplaceStores = '/admin/marketplace/stores';
  static String adminMarketplaceStoreById(String id) => '/admin/marketplace/stores/$id';
  static String adminMarketplaceStoreConnect(String storeId) => '/admin/marketplace/stores/$storeId/connect';
  static String adminMarketplaceStoreDisconnect(String id) => '/admin/marketplace/stores/$id/disconnect';
  static const String adminMarketplaceProducts = '/admin/marketplace/products';
  static String adminMarketplaceProductById(String id) => '/admin/marketplace/products/$id';
  static const String adminMarketplaceBulkPublish = '/admin/marketplace/products/bulk-publish';
  static const String adminMarketplaceOrders = '/admin/marketplace/orders';
  static String adminMarketplaceOrderById(String id) => '/admin/marketplace/orders/$id';
  static const String adminMarketplaceSettlements = '/admin/marketplace/settlements';
  static String adminMarketplaceSettlementById(String id) => '/admin/marketplace/settlements/$id';
  static const String adminMarketplaceSettlementSummary = '/admin/marketplace/settlements/summary';

  // ─── P12  Deployment & Release Management ───────────────
  static const String adminDeploymentOverview = '/admin/deployment/overview';
  static const String adminDeploymentReleases = '/admin/deployment/releases';
  static String adminDeploymentReleaseById(String id) => '/admin/deployment/releases/$id';
  static String adminDeploymentReleaseActivate(String id) => '/admin/deployment/releases/$id/activate';
  static String adminDeploymentReleaseDeactivate(String id) => '/admin/deployment/releases/$id/deactivate';
  static String adminDeploymentReleaseRollout(String id) => '/admin/deployment/releases/$id/rollout';
  static String adminDeploymentReleaseStats(String id) => '/admin/deployment/releases/$id/stats';
  static String adminDeploymentReleaseSummary(String id) => '/admin/deployment/releases/$id/summary';

  // ─── P13  Data Management & Migration ───────────────────
  static const String adminDataManagementOverview = '/admin/data-management/overview';
  static const String adminDatabaseBackups = '/admin/data-management/database-backups';
  static String adminDatabaseBackupById(String id) => '/admin/data-management/database-backups/$id';
  static String adminDatabaseBackupComplete(String id) => '/admin/data-management/database-backups/$id/complete';
  static const String adminBackupHistory = '/admin/data-management/backup-history';
  static String adminBackupHistoryById(String id) => '/admin/data-management/backup-history/$id';
  static const String adminSyncLogs = '/admin/data-management/sync-logs';
  static String adminSyncLogById(String id) => '/admin/data-management/sync-logs/$id';
  static const String adminSyncLogSummary = '/admin/data-management/sync-logs/summary';
  static const String adminSyncConflicts = '/admin/data-management/sync-conflicts';
  static String adminSyncConflictById(String id) => '/admin/data-management/sync-conflicts/$id';
  static String adminSyncConflictResolve(String id) => '/admin/data-management/sync-conflicts/$id/resolve';
  static const String adminProviderBackupStatuses = '/admin/data-management/provider-backup-statuses';
  static String adminProviderBackupStatusById(String id) => '/admin/data-management/provider-backup-statuses/$id';

  // ─── P14  Security Center ──────────────────────────────────────────
  static const String adminSecurityOverview = '/admin/security-center/overview';
  static const String adminSecCenterAlerts = '/admin/security-center/alerts';
  static String adminSecCenterAlertById(String id) => '/admin/security-center/alerts/$id';
  static String adminSecCenterAlertResolve(String id) => '/admin/security-center/alerts/$id/resolve';
  static const String adminSecuritySessions = '/admin/security-center/sessions';
  static String adminSecuritySessionById(String id) => '/admin/security-center/sessions/$id';
  static String adminSecuritySessionRevoke(String id) => '/admin/security-center/sessions/$id/revoke';
  static const String adminSecurityDevices = '/admin/security-center/devices';
  static String adminSecurityDeviceById(String id) => '/admin/security-center/devices/$id';
  static String adminSecurityDeviceWipe(String id) => '/admin/security-center/devices/$id/wipe';
  static const String adminSecurityLoginAttempts = '/admin/security-center/login-attempts';
  static String adminSecurityLoginAttemptById(String id) => '/admin/security-center/login-attempts/$id';
  static const String adminSecurityAuditLogs = '/admin/security-center/audit-logs';
  static String adminSecurityAuditLogById(String id) => '/admin/security-center/audit-logs/$id';
  static const String adminSecurityPolicies = '/admin/security-center/policies';
  static String adminSecurityPolicyById(String id) => '/admin/security-center/policies/$id';
  static const String adminSecurityIpAllowlist = '/admin/security-center/ip-allowlist';
  static String adminSecurityIpAllowlistById(String id) => '/admin/security-center/ip-allowlist/$id';
  static const String adminSecurityIpBlocklist = '/admin/security-center/ip-blocklist';
  static String adminSecurityIpBlocklistById(String id) => '/admin/security-center/ip-blocklist/$id';

  // ─── P15: Financial Operations ───────────────────────────
  static const String adminFinOpsOverview = '/admin/financial-operations/overview';
  static const String adminFinOpsPayments = '/admin/financial-operations/payments';
  static String adminFinOpsPaymentById(String id) => '/admin/financial-operations/payments/$id';
  static const String adminFinOpsRefunds = '/admin/financial-operations/refunds';
  static String adminFinOpsRefundById(String id) => '/admin/financial-operations/refunds/$id';
  static const String adminFinOpsCashSessions = '/admin/financial-operations/cash-sessions';
  static String adminFinOpsCashSessionById(String id) => '/admin/financial-operations/cash-sessions/$id';
  static const String adminFinOpsCashEvents = '/admin/financial-operations/cash-events';
  static String adminFinOpsCashEventById(String id) => '/admin/financial-operations/cash-events/$id';
  static const String adminFinOpsExpenses = '/admin/financial-operations/expenses';
  static String adminFinOpsExpenseById(String id) => '/admin/financial-operations/expenses/$id';
  static const String adminFinOpsGiftCards = '/admin/financial-operations/gift-cards';
  static String adminFinOpsGiftCardById(String id) => '/admin/financial-operations/gift-cards/$id';
  static const String adminFinOpsGiftCardTxns = '/admin/financial-operations/gift-card-transactions';
  static const String adminFinOpsAccountingConfigs = '/admin/financial-operations/accounting-configs';
  static String adminFinOpsAccountingConfigById(String id) => '/admin/financial-operations/accounting-configs/$id';
  static const String adminFinOpsAccountMappings = '/admin/financial-operations/account-mappings';
  static String adminFinOpsAccountMappingById(String id) => '/admin/financial-operations/account-mappings/$id';
  static const String adminFinOpsAccountingExports = '/admin/financial-operations/accounting-exports';
  static String adminFinOpsAccountingExportById(String id) => '/admin/financial-operations/accounting-exports/$id';
  static const String adminFinOpsAutoExportConfigs = '/admin/financial-operations/auto-export-configs';
  static String adminFinOpsAutoExportConfigById(String id) => '/admin/financial-operations/auto-export-configs/$id';
  static const String adminFinOpsThawaniSettlements = '/admin/financial-operations/thawani-settlements';
  static String adminFinOpsThawaniSettlementById(String id) => '/admin/financial-operations/thawani-settlements/$id';
  static const String adminFinOpsThawaniOrders = '/admin/financial-operations/thawani-orders';
  static String adminFinOpsThawaniOrderById(String id) => '/admin/financial-operations/thawani-orders/$id';
  static const String adminFinOpsThawaniStoreConfigs = '/admin/financial-operations/thawani-store-configs';
  static String adminFinOpsThawaniStoreConfigById(String id) => '/admin/financial-operations/thawani-store-configs/$id';
  static const String adminFinOpsDailySalesSummary = '/admin/financial-operations/daily-sales-summary';
  static String adminFinOpsDailySalesSummaryById(String id) => '/admin/financial-operations/daily-sales-summary/$id';
  static const String adminFinOpsProductSalesSummary = '/admin/financial-operations/product-sales-summary';
  static String adminFinOpsProductSalesSummaryById(String id) => '/admin/financial-operations/product-sales-summary/$id';
  static String adminFinOpsGiftCardTxnById(String id) => '/admin/financial-operations/gift-card-transactions/$id';
  static String adminFinOpsRefundProcess(String id) => '/admin/financial-operations/refunds/$id/process';
  static String adminFinOpsCashSessionForceClose(String id) => '/admin/financial-operations/cash-sessions/$id/force-close';
  static String adminFinOpsGiftCardVoid(String id) => '/admin/financial-operations/gift-cards/$id/void';
  static String adminFinOpsAccountingExportRetry(String id) => '/admin/financial-operations/accounting-exports/$id/retry';
  static String adminFinOpsThawaniSettlementReconcile(String id) =>
      '/admin/financial-operations/thawani-settlements/$id/reconcile';

  // ─── P16: Infrastructure & Operations ────────────────────
  static const String adminInfraOverview = '/admin/infrastructure/overview';
  static const String adminInfraQueues = '/admin/infrastructure/queues';
  static String adminInfraQueueRetry(String id) => '/admin/infrastructure/queues/$id/retry';
  static const String adminInfraFailedJobs = '/admin/infrastructure/failed-jobs';
  static String adminInfraFailedJobRetry(String id) => '/admin/infrastructure/failed-jobs/$id/retry';
  static String adminInfraFailedJobDelete(String id) => '/admin/infrastructure/failed-jobs/$id';
  static const String adminInfraCacheFlush = '/admin/infrastructure/cache/flush';
  static const String adminInfraHealth = '/admin/infrastructure/health';
  static const String adminInfraScheduledTasks = '/admin/infrastructure/scheduled-tasks';
  static String adminInfraScheduledTaskToggle(String id) => '/admin/infrastructure/scheduled-tasks/$id/toggle';
  static const String adminInfraServerMetrics = '/admin/infrastructure/server-metrics';
  static const String adminInfraStorageUsage = '/admin/infrastructure/storage-usage';
  static String adminInfraFailedJobById(String id) => '/admin/infrastructure/failed-jobs/$id';
  static const String adminInfraDatabaseBackups = '/admin/infrastructure/database-backups';
  static String adminInfraDatabaseBackupById(String id) => '/admin/infrastructure/database-backups/$id';
  static const String adminInfraHealthChecks = '/admin/infrastructure/health-checks';
  static String adminInfraHealthCheckById(String id) => '/admin/infrastructure/health-checks/$id';
  static const String adminInfraProviderBackups = '/admin/infrastructure/provider-backups';
  static String adminInfraProviderBackupById(String id) => '/admin/infrastructure/provider-backups/$id';
  static const String adminInfraSystemSettings = '/admin/infrastructure/system-settings';
  static String adminInfraSystemSettingById(String id) => '/admin/infrastructure/system-settings/$id';
  static const String adminInfraCacheStats = '/admin/infrastructure/cache/stats';

  // ─── P17: Provider Roles & Permissions ───────────────────
  static const String adminProviderPermissions = '/admin/provider-roles/permissions';
  static const String adminProviderRoleTemplates = '/admin/provider-roles/templates';
  static String adminProviderRoleTemplateById(String id) => '/admin/provider-roles/templates/$id';
  static String adminProviderRoleTemplatePermissions(String id) => '/admin/provider-roles/templates/$id/permissions';

  // ─── POS Feature #20: ZATCA Compliance ───────────────────
  static const String zatcaEnroll = '/zatca/enroll';
  static const String zatcaRenew = '/zatca/renew';
  static const String zatcaSubmitInvoice = '/zatca/submit-invoice';
  static const String zatcaSubmitBatch = '/zatca/submit-batch';
  static const String zatcaInvoices = '/zatca/invoices';
  static String zatcaInvoiceXml(String id) => '/zatca/invoices/$id/xml';
  static const String zatcaComplianceSummary = '/zatca/compliance-summary';
  static const String zatcaVatReport = '/zatca/vat-report';

  // ─── POS Feature #21: Offline/Online Sync ────────────────
  static const String syncPush = '/sync/push';
  static const String syncPull = '/sync/pull';
  static const String syncFull = '/sync/full';
  static const String syncStatus = '/sync/status';
  static String syncResolveConflict(String id) => '/sync/resolve-conflict/$id';
  static const String syncConflicts = '/sync/conflicts';
  static const String syncHeartbeat = '/sync/heartbeat';

  // ─── POS Feature #22: Hardware Support ───────────────────
  static const String hardwareConfig = '/hardware/config';
  static String hardwareConfigDelete(String id) => '/hardware/config/$id';
  static const String hardwareSupportedModels = '/hardware/supported-models';
  static const String hardwareTest = '/hardware/test';
  static const String hardwareEventLog = '/hardware/event-log';
  static const String hardwareEventLogs = '/hardware/event-logs';

  // ─── POS Feature #24: Security Provider ──────────────────
  static const String securityPolicy = '/security/policy';
  static const String securityAuditLogs = '/security/audit-logs';
  static const String securityAuditStats = '/security/audit-stats';
  static const String securityOverviewEndpoint = '/security/overview';
  static const String securityDevices = '/security/devices';
  static String securityDeviceById(String id) => '/security/devices/$id';
  static String securityDeviceDeactivate(String id) => '/security/devices/$id/deactivate';
  static String securityDeviceRemoteWipe(String id) => '/security/devices/$id/remote-wipe';
  static String securityDeviceHeartbeat(String id) => '/security/devices/$id/heartbeat';
  static const String securityLoginAttempts = '/security/login-attempts';
  static const String securityLoginAttemptsFailedCount = '/security/login-attempts/failed-count';
  static const String securityLoginAttemptsIsLockedOut = '/security/login-attempts/is-locked-out';
  static const String securityLoginAttemptsStats = '/security/login-attempts/stats';
  static const String securitySessions = '/security/sessions';
  static String securitySessionEnd(String id) => '/security/sessions/$id/end';
  static String securitySessionHeartbeat(String id) => '/security/sessions/$id/heartbeat';
  static const String securitySessionsEndAll = '/security/sessions/end-all';
  static const String securityIncidents = '/security/incidents';
  static String securityIncidentResolve(String id) => '/security/incidents/$id/resolve';

  // ─── POS Feature #25: Backup & Recovery ──────────────────
  static const String backupCreate = '/backup/create';
  static const String backupList = '/backup/list';
  static const String backupSchedule = '/backup/schedule';
  static const String backupStorage = '/backup/storage';
  static const String backupExport = '/backup/export';
  static const String backupProviderStatus = '/backup/provider-status';
  static String backupById(String id) => '/backup/$id';
  static String backupRestore(String id) => '/backup/$id/restore';
  static String backupVerify(String id) => '/backup/$id/verify';
  static String backupDelete(String id) => '/backup/$id';

  // ─── POS Feature #26: Mobile Companion ───────────────────
  static const String companionQuickStats = '/companion/quick-stats';
  static const String companionSummary = '/companion/summary';
  static const String companionSessions = '/companion/sessions';
  static String companionSessionEnd(String id) => '/companion/sessions/$id/end';
  static const String companionPreferences = '/companion/preferences';
  static const String companionQuickActions = '/companion/quick-actions';
  static const String companionEvents = '/companion/events';
  static const String companionDashboard = '/companion/dashboard';
  static const String companionBranches = '/companion/branches';
  static const String companionSalesSummary = '/companion/sales/summary';
  static const String companionActiveOrders = '/companion/orders/active';
  static const String companionInventoryAlerts = '/companion/inventory/alerts';
  static const String companionActiveStaff = '/companion/staff/active';
  static const String companionStoreAvailability = '/companion/store/availability';

  // ─── POS Feature #27: POS Customization ─────────────────
  static const String customizationSettings = '/customization/settings';
  static const String customizationReceipt = '/customization/receipt';
  static const String customizationQuickAccess = '/customization/quick-access';
  static const String customizationExport = '/customization/export';

  // ─── UI / Layout Management ─────────────────────────────
  static const String uiDefaults = '/ui/defaults';
  static const String uiLayouts = '/ui/layouts';
  static const String uiThemes = '/ui/themes';
  static const String uiPreferences = '/ui/preferences';
  static const String uiStoreDefaults = '/ui/store-defaults';

  // UI Template Browsing
  static const String uiReceiptTemplates = '/ui/receipt-templates';
  static String uiReceiptTemplateBySlug(String slug) => '/ui/receipt-templates/$slug';
  static String uiReceiptTemplatePreviewUrl(String id) => '/ui/receipt-templates/$id/preview-url';
  static const String uiCfdThemes = '/ui/cfd-themes';
  static String uiCfdThemeBySlug(String slug) => '/ui/cfd-themes/$slug';
  static String uiCfdThemePreviewUrl(String id) => '/ui/cfd-themes/$id/preview-url';
  static const String uiSignageTemplates = '/ui/signage-templates';
  static String uiSignageTemplateBySlug(String slug) => '/ui/signage-templates/$slug';
  static const String uiLabelTemplates = '/ui/label-templates';
  static String uiLabelTemplateBySlug(String slug) => '/ui/label-templates/$slug';
  static String uiLabelTemplatePreviewUrl(String id) => '/ui/label-templates/$id/preview-url';

  // Layout Builder
  static const String layoutBuilderWidgets = '/ui/layout-builder/widgets';
  static String layoutBuilderWidgetById(String id) => '/ui/layout-builder/widgets/$id';
  static const String layoutBuilderCanvas = '/ui/layout-builder/canvas';
  static const String layoutBuilderPlacements = '/ui/layout-builder/placements';
  static String layoutBuilderPlacementById(String id) => '/ui/layout-builder/placements/$id';
  static const String layoutBuilderThemeOverrides = '/ui/layout-builder/theme-overrides';
  static String layoutBuilderThemeOverrideById(String id) => '/ui/layout-builder/theme-overrides/$id';
  static const String layoutBuilderClone = '/ui/layout-builder/clone';
  static const String layoutBuilderVersions = '/ui/layout-builder/versions';
  static const String layoutBuilderFull = '/ui/layout-builder/full';

  // Template Marketplace
  static const String marketplaceListings = '/ui/marketplace/listings';
  static String marketplaceListingById(String id) => '/ui/marketplace/listings/$id';
  static String marketplaceListingPreviewUrl(String id) => '/ui/marketplace/listings/$id/preview-url';
  static const String marketplaceCategories = '/ui/marketplace/categories';
  static String marketplaceCategoryById(String id) => '/ui/marketplace/categories/$id';
  static String marketplacePurchase(String listingId) => '/ui/marketplace/listings/$listingId/purchase';
  static const String marketplaceMyPurchases = '/ui/marketplace/my-purchases';
  static String marketplaceCheckAccess(String listingId) => '/ui/marketplace/listings/$listingId/check-access';
  static String marketplaceCancelPurchase(String purchaseId) => '/ui/marketplace/purchases/$purchaseId/cancel';
  static const String marketplaceMyInvoices = '/ui/marketplace/my-invoices';
  static String marketplaceInvoiceById(String id) => '/ui/marketplace/invoices/$id';
  static String marketplaceListingReviews(String listingId) => '/ui/marketplace/listings/$listingId/reviews';
  static String marketplaceReviewById(String id) => '/ui/marketplace/reviews/$id';

  // ─── POS Feature #28: Auto Updates ──────────────────────
  static const String autoUpdateCheck = '/auto-update/check';
  static const String autoUpdateReportStatus = '/auto-update/report-status';
  static const String autoUpdateChangelog = '/auto-update/changelog';
  static const String autoUpdateHistory = '/auto-update/history';
  static const String autoUpdateCurrentVersion = '/auto-update/current-version';
  static String autoUpdateManifest(String version) => '/auto-update/manifest/$version';
  static String autoUpdateDownload(String version) => '/auto-update/download/$version';
  static const String autoUpdateRolloutStatus = '/auto-update/rollout-status';

  // ─── POS Feature #29: Accessibility ─────────────────────
  static const String accessibilityPreferences = '/accessibility/preferences';
  static const String accessibilityShortcuts = '/accessibility/shortcuts';

  // ─── POS Feature #30: Nice-to-Have ──────────────────────
  static const String wishlist = '/wishlist';
  static const String appointments = '/appointments';
  static String appointmentUpdate(String id) => '/appointments/$id';
  static String appointmentCancel(String id) => '/appointments/$id/cancel';
  static const String cfdConfig = '/cfd/config';
  static const String giftRegistry = '/gift-registry';
  static String giftRegistryShare(String code) => '/gift-registry/share/$code';
  static String giftRegistryItems(String id) => '/gift-registry/$id/items';
  static const String signagePlaylists = '/signage/playlists';
  static String signagePlaylist(String id) => '/signage/playlists/$id';
  static const String gamificationChallenges = '/gamification/challenges';
  static const String gamificationBadges = '/gamification/badges';
  static const String gamificationTiers = '/gamification/tiers';
  static String gamificationCustomerProgress(String id) => '/gamification/customer/$id/progress';
  static String gamificationCustomerBadges(String id) => '/gamification/customer/$id/badges';

  // ─── POS Feature #31: Industry Workflows ────────────────

  // Pharmacy
  static const String pharmacyPrescriptions = '/industry/pharmacy/prescriptions';
  static String pharmacyPrescription(String id) => '/industry/pharmacy/prescriptions/$id';
  static const String pharmacyDrugSchedules = '/industry/pharmacy/drug-schedules';
  static String pharmacyDrugSchedule(String id) => '/industry/pharmacy/drug-schedules/$id';

  // Jewelry
  static const String jewelryMetalRates = '/industry/jewelry/metal-rates';
  static const String jewelryProductDetails = '/industry/jewelry/product-details';
  static String jewelryProductDetail(String id) => '/industry/jewelry/product-details/$id';
  static const String jewelryBuybacks = '/industry/jewelry/buybacks';

  // Electronics
  static const String electronicsImeiRecords = '/industry/electronics/imei-records';
  static String electronicsImeiRecord(String id) => '/industry/electronics/imei-records/$id';
  static const String electronicsRepairJobs = '/industry/electronics/repair-jobs';
  static String electronicsRepairJob(String id) => '/industry/electronics/repair-jobs/$id';
  static String electronicsRepairJobStatus(String id) => '/industry/electronics/repair-jobs/$id/status';
  static const String electronicsTradeIns = '/industry/electronics/trade-ins';

  // Florist
  static const String floristArrangements = '/industry/florist/arrangements';
  static String floristArrangement(String id) => '/industry/florist/arrangements/$id';
  static const String floristFreshnessLogs = '/industry/florist/freshness-logs';
  static String floristFreshnessLogStatus(String id) => '/industry/florist/freshness-logs/$id/status';
  static const String floristSubscriptions = '/industry/florist/subscriptions';
  static String floristSubscription(String id) => '/industry/florist/subscriptions/$id';
  static String floristSubscriptionToggle(String id) => '/industry/florist/subscriptions/$id/toggle';

  // Bakery
  static const String bakeryRecipes = '/industry/bakery/recipes';
  static String bakeryRecipe(String id) => '/industry/bakery/recipes/$id';
  static const String bakeryProductionSchedules = '/industry/bakery/production-schedules';
  static String bakeryProductionSchedule(String id) => '/industry/bakery/production-schedules/$id';
  static String bakeryProductionScheduleStatus(String id) => '/industry/bakery/production-schedules/$id/status';
  static const String bakeryCakeOrders = '/industry/bakery/cake-orders';
  static String bakeryCakeOrder(String id) => '/industry/bakery/cake-orders/$id';
  static String bakeryCakeOrderStatus(String id) => '/industry/bakery/cake-orders/$id/status';

  // Restaurant
  static const String restaurantTables = '/industry/restaurant/tables';
  static String restaurantTable(String id) => '/industry/restaurant/tables/$id';
  static String restaurantTableStatus(String id) => '/industry/restaurant/tables/$id/status';
  static const String restaurantKitchenTickets = '/industry/restaurant/kitchen-tickets';
  static String restaurantKitchenTicketStatus(String id) => '/industry/restaurant/kitchen-tickets/$id/status';
  static const String restaurantReservations = '/industry/restaurant/reservations';
  static String restaurantReservation(String id) => '/industry/restaurant/reservations/$id';
  static String restaurantReservationStatus(String id) => '/industry/restaurant/reservations/$id/status';
  static const String restaurantTabs = '/industry/restaurant/tabs';
  static String restaurantTabClose(String id) => '/industry/restaurant/tabs/$id/close';

  // Support
  static const String supportStats = '/support/stats';
  static const String supportTickets = '/support/tickets';
  static String supportTicketById(String id) => '/support/tickets/$id';
  static String supportTicketMessages(String id) => '/support/tickets/$id/messages';
  static String supportTicketClose(String id) => '/support/tickets/$id/close';
  static const String supportKb = '/support/kb';
  static String supportKbArticle(String slug) => '/support/kb/$slug';

  // Delivery Integration
  static const String deliveryStats = '/delivery/stats';
  static const String deliveryConfigs = '/delivery/configs';
  static String deliveryConfigDetail(String id) => '/delivery/configs/$id';
  static String deliveryConfigDelete(String id) => '/delivery/configs/$id';
  static String deliveryConfigToggle(String id) => '/delivery/configs/$id/toggle';
  static String deliveryConfigTestConnection(String id) => '/delivery/configs/$id/test-connection';
  static const String deliveryOrders = '/delivery/orders';
  static const String deliveryOrdersActive = '/delivery/orders/active';
  static String deliveryOrderDetail(String id) => '/delivery/orders/$id';
  static String deliveryOrderUpdateStatus(String id) => '/delivery/orders/$id/status';
  static const String deliverySyncLogs = '/delivery/sync-logs';
  static const String deliveryMenuSync = '/delivery/menu-sync';
  static const String deliveryPlatforms = '/delivery/platforms';
  static const String deliveryWebhookLogs = '/delivery/webhook-logs';
  static const String deliveryStatusPushLogs = '/delivery/status-push-logs';

  // Thawani Integration
  static const String thawaniStats = '/thawani/stats';
  static const String thawaniConfig = '/thawani/config';
  static const String thawaniDisconnect = '/thawani/disconnect';
  static const String thawaniOrders = '/thawani/orders';
  static const String thawaniProductMappings = '/thawani/product-mappings';
  static const String thawaniSettlements = '/thawani/settlements';

  // ─── Predefined Catalog ───────────────────────────────────
  static const String predefinedCategories = '/predefined-catalog/categories';
  static const String predefinedCategoryTree = '/predefined-catalog/categories/tree';
  static String predefinedCategoryById(String id) => '/predefined-catalog/categories/$id';
  static String predefinedCategoryClone(String id) => '/predefined-catalog/categories/$id/clone';
  static const String predefinedProducts = '/predefined-catalog/products';
  static String predefinedProductById(String id) => '/predefined-catalog/products/$id';
  static String predefinedProductClone(String id) => '/predefined-catalog/products/$id/clone';
  static const String predefinedProductsBulkAction = '/predefined-catalog/products/bulk-action';
  static const String predefinedCloneAll = '/predefined-catalog/clone-all';

  // Branches (uses core stores)
  static const String branches = '/core/stores';
  static const String branchStats = '/core/stores/stats';
  static const String branchManagers = '/core/stores/managers';
  static const String branchSortOrder = '/core/stores/sort-order';
  static String branchById(String id) => '/core/stores/$id';
  static String branchToggleActive(String id) => '/core/stores/$id/toggle-active';
  static String branchSettings(String id) => '/core/stores/$id/settings';
  static String branchWorkingHours(String id) => '/core/stores/$id/working-hours';
  static String branchCopySettings(String id) => '/core/stores/$id/copy-settings';
  static String branchCopyWorkingHours(String id) => '/core/stores/$id/copy-working-hours';
}
