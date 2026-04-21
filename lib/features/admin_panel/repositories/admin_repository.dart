import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/data/remote/admin_api_service.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(adminApiServiceProvider));
});

class AdminRepository {

  AdminRepository(this._apiService);
  final AdminApiService _apiService;

  // ─── Stores ───────────────────────────────────────────
  Future<Map<String, dynamic>> listStores({
    String? search,
    bool? isActive,
    String? businessType,
    String? organizationId,
    String? storeId,
    int perPage = 15,
    int page = 1,
  }) => _apiService.listStores(
    search: search,
    isActive: isActive,
    businessType: businessType,
    organizationId: organizationId,
    storeId: storeId,
    perPage: perPage,
    page: page,
  );

  Future<Map<String, dynamic>> showStore(String storeId) => _apiService.showStore(storeId);

  Future<Map<String, dynamic>> storeMetrics(String storeId) => _apiService.storeMetrics(storeId);

  Future<Map<String, dynamic>> suspendStore(String storeId, {String? reason}) =>
      _apiService.suspendStore(storeId, reason: reason);

  Future<Map<String, dynamic>> activateStore(String storeId) => _apiService.activateStore(storeId);

  Future<Map<String, dynamic>> createStore({
    required String organizationName,
    required String storeName,
    String? organizationBusinessType,
    String? organizationCountry,
    String? storeBusinessType,
    String? storeCurrency,
  }) => _apiService.createStore(
    organizationName: organizationName,
    storeName: storeName,
    organizationBusinessType: organizationBusinessType,
    organizationCountry: organizationCountry,
    storeBusinessType: storeBusinessType,
    storeCurrency: storeCurrency,
  );

  Future<Map<String, dynamic>> exportStores({bool? isActive, String? businessType}) =>
      _apiService.exportStores(isActive: isActive, businessType: businessType);

  // ─── Limit Overrides ──────────────────────────────────
  Future<Map<String, dynamic>> listLimitOverrides(String storeId) => _apiService.listLimitOverrides(storeId);

  Future<Map<String, dynamic>> setLimitOverride(
    String storeId, {
    required String limitKey,
    required int overrideValue,
    String? reason,
    String? expiresAt,
  }) => _apiService.setLimitOverride(
    storeId,
    limitKey: limitKey,
    overrideValue: overrideValue,
    reason: reason,
    expiresAt: expiresAt,
  );

  Future<Map<String, dynamic>> removeLimitOverride(String storeId, String limitKey) =>
      _apiService.removeLimitOverride(storeId, limitKey);

  // ─── Registrations ────────────────────────────────────
  Future<Map<String, dynamic>> listRegistrations({
    String? status,
    String? search,
    String? storeId,
    int perPage = 15,
    int page = 1,
  }) => _apiService.listRegistrations(status: status, search: search, storeId: storeId, perPage: perPage, page: page);

  Future<Map<String, dynamic>> approveRegistration(String id) => _apiService.approveRegistration(id);

  Future<Map<String, dynamic>> rejectRegistration(String id, {required String rejectionReason}) =>
      _apiService.rejectRegistration(id, rejectionReason: rejectionReason);

  // ─── Notes ────────────────────────────────────────────
  Future<Map<String, dynamic>> addNote({required String organizationId, required String noteText}) =>
      _apiService.addNote(organizationId: organizationId, noteText: noteText);

  Future<Map<String, dynamic>> listNotes(String organizationId) => _apiService.listNotes(organizationId);

  // ─── Platform Roles (P2) ──────────────────────────────
  Future<Map<String, dynamic>> listRoles() => _apiService.listRoles();

  Future<Map<String, dynamic>> showRole(String roleId) => _apiService.showRole(roleId);

  Future<Map<String, dynamic>> createRole({
    required String name,
    String? slug,
    String? description,
    List<String>? permissionIds,
  }) => _apiService.createRole(name: name, slug: slug, description: description, permissionIds: permissionIds);

  Future<Map<String, dynamic>> updateRole(String roleId, {String? name, String? description, List<String>? permissionIds}) =>
      _apiService.updateRole(roleId, name: name, description: description, permissionIds: permissionIds);

  Future<Map<String, dynamic>> deleteRole(String roleId) => _apiService.deleteRole(roleId);

  // ─── Permissions (P2) ─────────────────────────────────
  Future<Map<String, dynamic>> listPermissions() => _apiService.listPermissions();

  // ─── Admin Team (P2) ──────────────────────────────────
  Future<Map<String, dynamic>> listTeamUsers({
    String? search,
    bool? isActive,
    String? roleId,
    String? storeId,
    int perPage = 15,
    int page = 1,
  }) => _apiService.listTeamUsers(
    search: search,
    isActive: isActive,
    roleId: roleId,
    storeId: storeId,
    perPage: perPage,
    page: page,
  );

  Future<Map<String, dynamic>> showTeamUser(String userId) => _apiService.showTeamUser(userId);

