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
}
