import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

final adminApiServiceProvider = Provider<AdminApiService>((ref) {
  return AdminApiService(ref.watch(dioClientProvider));
});

class AdminApiService {
  final Dio _dio;

  AdminApiService(this._dio);

  // ─── Stores ──────────────────────────────────────────────

  Future<Map<String, dynamic>> listStores({
    String? search,
    bool? isActive,
    String? businessType,
    String? organizationId,
    String? storeId,
    int perPage = 15,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'per_page': perPage, 'page': page};
    if (search != null) params['search'] = search;
    if (isActive != null) params['is_active'] = isActive;
    if (businessType != null) params['business_type'] = businessType;
    if (organizationId != null) params['organization_id'] = organizationId;
    if (storeId != null) params['store_id'] = storeId;

    final response = await _dio.get(ApiEndpoints.adminStores, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showStore(String storeId) async {
    final response = await _dio.get(ApiEndpoints.adminStoreById(storeId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> storeMetrics(String storeId) async {
    final response = await _dio.get(ApiEndpoints.adminStoreMetrics(storeId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> suspendStore(String storeId, {String? reason}) async {
    final response = await _dio.post(ApiEndpoints.adminStoreSuspend(storeId), data: {'reason': reason});
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> activateStore(String storeId) async {
    final response = await _dio.post(ApiEndpoints.adminStoreActivate(storeId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createStore({
    required String organizationName,
    required String storeName,
    String? organizationBusinessType,
    String? organizationCountry,
    String? storeBusinessType,
    String? storeCurrency,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.adminStoresCreate,
      data: {
        'organization_name': organizationName,
        'store_name': storeName,
        if (organizationBusinessType != null) 'organization_business_type': organizationBusinessType,
        if (organizationCountry != null) 'organization_country': organizationCountry,
        if (storeBusinessType != null) 'store_business_type': storeBusinessType,
        if (storeCurrency != null) 'store_currency': storeCurrency,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> exportStores({bool? isActive, String? businessType}) async {
    final response = await _dio.post(
      ApiEndpoints.adminStoresExport,
      data: {if (isActive != null) 'is_active': isActive, if (businessType != null) 'business_type': businessType},
    );
    return response.data as Map<String, dynamic>;
  }

  // ─── Limit Overrides ─────────────────────────────────────

  Future<Map<String, dynamic>> listLimitOverrides(String storeId) async {
    final response = await _dio.get(ApiEndpoints.adminStoreLimits(storeId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> setLimitOverride(
    String storeId, {
    required String limitKey,
    required int overrideValue,
    String? reason,
    String? expiresAt,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.adminStoreLimits(storeId),
      data: {
        'limit_key': limitKey,
        'override_value': overrideValue,
        if (reason != null) 'reason': reason,
        if (expiresAt != null) 'expires_at': expiresAt,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> removeLimitOverride(String storeId, String limitKey) async {
    final response = await _dio.delete(ApiEndpoints.adminStoreLimitDelete(storeId, limitKey));
    return response.data as Map<String, dynamic>;
  }

  // ─── Registrations ───────────────────────────────────────

  Future<Map<String, dynamic>> listRegistrations({
    String? status,
    String? search,
    String? storeId,
    int perPage = 15,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'per_page': perPage, 'page': page};
    if (status != null) params['status'] = status;
    if (search != null) params['search'] = search;
    if (storeId != null) params['store_id'] = storeId;

    final response = await _dio.get(ApiEndpoints.adminRegistrations, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> approveRegistration(String registrationId) async {
    final response = await _dio.post(ApiEndpoints.adminRegistrationApprove(registrationId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> rejectRegistration(String registrationId, {required String rejectionReason}) async {
    final response = await _dio.post(
      ApiEndpoints.adminRegistrationReject(registrationId),
      data: {'rejection_reason': rejectionReason},
    );
    return response.data as Map<String, dynamic>;
  }

  // ─── Notes ───────────────────────────────────────────────

  Future<Map<String, dynamic>> addNote({required String organizationId, required String noteText}) async {
    final response = await _dio.post(ApiEndpoints.adminNotes, data: {'organization_id': organizationId, 'note_text': noteText});
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listNotes(String organizationId) async {
    final response = await _dio.get(ApiEndpoints.adminNotesByOrg(organizationId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Platform Roles (P2) ─────────────────────────────────

  Future<Map<String, dynamic>> listRoles() async {
    final response = await _dio.get(ApiEndpoints.adminRoles);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showRole(String roleId) async {
    final response = await _dio.get(ApiEndpoints.adminRoleById(roleId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createRole({
    required String name,
    String? slug,
    String? description,
    List<String>? permissionIds,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.adminRoles,
      data: {
        'name': name,
        if (slug != null) 'slug': slug,
        if (description != null) 'description': description,
        if (permissionIds != null) 'permission_ids': permissionIds,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRole(String roleId, {String? name, String? description, List<String>? permissionIds}) async {
    final response = await _dio.put(
      ApiEndpoints.adminRoleById(roleId),
      data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (permissionIds != null) 'permission_ids': permissionIds,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteRole(String roleId) async {
    final response = await _dio.delete(ApiEndpoints.adminRoleById(roleId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Permissions (P2) ────────────────────────────────────

  Future<Map<String, dynamic>> listPermissions() async {
    final response = await _dio.get(ApiEndpoints.adminPermissions);
    return response.data as Map<String, dynamic>;
  }

  // ─── Admin Team (P2) ─────────────────────────────────────

  Future<Map<String, dynamic>> listTeamUsers({
    String? search,
    bool? isActive,
    String? roleId,
    String? storeId,
    int perPage = 15,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'per_page': perPage, 'page': page};
    if (search != null) params['search'] = search;
    if (isActive != null) params['is_active'] = isActive;
    if (roleId != null) params['role_id'] = roleId;
    if (storeId != null) params['store_id'] = storeId;

    final response = await _dio.get(ApiEndpoints.adminTeam, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showTeamUser(String userId) async {
    final response = await _dio.get(ApiEndpoints.adminTeamUserById(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createTeamUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    bool isActive = true,
    List<String>? roleIds,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.adminTeam,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        if (phone != null) 'phone': phone,
        'is_active': isActive,
        if (roleIds != null) 'role_ids': roleIds,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateTeamUser(
    String userId, {
    String? name,
    String? phone,
    bool? isActive,
    List<String>? roleIds,
  }) async {
    final response = await _dio.put(
      ApiEndpoints.adminTeamUserById(userId),
      data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (isActive != null) 'is_active': isActive,
        if (roleIds != null) 'role_ids': roleIds,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deactivateTeamUser(String userId) async {
    final response = await _dio.post(ApiEndpoints.adminTeamUserDeactivate(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> activateTeamUser(String userId) async {
    final response = await _dio.post(ApiEndpoints.adminTeamUserActivate(userId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Profile & Activity (P2) ─────────────────────────────

  Future<Map<String, dynamic>> getMyProfile() async {
    final response = await _dio.get(ApiEndpoints.adminMe);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listActivityLogs({
    String? adminUserId,
    String? action,
    String? entityType,
    String? dateFrom,
    String? dateTo,
    String? storeId,
    int perPage = 25,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'per_page': perPage, 'page': page};
    if (adminUserId != null) params['admin_user_id'] = adminUserId;
    if (action != null) params['action'] = action;
    if (entityType != null) params['entity_type'] = entityType;
    if (dateFrom != null) params['date_from'] = dateFrom;
    if (dateTo != null) params['date_to'] = dateTo;
    if (storeId != null) params['store_id'] = storeId;

    final response = await _dio.get(ApiEndpoints.adminActivityLog, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  // ─── Plans (P3) ────────────────────────────────────────────

  Future<Map<String, dynamic>> listPlans({bool? activeOnly}) async {
    final params = <String, dynamic>{};
    if (activeOnly == true) params['active_only'] = 1;
    final response = await _dio.get(ApiEndpoints.adminPlans, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showPlan(String planId) async {
    final response = await _dio.get(ApiEndpoints.adminPlanById(planId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPlan(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminPlans, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updatePlan(String planId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminPlanById(planId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> togglePlan(String planId) async {
    final response = await _dio.post(ApiEndpoints.adminPlanToggle(planId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deletePlan(String planId) async {
    final response = await _dio.delete(ApiEndpoints.adminPlanById(planId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> comparePlans({List<String>? planIds}) async {
    final params = <String, dynamic>{};
    if (planIds != null) params['plan_ids'] = planIds;
    final response = await _dio.get(ApiEndpoints.adminPlanCompare, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  // ─── Add-Ons (P3) ─────────────────────────────────────────

  Future<Map<String, dynamic>> listAddOns({bool? activeOnly}) async {
    final params = <String, dynamic>{};
    if (activeOnly == true) params['active_only'] = 1;
    final response = await _dio.get(ApiEndpoints.adminAddOns, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showAddOn(String addOnId) async {
    final response = await _dio.get(ApiEndpoints.adminAddOnById(addOnId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createAddOn(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminAddOns, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAddOn(String addOnId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminAddOnById(addOnId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteAddOn(String addOnId) async {
    final response = await _dio.delete(ApiEndpoints.adminAddOnById(addOnId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Discounts (P3) ───────────────────────────────────────

  Future<Map<String, dynamic>> listDiscounts({bool? active, int perPage = 15}) async {
    final params = <String, dynamic>{'per_page': perPage};
    if (active == true) params['active'] = 1;
    final response = await _dio.get(ApiEndpoints.adminDiscounts, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showDiscount(String discountId) async {
    final response = await _dio.get(ApiEndpoints.adminDiscountById(discountId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createDiscount(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminDiscounts, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateDiscount(String discountId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminDiscountById(discountId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteDiscount(String discountId) async {
    final response = await _dio.delete(ApiEndpoints.adminDiscountById(discountId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Subscriptions (P3) ───────────────────────────────────

  Future<Map<String, dynamic>> listSubscriptions({String? status, String? planId, String? storeId, int perPage = 15}) async {
    final params = <String, dynamic>{'per_page': perPage};
    if (status != null) params['status'] = status;
    if (planId != null) params['plan_id'] = planId;
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminSubscriptions, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showSubscription(String subId) async {
    final response = await _dio.get(ApiEndpoints.adminSubscriptionById(subId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Invoices (P3) ────────────────────────────────────────

  Future<Map<String, dynamic>> listInvoices({String? status, String? subscriptionId, String? storeId, int perPage = 15}) async {
    final params = <String, dynamic>{'per_page': perPage};
    if (status != null) params['status'] = status;
    if (subscriptionId != null) {
      params['store_subscription_id'] = subscriptionId;
    }
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminInvoices, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showInvoice(String invoiceId) async {
    final response = await _dio.get(ApiEndpoints.adminInvoiceById(invoiceId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Revenue Dashboard (P3) ───────────────────────────────

  Future<Map<String, dynamic>> getRevenueDashboard({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminRevenueDashboard, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════════════════════════════
  // P4: User Management
  // ═══════════════════════════════════════════════════════════════

  // ─── Provider Users ────────────────────────────────────────

  Future<Map<String, dynamic>> listProviderUsers({
    String? search,
    String? storeId,
    String? organizationId,
    String? role,
    bool? isActive,
    int perPage = 15,
    int page = 1,
  }) async {
    final params = <String, dynamic>{'per_page': perPage, 'page': page};
    if (search != null) params['search'] = search;
    if (storeId != null) params['store_id'] = storeId;
    if (organizationId != null) params['organization_id'] = organizationId;
    if (role != null) params['role'] = role;
    if (isActive != null) params['is_active'] = isActive;
    final response = await _dio.get(ApiEndpoints.adminProviderUsers, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showProviderUser(String userId) async {
    final response = await _dio.get(ApiEndpoints.adminProviderUserById(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetProviderPassword(String userId) async {
    final response = await _dio.post(ApiEndpoints.adminProviderUserResetPassword(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> forcePasswordChange(String userId) async {
    final response = await _dio.post(ApiEndpoints.adminProviderUserForcePasswordChange(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleProviderActive(String userId) async {
    final response = await _dio.post(ApiEndpoints.adminProviderUserToggleActive(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProviderUserActivity(String userId) async {
    final response = await _dio.get(ApiEndpoints.adminProviderUserActivity(userId));
    return response.data as Map<String, dynamic>;
  }

  // ─── Admin Users ──────────────────────────────────────────

  Future<Map<String, dynamic>> listAdminUsers({String? search, bool? isActive, String? storeId}) async {
    final params = <String, dynamic>{};
    if (search != null) params['search'] = search;
    if (isActive != null) params['is_active'] = isActive;
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminAdminUsers, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showAdminUser(String userId) async {
    final response = await _dio.get(ApiEndpoints.adminAdminUserById(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> inviteAdmin(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminAdminUsers, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAdminUser(String userId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminAdminUserById(userId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetAdmin2fa(String userId) async {
    final response = await _dio.post(ApiEndpoints.adminAdminUserReset2fa(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAdminUserActivity(String userId) async {
    final response = await _dio.get(ApiEndpoints.adminAdminUserActivity(userId));
    return response.data as Map<String, dynamic>;
  }

  // ─── P5: Billing & Finance ──────────────────────────────────

  // Invoices
  Future<Map<String, dynamic>> listBillingInvoices({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminBillingInvoices, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showBillingInvoice(String invoiceId) async {
    final response = await _dio.get(ApiEndpoints.adminBillingInvoiceById(invoiceId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createManualInvoice(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminBillingInvoices, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> markInvoicePaid(String invoiceId) async {
    final response = await _dio.post(ApiEndpoints.adminBillingInvoiceMarkPaid(invoiceId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> processRefund(String invoiceId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminBillingInvoiceRefund(invoiceId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInvoicePdfUrl(String invoiceId) async {
    final response = await _dio.get(ApiEndpoints.adminBillingInvoicePdf(invoiceId));
    return response.data as Map<String, dynamic>;
  }

  // Failed payments
  Future<Map<String, dynamic>> listFailedPayments({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminBillingFailedPayments, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> retryPayment(String invoiceId) async {
    final response = await _dio.post(ApiEndpoints.adminBillingRetryPayment(invoiceId));
    return response.data as Map<String, dynamic>;
  }

  // Retry rules
  Future<Map<String, dynamic>> getRetryRules() async {
    final response = await _dio.get(ApiEndpoints.adminBillingRetryRules);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRetryRules(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminBillingRetryRules, data: data);
    return response.data as Map<String, dynamic>;
  }

  // Revenue dashboard
  Future<Map<String, dynamic>> getBillingRevenue({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminBillingRevenue, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  // Payment gateways
  Future<Map<String, dynamic>> listGateways({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminBillingGateways, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showGateway(String gatewayId) async {
    final response = await _dio.get(ApiEndpoints.adminBillingGatewayById(gatewayId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createGateway(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminBillingGateways, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateGateway(String gatewayId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminBillingGatewayById(gatewayId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteGateway(String gatewayId) async {
    final response = await _dio.delete(ApiEndpoints.adminBillingGatewayById(gatewayId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> testGatewayConnection(String gatewayId) async {
    final response = await _dio.post(ApiEndpoints.adminBillingGatewayTest(gatewayId));
    return response.data as Map<String, dynamic>;
  }

  // Hardware sales
  Future<Map<String, dynamic>> listHardwareSales({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminBillingHardwareSales, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showHardwareSale(String saleId) async {
    final response = await _dio.get(ApiEndpoints.adminBillingHardwareSaleById(saleId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createHardwareSale(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminBillingHardwareSales, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateHardwareSale(String saleId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminBillingHardwareSaleById(saleId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteHardwareSale(String saleId) async {
    final response = await _dio.delete(ApiEndpoints.adminBillingHardwareSaleById(saleId));
    return response.data as Map<String, dynamic>;
  }

  // Implementation fees
  Future<Map<String, dynamic>> listImplementationFees({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminBillingImplementationFees, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showImplementationFee(String feeId) async {
    final response = await _dio.get(ApiEndpoints.adminBillingImplementationFeeById(feeId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createImplementationFee(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminBillingImplementationFees, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateImplementationFee(String feeId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminBillingImplementationFeeById(feeId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteImplementationFee(String feeId) async {
    final response = await _dio.delete(ApiEndpoints.adminBillingImplementationFeeById(feeId));
    return response.data as Map<String, dynamic>;
  }

  // ─── P6: Analytics & Reporting ────────────────────────────────

  Future<Map<String, dynamic>> getAnalyticsDashboard({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminAnalyticsDashboard, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsRevenue({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsRevenue, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsSubscriptions({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsSubscriptions, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsStores({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsStores, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsFeatures({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsFeatures, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsSupport({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsSupport, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsSystemHealth({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminAnalyticsSystemHealth, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsNotifications({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsNotifications, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsDailyStats({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsDailyStats, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsPlanStats({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsPlanStats, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsFeatureStats({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsFeatureStats, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnalyticsStoreHealth({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminAnalyticsStoreHealth, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> exportAnalyticsRevenue(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminAnalyticsExportRevenue, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> exportAnalyticsSubscriptions(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminAnalyticsExportSubscriptions, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> exportAnalyticsStores(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminAnalyticsExportStores, data: data);
    return response.data as Map<String, dynamic>;
  }

  // ─── P7: Feature Flags & A/B Testing ──────────────────────────

  Future<Map<String, dynamic>> getFeatureFlags({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFeatureFlags, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createFeatureFlag(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFeatureFlags, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFeatureFlag(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFeatureFlagById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateFeatureFlag(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminFeatureFlagById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteFeatureFlag(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminFeatureFlagById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleFeatureFlag(String id) async {
    final response = await _dio.post(ApiEndpoints.adminFeatureFlagToggle(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getABTests({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminABTests, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createABTest(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminABTests, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getABTest(String id) async {
    final response = await _dio.get(ApiEndpoints.adminABTestById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateABTest(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminABTestById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteABTest(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminABTestById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> startABTest(String id) async {
    final response = await _dio.post(ApiEndpoints.adminABTestStart(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> stopABTest(String id) async {
    final response = await _dio.post(ApiEndpoints.adminABTestStop(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getABTestResults(String id) async {
    final response = await _dio.get(ApiEndpoints.adminABTestResults(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> addABTestVariant(String testId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminABTestVariants(testId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> removeABTestVariant(String testId, String variantId) async {
    final response = await _dio.delete(ApiEndpoints.adminABTestVariantById(testId, variantId));
    return response.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════════════════════════════
  //  P8: Content Management
  // ═══════════════════════════════════════════════════════════════

  // CMS Pages
  Future<Map<String, dynamic>> getCmsPages({String? search, String? pageType, bool? isPublished, String? storeId}) async {
    final params = <String, dynamic>{};
    if (search != null) params['search'] = search;
    if (pageType != null) params['page_type'] = pageType;
    if (isPublished != null) params['is_published'] = isPublished;
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminCmsPages, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createCmsPage(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminCmsPages, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCmsPage(String id) async {
    final response = await _dio.get(ApiEndpoints.adminCmsPageById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateCmsPage(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminCmsPageById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteCmsPage(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminCmsPageById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleCmsPagePublish(String id) async {
    final response = await _dio.post(ApiEndpoints.adminCmsPagePublish(id));
    return response.data as Map<String, dynamic>;
  }

  // Knowledge Base Articles
  Future<Map<String, dynamic>> getArticles({
    String? search,
    String? category,
    bool? isPublished,
    int? page,
    int? perPage,
    String? storeId,
  }) async {
    final params = <String, dynamic>{};
    if (search != null) params['search'] = search;
    if (category != null) params['category'] = category;
    if (isPublished != null) params['is_published'] = isPublished;
    if (page != null) params['page'] = page;
    if (perPage != null) params['per_page'] = perPage;
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminArticles, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminArticles, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getArticle(String id) async {
    final response = await _dio.get(ApiEndpoints.adminArticleById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateArticle(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminArticleById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteArticle(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminArticleById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleArticlePublish(String id) async {
    final response = await _dio.post(ApiEndpoints.adminArticlePublish(id));
    return response.data as Map<String, dynamic>;
  }

  // Platform Announcements
  Future<Map<String, dynamic>> getAnnouncements({String? search, String? type, int? page, int? perPage, String? storeId}) async {
    final params = <String, dynamic>{};
    if (search != null) params['search'] = search;
    if (type != null) params['type'] = type;
    if (page != null) params['page'] = page;
    if (perPage != null) params['per_page'] = perPage;
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminAnnouncements, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createAnnouncement(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminAnnouncements, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAnnouncement(String id) async {
    final response = await _dio.get(ApiEndpoints.adminAnnouncementById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAnnouncement(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminAnnouncementById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteAnnouncement(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminAnnouncementById(id));
    return response.data as Map<String, dynamic>;
  }

  // Notification Templates
  Future<Map<String, dynamic>> getNotificationTemplates({
    String? search,
    String? channel,
    bool? isActive,
    String? storeId,
  }) async {
    final params = <String, dynamic>{};
    if (search != null) params['search'] = search;
    if (channel != null) params['channel'] = channel;
    if (isActive != null) params['is_active'] = isActive;
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminNotificationTemplates, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createNotificationTemplate(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminNotificationTemplates, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getNotificationTemplate(String id) async {
    final response = await _dio.get(ApiEndpoints.adminNotificationTemplateById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateNotificationTemplate(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminNotificationTemplateById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteNotificationTemplate(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminNotificationTemplateById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleNotificationTemplate(String id) async {
    final response = await _dio.post(ApiEndpoints.adminNotificationTemplateToggle(id));
    return response.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════════════════════════
  //  P9: Platform Logs & Monitoring
  // ═══════════════════════════════════════════════════════════

  // ─── Activity Logs ─────────────────────────────────────────

  Future<Map<String, dynamic>> getActivityLogs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminActivityLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getActivityLog(String id) async {
    final response = await _dio.get(ApiEndpoints.adminActivityLogById(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── Security Alerts ───────────────────────────────────────

  Future<Map<String, dynamic>> getSecurityAlerts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityAlerts, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityAlert(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityAlertById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resolveSecurityAlert(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSecurityAlertResolve(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  // ─── Notification Logs ─────────────────────────────────────

  Future<Map<String, dynamic>> getNotificationLogs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminNotificationLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  // ─── Platform Events ──────────────────────────────────────

  Future<Map<String, dynamic>> getPlatformEvents({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminPlatformEvents, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPlatformEvent(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminPlatformEvents, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPlatformEvent(String id) async {
    final response = await _dio.get(ApiEndpoints.adminPlatformEventById(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── System Health ─────────────────────────────────────────

  Future<Map<String, dynamic>> getHealthDashboard({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminHealthDashboard, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHealthChecks({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminHealthChecks, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createHealthCheck(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminHealthChecks, data: data);
    return response.data as Map<String, dynamic>;
  }

  // ─── Store Health ──────────────────────────────────────────

  Future<Map<String, dynamic>> getStoreHealth({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminStoreHealth, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════════════════════════
  //  P10: SUPPORT TICKET SYSTEM
  // ═══════════════════════════════════════════════════════════

  // ─── Tickets ───────────────────────────────────────────────

  Future<Map<String, dynamic>> getSupportTickets({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSupportTickets, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createSupportTicket(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSupportTickets, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSupportTicket(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSupportTicketById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateSupportTicket(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminSupportTicketById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> assignSupportTicket(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSupportTicketAssign(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> changeSupportTicketStatus(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSupportTicketStatus(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  // ─── Messages ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getTicketMessages(String ticketId, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminTicketMessages(ticketId), queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> addTicketMessage(String ticketId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminTicketMessages(ticketId), data: data);
    return response.data as Map<String, dynamic>;
  }

  // ─── Canned Responses ──────────────────────────────────────

  Future<Map<String, dynamic>> getCannedResponses({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminCannedResponses, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createCannedResponse(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminCannedResponses, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCannedResponse(String id) async {
    final response = await _dio.get(ApiEndpoints.adminCannedResponseById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateCannedResponse(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminCannedResponseById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteCannedResponse(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminCannedResponseById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleCannedResponse(String id) async {
    final response = await _dio.post(ApiEndpoints.adminCannedResponseToggle(id));
    return response.data as Map<String, dynamic>;
  }

  // ═══════════════════════════════════════════════════════════
  //  P11: MARKETPLACE MANAGEMENT
  // ═══════════════════════════════════════════════════════════

  // ─── Store Listings ─────────────────────────────────────────

  Future<Map<String, dynamic>> getMarketplaceStores({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceStores, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMarketplaceStore(String id) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceStoreById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMarketplaceStoreConfig(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminMarketplaceStoreById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> connectMarketplaceStore(String storeId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminMarketplaceStoreConnect(storeId), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> disconnectMarketplaceStore(String id) async {
    final response = await _dio.post(ApiEndpoints.adminMarketplaceStoreDisconnect(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── Product Listings ───────────────────────────────────────

  Future<Map<String, dynamic>> getMarketplaceProducts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceProducts, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMarketplaceProduct(String id) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceProductById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMarketplaceProduct(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminMarketplaceProductById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> bulkPublishProducts(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminMarketplaceBulkPublish, data: data);
    return response.data as Map<String, dynamic>;
  }

  // ─── Orders ─────────────────────────────────────────────────

  Future<Map<String, dynamic>> getMarketplaceOrders({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceOrders, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMarketplaceOrder(String id) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceOrderById(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── Settlements ────────────────────────────────────────────

  Future<Map<String, dynamic>> getMarketplaceSettlements({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceSettlements, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMarketplaceSettlement(String id) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceSettlementById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMarketplaceSettlementSummary({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminMarketplaceSettlementSummary, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  // ─── P12  Deployment & Release Management ───────────────
  Future<Map<String, dynamic>> getDeploymentOverview({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminDeploymentOverview, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDeploymentReleases({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminDeploymentReleases, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createDeploymentRelease(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminDeploymentReleases, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDeploymentRelease(String id) async {
    final response = await _dio.get(ApiEndpoints.adminDeploymentReleaseById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateDeploymentRelease(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminDeploymentReleaseById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteDeploymentRelease(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminDeploymentReleaseById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> activateDeploymentRelease(String id) async {
    final response = await _dio.post(ApiEndpoints.adminDeploymentReleaseActivate(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deactivateDeploymentRelease(String id) async {
    final response = await _dio.post(ApiEndpoints.adminDeploymentReleaseDeactivate(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateDeploymentRollout(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminDeploymentReleaseRollout(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDeploymentReleaseStats(String id, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminDeploymentReleaseStats(id), queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> recordDeploymentReleaseStat(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminDeploymentReleaseStats(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDeploymentReleaseSummary(String id) async {
    final response = await _dio.get(ApiEndpoints.adminDeploymentReleaseSummary(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── P13  Data Management & Migration ───────────────────
  Future<Map<String, dynamic>> getDataManagementOverview({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminDataManagementOverview, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDatabaseBackups({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminDatabaseBackups, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createDatabaseBackup(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminDatabaseBackups, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getDatabaseBackup(String id) async {
    final response = await _dio.get(ApiEndpoints.adminDatabaseBackupById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> completeDatabaseBackup(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminDatabaseBackupComplete(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBackupHistory({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminBackupHistory, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBackupHistoryItem(String id) async {
    final response = await _dio.get(ApiEndpoints.adminBackupHistoryById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSyncLogs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSyncLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSyncLog(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSyncLogById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSyncLogSummary({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSyncLogSummary, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSyncConflicts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSyncConflicts, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSyncConflict(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSyncConflictById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resolveSyncConflict(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSyncConflictResolve(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProviderBackupStatuses({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminProviderBackupStatuses, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProviderBackupStatus(String id) async {
    final response = await _dio.get(ApiEndpoints.adminProviderBackupStatusById(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── P14  Security Center ──────────────────────────────────────────
  Future<Map<String, dynamic>> getSecurityOverview({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminSecurityOverview, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecCenterAlerts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecCenterAlerts, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecCenterAlert(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSecCenterAlertById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resolveSecCenterAlert(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSecCenterAlertResolve(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecuritySessions({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecuritySessions, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecuritySession(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSecuritySessionById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> revokeSecuritySession(String id) async {
    final response = await _dio.post(ApiEndpoints.adminSecuritySessionRevoke(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityDevices({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityDevices, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityDevice(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityDeviceById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> wipeSecurityDevice(String id) async {
    final response = await _dio.post(ApiEndpoints.adminSecurityDeviceWipe(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityLoginAttempts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityLoginAttempts, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityLoginAttempt(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityLoginAttemptById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityAuditLogs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityAuditLogs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityAuditLog(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityAuditLogById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityPolicies({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityPolicies, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityPolicy(String id) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityPolicyById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateSecurityPolicy(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminSecurityPolicyById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityIpAllowlist({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityIpAllowlist, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createSecurityIpAllowlistEntry(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSecurityIpAllowlist, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteSecurityIpAllowlistEntry(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminSecurityIpAllowlistById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSecurityIpBlocklist({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminSecurityIpBlocklist, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createSecurityIpBlocklistEntry(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminSecurityIpBlocklist, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteSecurityIpBlocklistEntry(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminSecurityIpBlocklistById(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── P15: Financial Operations ───────────────────────────
  Future<Map<String, dynamic>> getFinOpsOverview({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminFinOpsOverview, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsPayments({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsPayments, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsPayment(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsPaymentById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsRefunds({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsRefunds, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsRefund(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsRefundById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsCashSessions({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsCashSessions, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsCashSession(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsCashSessionById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsCashEvents({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsCashEvents, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsCashEvent(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsCashEventById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsExpenses({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsExpenses, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsExpense(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsExpenseById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsGiftCards({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsGiftCards, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsGiftCard(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsGiftCardById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsGiftCardTxns({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsGiftCardTxns, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAccountingConfigs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAccountingConfigs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAccountingConfig(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAccountingConfigById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAccountMappings({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAccountMappings, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAccountMapping(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAccountMappingById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAccountingExports({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAccountingExports, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAccountingExport(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAccountingExportById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAutoExportConfigs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAutoExportConfigs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsAutoExportConfig(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsAutoExportConfigById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateFinOpsAutoExportConfig(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminFinOpsAutoExportConfigById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsThawaniSettlements({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsThawaniSettlements, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsThawaniSettlement(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsThawaniSettlementById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsThawaniOrders({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsThawaniOrders, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsThawaniOrder(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsThawaniOrderById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsThawaniStoreConfigs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsThawaniStoreConfigs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsThawaniStoreConfig(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsThawaniStoreConfigById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsDailySalesSummary({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsDailySalesSummary, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsProductSalesSummary({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsProductSalesSummary, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  // P15 Mutation Methods
  Future<Map<String, dynamic>> createFinOpsExpense(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsExpenses, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateFinOpsExpense(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminFinOpsExpenseById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteFinOpsExpense(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminFinOpsExpenseById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> issueFinOpsGiftCard(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsGiftCards, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateFinOpsGiftCard(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminFinOpsGiftCardById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> voidFinOpsGiftCard(String id) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsGiftCardVoid(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsGiftCardTxn(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsGiftCardTxnById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> processFinOpsRefund(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsRefundProcess(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> forceCloseFinOpsCashSession(String id, {Map<String, dynamic>? data}) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsCashSessionForceClose(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createFinOpsAccountingConfig(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsAccountingConfigs, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateFinOpsAccountingConfig(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminFinOpsAccountingConfigById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteFinOpsAccountingConfig(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminFinOpsAccountingConfigById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createFinOpsAccountMapping(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsAccountMappings, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateFinOpsAccountMapping(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminFinOpsAccountMappingById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteFinOpsAccountMapping(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminFinOpsAccountMappingById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> triggerFinOpsAccountingExport(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsAccountingExports, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> retryFinOpsAccountingExport(String id) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsAccountingExportRetry(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createFinOpsAutoExportConfig(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsAutoExportConfigs, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteFinOpsAutoExportConfig(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminFinOpsAutoExportConfigById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> reconcileFinOpsThawaniSettlement(String id, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminFinOpsThawaniSettlementReconcile(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsDailySalesSummaryDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsDailySalesSummaryById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFinOpsProductSalesSummaryDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.adminFinOpsProductSalesSummaryById(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── P16: Infrastructure & Operations ────────────────────
  Future<Map<String, dynamic>> getInfraOverview({String? storeId}) async {
    final params = <String, dynamic>{};
    if (storeId != null) params['store_id'] = storeId;
    final response = await _dio.get(ApiEndpoints.adminInfraOverview, queryParameters: params.isNotEmpty ? params : null);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraQueues({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminInfraQueues, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> retryInfraQueue(String id) async {
    final response = await _dio.post(ApiEndpoints.adminInfraQueueRetry(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraFailedJobs({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminInfraFailedJobs, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> retryInfraFailedJob(String id) async {
    final response = await _dio.post(ApiEndpoints.adminInfraFailedJobRetry(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteInfraFailedJob(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminInfraFailedJobDelete(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> flushInfraCache() async {
    final response = await _dio.post(ApiEndpoints.adminInfraCacheFlush);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraHealth() async {
    final response = await _dio.get(ApiEndpoints.adminInfraHealth);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraScheduledTasks() async {
    final response = await _dio.get(ApiEndpoints.adminInfraScheduledTasks);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleInfraScheduledTask(String id) async {
    final response = await _dio.post(ApiEndpoints.adminInfraScheduledTaskToggle(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraServerMetrics() async {
    final response = await _dio.get(ApiEndpoints.adminInfraServerMetrics);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraStorageUsage() async {
    final response = await _dio.get(ApiEndpoints.adminInfraStorageUsage);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showInfraFailedJob(String id) async {
    final response = await _dio.get(ApiEndpoints.adminInfraFailedJobById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraDatabaseBackups({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminInfraDatabaseBackups, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showInfraDatabaseBackup(String id) async {
    final response = await _dio.get(ApiEndpoints.adminInfraDatabaseBackupById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraHealthChecks({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminInfraHealthChecks, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showInfraHealthCheck(String id) async {
    final response = await _dio.get(ApiEndpoints.adminInfraHealthCheckById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraProviderBackups({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminInfraProviderBackups, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showInfraProviderBackup(String id) async {
    final response = await _dio.get(ApiEndpoints.adminInfraProviderBackupById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraSystemSettings({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminInfraSystemSettings, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> showInfraSystemSetting(String id) async {
    final response = await _dio.get(ApiEndpoints.adminInfraSystemSettingById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInfraCacheStats() async {
    final response = await _dio.get(ApiEndpoints.adminInfraCacheStats);
    return response.data as Map<String, dynamic>;
  }

  // ─── P17: Provider Roles & Permissions ───────────────────
  Future<Map<String, dynamic>> getProviderPermissions() async {
    final response = await _dio.get(ApiEndpoints.adminProviderPermissions);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProviderRoleTemplates({Map<String, dynamic>? params}) async {
    final response = await _dio.get(ApiEndpoints.adminProviderRoleTemplates, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProviderRoleTemplate(String id) async {
    final response = await _dio.get(ApiEndpoints.adminProviderRoleTemplateById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createProviderRoleTemplate(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.adminProviderRoleTemplates, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProviderRoleTemplate(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminProviderRoleTemplateById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteProviderRoleTemplate(String id) async {
    final response = await _dio.delete(ApiEndpoints.adminProviderRoleTemplateById(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProviderRoleTemplatePermissions(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.adminProviderRoleTemplatePermissions(id), data: data);
    return response.data as Map<String, dynamic>;
  }
}