  Future<Map<String, dynamic>> createTeamUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    bool isActive = true,
    List<String>? roleIds,
  }) => _apiService.createTeamUser(
    name: name,
    email: email,
    password: password,
    phone: phone,
    isActive: isActive,
    roleIds: roleIds,
  );

  Future<Map<String, dynamic>> updateTeamUser(
    String userId, {
    String? name,
    String? phone,
    bool? isActive,
    List<String>? roleIds,
  }) => _apiService.updateTeamUser(userId, name: name, phone: phone, isActive: isActive, roleIds: roleIds);

  Future<Map<String, dynamic>> deactivateTeamUser(String userId) => _apiService.deactivateTeamUser(userId);

  Future<Map<String, dynamic>> activateTeamUser(String userId) => _apiService.activateTeamUser(userId);

  // ─── Profile & Activity (P2) ──────────────────────────
  Future<Map<String, dynamic>> getMyProfile() => _apiService.getMyProfile();

  Future<Map<String, dynamic>> listActivityLogs({
    String? adminUserId,
    String? action,
    String? entityType,
    String? dateFrom,
    String? dateTo,
    String? storeId,
    int perPage = 25,
    int page = 1,
  }) => _apiService.listActivityLogs(
    adminUserId: adminUserId,
    action: action,
    entityType: entityType,
    dateFrom: dateFrom,
    dateTo: dateTo,
    storeId: storeId,
    perPage: perPage,
    page: page,
  );

  // ─── Plans (P3) ────────────────────────────────────────────

  Future<Map<String, dynamic>> listPlans({bool? activeOnly}) => _apiService.listPlans(activeOnly: activeOnly);

  Future<Map<String, dynamic>> showPlan(String planId) => _apiService.showPlan(planId);

  Future<Map<String, dynamic>> createPlan(Map<String, dynamic> data) => _apiService.createPlan(data);

  Future<Map<String, dynamic>> updatePlan(String planId, Map<String, dynamic> data) => _apiService.updatePlan(planId, data);

  Future<Map<String, dynamic>> togglePlan(String planId) => _apiService.togglePlan(planId);

  Future<Map<String, dynamic>> deletePlan(String planId) => _apiService.deletePlan(planId);

  Future<Map<String, dynamic>> comparePlans({List<String>? planIds}) => _apiService.comparePlans(planIds: planIds);

  // ─── Add-Ons (P3) ─────────────────────────────────────────

  Future<Map<String, dynamic>> listAddOns({bool? activeOnly}) => _apiService.listAddOns(activeOnly: activeOnly);

  Future<Map<String, dynamic>> showAddOn(String addOnId) => _apiService.showAddOn(addOnId);

  Future<Map<String, dynamic>> createAddOn(Map<String, dynamic> data) => _apiService.createAddOn(data);

  Future<Map<String, dynamic>> updateAddOn(String addOnId, Map<String, dynamic> data) => _apiService.updateAddOn(addOnId, data);

  Future<Map<String, dynamic>> deleteAddOn(String addOnId) => _apiService.deleteAddOn(addOnId);

  // ─── Discounts (P3) ───────────────────────────────────────

  Future<Map<String, dynamic>> listDiscounts({bool? active, int perPage = 15}) =>
      _apiService.listDiscounts(active: active, perPage: perPage);

  Future<Map<String, dynamic>> showDiscount(String discountId) => _apiService.showDiscount(discountId);

  Future<Map<String, dynamic>> createDiscount(Map<String, dynamic> data) => _apiService.createDiscount(data);

  Future<Map<String, dynamic>> updateDiscount(String discountId, Map<String, dynamic> data) =>
      _apiService.updateDiscount(discountId, data);

  Future<Map<String, dynamic>> deleteDiscount(String discountId) => _apiService.deleteDiscount(discountId);

  // ─── Subscriptions (P3) ───────────────────────────────────

  Future<Map<String, dynamic>> listSubscriptions({String? status, String? planId, String? storeId, int perPage = 15}) =>
      _apiService.listSubscriptions(status: status, planId: planId, storeId: storeId, perPage: perPage);

  Future<Map<String, dynamic>> showSubscription(String subId) => _apiService.showSubscription(subId);

  // ─── Invoices (P3) ────────────────────────────────────────

  Future<Map<String, dynamic>> listInvoices({String? status, String? subscriptionId, String? storeId, int perPage = 15}) =>
      _apiService.listInvoices(status: status, subscriptionId: subscriptionId, storeId: storeId, perPage: perPage);

  Future<Map<String, dynamic>> showInvoice(String invoiceId) => _apiService.showInvoice(invoiceId);

  // ─── Revenue Dashboard (P3) ───────────────────────────────

  Future<Map<String, dynamic>> getRevenueDashboard() => _apiService.getRevenueDashboard();

  // ═══════════════════════════════════════════════════════════════
  // P4: User Management
  // ═══════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getUserStats() => _apiService.getUserStats();

  // ─── Provider Users ────────────────────────────────────────

  Future<Map<String, dynamic>> listProviderUsers({
    String? search,
    String? storeId,
    String? organizationId,
    String? role,
    bool? isActive,
    int perPage = 15,
    int page = 1,
  }) => _apiService.listProviderUsers(
    search: search,
    storeId: storeId,
    organizationId: organizationId,
    role: role,
    isActive: isActive,
    perPage: perPage,
    page: page,
  );

  Future<Map<String, dynamic>> showProviderUser(String userId) => _apiService.showProviderUser(userId);

  Future<Map<String, dynamic>> resetProviderPassword(String userId) => _apiService.resetProviderPassword(userId);

  Future<Map<String, dynamic>> forcePasswordChange(String userId) => _apiService.forcePasswordChange(userId);

  Future<Map<String, dynamic>> toggleProviderActive(String userId) => _apiService.toggleProviderActive(userId);

  Future<Map<String, dynamic>> getProviderUserActivity(String userId) => _apiService.getProviderUserActivity(userId);

  // ─── Admin Users ──────────────────────────────────────────

  Future<Map<String, dynamic>> listAdminUsers({String? search, bool? isActive, String? storeId}) =>
      _apiService.listAdminUsers(search: search, isActive: isActive, storeId: storeId);

  Future<Map<String, dynamic>> showAdminUser(String userId) => _apiService.showAdminUser(userId);

  Future<Map<String, dynamic>> inviteAdmin(Map<String, dynamic> data) => _apiService.inviteAdmin(data);

  Future<Map<String, dynamic>> updateAdminUser(String userId, Map<String, dynamic> data) =>
      _apiService.updateAdminUser(userId, data);

  Future<Map<String, dynamic>> resetAdmin2fa(String userId) => _apiService.resetAdmin2fa(userId);

  Future<Map<String, dynamic>> getAdminUserActivity(String userId) => _apiService.getAdminUserActivity(userId);

  // ─── P5: Billing & Finance ──────────────────────────────────

  Future<Map<String, dynamic>> listBillingInvoices({Map<String, dynamic>? params}) =>
      _apiService.listBillingInvoices(params: params);

  Future<Map<String, dynamic>> showBillingInvoice(String invoiceId) => _apiService.showBillingInvoice(invoiceId);

  Future<Map<String, dynamic>> createManualInvoice(Map<String, dynamic> data) => _apiService.createManualInvoice(data);

  Future<Map<String, dynamic>> markInvoicePaid(String invoiceId) => _apiService.markInvoicePaid(invoiceId);

  Future<Map<String, dynamic>> processRefund(String invoiceId, Map<String, dynamic> data) =>
      _apiService.processRefund(invoiceId, data);

  Future<Map<String, dynamic>> getInvoicePdfUrl(String invoiceId) => _apiService.getInvoicePdfUrl(invoiceId);

  Future<Map<String, dynamic>> listFailedPayments({Map<String, dynamic>? params}) =>
      _apiService.listFailedPayments(params: params);

  Future<Map<String, dynamic>> retryPayment(String invoiceId) => _apiService.retryPayment(invoiceId);

  Future<Map<String, dynamic>> getRetryRules() => _apiService.getRetryRules();

  Future<Map<String, dynamic>> updateRetryRules(Map<String, dynamic> data) => _apiService.updateRetryRules(data);

  Future<Map<String, dynamic>> getBillingRevenue({String? storeId}) => _apiService.getBillingRevenue(storeId: storeId);

  Future<Map<String, dynamic>> listGateways({Map<String, dynamic>? params}) => _apiService.listGateways(params: params);

  Future<Map<String, dynamic>> showGateway(String gatewayId) => _apiService.showGateway(gatewayId);

  Future<Map<String, dynamic>> createGateway(Map<String, dynamic> data) => _apiService.createGateway(data);

  Future<Map<String, dynamic>> updateGateway(String gatewayId, Map<String, dynamic> data) =>
      _apiService.updateGateway(gatewayId, data);

  Future<Map<String, dynamic>> deleteGateway(String gatewayId) => _apiService.deleteGateway(gatewayId);

  Future<Map<String, dynamic>> testGatewayConnection(String gatewayId) => _apiService.testGatewayConnection(gatewayId);

  Future<Map<String, dynamic>> listHardwareSales({Map<String, dynamic>? params}) => _apiService.listHardwareSales(params: params);

  Future<Map<String, dynamic>> showHardwareSale(String saleId) => _apiService.showHardwareSale(saleId);

  Future<Map<String, dynamic>> createHardwareSale(Map<String, dynamic> data) => _apiService.createHardwareSale(data);

  Future<Map<String, dynamic>> updateHardwareSale(String saleId, Map<String, dynamic> data) =>
      _apiService.updateHardwareSale(saleId, data);

  Future<Map<String, dynamic>> deleteHardwareSale(String saleId) => _apiService.deleteHardwareSale(saleId);

  Future<Map<String, dynamic>> listImplementationFees({Map<String, dynamic>? params}) =>
      _apiService.listImplementationFees(params: params);

  Future<Map<String, dynamic>> showImplementationFee(String feeId) => _apiService.showImplementationFee(feeId);

  Future<Map<String, dynamic>> createImplementationFee(Map<String, dynamic> data) => _apiService.createImplementationFee(data);

  Future<Map<String, dynamic>> updateImplementationFee(String feeId, Map<String, dynamic> data) =>
      _apiService.updateImplementationFee(feeId, data);

  Future<Map<String, dynamic>> deleteImplementationFee(String feeId) => _apiService.deleteImplementationFee(feeId);

  // ─── P6: Analytics & Reporting ──────────────────────────────

  Future<Map<String, dynamic>> getAnalyticsDashboard({String? storeId}) => _apiService.getAnalyticsDashboard(storeId: storeId);

  Future<Map<String, dynamic>> getAnalyticsRevenue({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsRevenue(params: params);

  Future<Map<String, dynamic>> getAnalyticsSubscriptions({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsSubscriptions(params: params);

  Future<Map<String, dynamic>> getAnalyticsStores({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsStores(params: params);

  Future<Map<String, dynamic>> getAnalyticsFeatures({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsFeatures(params: params);

  Future<Map<String, dynamic>> getAnalyticsSupport({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsSupport(params: params);

  Future<Map<String, dynamic>> getAnalyticsSystemHealth({String? storeId}) =>
      _apiService.getAnalyticsSystemHealth(storeId: storeId);

  Future<Map<String, dynamic>> getAnalyticsNotifications({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsNotifications(params: params);

  Future<Map<String, dynamic>> getAnalyticsDailyStats({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsDailyStats(params: params);

  Future<Map<String, dynamic>> getAnalyticsPlanStats({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsPlanStats(params: params);

  Future<Map<String, dynamic>> getAnalyticsFeatureStats({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsFeatureStats(params: params);

  Future<Map<String, dynamic>> getAnalyticsStoreHealth({Map<String, dynamic>? params}) =>
      _apiService.getAnalyticsStoreHealth(params: params);

  Future<Map<String, dynamic>> exportAnalyticsRevenue(Map<String, dynamic> data) => _apiService.exportAnalyticsRevenue(data);

  Future<Map<String, dynamic>> exportAnalyticsSubscriptions(Map<String, dynamic> data) =>
      _apiService.exportAnalyticsSubscriptions(data);

  Future<Map<String, dynamic>> exportAnalyticsStores(Map<String, dynamic> data) => _apiService.exportAnalyticsStores(data);

  // ─── P7: Feature Flags & A/B Testing ──────────────────────────

  Future<Map<String, dynamic>> getFeatureFlagStats() => _apiService.getFeatureFlagStats();
  Future<Map<String, dynamic>> getFeatureFlags({Map<String, dynamic>? params}) => _apiService.getFeatureFlags(params: params);

  Future<Map<String, dynamic>> createFeatureFlag(Map<String, dynamic> data) => _apiService.createFeatureFlag(data);

  Future<Map<String, dynamic>> getFeatureFlag(String id) => _apiService.getFeatureFlag(id);

  Future<Map<String, dynamic>> updateFeatureFlag(String id, Map<String, dynamic> data) => _apiService.updateFeatureFlag(id, data);

  Future<Map<String, dynamic>> deleteFeatureFlag(String id) => _apiService.deleteFeatureFlag(id);

  Future<Map<String, dynamic>> toggleFeatureFlag(String id) => _apiService.toggleFeatureFlag(id);

  Future<Map<String, dynamic>> getABTests({Map<String, dynamic>? params}) => _apiService.getABTests(params: params);

  Future<Map<String, dynamic>> createABTest(Map<String, dynamic> data) => _apiService.createABTest(data);

  Future<Map<String, dynamic>> getABTest(String id) => _apiService.getABTest(id);

  Future<Map<String, dynamic>> updateABTest(String id, Map<String, dynamic> data) => _apiService.updateABTest(id, data);

  Future<Map<String, dynamic>> deleteABTest(String id) => _apiService.deleteABTest(id);

  Future<Map<String, dynamic>> startABTest(String id) => _apiService.startABTest(id);

  Future<Map<String, dynamic>> stopABTest(String id) => _apiService.stopABTest(id);

  Future<Map<String, dynamic>> getABTestResults(String id) => _apiService.getABTestResults(id);

  Future<Map<String, dynamic>> addABTestVariant(String testId, Map<String, dynamic> data) =>
      _apiService.addABTestVariant(testId, data);

  Future<Map<String, dynamic>> removeABTestVariant(String testId, String variantId) =>
      _apiService.removeABTestVariant(testId, variantId);

  // ═══════════════════════════════════════════════════════════════
  //  P8: Content Management
  // ═══════════════════════════════════════════════════════════════

  // CMS Pages
  Future<Map<String, dynamic>> getCmsPages({String? search, String? pageType, bool? isPublished, String? storeId}) =>
      _apiService.getCmsPages(search: search, pageType: pageType, isPublished: isPublished, storeId: storeId);
  Future<Map<String, dynamic>> createCmsPage(Map<String, dynamic> data) => _apiService.createCmsPage(data);
  Future<Map<String, dynamic>> getCmsPage(String id) => _apiService.getCmsPage(id);
  Future<Map<String, dynamic>> updateCmsPage(String id, Map<String, dynamic> data) => _apiService.updateCmsPage(id, data);
  Future<Map<String, dynamic>> deleteCmsPage(String id) => _apiService.deleteCmsPage(id);
  Future<Map<String, dynamic>> toggleCmsPagePublish(String id) => _apiService.toggleCmsPagePublish(id);

  // Articles
  Future<Map<String, dynamic>> getArticles({
    String? search,
    String? category,
    bool? isPublished,
    int? page,
    int? perPage,
    String? storeId,
  }) => _apiService.getArticles(
    search: search,
    category: category,
    isPublished: isPublished,
    page: page,
    perPage: perPage,
    storeId: storeId,
  );
  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> data) => _apiService.createArticle(data);
  Future<Map<String, dynamic>> getArticle(String id) => _apiService.getArticle(id);
  Future<Map<String, dynamic>> updateArticle(String id, Map<String, dynamic> data) => _apiService.updateArticle(id, data);
  Future<Map<String, dynamic>> deleteArticle(String id) => _apiService.deleteArticle(id);
  Future<Map<String, dynamic>> toggleArticlePublish(String id) => _apiService.toggleArticlePublish(id);

  // Announcements
  Future<Map<String, dynamic>> getAnnouncements({String? search, String? type, int? page, int? perPage, String? storeId}) =>
      _apiService.getAnnouncements(search: search, type: type, page: page, perPage: perPage, storeId: storeId);
  Future<Map<String, dynamic>> createAnnouncement(Map<String, dynamic> data) => _apiService.createAnnouncement(data);
  Future<Map<String, dynamic>> getAnnouncement(String id) => _apiService.getAnnouncement(id);
  Future<Map<String, dynamic>> updateAnnouncement(String id, Map<String, dynamic> data) =>
      _apiService.updateAnnouncement(id, data);
  Future<Map<String, dynamic>> deleteAnnouncement(String id) => _apiService.deleteAnnouncement(id);

  // Notification Templates
  Future<Map<String, dynamic>> getNotificationTemplates({String? search, String? channel, bool? isActive, String? storeId}) =>
      _apiService.getNotificationTemplates(search: search, channel: channel, isActive: isActive, storeId: storeId);
  Future<Map<String, dynamic>> createNotificationTemplate(Map<String, dynamic> data) =>
      _apiService.createNotificationTemplate(data);
  Future<Map<String, dynamic>> getNotificationTemplate(String id) => _apiService.getNotificationTemplate(id);
  Future<Map<String, dynamic>> updateNotificationTemplate(String id, Map<String, dynamic> data) =>
      _apiService.updateNotificationTemplate(id, data);
  Future<Map<String, dynamic>> deleteNotificationTemplate(String id) => _apiService.deleteNotificationTemplate(id);
  Future<Map<String, dynamic>> toggleNotificationTemplate(String id) => _apiService.toggleNotificationTemplate(id);

  // ═══════════════════════════════════════════════════════════
  //  P9: Platform Logs & Monitoring
  // ═══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getLogStats() => _apiService.getLogStats();
  Future<Map<String, dynamic>> getActivityLogs({Map<String, dynamic>? params}) => _apiService.getActivityLogs(params: params);
  Future<Map<String, dynamic>> getActivityLog(String id) => _apiService.getActivityLog(id);

  Future<Map<String, dynamic>> getSecurityAlerts({Map<String, dynamic>? params}) => _apiService.getSecurityAlerts(params: params);
  Future<Map<String, dynamic>> getSecurityAlert(String id) => _apiService.getSecurityAlert(id);
  Future<Map<String, dynamic>> resolveSecurityAlert(String id, Map<String, dynamic> data) =>
      _apiService.resolveSecurityAlert(id, data);

  Future<Map<String, dynamic>> getNotificationLogs({Map<String, dynamic>? params}) =>
      _apiService.getNotificationLogs(params: params);

  Future<Map<String, dynamic>> getPlatformEvents({Map<String, dynamic>? params}) => _apiService.getPlatformEvents(params: params);
  Future<Map<String, dynamic>> createPlatformEvent(Map<String, dynamic> data) => _apiService.createPlatformEvent(data);
  Future<Map<String, dynamic>> getPlatformEvent(String id) => _apiService.getPlatformEvent(id);

  Future<Map<String, dynamic>> getHealthDashboard({String? storeId}) => _apiService.getHealthDashboard(storeId: storeId);
  Future<Map<String, dynamic>> getHealthChecks({Map<String, dynamic>? params}) => _apiService.getHealthChecks(params: params);
  Future<Map<String, dynamic>> createHealthCheck(Map<String, dynamic> data) => _apiService.createHealthCheck(data);

  Future<Map<String, dynamic>> getStoreHealth({Map<String, dynamic>? params}) => _apiService.getStoreHealth(params: params);

  // ═══ P10: Support Ticket System ════════════════════════════
  Future<Map<String, dynamic>> getSupportStats() => _apiService.getSupportStats();
  Future<Map<String, dynamic>> getSupportTickets({Map<String, dynamic>? params}) => _apiService.getSupportTickets(params: params);
  Future<Map<String, dynamic>> createSupportTicket(Map<String, dynamic> data) => _apiService.createSupportTicket(data);
  Future<Map<String, dynamic>> getSupportTicket(String id) => _apiService.getSupportTicket(id);
  Future<Map<String, dynamic>> updateSupportTicket(String id, Map<String, dynamic> data) =>
      _apiService.updateSupportTicket(id, data);
  Future<Map<String, dynamic>> assignSupportTicket(String id, Map<String, dynamic> data) =>
      _apiService.assignSupportTicket(id, data);
  Future<Map<String, dynamic>> changeSupportTicketStatus(String id, Map<String, dynamic> data) =>
      _apiService.changeSupportTicketStatus(id, data);
  Future<Map<String, dynamic>> getTicketMessages(String ticketId, {Map<String, dynamic>? params}) =>
      _apiService.getTicketMessages(ticketId, params: params);
  Future<Map<String, dynamic>> addTicketMessage(String ticketId, Map<String, dynamic> data) =>
      _apiService.addTicketMessage(ticketId, data);
  Future<Map<String, dynamic>> getCannedResponses({Map<String, dynamic>? params}) =>
      _apiService.getCannedResponses(params: params);
  Future<Map<String, dynamic>> createCannedResponse(Map<String, dynamic> data) => _apiService.createCannedResponse(data);
  Future<Map<String, dynamic>> getCannedResponse(String id) => _apiService.getCannedResponse(id);
  Future<Map<String, dynamic>> updateCannedResponse(String id, Map<String, dynamic> data) =>
      _apiService.updateCannedResponse(id, data);
  Future<Map<String, dynamic>> deleteCannedResponse(String id) => _apiService.deleteCannedResponse(id);
  Future<Map<String, dynamic>> toggleCannedResponse(String id) => _apiService.toggleCannedResponse(id);

  // ═══ P11: Marketplace Management ════════════════════════════
  Future<Map<String, dynamic>> getMarketplaceStores({Map<String, dynamic>? params}) =>
      _apiService.getMarketplaceStores(params: params);
  Future<Map<String, dynamic>> getMarketplaceStore(String id) => _apiService.getMarketplaceStore(id);
  Future<Map<String, dynamic>> updateMarketplaceStoreConfig(String id, Map<String, dynamic> data) =>
      _apiService.updateMarketplaceStoreConfig(id, data);
  Future<Map<String, dynamic>> connectMarketplaceStore(String storeId, Map<String, dynamic> data) =>
      _apiService.connectMarketplaceStore(storeId, data);
  Future<Map<String, dynamic>> disconnectMarketplaceStore(String id) => _apiService.disconnectMarketplaceStore(id);
  Future<Map<String, dynamic>> getMarketplaceProducts({Map<String, dynamic>? params}) =>
      _apiService.getMarketplaceProducts(params: params);
  Future<Map<String, dynamic>> getMarketplaceProduct(String id) => _apiService.getMarketplaceProduct(id);
  Future<Map<String, dynamic>> updateMarketplaceProduct(String id, Map<String, dynamic> data) =>
      _apiService.updateMarketplaceProduct(id, data);
  Future<Map<String, dynamic>> bulkPublishProducts(Map<String, dynamic> data) => _apiService.bulkPublishProducts(data);
  Future<Map<String, dynamic>> getMarketplaceOrders({Map<String, dynamic>? params}) =>
      _apiService.getMarketplaceOrders(params: params);
  Future<Map<String, dynamic>> getMarketplaceOrder(String id) => _apiService.getMarketplaceOrder(id);
  Future<Map<String, dynamic>> getMarketplaceSettlements({Map<String, dynamic>? params}) =>
      _apiService.getMarketplaceSettlements(params: params);
  Future<Map<String, dynamic>> getMarketplaceSettlement(String id) => _apiService.getMarketplaceSettlement(id);
  Future<Map<String, dynamic>> getMarketplaceSettlementSummary({Map<String, dynamic>? params}) =>
      _apiService.getMarketplaceSettlementSummary(params: params);

  // ─── P12  Deployment & Release Management ───────────────
  Future<Map<String, dynamic>> getDeploymentOverview({String? storeId}) => _apiService.getDeploymentOverview(storeId: storeId);
  Future<Map<String, dynamic>> getDeploymentReleases({Map<String, dynamic>? params}) =>
      _apiService.getDeploymentReleases(params: params);
  Future<Map<String, dynamic>> createDeploymentRelease(Map<String, dynamic> data) => _apiService.createDeploymentRelease(data);
  Future<Map<String, dynamic>> getDeploymentRelease(String id) => _apiService.getDeploymentRelease(id);
  Future<Map<String, dynamic>> updateDeploymentRelease(String id, Map<String, dynamic> data) =>
      _apiService.updateDeploymentRelease(id, data);
  Future<Map<String, dynamic>> deleteDeploymentRelease(String id) => _apiService.deleteDeploymentRelease(id);
  Future<Map<String, dynamic>> activateDeploymentRelease(String id) => _apiService.activateDeploymentRelease(id);
  Future<Map<String, dynamic>> deactivateDeploymentRelease(String id) => _apiService.deactivateDeploymentRelease(id);
  Future<Map<String, dynamic>> updateDeploymentRollout(String id, Map<String, dynamic> data) =>
      _apiService.updateDeploymentRollout(id, data);
  Future<Map<String, dynamic>> getDeploymentReleaseStats(String id, {Map<String, dynamic>? params}) =>
      _apiService.getDeploymentReleaseStats(id, params: params);
  Future<Map<String, dynamic>> recordDeploymentReleaseStat(String id, Map<String, dynamic> data) =>
      _apiService.recordDeploymentReleaseStat(id, data);
  Future<Map<String, dynamic>> getDeploymentReleaseSummary(String id) => _apiService.getDeploymentReleaseSummary(id);

  // ─── P13  Data Management & Migration ───────────────────
  Future<Map<String, dynamic>> getDataManagementOverview({String? storeId}) =>
      _apiService.getDataManagementOverview(storeId: storeId);
  Future<Map<String, dynamic>> getDatabaseBackups({Map<String, dynamic>? params}) =>
      _apiService.getDatabaseBackups(params: params);
  Future<Map<String, dynamic>> createDatabaseBackup(Map<String, dynamic> data) => _apiService.createDatabaseBackup(data);
  Future<Map<String, dynamic>> getDatabaseBackup(String id) => _apiService.getDatabaseBackup(id);
  Future<Map<String, dynamic>> completeDatabaseBackup(String id, Map<String, dynamic> data) =>
      _apiService.completeDatabaseBackup(id, data);
  Future<Map<String, dynamic>> getBackupHistory({Map<String, dynamic>? params}) => _apiService.getBackupHistory(params: params);
  Future<Map<String, dynamic>> getBackupHistoryItem(String id) => _apiService.getBackupHistoryItem(id);
  Future<Map<String, dynamic>> getSyncLogs({Map<String, dynamic>? params}) => _apiService.getSyncLogs(params: params);
  Future<Map<String, dynamic>> getSyncLog(String id) => _apiService.getSyncLog(id);
  Future<Map<String, dynamic>> getSyncLogSummary({Map<String, dynamic>? params}) => _apiService.getSyncLogSummary(params: params);
  Future<Map<String, dynamic>> getSyncConflicts({Map<String, dynamic>? params}) => _apiService.getSyncConflicts(params: params);
  Future<Map<String, dynamic>> getSyncConflict(String id) => _apiService.getSyncConflict(id);
  Future<Map<String, dynamic>> resolveSyncConflict(String id, Map<String, dynamic> data) =>
      _apiService.resolveSyncConflict(id, data);
  Future<Map<String, dynamic>> getProviderBackupStatuses({Map<String, dynamic>? params}) =>
      _apiService.getProviderBackupStatuses(params: params);
  Future<Map<String, dynamic>> getProviderBackupStatus(String id) => _apiService.getProviderBackupStatus(id);

  // ─── P14  Security Center ──────────────────────────────────────────
  Future<Map<String, dynamic>> getSecurityOverview({String? storeId}) => _apiService.getSecurityOverview(storeId: storeId);
  Future<Map<String, dynamic>> getSecCenterAlerts({Map<String, dynamic>? params}) =>
      _apiService.getSecCenterAlerts(params: params);
  Future<Map<String, dynamic>> getSecCenterAlert(String id) => _apiService.getSecCenterAlert(id);
  Future<Map<String, dynamic>> resolveSecCenterAlert(String id, Map<String, dynamic> data) =>
      _apiService.resolveSecCenterAlert(id, data);
  Future<Map<String, dynamic>> getSecuritySessions({Map<String, dynamic>? params}) =>
      _apiService.getSecuritySessions(params: params);
  Future<Map<String, dynamic>> getSecuritySession(String id) => _apiService.getSecuritySession(id);
  Future<Map<String, dynamic>> revokeSecuritySession(String id) => _apiService.revokeSecuritySession(id);
  Future<Map<String, dynamic>> getSecurityDevices({Map<String, dynamic>? params}) =>
      _apiService.getSecurityDevices(params: params);
  Future<Map<String, dynamic>> getSecurityDevice(String id) => _apiService.getSecurityDevice(id);
  Future<Map<String, dynamic>> wipeSecurityDevice(String id) => _apiService.wipeSecurityDevice(id);
  Future<Map<String, dynamic>> getSecurityLoginAttempts({Map<String, dynamic>? params}) =>
      _apiService.getSecurityLoginAttempts(params: params);
  Future<Map<String, dynamic>> getSecurityLoginAttempt(String id) => _apiService.getSecurityLoginAttempt(id);
  Future<Map<String, dynamic>> getSecurityAuditLogs({Map<String, dynamic>? params}) =>
      _apiService.getSecurityAuditLogs(params: params);
  Future<Map<String, dynamic>> getSecurityAuditLog(String id) => _apiService.getSecurityAuditLog(id);
  Future<Map<String, dynamic>> getSecurityPolicies({Map<String, dynamic>? params}) =>
      _apiService.getSecurityPolicies(params: params);
  Future<Map<String, dynamic>> getSecurityPolicy(String id) => _apiService.getSecurityPolicy(id);
  Future<Map<String, dynamic>> updateSecurityPolicy(String id, Map<String, dynamic> data) =>
      _apiService.updateSecurityPolicy(id, data);
  Future<Map<String, dynamic>> getSecurityIpAllowlist({Map<String, dynamic>? params}) =>
      _apiService.getSecurityIpAllowlist(params: params);
  Future<Map<String, dynamic>> createSecurityIpAllowlistEntry(Map<String, dynamic> data) =>
      _apiService.createSecurityIpAllowlistEntry(data);
  Future<Map<String, dynamic>> deleteSecurityIpAllowlistEntry(String id) => _apiService.deleteSecurityIpAllowlistEntry(id);
  Future<Map<String, dynamic>> getSecurityIpBlocklist({Map<String, dynamic>? params}) =>
      _apiService.getSecurityIpBlocklist(params: params);
  Future<Map<String, dynamic>> createSecurityIpBlocklistEntry(Map<String, dynamic> data) =>
      _apiService.createSecurityIpBlocklistEntry(data);
  Future<Map<String, dynamic>> deleteSecurityIpBlocklistEntry(String id) => _apiService.deleteSecurityIpBlocklistEntry(id);

  // ─── P15: Financial Operations ───────────────────────────
  Future<Map<String, dynamic>> getFinOpsOverview({String? storeId}) => _apiService.getFinOpsOverview(storeId: storeId);
  Future<Map<String, dynamic>> getFinOpsPayments({Map<String, dynamic>? params}) => _apiService.getFinOpsPayments(params: params);
  Future<Map<String, dynamic>> getFinOpsPayment(String id) => _apiService.getFinOpsPayment(id);
  Future<Map<String, dynamic>> getFinOpsRefunds({Map<String, dynamic>? params}) => _apiService.getFinOpsRefunds(params: params);
  Future<Map<String, dynamic>> getFinOpsRefund(String id) => _apiService.getFinOpsRefund(id);
  Future<Map<String, dynamic>> getFinOpsCashSessions({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsCashSessions(params: params);
  Future<Map<String, dynamic>> getFinOpsCashSession(String id) => _apiService.getFinOpsCashSession(id);
  Future<Map<String, dynamic>> getFinOpsCashEvents({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsCashEvents(params: params);
  Future<Map<String, dynamic>> getFinOpsCashEvent(String id) => _apiService.getFinOpsCashEvent(id);
  Future<Map<String, dynamic>> getFinOpsExpenses({Map<String, dynamic>? params}) => _apiService.getFinOpsExpenses(params: params);
  Future<Map<String, dynamic>> getFinOpsExpense(String id) => _apiService.getFinOpsExpense(id);
  Future<Map<String, dynamic>> getFinOpsGiftCards({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsGiftCards(params: params);
  Future<Map<String, dynamic>> getFinOpsGiftCard(String id) => _apiService.getFinOpsGiftCard(id);
  Future<Map<String, dynamic>> getFinOpsGiftCardTxns({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsGiftCardTxns(params: params);
  Future<Map<String, dynamic>> getFinOpsAccountingConfigs({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsAccountingConfigs(params: params);
  Future<Map<String, dynamic>> getFinOpsAccountingConfig(String id) => _apiService.getFinOpsAccountingConfig(id);
  Future<Map<String, dynamic>> getFinOpsAccountMappings({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsAccountMappings(params: params);
  Future<Map<String, dynamic>> getFinOpsAccountMapping(String id) => _apiService.getFinOpsAccountMapping(id);
  Future<Map<String, dynamic>> getFinOpsAccountingExports({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsAccountingExports(params: params);
  Future<Map<String, dynamic>> getFinOpsAccountingExport(String id) => _apiService.getFinOpsAccountingExport(id);
  Future<Map<String, dynamic>> getFinOpsAutoExportConfigs({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsAutoExportConfigs(params: params);
  Future<Map<String, dynamic>> getFinOpsAutoExportConfig(String id) => _apiService.getFinOpsAutoExportConfig(id);
  Future<Map<String, dynamic>> updateFinOpsAutoExportConfig(String id, Map<String, dynamic> data) =>
      _apiService.updateFinOpsAutoExportConfig(id, data);
  Future<Map<String, dynamic>> getFinOpsThawaniSettlements({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsThawaniSettlements(params: params);
  Future<Map<String, dynamic>> getFinOpsThawaniSettlement(String id) => _apiService.getFinOpsThawaniSettlement(id);
  Future<Map<String, dynamic>> getFinOpsThawaniOrders({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsThawaniOrders(params: params);
  Future<Map<String, dynamic>> getFinOpsThawaniOrder(String id) => _apiService.getFinOpsThawaniOrder(id);
  Future<Map<String, dynamic>> getFinOpsThawaniStoreConfigs({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsThawaniStoreConfigs(params: params);
  Future<Map<String, dynamic>> getFinOpsThawaniStoreConfig(String id) => _apiService.getFinOpsThawaniStoreConfig(id);
  Future<Map<String, dynamic>> getFinOpsDailySalesSummary({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsDailySalesSummary(params: params);
  Future<Map<String, dynamic>> getFinOpsProductSalesSummary({Map<String, dynamic>? params}) =>
      _apiService.getFinOpsProductSalesSummary(params: params);

  // P15 Mutations
  Future<Map<String, dynamic>> createFinOpsExpense(Map<String, dynamic> data) => _apiService.createFinOpsExpense(data);
  Future<Map<String, dynamic>> updateFinOpsExpense(String id, Map<String, dynamic> data) =>
      _apiService.updateFinOpsExpense(id, data);
  Future<Map<String, dynamic>> deleteFinOpsExpense(String id) => _apiService.deleteFinOpsExpense(id);
  Future<Map<String, dynamic>> issueFinOpsGiftCard(Map<String, dynamic> data) => _apiService.issueFinOpsGiftCard(data);
  Future<Map<String, dynamic>> updateFinOpsGiftCard(String id, Map<String, dynamic> data) =>
      _apiService.updateFinOpsGiftCard(id, data);
  Future<Map<String, dynamic>> voidFinOpsGiftCard(String id) => _apiService.voidFinOpsGiftCard(id);
  Future<Map<String, dynamic>> getFinOpsGiftCardTxn(String id) => _apiService.getFinOpsGiftCardTxn(id);
  Future<Map<String, dynamic>> processFinOpsRefund(String id, Map<String, dynamic> data) =>
      _apiService.processFinOpsRefund(id, data);
  Future<Map<String, dynamic>> forceCloseFinOpsCashSession(String id, {Map<String, dynamic>? data}) =>
      _apiService.forceCloseFinOpsCashSession(id, data: data);
  Future<Map<String, dynamic>> createFinOpsAccountingConfig(Map<String, dynamic> data) =>
      _apiService.createFinOpsAccountingConfig(data);
  Future<Map<String, dynamic>> updateFinOpsAccountingConfig(String id, Map<String, dynamic> data) =>
      _apiService.updateFinOpsAccountingConfig(id, data);
  Future<Map<String, dynamic>> deleteFinOpsAccountingConfig(String id) => _apiService.deleteFinOpsAccountingConfig(id);
  Future<Map<String, dynamic>> createFinOpsAccountMapping(Map<String, dynamic> data) =>
      _apiService.createFinOpsAccountMapping(data);
  Future<Map<String, dynamic>> updateFinOpsAccountMapping(String id, Map<String, dynamic> data) =>
      _apiService.updateFinOpsAccountMapping(id, data);
  Future<Map<String, dynamic>> deleteFinOpsAccountMapping(String id) => _apiService.deleteFinOpsAccountMapping(id);
  Future<Map<String, dynamic>> triggerFinOpsAccountingExport(Map<String, dynamic> data) =>
      _apiService.triggerFinOpsAccountingExport(data);
  Future<Map<String, dynamic>> retryFinOpsAccountingExport(String id) => _apiService.retryFinOpsAccountingExport(id);
  Future<Map<String, dynamic>> createFinOpsAutoExportConfig(Map<String, dynamic> data) =>
      _apiService.createFinOpsAutoExportConfig(data);
  Future<Map<String, dynamic>> deleteFinOpsAutoExportConfig(String id) => _apiService.deleteFinOpsAutoExportConfig(id);
  Future<Map<String, dynamic>> reconcileFinOpsThawaniSettlement(String id, Map<String, dynamic> data) =>
      _apiService.reconcileFinOpsThawaniSettlement(id, data);
  Future<Map<String, dynamic>> getFinOpsDailySalesSummaryDetail(String id) => _apiService.getFinOpsDailySalesSummaryDetail(id);
  Future<Map<String, dynamic>> getFinOpsProductSalesSummaryDetail(String id) =>
      _apiService.getFinOpsProductSalesSummaryDetail(id);

  // ─── P16: Infrastructure & Operations ────────────────────
  Future<Map<String, dynamic>> getInfraOverview({String? storeId}) => _apiService.getInfraOverview(storeId: storeId);
  Future<Map<String, dynamic>> getInfraQueues({Map<String, dynamic>? params}) => _apiService.getInfraQueues(params: params);
  Future<Map<String, dynamic>> retryInfraQueue(String id) => _apiService.retryInfraQueue(id);
  Future<Map<String, dynamic>> getInfraFailedJobs({Map<String, dynamic>? params}) =>
      _apiService.getInfraFailedJobs(params: params);
  Future<Map<String, dynamic>> retryInfraFailedJob(String id) => _apiService.retryInfraFailedJob(id);
  Future<Map<String, dynamic>> deleteInfraFailedJob(String id) => _apiService.deleteInfraFailedJob(id);
  Future<Map<String, dynamic>> flushInfraCache() => _apiService.flushInfraCache();
  Future<Map<String, dynamic>> getInfraHealth() => _apiService.getInfraHealth();
  Future<Map<String, dynamic>> getInfraScheduledTasks() => _apiService.getInfraScheduledTasks();
  Future<Map<String, dynamic>> toggleInfraScheduledTask(String id) => _apiService.toggleInfraScheduledTask(id);
  Future<Map<String, dynamic>> getInfraServerMetrics() => _apiService.getInfraServerMetrics();
  Future<Map<String, dynamic>> getInfraStorageUsage() => _apiService.getInfraStorageUsage();
  Future<Map<String, dynamic>> showInfraFailedJob(String id) => _apiService.showInfraFailedJob(id);
  Future<Map<String, dynamic>> getInfraDatabaseBackups({Map<String, dynamic>? params}) =>
      _apiService.getInfraDatabaseBackups(params: params);
  Future<Map<String, dynamic>> showInfraDatabaseBackup(String id) => _apiService.showInfraDatabaseBackup(id);
  Future<Map<String, dynamic>> getInfraHealthChecks({Map<String, dynamic>? params}) =>
      _apiService.getInfraHealthChecks(params: params);
  Future<Map<String, dynamic>> showInfraHealthCheck(String id) => _apiService.showInfraHealthCheck(id);
  Future<Map<String, dynamic>> getInfraProviderBackups({Map<String, dynamic>? params}) =>
      _apiService.getInfraProviderBackups(params: params);
  Future<Map<String, dynamic>> showInfraProviderBackup(String id) => _apiService.showInfraProviderBackup(id);
  Future<Map<String, dynamic>> getInfraSystemSettings({Map<String, dynamic>? params}) =>
      _apiService.getInfraSystemSettings(params: params);
  Future<Map<String, dynamic>> showInfraSystemSetting(String id) => _apiService.showInfraSystemSetting(id);
  Future<Map<String, dynamic>> getInfraCacheStats() => _apiService.getInfraCacheStats();

  // ─── P17: Provider Roles & Permissions ───────────────────
  Future<Map<String, dynamic>> getProviderPermissions() => _apiService.getProviderPermissions();
  Future<Map<String, dynamic>> getProviderRoleTemplates({Map<String, dynamic>? params}) =>
      _apiService.getProviderRoleTemplates(params: params);
  Future<Map<String, dynamic>> getProviderRoleTemplate(String id) => _apiService.getProviderRoleTemplate(id);
  Future<Map<String, dynamic>> createProviderRoleTemplate(Map<String, dynamic> data) =>
      _apiService.createProviderRoleTemplate(data);
  Future<Map<String, dynamic>> updateProviderRoleTemplate(String id, Map<String, dynamic> data) =>
      _apiService.updateProviderRoleTemplate(id, data);
  Future<Map<String, dynamic>> deleteProviderRoleTemplate(String id) => _apiService.deleteProviderRoleTemplate(id);
  Future<Map<String, dynamic>> updateProviderRoleTemplatePermissions(String id, Map<String, dynamic> data) =>
      _apiService.updateProviderRoleTemplatePermissions(id, data);

  // ─── P18: Wameed AI Admin ────────────────────────────────
  Future<Map<String, dynamic>> getWameedAIDashboard({Map<String, dynamic>? params}) =>
      _apiService.getWameedAIDashboard(params: params);
  Future<Map<String, dynamic>> getWameedAIPlatformLogs({Map<String, dynamic>? params}) =>
      _apiService.getWameedAIPlatformLogs(params: params);
  Future<Map<String, dynamic>> getWameedAIPlatformLogStats({Map<String, dynamic>? params}) =>
      _apiService.getWameedAIPlatformLogStats(params: params);
  Future<Map<String, dynamic>> getWameedAIProviders() => _apiService.getWameedAIProviders();
  Future<Map<String, dynamic>> getWameedAIFeatures() => _apiService.getWameedAIFeatures();
  Future<Map<String, dynamic>> toggleWameedAIFeature(String id) => _apiService.toggleWameedAIFeature(id);
  Future<Map<String, dynamic>> getWameedAILlmModels({Map<String, dynamic>? params}) =>
      _apiService.getWameedAILlmModels(params: params);
  Future<Map<String, dynamic>> createWameedAILlmModel(Map<String, dynamic> data) => _apiService.createWameedAILlmModel(data);
  Future<Map<String, dynamic>> updateWameedAILlmModel(String id, Map<String, dynamic> data) =>
      _apiService.updateWameedAILlmModel(id, data);
  Future<Map<String, dynamic>> toggleWameedAILlmModel(String id) => _apiService.toggleWameedAILlmModel(id);
  Future<Map<String, dynamic>> deleteWameedAILlmModel(String id) => _apiService.deleteWameedAILlmModel(id);
  Future<Map<String, dynamic>> getWameedAIChats({Map<String, dynamic>? params}) => _apiService.getWameedAIChats(params: params);
  Future<Map<String, dynamic>> getWameedAIChatDetail(String id) => _apiService.getWameedAIChatDetail(id);
  Future<Map<String, dynamic>> getWameedAIBillingDashboard({Map<String, dynamic>? params}) =>
      _apiService.getWameedAIBillingDashboard(params: params);
  Future<Map<String, dynamic>> getWameedAIBillingInvoices({Map<String, dynamic>? params}) =>
      _apiService.getWameedAIBillingInvoices(params: params);
  Future<Map<String, dynamic>> getWameedAIBillingInvoiceDetail(String id) => _apiService.getWameedAIBillingInvoiceDetail(id);
  Future<Map<String, dynamic>> markWameedAIBillingInvoicePaid(String id, Map<String, dynamic> data) =>
      _apiService.markWameedAIBillingInvoicePaid(id, data);
  Future<Map<String, dynamic>> getWameedAIBillingStores({Map<String, dynamic>? params}) =>
      _apiService.getWameedAIBillingStores(params: params);
  Future<Map<String, dynamic>> getWameedAIBillingStoreDetail(String id) => _apiService.getWameedAIBillingStoreDetail(id);
  Future<Map<String, dynamic>> toggleWameedAIBillingStoreAI(String id, {Map<String, dynamic>? data}) =>
      _apiService.toggleWameedAIBillingStoreAI(id, data: data);
  Future<Map<String, dynamic>> generateWameedAIBillingInvoices({Map<String, dynamic>? data}) =>
      _apiService.generateWameedAIBillingInvoices(data: data);
  Future<Map<String, dynamic>> getWameedAIBillingSettings() => _apiService.getWameedAIBillingSettings();
  Future<Map<String, dynamic>> updateWameedAIBillingSettings(Map<String, dynamic> data) =>
      _apiService.updateWameedAIBillingSettings(data);
}
