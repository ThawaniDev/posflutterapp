// ════════════════════════════════════════════════════════
// Admin Store List State
// ════════════════════════════════════════════════════════

sealed class AdminStoreListState {
  const AdminStoreListState();
}

class AdminStoreListInitial extends AdminStoreListState {
  const AdminStoreListInitial();
}

class AdminStoreListLoading extends AdminStoreListState {
  const AdminStoreListLoading();
}

class AdminStoreListLoaded extends AdminStoreListState {

  const AdminStoreListLoaded({required this.stores, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> stores;
  final int total;
  final int currentPage;
  final int lastPage;
}

class AdminStoreListError extends AdminStoreListState {
  const AdminStoreListError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Admin Store Detail State
// ════════════════════════════════════════════════════════

sealed class AdminStoreDetailState {
  const AdminStoreDetailState();
}

class AdminStoreDetailInitial extends AdminStoreDetailState {
  const AdminStoreDetailInitial();
}

class AdminStoreDetailLoading extends AdminStoreDetailState {
  const AdminStoreDetailLoading();
}

class AdminStoreDetailLoaded extends AdminStoreDetailState {

  const AdminStoreDetailLoaded(this.store);
  final Map<String, dynamic> store;
}

class AdminStoreDetailError extends AdminStoreDetailState {
  const AdminStoreDetailError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Admin Action State (suspend, activate, create, etc.)
// ════════════════════════════════════════════════════════

sealed class AdminActionState {
  const AdminActionState();
}

class AdminActionInitial extends AdminActionState {
  const AdminActionInitial();
}

class AdminActionLoading extends AdminActionState {
  const AdminActionLoading();
}

class AdminActionSuccess extends AdminActionState {
  const AdminActionSuccess(this.message, {this.data});
  final String message;
  final Map<String, dynamic>? data;
}

class AdminActionError extends AdminActionState {
  const AdminActionError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Registration List State
// ════════════════════════════════════════════════════════

sealed class RegistrationListState {
  const RegistrationListState();
}

class RegistrationListInitial extends RegistrationListState {
  const RegistrationListInitial();
}

class RegistrationListLoading extends RegistrationListState {
  const RegistrationListLoading();
}

class RegistrationListLoaded extends RegistrationListState {

  const RegistrationListLoaded({
    required this.registrations,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
  final List<Map<String, dynamic>> registrations;
  final int total;
  final int currentPage;
  final int lastPage;
}

class RegistrationListError extends RegistrationListState {
  const RegistrationListError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Limit Override State
// ════════════════════════════════════════════════════════

sealed class LimitOverrideListState {
  const LimitOverrideListState();
}

class LimitOverrideListInitial extends LimitOverrideListState {
  const LimitOverrideListInitial();
}

class LimitOverrideListLoading extends LimitOverrideListState {
  const LimitOverrideListLoading();
}

class LimitOverrideListLoaded extends LimitOverrideListState {

  const LimitOverrideListLoaded(this.overrides);
  final List<Map<String, dynamic>> overrides;
}

class LimitOverrideListError extends LimitOverrideListState {
  const LimitOverrideListError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Provider Notes State
// ════════════════════════════════════════════════════════

sealed class ProviderNotesState {
  const ProviderNotesState();
}

class ProviderNotesInitial extends ProviderNotesState {
  const ProviderNotesInitial();
}

class ProviderNotesLoading extends ProviderNotesState {
  const ProviderNotesLoading();
}

class ProviderNotesLoaded extends ProviderNotesState {

  const ProviderNotesLoaded(this.notes);
  final List<Map<String, dynamic>> notes;
}

class ProviderNotesError extends ProviderNotesState {
  const ProviderNotesError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Platform Role List State (P2)
// ════════════════════════════════════════════════════════

sealed class AdminRoleListState {
  const AdminRoleListState();
}

class AdminRoleListInitial extends AdminRoleListState {
  const AdminRoleListInitial();
}

class AdminRoleListLoading extends AdminRoleListState {
  const AdminRoleListLoading();
}

class AdminRoleListLoaded extends AdminRoleListState {

  const AdminRoleListLoaded(this.roles);
  final List<Map<String, dynamic>> roles;
}

class AdminRoleListError extends AdminRoleListState {
  const AdminRoleListError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Admin Role Detail State (P2)
// ════════════════════════════════════════════════════════

sealed class AdminRoleDetailState {
  const AdminRoleDetailState();
}

class AdminRoleDetailInitial extends AdminRoleDetailState {
  const AdminRoleDetailInitial();
}

class AdminRoleDetailLoading extends AdminRoleDetailState {
  const AdminRoleDetailLoading();
}

class AdminRoleDetailLoaded extends AdminRoleDetailState {

  const AdminRoleDetailLoaded(this.role);
  final Map<String, dynamic> role;
}

class AdminRoleDetailError extends AdminRoleDetailState {
  const AdminRoleDetailError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Permission List State (P2)
// ════════════════════════════════════════════════════════

sealed class PermissionListState {
  const PermissionListState();
}

class PermissionListInitial extends PermissionListState {
  const PermissionListInitial();
}

class PermissionListLoading extends PermissionListState {
  const PermissionListLoading();
}

class PermissionListLoaded extends PermissionListState {

  const PermissionListLoaded(this.groupedPermissions);
  final Map<String, List<Map<String, dynamic>>> groupedPermissions;
}

class PermissionListError extends PermissionListState {
  const PermissionListError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Admin Team List State (P2)
// ════════════════════════════════════════════════════════

sealed class AdminTeamListState {
  const AdminTeamListState();
}

class AdminTeamListInitial extends AdminTeamListState {
  const AdminTeamListInitial();
}

class AdminTeamListLoading extends AdminTeamListState {
  const AdminTeamListLoading();
}

class AdminTeamListLoaded extends AdminTeamListState {

  const AdminTeamListLoaded({required this.users, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> users;
  final int total;
  final int currentPage;
  final int lastPage;
}

class AdminTeamListError extends AdminTeamListState {
  const AdminTeamListError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Admin Team User Detail State (P2)
// ════════════════════════════════════════════════════════

sealed class AdminTeamUserDetailState {
  const AdminTeamUserDetailState();
}

class AdminTeamUserDetailInitial extends AdminTeamUserDetailState {
  const AdminTeamUserDetailInitial();
}

class AdminTeamUserDetailLoading extends AdminTeamUserDetailState {
  const AdminTeamUserDetailLoading();
}

class AdminTeamUserDetailLoaded extends AdminTeamUserDetailState {

  const AdminTeamUserDetailLoaded(this.user);
  final Map<String, dynamic> user;
}

class AdminTeamUserDetailError extends AdminTeamUserDetailState {
  const AdminTeamUserDetailError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Admin Profile State (P2)
// ════════════════════════════════════════════════════════

sealed class AdminProfileState {
  const AdminProfileState();
}

class AdminProfileInitial extends AdminProfileState {
  const AdminProfileInitial();
}

class AdminProfileLoading extends AdminProfileState {
  const AdminProfileLoading();
}

class AdminProfileLoaded extends AdminProfileState {

  const AdminProfileLoaded(this.profile);
  final Map<String, dynamic> profile;
}

class AdminProfileError extends AdminProfileState {
  const AdminProfileError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// Activity Log State (P2)
// ════════════════════════════════════════════════════════

sealed class ActivityLogState {
  const ActivityLogState();
}

class ActivityLogInitial extends ActivityLogState {
  const ActivityLogInitial();
}

class ActivityLogLoading extends ActivityLogState {
  const ActivityLogLoading();
}

class ActivityLogLoaded extends ActivityLogState {

  const ActivityLogLoaded({required this.logs, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> logs;
  final int total;
  final int currentPage;
  final int lastPage;
}

class ActivityLogError extends ActivityLogState {
  const ActivityLogError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P3: Plan List State
// ═══════════════════════════════════════════════════════════════

sealed class PlanListState {
  const PlanListState();
}

class PlanListInitial extends PlanListState {
  const PlanListInitial();
}

class PlanListLoading extends PlanListState {
  const PlanListLoading();
}

class PlanListLoaded extends PlanListState {
  const PlanListLoaded(this.plans);
  final List<Map<String, dynamic>> plans;
}

class PlanListError extends PlanListState {
  const PlanListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P3: Plan Detail State
// ═══════════════════════════════════════════════════════════════

sealed class PlanDetailState {
  const PlanDetailState();
}

class PlanDetailInitial extends PlanDetailState {
  const PlanDetailInitial();
}

class PlanDetailLoading extends PlanDetailState {
  const PlanDetailLoading();
}

class PlanDetailLoaded extends PlanDetailState {
  const PlanDetailLoaded(this.plan);
  final Map<String, dynamic> plan;
}

class PlanDetailError extends PlanDetailState {
  const PlanDetailError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P3: Add-On List State
// ═══════════════════════════════════════════════════════════════

sealed class AddOnListState {
  const AddOnListState();
}

class AddOnListInitial extends AddOnListState {
  const AddOnListInitial();
}

class AddOnListLoading extends AddOnListState {
  const AddOnListLoading();
}

class AddOnListLoaded extends AddOnListState {
  const AddOnListLoaded(this.addOns);
  final List<Map<String, dynamic>> addOns;
}

class AddOnListError extends AddOnListState {
  const AddOnListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P3: Discount List State
// ═══════════════════════════════════════════════════════════════

sealed class DiscountListState {
  const DiscountListState();
}

class DiscountListInitial extends DiscountListState {
  const DiscountListInitial();
}

class DiscountListLoading extends DiscountListState {
  const DiscountListLoading();
}

class DiscountListLoaded extends DiscountListState {

  const DiscountListLoaded({required this.discounts, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> discounts;
  final int total;
  final int currentPage;
  final int lastPage;
}

class DiscountListError extends DiscountListState {
  const DiscountListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P3: Subscription List State
// ═══════════════════════════════════════════════════════════════

sealed class SubscriptionListState {
  const SubscriptionListState();
}

class SubscriptionListInitial extends SubscriptionListState {
  const SubscriptionListInitial();
}

class SubscriptionListLoading extends SubscriptionListState {
  const SubscriptionListLoading();
}

class SubscriptionListLoaded extends SubscriptionListState {

  const SubscriptionListLoaded({
    required this.subscriptions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
  final List<Map<String, dynamic>> subscriptions;
  final int total;
  final int currentPage;
  final int lastPage;
}

class SubscriptionListError extends SubscriptionListState {
  const SubscriptionListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P3: Invoice List State
// ═══════════════════════════════════════════════════════════════

sealed class InvoiceListState {
  const InvoiceListState();
}

class InvoiceListInitial extends InvoiceListState {
  const InvoiceListInitial();
}

class InvoiceListLoading extends InvoiceListState {
  const InvoiceListLoading();
}

class InvoiceListLoaded extends InvoiceListState {

  const InvoiceListLoaded({required this.invoices, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> invoices;
  final int total;
  final int currentPage;
  final int lastPage;
}

class InvoiceListError extends InvoiceListState {
  const InvoiceListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P3: Revenue Dashboard State
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// P4: User Management States
// ═══════════════════════════════════════════════════════════════

// ─── Provider User List ─────────────────────────────────────

sealed class ProviderUserListState {
  const ProviderUserListState();
}

class ProviderUserListInitial extends ProviderUserListState {
  const ProviderUserListInitial();
}

class ProviderUserListLoading extends ProviderUserListState {
  const ProviderUserListLoading();
}

class ProviderUserListLoaded extends ProviderUserListState {

  const ProviderUserListLoaded({required this.users, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> users;
  final int total;
  final int currentPage;
  final int lastPage;
}

class ProviderUserListError extends ProviderUserListState {
  const ProviderUserListError(this.message);
  final String message;
}

// ─── Provider User Detail ───────────────────────────────────

sealed class ProviderUserDetailState {
  const ProviderUserDetailState();
}

class ProviderUserDetailInitial extends ProviderUserDetailState {
  const ProviderUserDetailInitial();
}

class ProviderUserDetailLoading extends ProviderUserDetailState {
  const ProviderUserDetailLoading();
}

class ProviderUserDetailLoaded extends ProviderUserDetailState {
  const ProviderUserDetailLoaded(this.user);
  final Map<String, dynamic> user;
}

class ProviderUserDetailError extends ProviderUserDetailState {
  const ProviderUserDetailError(this.message);
  final String message;
}

// ─── Admin User List ────────────────────────────────────────

sealed class AdminUserListState {
  const AdminUserListState();
}

class AdminUserListInitial extends AdminUserListState {
  const AdminUserListInitial();
}

class AdminUserListLoading extends AdminUserListState {
  const AdminUserListLoading();
}

class AdminUserListLoaded extends AdminUserListState {
  const AdminUserListLoaded(this.admins);
  final List<Map<String, dynamic>> admins;
}

class AdminUserListError extends AdminUserListState {
  const AdminUserListError(this.message);
  final String message;
}

// ─── Admin User Detail ──────────────────────────────────────

sealed class AdminUserDetailState {
  const AdminUserDetailState();
}

class AdminUserDetailInitial extends AdminUserDetailState {
  const AdminUserDetailInitial();
}

class AdminUserDetailLoading extends AdminUserDetailState {
  const AdminUserDetailLoading();
}

class AdminUserDetailLoaded extends AdminUserDetailState {
  const AdminUserDetailLoaded(this.admin);
  final Map<String, dynamic> admin;
}

class AdminUserDetailError extends AdminUserDetailState {
  const AdminUserDetailError(this.message);
  final String message;
}

// ─── User Activity Log ──────────────────────────────────────

sealed class UserActivityState {
  const UserActivityState();
}

class UserActivityInitial extends UserActivityState {
  const UserActivityInitial();
}

class UserActivityLoading extends UserActivityState {
  const UserActivityLoading();
}

class UserActivityLoaded extends UserActivityState {
  const UserActivityLoaded(this.logs);
  final List<Map<String, dynamic>> logs;
}

class UserActivityError extends UserActivityState {
  const UserActivityError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P5: Billing & Finance States
// ═══════════════════════════════════════════════════════════════

// ─── Billing Invoice List ──────────────────────────────────────
sealed class BillingInvoiceListState {
  const BillingInvoiceListState();
}

class BillingInvoiceListInitial extends BillingInvoiceListState {
  const BillingInvoiceListInitial();
}

class BillingInvoiceListLoading extends BillingInvoiceListState {
  const BillingInvoiceListLoading();
}

class BillingInvoiceListLoaded extends BillingInvoiceListState {
  const BillingInvoiceListLoaded(this.invoices, this.pagination);
  final List<Map<String, dynamic>> invoices;
  final Map<String, dynamic> pagination;
}

class BillingInvoiceListError extends BillingInvoiceListState {
  const BillingInvoiceListError(this.message);
  final String message;
}

// ─── Billing Invoice Detail ────────────────────────────────────
sealed class BillingInvoiceDetailState {
  const BillingInvoiceDetailState();
}

class BillingInvoiceDetailInitial extends BillingInvoiceDetailState {
  const BillingInvoiceDetailInitial();
}

class BillingInvoiceDetailLoading extends BillingInvoiceDetailState {
  const BillingInvoiceDetailLoading();
}

class BillingInvoiceDetailLoaded extends BillingInvoiceDetailState {
  const BillingInvoiceDetailLoaded(this.invoice);
  final Map<String, dynamic> invoice;
}

class BillingInvoiceDetailError extends BillingInvoiceDetailState {
  const BillingInvoiceDetailError(this.message);
  final String message;
}

// ─── Revenue Dashboard ─────────────────────────────────────────
sealed class RevenueDashboardState {
  const RevenueDashboardState();
}

class RevenueDashboardInitial extends RevenueDashboardState {
  const RevenueDashboardInitial();
}

class RevenueDashboardLoading extends RevenueDashboardState {
  const RevenueDashboardLoading();
}

class RevenueDashboardLoaded extends RevenueDashboardState {
  const RevenueDashboardLoaded({
    required this.mrr,
    required this.arr,
    required this.revenueByStatus,
    required this.upcomingRenewals,
    required this.hardwareRevenue,
    required this.implementationRevenue,
    required this.totalInvoices,
    required this.paidInvoices,
    required this.failedInvoices,
  });
  final double mrr;
  final double arr;
  final List<Map<String, dynamic>> revenueByStatus;
  final int upcomingRenewals;
  final double hardwareRevenue;
  final double implementationRevenue;
  final int totalInvoices;
  final int paidInvoices;
  final int failedInvoices;
}

class RevenueDashboardError extends RevenueDashboardState {
  const RevenueDashboardError(this.message);
  final String message;
}

// ─── Payment Gateway List ──────────────────────────────────────
sealed class GatewayListState {
  const GatewayListState();
}

class GatewayListInitial extends GatewayListState {
  const GatewayListInitial();
}

class GatewayListLoading extends GatewayListState {
  const GatewayListLoading();
}

class GatewayListLoaded extends GatewayListState {
  const GatewayListLoaded(this.gateways);
  final List<Map<String, dynamic>> gateways;
}

class GatewayListError extends GatewayListState {
  const GatewayListError(this.message);
  final String message;
}

// ─── Hardware Sales List ───────────────────────────────────────
sealed class HardwareSaleListState {
  const HardwareSaleListState();
}

class HardwareSaleListInitial extends HardwareSaleListState {
  const HardwareSaleListInitial();
}

class HardwareSaleListLoading extends HardwareSaleListState {
  const HardwareSaleListLoading();
}

class HardwareSaleListLoaded extends HardwareSaleListState {
  const HardwareSaleListLoaded(this.sales, this.pagination);
  final List<Map<String, dynamic>> sales;
  final Map<String, dynamic> pagination;
}

class HardwareSaleListError extends HardwareSaleListState {
  const HardwareSaleListError(this.message);
  final String message;
}

// ─── Implementation Fee List ───────────────────────────────────
sealed class ImplementationFeeListState {
  const ImplementationFeeListState();
}

class ImplementationFeeListInitial extends ImplementationFeeListState {
  const ImplementationFeeListInitial();
}

class ImplementationFeeListLoading extends ImplementationFeeListState {
  const ImplementationFeeListLoading();
}

class ImplementationFeeListLoaded extends ImplementationFeeListState {
  const ImplementationFeeListLoaded(this.fees, this.pagination);
  final List<Map<String, dynamic>> fees;
  final Map<String, dynamic> pagination;
}

class ImplementationFeeListError extends ImplementationFeeListState {
  const ImplementationFeeListError(this.message);
  final String message;
}

// ─── Retry Rules ───────────────────────────────────────────────
sealed class RetryRulesState {
  const RetryRulesState();
}

class RetryRulesInitial extends RetryRulesState {
  const RetryRulesInitial();
}

class RetryRulesLoading extends RetryRulesState {
  const RetryRulesLoading();
}

class RetryRulesLoaded extends RetryRulesState {
  const RetryRulesLoaded({required this.maxRetries, required this.retryIntervalHours, required this.gracePeriodDays});
  final int maxRetries;
  final int retryIntervalHours;
  final int gracePeriodDays;
}

class RetryRulesError extends RetryRulesState {
  const RetryRulesError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// P6: Analytics Dashboard State
// ════════════════════════════════════════════════════════

sealed class AnalyticsDashboardState {
  const AnalyticsDashboardState();
}

class AnalyticsDashboardInitial extends AnalyticsDashboardState {
  const AnalyticsDashboardInitial();
}

class AnalyticsDashboardLoading extends AnalyticsDashboardState {
  const AnalyticsDashboardLoading();
}

class AnalyticsDashboardLoaded extends AnalyticsDashboardState {
  const AnalyticsDashboardLoaded({required this.kpi, required this.recentActivity});
  final Map<String, dynamic> kpi;
  final List<Map<String, dynamic>> recentActivity;
}

class AnalyticsDashboardError extends AnalyticsDashboardState {
  const AnalyticsDashboardError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// P6: Analytics Revenue State
// ════════════════════════════════════════════════════════

sealed class AnalyticsRevenueState {
  const AnalyticsRevenueState();
}

class AnalyticsRevenueInitial extends AnalyticsRevenueState {
  const AnalyticsRevenueInitial();
}

class AnalyticsRevenueLoading extends AnalyticsRevenueState {
  const AnalyticsRevenueLoading();
}

class AnalyticsRevenueLoaded extends AnalyticsRevenueState {
  const AnalyticsRevenueLoaded({
    required this.mrr,
    required this.arr,
    required this.revenueTrend,
    required this.revenueByPlan,
    required this.failedPaymentsCount,
    required this.upcomingRenewals,
  });
  final double mrr;
  final double arr;
  final List<Map<String, dynamic>> revenueTrend;
  final List<Map<String, dynamic>> revenueByPlan;
  final int failedPaymentsCount;
  final int upcomingRenewals;
}

class AnalyticsRevenueError extends AnalyticsRevenueState {
  const AnalyticsRevenueError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// P6: Analytics Subscriptions State
// ════════════════════════════════════════════════════════

sealed class AnalyticsSubscriptionsState {
  const AnalyticsSubscriptionsState();
}

class AnalyticsSubscriptionsInitial extends AnalyticsSubscriptionsState {
  const AnalyticsSubscriptionsInitial();
}

class AnalyticsSubscriptionsLoading extends AnalyticsSubscriptionsState {
  const AnalyticsSubscriptionsLoading();
}

class AnalyticsSubscriptionsLoaded extends AnalyticsSubscriptionsState {
  const AnalyticsSubscriptionsLoaded({
    required this.statusCounts,
    required this.lifecycleTrend,
    required this.averageSubscriptionAgeDays,
    required this.totalChurnInPeriod,
    required this.trialToPaidConversionRate,
  });
  final Map<String, dynamic> statusCounts;
  final List<Map<String, dynamic>> lifecycleTrend;
  final double averageSubscriptionAgeDays;
  final int totalChurnInPeriod;
  final double trialToPaidConversionRate;
}

class AnalyticsSubscriptionsError extends AnalyticsSubscriptionsState {
  const AnalyticsSubscriptionsError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// P6: Analytics Stores State
// ════════════════════════════════════════════════════════

sealed class AnalyticsStoresState {
  const AnalyticsStoresState();
}

class AnalyticsStoresInitial extends AnalyticsStoresState {
  const AnalyticsStoresInitial();
}

class AnalyticsStoresLoading extends AnalyticsStoresState {
  const AnalyticsStoresLoading();
}

class AnalyticsStoresLoaded extends AnalyticsStoresState {
  const AnalyticsStoresLoaded({
    required this.totalStores,
    required this.activeStores,
    required this.topStores,
    required this.healthSummary,
  });
  final int totalStores;
  final int activeStores;
  final List<Map<String, dynamic>> topStores;
  final Map<String, dynamic> healthSummary;
}

class AnalyticsStoresError extends AnalyticsStoresState {
  const AnalyticsStoresError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// P6: Analytics Features State
// ════════════════════════════════════════════════════════

sealed class AnalyticsFeaturesState {
  const AnalyticsFeaturesState();
}

class AnalyticsFeaturesInitial extends AnalyticsFeaturesState {
  const AnalyticsFeaturesInitial();
}

class AnalyticsFeaturesLoading extends AnalyticsFeaturesState {
  const AnalyticsFeaturesLoading();
}

class AnalyticsFeaturesLoaded extends AnalyticsFeaturesState {
  const AnalyticsFeaturesLoaded({required this.features, required this.trend});
  final List<Map<String, dynamic>> features;
  final List<Map<String, dynamic>> trend;
}

class AnalyticsFeaturesError extends AnalyticsFeaturesState {
  const AnalyticsFeaturesError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// P6: Analytics System Health State
// ════════════════════════════════════════════════════════

sealed class AnalyticsSystemHealthState {
  const AnalyticsSystemHealthState();
}

class AnalyticsSystemHealthInitial extends AnalyticsSystemHealthState {
  const AnalyticsSystemHealthInitial();
}

class AnalyticsSystemHealthLoading extends AnalyticsSystemHealthState {
  const AnalyticsSystemHealthLoading();
}

class AnalyticsSystemHealthLoaded extends AnalyticsSystemHealthState {
  const AnalyticsSystemHealthLoaded({
    required this.storesMonitored,
    required this.storesWithErrors,
    required this.totalErrorsToday,
    required this.syncStatusBreakdown,
  });
  final int storesMonitored;
  final int storesWithErrors;
  final int totalErrorsToday;
  final Map<String, dynamic> syncStatusBreakdown;
}

class AnalyticsSystemHealthError extends AnalyticsSystemHealthState {
  const AnalyticsSystemHealthError(this.message);
  final String message;
}

// ════════════════════════════════════════════════════════
// P6: Analytics Export State
// ════════════════════════════════════════════════════════

sealed class AnalyticsExportState {
  const AnalyticsExportState();
}

class AnalyticsExportInitial extends AnalyticsExportState {
  const AnalyticsExportInitial();
}

class AnalyticsExportLoading extends AnalyticsExportState {
  const AnalyticsExportLoading();
}

class AnalyticsExportSuccess extends AnalyticsExportState {
  const AnalyticsExportSuccess({required this.exportType, required this.format, required this.recordCount, this.downloadUrl});
  final String exportType;
  final String format;
  final int recordCount;
  final String? downloadUrl;
}

class AnalyticsExportError extends AnalyticsExportState {
  const AnalyticsExportError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════════
//  P7: Feature Flags & A/B Testing States
// ═══════════════════════════════════════════════════════════════════

// ─── Feature Flag List ───────────────────────────────────────────
sealed class FeatureFlagListState {
  const FeatureFlagListState();
}

class FeatureFlagListInitial extends FeatureFlagListState {
  const FeatureFlagListInitial();
}

class FeatureFlagListLoading extends FeatureFlagListState {
  const FeatureFlagListLoading();
}

class FeatureFlagListLoaded extends FeatureFlagListState {
  const FeatureFlagListLoaded({required this.flags, required this.total});
  final List<Map<String, dynamic>> flags;
  final int total;
}

class FeatureFlagListError extends FeatureFlagListState {
  const FeatureFlagListError(this.message);
  final String message;
}

// ─── Feature Flag Detail ─────────────────────────────────────────
sealed class FeatureFlagDetailState {
  const FeatureFlagDetailState();
}

class FeatureFlagDetailInitial extends FeatureFlagDetailState {
  const FeatureFlagDetailInitial();
}

class FeatureFlagDetailLoading extends FeatureFlagDetailState {
  const FeatureFlagDetailLoading();
}

class FeatureFlagDetailLoaded extends FeatureFlagDetailState {
  const FeatureFlagDetailLoaded({required this.flag, required this.abTests});
  final Map<String, dynamic> flag;
  final List<Map<String, dynamic>> abTests;
}

class FeatureFlagDetailError extends FeatureFlagDetailState {
  const FeatureFlagDetailError(this.message);
  final String message;
}

// ─── Feature Flag Action ─────────────────────────────────────────
sealed class FeatureFlagActionState {
  const FeatureFlagActionState();
}

class FeatureFlagActionInitial extends FeatureFlagActionState {
  const FeatureFlagActionInitial();
}

class FeatureFlagActionLoading extends FeatureFlagActionState {
  const FeatureFlagActionLoading();
}

class FeatureFlagActionSuccess extends FeatureFlagActionState {
  const FeatureFlagActionSuccess(this.message);
  final String message;
}

class FeatureFlagActionError extends FeatureFlagActionState {
  const FeatureFlagActionError(this.message);
  final String message;
}

// ─── A/B Test List ───────────────────────────────────────────────
sealed class ABTestListState {
  const ABTestListState();
}

class ABTestListInitial extends ABTestListState {
  const ABTestListInitial();
}

class ABTestListLoading extends ABTestListState {
  const ABTestListLoading();
}

class ABTestListLoaded extends ABTestListState {
  const ABTestListLoaded({required this.tests, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> tests;
  final int total;
  final int currentPage;
  final int lastPage;
}

class ABTestListError extends ABTestListState {
  const ABTestListError(this.message);
  final String message;
}

// ─── A/B Test Detail ─────────────────────────────────────────────
sealed class ABTestDetailState {
  const ABTestDetailState();
}

class ABTestDetailInitial extends ABTestDetailState {
  const ABTestDetailInitial();
}

class ABTestDetailLoading extends ABTestDetailState {
  const ABTestDetailLoading();
}

class ABTestDetailLoaded extends ABTestDetailState {
  const ABTestDetailLoaded({required this.test, required this.variants});
  final Map<String, dynamic> test;
  final List<Map<String, dynamic>> variants;
}

class ABTestDetailError extends ABTestDetailState {
  const ABTestDetailError(this.message);
  final String message;
}

// ─── A/B Test Results ────────────────────────────────────────────
sealed class ABTestResultsState {
  const ABTestResultsState();
}

class ABTestResultsInitial extends ABTestResultsState {
  const ABTestResultsInitial();
}

class ABTestResultsLoading extends ABTestResultsState {
  const ABTestResultsLoading();
}

class ABTestResultsLoaded extends ABTestResultsState {
  const ABTestResultsLoaded({required this.test, required this.results, this.winner, required this.confidence});
  final Map<String, dynamic> test;
  final List<Map<String, dynamic>> results;
  final String? winner;
  final double confidence;
}

class ABTestResultsError extends ABTestResultsState {
  const ABTestResultsError(this.message);
  final String message;
}

// ─── A/B Test Action ─────────────────────────────────────────────
sealed class ABTestActionState {
  const ABTestActionState();
}

class ABTestActionInitial extends ABTestActionState {
  const ABTestActionInitial();
}

class ABTestActionLoading extends ABTestActionState {
  const ABTestActionLoading();
}

class ABTestActionSuccess extends ABTestActionState {
  const ABTestActionSuccess(this.message);
  final String message;
}

class ABTestActionError extends ABTestActionState {
  const ABTestActionError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════════════════════
//  P8: Content Management States
// ═══════════════════════════════════════════════════════════════════════════════

// ─── CMS Page List ───────────────────────────────────────────
sealed class CmsPageListState {
  const CmsPageListState();
}

class CmsPageListInitial extends CmsPageListState {
  const CmsPageListInitial();
}

class CmsPageListLoading extends CmsPageListState {
  const CmsPageListLoading();
}

class CmsPageListLoaded extends CmsPageListState {
  const CmsPageListLoaded({required this.pages, required this.total});
  final List<Map<String, dynamic>> pages;
  final int total;
}

class CmsPageListError extends CmsPageListState {
  const CmsPageListError(this.message);
  final String message;
}

// ─── CMS Page Detail ─────────────────────────────────────────
sealed class CmsPageDetailState {
  const CmsPageDetailState();
}

class CmsPageDetailInitial extends CmsPageDetailState {
  const CmsPageDetailInitial();
}

class CmsPageDetailLoading extends CmsPageDetailState {
  const CmsPageDetailLoading();
}

class CmsPageDetailLoaded extends CmsPageDetailState {
  const CmsPageDetailLoaded({required this.page});
  final Map<String, dynamic> page;
}

class CmsPageDetailError extends CmsPageDetailState {
  const CmsPageDetailError(this.message);
  final String message;
}

// ─── CMS Page Action ─────────────────────────────────────────
sealed class CmsPageActionState {
  const CmsPageActionState();
}

class CmsPageActionInitial extends CmsPageActionState {
  const CmsPageActionInitial();
}

class CmsPageActionLoading extends CmsPageActionState {
  const CmsPageActionLoading();
}

class CmsPageActionSuccess extends CmsPageActionState {
  const CmsPageActionSuccess(this.message);
  final String message;
}

class CmsPageActionError extends CmsPageActionState {
  const CmsPageActionError(this.message);
  final String message;
}

// ─── Article List ────────────────────────────────────────────
sealed class ArticleListState {
  const ArticleListState();
}

class ArticleListInitial extends ArticleListState {
  const ArticleListInitial();
}

class ArticleListLoading extends ArticleListState {
  const ArticleListLoading();
}

class ArticleListLoaded extends ArticleListState {
  const ArticleListLoaded({required this.articles, required this.total, required this.currentPage, required this.lastPage});
  final List<Map<String, dynamic>> articles;
  final int total;
  final int currentPage;
  final int lastPage;
}

class ArticleListError extends ArticleListState {
  const ArticleListError(this.message);
  final String message;
}

// ─── Article Detail ──────────────────────────────────────────
sealed class ArticleDetailState {
  const ArticleDetailState();
}

class ArticleDetailInitial extends ArticleDetailState {
  const ArticleDetailInitial();
}

class ArticleDetailLoading extends ArticleDetailState {
  const ArticleDetailLoading();
}

class ArticleDetailLoaded extends ArticleDetailState {
  const ArticleDetailLoaded({required this.article});
  final Map<String, dynamic> article;
}

class ArticleDetailError extends ArticleDetailState {
  const ArticleDetailError(this.message);
  final String message;
}

// ─── Article Action ──────────────────────────────────────────
sealed class ArticleActionState {
  const ArticleActionState();
}

class ArticleActionInitial extends ArticleActionState {
  const ArticleActionInitial();
}

class ArticleActionLoading extends ArticleActionState {
  const ArticleActionLoading();
}

class ArticleActionSuccess extends ArticleActionState {
  const ArticleActionSuccess(this.message);
  final String message;
}

class ArticleActionError extends ArticleActionState {
  const ArticleActionError(this.message);
  final String message;
}

// ─── Announcement List ───────────────────────────────────────
sealed class AnnouncementListState {
  const AnnouncementListState();
}

class AnnouncementListInitial extends AnnouncementListState {
  const AnnouncementListInitial();
}

class AnnouncementListLoading extends AnnouncementListState {
  const AnnouncementListLoading();
}

class AnnouncementListLoaded extends AnnouncementListState {
  const AnnouncementListLoaded({
    required this.announcements,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
  final List<Map<String, dynamic>> announcements;
  final int total;
  final int currentPage;
  final int lastPage;
}

class AnnouncementListError extends AnnouncementListState {
  const AnnouncementListError(this.message);
  final String message;
}

// ─── Announcement Detail ─────────────────────────────────────
sealed class AnnouncementDetailState {
  const AnnouncementDetailState();
}

class AnnouncementDetailInitial extends AnnouncementDetailState {
  const AnnouncementDetailInitial();
}

class AnnouncementDetailLoading extends AnnouncementDetailState {
  const AnnouncementDetailLoading();
}

class AnnouncementDetailLoaded extends AnnouncementDetailState {
  const AnnouncementDetailLoaded({required this.announcement});
  final Map<String, dynamic> announcement;
}

class AnnouncementDetailError extends AnnouncementDetailState {
  const AnnouncementDetailError(this.message);
  final String message;
}

// ─── Announcement Action ─────────────────────────────────────
sealed class AnnouncementActionState {
  const AnnouncementActionState();
}

class AnnouncementActionInitial extends AnnouncementActionState {
  const AnnouncementActionInitial();
}

class AnnouncementActionLoading extends AnnouncementActionState {
  const AnnouncementActionLoading();
}

class AnnouncementActionSuccess extends AnnouncementActionState {
  const AnnouncementActionSuccess(this.message);
  final String message;
}

class AnnouncementActionError extends AnnouncementActionState {
  const AnnouncementActionError(this.message);
  final String message;
}

// ─── Notification Template List ──────────────────────────────
sealed class NotificationTemplateListState {
  const NotificationTemplateListState();
}

class NotificationTemplateListInitial extends NotificationTemplateListState {
  const NotificationTemplateListInitial();
}

class NotificationTemplateListLoading extends NotificationTemplateListState {
  const NotificationTemplateListLoading();
}

class NotificationTemplateListLoaded extends NotificationTemplateListState {
  const NotificationTemplateListLoaded({required this.templates, required this.total});
  final List<Map<String, dynamic>> templates;
  final int total;
}

class NotificationTemplateListError extends NotificationTemplateListState {
  const NotificationTemplateListError(this.message);
  final String message;
}

// ─── Notification Template Detail ────────────────────────────
sealed class NotificationTemplateDetailState {
  const NotificationTemplateDetailState();
}

class NotificationTemplateDetailInitial extends NotificationTemplateDetailState {
  const NotificationTemplateDetailInitial();
}

class NotificationTemplateDetailLoading extends NotificationTemplateDetailState {
  const NotificationTemplateDetailLoading();
}

class NotificationTemplateDetailLoaded extends NotificationTemplateDetailState {
  const NotificationTemplateDetailLoaded({required this.template});
  final Map<String, dynamic> template;
}

class NotificationTemplateDetailError extends NotificationTemplateDetailState {
  const NotificationTemplateDetailError(this.message);
  final String message;
}

// ─── Notification Template Action ────────────────────────────
sealed class NotificationTemplateActionState {
  const NotificationTemplateActionState();
}

class NotificationTemplateActionInitial extends NotificationTemplateActionState {
  const NotificationTemplateActionInitial();
}

class NotificationTemplateActionLoading extends NotificationTemplateActionState {
  const NotificationTemplateActionLoading();
}

class NotificationTemplateActionSuccess extends NotificationTemplateActionState {
  const NotificationTemplateActionSuccess(this.message);
  final String message;
}

class NotificationTemplateActionError extends NotificationTemplateActionState {
  const NotificationTemplateActionError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
//  P9: Platform Logs & Monitoring States
// ═══════════════════════════════════════════════════════════════

// ─── Activity Log List ───────────────────────────────────────
sealed class ActivityLogListState {
  const ActivityLogListState();
}

class ActivityLogListInitial extends ActivityLogListState {
  const ActivityLogListInitial();
}

class ActivityLogListLoading extends ActivityLogListState {
  const ActivityLogListLoading();
}

class ActivityLogListLoaded extends ActivityLogListState {
  const ActivityLogListLoaded(this.data);
  final Map<String, dynamic> data;
}

class ActivityLogListError extends ActivityLogListState {
  const ActivityLogListError(this.message);
  final String message;
}

// ─── Activity Log Detail ─────────────────────────────────────
sealed class ActivityLogDetailState {
  const ActivityLogDetailState();
}

class ActivityLogDetailInitial extends ActivityLogDetailState {
  const ActivityLogDetailInitial();
}

class ActivityLogDetailLoading extends ActivityLogDetailState {
  const ActivityLogDetailLoading();
}

class ActivityLogDetailLoaded extends ActivityLogDetailState {
  const ActivityLogDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class ActivityLogDetailError extends ActivityLogDetailState {
  const ActivityLogDetailError(this.message);
  final String message;
}

// ─── Security Alert List ─────────────────────────────────────
sealed class SecurityAlertListState {
  const SecurityAlertListState();
}

class SecurityAlertListInitial extends SecurityAlertListState {
  const SecurityAlertListInitial();
}

class SecurityAlertListLoading extends SecurityAlertListState {
  const SecurityAlertListLoading();
}

class SecurityAlertListLoaded extends SecurityAlertListState {
  const SecurityAlertListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecurityAlertListError extends SecurityAlertListState {
  const SecurityAlertListError(this.message);
  final String message;
}

// ─── Security Alert Detail ───────────────────────────────────
sealed class SecurityAlertDetailState {
  const SecurityAlertDetailState();
}

class SecurityAlertDetailInitial extends SecurityAlertDetailState {
  const SecurityAlertDetailInitial();
}

class SecurityAlertDetailLoading extends SecurityAlertDetailState {
  const SecurityAlertDetailLoading();
}

class SecurityAlertDetailLoaded extends SecurityAlertDetailState {
  const SecurityAlertDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecurityAlertDetailError extends SecurityAlertDetailState {
  const SecurityAlertDetailError(this.message);
  final String message;
}

// ─── Security Alert Action ───────────────────────────────────
sealed class SecurityAlertActionState {
  const SecurityAlertActionState();
}

class SecurityAlertActionInitial extends SecurityAlertActionState {
  const SecurityAlertActionInitial();
}

class SecurityAlertActionLoading extends SecurityAlertActionState {
  const SecurityAlertActionLoading();
}

class SecurityAlertActionSuccess extends SecurityAlertActionState {
  const SecurityAlertActionSuccess(this.message);
  final String message;
}

class SecurityAlertActionError extends SecurityAlertActionState {
  const SecurityAlertActionError(this.message);
  final String message;
}

// ─── Notification Log List ───────────────────────────────────
sealed class NotificationLogListState {
  const NotificationLogListState();
}

class NotificationLogListInitial extends NotificationLogListState {
  const NotificationLogListInitial();
}

class NotificationLogListLoading extends NotificationLogListState {
  const NotificationLogListLoading();
}

class NotificationLogListLoaded extends NotificationLogListState {
  const NotificationLogListLoaded(this.data);
  final Map<String, dynamic> data;
}

class NotificationLogListError extends NotificationLogListState {
  const NotificationLogListError(this.message);
  final String message;
}

// ─── Platform Event List ─────────────────────────────────────
sealed class PlatformEventListState {
  const PlatformEventListState();
}

class PlatformEventListInitial extends PlatformEventListState {
  const PlatformEventListInitial();
}

class PlatformEventListLoading extends PlatformEventListState {
  const PlatformEventListLoading();
}

class PlatformEventListLoaded extends PlatformEventListState {
  const PlatformEventListLoaded(this.data);
  final Map<String, dynamic> data;
}

class PlatformEventListError extends PlatformEventListState {
  const PlatformEventListError(this.message);
  final String message;
}

// ─── Platform Event Detail ───────────────────────────────────
sealed class PlatformEventDetailState {
  const PlatformEventDetailState();
}

class PlatformEventDetailInitial extends PlatformEventDetailState {
  const PlatformEventDetailInitial();
}

class PlatformEventDetailLoading extends PlatformEventDetailState {
  const PlatformEventDetailLoading();
}

class PlatformEventDetailLoaded extends PlatformEventDetailState {
  const PlatformEventDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class PlatformEventDetailError extends PlatformEventDetailState {
  const PlatformEventDetailError(this.message);
  final String message;
}

// ─── Platform Event Action ───────────────────────────────────
sealed class PlatformEventActionState {
  const PlatformEventActionState();
}

class PlatformEventActionInitial extends PlatformEventActionState {
  const PlatformEventActionInitial();
}

class PlatformEventActionLoading extends PlatformEventActionState {
  const PlatformEventActionLoading();
}

class PlatformEventActionSuccess extends PlatformEventActionState {
  const PlatformEventActionSuccess(this.message);
  final String message;
}

class PlatformEventActionError extends PlatformEventActionState {
  const PlatformEventActionError(this.message);
  final String message;
}

// ─── Health Dashboard ────────────────────────────────────────
sealed class HealthDashboardState {
  const HealthDashboardState();
}

class HealthDashboardInitial extends HealthDashboardState {
  const HealthDashboardInitial();
}

class HealthDashboardLoading extends HealthDashboardState {
  const HealthDashboardLoading();
}

class HealthDashboardLoaded extends HealthDashboardState {
  const HealthDashboardLoaded(this.data);
  final Map<String, dynamic> data;
}

class HealthDashboardError extends HealthDashboardState {
  const HealthDashboardError(this.message);
  final String message;
}

// ─── Health Check List ───────────────────────────────────────
sealed class HealthCheckListState {
  const HealthCheckListState();
}

class HealthCheckListInitial extends HealthCheckListState {
  const HealthCheckListInitial();
}

class HealthCheckListLoading extends HealthCheckListState {
  const HealthCheckListLoading();
}

class HealthCheckListLoaded extends HealthCheckListState {
  const HealthCheckListLoaded(this.data);
  final Map<String, dynamic> data;
}

class HealthCheckListError extends HealthCheckListState {
  const HealthCheckListError(this.message);
  final String message;
}

// ─── Store Health List ───────────────────────────────────────
sealed class StoreHealthListState {
  const StoreHealthListState();
}

class StoreHealthListInitial extends StoreHealthListState {
  const StoreHealthListInitial();
}

class StoreHealthListLoading extends StoreHealthListState {
  const StoreHealthListLoading();
}

class StoreHealthListLoaded extends StoreHealthListState {
  const StoreHealthListLoaded(this.data);
  final Map<String, dynamic> data;
}

class StoreHealthListError extends StoreHealthListState {
  const StoreHealthListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
//  P10: SUPPORT TICKET SYSTEM
// ═══════════════════════════════════════════════════════════════

// ─── Ticket List ─────────────────────────────────────────────
sealed class TicketListState {
  const TicketListState();
}

class TicketListInitial extends TicketListState {
  const TicketListInitial();
}

class TicketListLoading extends TicketListState {
  const TicketListLoading();
}

class TicketListLoaded extends TicketListState {
  const TicketListLoaded(this.data);
  final Map<String, dynamic> data;
}

class TicketListError extends TicketListState {
  const TicketListError(this.message);
  final String message;
}

// ─── Ticket Detail ───────────────────────────────────────────
sealed class TicketDetailState {
  const TicketDetailState();
}

class TicketDetailInitial extends TicketDetailState {
  const TicketDetailInitial();
}

class TicketDetailLoading extends TicketDetailState {
  const TicketDetailLoading();
}

class TicketDetailLoaded extends TicketDetailState {
  const TicketDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class TicketDetailError extends TicketDetailState {
  const TicketDetailError(this.message);
  final String message;
}

// ─── Ticket Action ───────────────────────────────────────────
sealed class TicketActionState {
  const TicketActionState();
}

class TicketActionInitial extends TicketActionState {
  const TicketActionInitial();
}

class TicketActionLoading extends TicketActionState {
  const TicketActionLoading();
}

class TicketActionSuccess extends TicketActionState {
  const TicketActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class TicketActionError extends TicketActionState {
  const TicketActionError(this.message);
  final String message;
}

// ─── Ticket Message List ─────────────────────────────────────
sealed class TicketMessageListState {
  const TicketMessageListState();
}

class TicketMessageListInitial extends TicketMessageListState {
  const TicketMessageListInitial();
}

class TicketMessageListLoading extends TicketMessageListState {
  const TicketMessageListLoading();
}

class TicketMessageListLoaded extends TicketMessageListState {
  const TicketMessageListLoaded(this.data);
  final Map<String, dynamic> data;
}

class TicketMessageListError extends TicketMessageListState {
  const TicketMessageListError(this.message);
  final String message;
}

// ─── Ticket Message Action ───────────────────────────────────
sealed class TicketMessageActionState {
  const TicketMessageActionState();
}

class TicketMessageActionInitial extends TicketMessageActionState {
  const TicketMessageActionInitial();
}

class TicketMessageActionLoading extends TicketMessageActionState {
  const TicketMessageActionLoading();
}

class TicketMessageActionSuccess extends TicketMessageActionState {
  const TicketMessageActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class TicketMessageActionError extends TicketMessageActionState {
  const TicketMessageActionError(this.message);
  final String message;
}

// ─── Canned Response List ────────────────────────────────────
sealed class CannedResponseListState {
  const CannedResponseListState();
}

class CannedResponseListInitial extends CannedResponseListState {
  const CannedResponseListInitial();
}

class CannedResponseListLoading extends CannedResponseListState {
  const CannedResponseListLoading();
}

class CannedResponseListLoaded extends CannedResponseListState {
  const CannedResponseListLoaded(this.data);
  final Map<String, dynamic> data;
}

class CannedResponseListError extends CannedResponseListState {
  const CannedResponseListError(this.message);
  final String message;
}

// ─── Canned Response Detail ──────────────────────────────────
sealed class CannedResponseDetailState {
  const CannedResponseDetailState();
}

class CannedResponseDetailInitial extends CannedResponseDetailState {
  const CannedResponseDetailInitial();
}

class CannedResponseDetailLoading extends CannedResponseDetailState {
  const CannedResponseDetailLoading();
}

class CannedResponseDetailLoaded extends CannedResponseDetailState {
  const CannedResponseDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class CannedResponseDetailError extends CannedResponseDetailState {
  const CannedResponseDetailError(this.message);
  final String message;
}

// ─── Canned Response Action ──────────────────────────────────
sealed class CannedResponseActionState {
  const CannedResponseActionState();
}

class CannedResponseActionInitial extends CannedResponseActionState {
  const CannedResponseActionInitial();
}

class CannedResponseActionLoading extends CannedResponseActionState {
  const CannedResponseActionLoading();
}

class CannedResponseActionSuccess extends CannedResponseActionState {
  const CannedResponseActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class CannedResponseActionError extends CannedResponseActionState {
  const CannedResponseActionError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════════
//  P11: MARKETPLACE MANAGEMENT
// ═══════════════════════════════════════════════════════════════════

// ─── Marketplace Store List ─────────────────────────────────────
sealed class MarketplaceStoreListState {
  const MarketplaceStoreListState();
}

class MarketplaceStoreListInitial extends MarketplaceStoreListState {
  const MarketplaceStoreListInitial();
}

class MarketplaceStoreListLoading extends MarketplaceStoreListState {
  const MarketplaceStoreListLoading();
}

class MarketplaceStoreListLoaded extends MarketplaceStoreListState {
  const MarketplaceStoreListLoaded(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceStoreListError extends MarketplaceStoreListState {
  const MarketplaceStoreListError(this.message);
  final String message;
}

// ─── Marketplace Store Detail ───────────────────────────────────
sealed class MarketplaceStoreDetailState {
  const MarketplaceStoreDetailState();
}

class MarketplaceStoreDetailInitial extends MarketplaceStoreDetailState {
  const MarketplaceStoreDetailInitial();
}

class MarketplaceStoreDetailLoading extends MarketplaceStoreDetailState {
  const MarketplaceStoreDetailLoading();
}

class MarketplaceStoreDetailLoaded extends MarketplaceStoreDetailState {
  const MarketplaceStoreDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceStoreDetailError extends MarketplaceStoreDetailState {
  const MarketplaceStoreDetailError(this.message);
  final String message;
}

// ─── Marketplace Store Action ───────────────────────────────────
sealed class MarketplaceStoreActionState {
  const MarketplaceStoreActionState();
}

class MarketplaceStoreActionInitial extends MarketplaceStoreActionState {
  const MarketplaceStoreActionInitial();
}

class MarketplaceStoreActionLoading extends MarketplaceStoreActionState {
  const MarketplaceStoreActionLoading();
}

class MarketplaceStoreActionSuccess extends MarketplaceStoreActionState {
  const MarketplaceStoreActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceStoreActionError extends MarketplaceStoreActionState {
  const MarketplaceStoreActionError(this.message);
  final String message;
}

// ─── Marketplace Product List ───────────────────────────────────
sealed class MarketplaceProductListState {
  const MarketplaceProductListState();
}

class MarketplaceProductListInitial extends MarketplaceProductListState {
  const MarketplaceProductListInitial();
}

class MarketplaceProductListLoading extends MarketplaceProductListState {
  const MarketplaceProductListLoading();
}

class MarketplaceProductListLoaded extends MarketplaceProductListState {
  const MarketplaceProductListLoaded(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceProductListError extends MarketplaceProductListState {
  const MarketplaceProductListError(this.message);
  final String message;
}

// ─── Marketplace Product Action ─────────────────────────────────
sealed class MarketplaceProductActionState {
  const MarketplaceProductActionState();
}

class MarketplaceProductActionInitial extends MarketplaceProductActionState {
  const MarketplaceProductActionInitial();
}

class MarketplaceProductActionLoading extends MarketplaceProductActionState {
  const MarketplaceProductActionLoading();
}

class MarketplaceProductActionSuccess extends MarketplaceProductActionState {
  const MarketplaceProductActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceProductActionError extends MarketplaceProductActionState {
  const MarketplaceProductActionError(this.message);
  final String message;
}

// ─── Marketplace Order List ─────────────────────────────────────
sealed class MarketplaceOrderListState {
  const MarketplaceOrderListState();
}

class MarketplaceOrderListInitial extends MarketplaceOrderListState {
  const MarketplaceOrderListInitial();
}

class MarketplaceOrderListLoading extends MarketplaceOrderListState {
  const MarketplaceOrderListLoading();
}

class MarketplaceOrderListLoaded extends MarketplaceOrderListState {
  const MarketplaceOrderListLoaded(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceOrderListError extends MarketplaceOrderListState {
  const MarketplaceOrderListError(this.message);
  final String message;
}

// ─── Marketplace Order Detail ───────────────────────────────────
sealed class MarketplaceOrderDetailState {
  const MarketplaceOrderDetailState();
}

class MarketplaceOrderDetailInitial extends MarketplaceOrderDetailState {
  const MarketplaceOrderDetailInitial();
}

class MarketplaceOrderDetailLoading extends MarketplaceOrderDetailState {
  const MarketplaceOrderDetailLoading();
}

class MarketplaceOrderDetailLoaded extends MarketplaceOrderDetailState {
  const MarketplaceOrderDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceOrderDetailError extends MarketplaceOrderDetailState {
  const MarketplaceOrderDetailError(this.message);
  final String message;
}

// ─── Marketplace Settlement List ────────────────────────────────
sealed class MarketplaceSettlementListState {
  const MarketplaceSettlementListState();
}

class MarketplaceSettlementListInitial extends MarketplaceSettlementListState {
  const MarketplaceSettlementListInitial();
}

class MarketplaceSettlementListLoading extends MarketplaceSettlementListState {
  const MarketplaceSettlementListLoading();
}

class MarketplaceSettlementListLoaded extends MarketplaceSettlementListState {
  const MarketplaceSettlementListLoaded(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceSettlementListError extends MarketplaceSettlementListState {
  const MarketplaceSettlementListError(this.message);
  final String message;
}

// ─── Marketplace Settlement Summary ─────────────────────────────
sealed class MarketplaceSettlementSummaryState {
  const MarketplaceSettlementSummaryState();
}

class MarketplaceSettlementSummaryInitial extends MarketplaceSettlementSummaryState {
  const MarketplaceSettlementSummaryInitial();
}

class MarketplaceSettlementSummaryLoading extends MarketplaceSettlementSummaryState {
  const MarketplaceSettlementSummaryLoading();
}

class MarketplaceSettlementSummaryLoaded extends MarketplaceSettlementSummaryState {
  const MarketplaceSettlementSummaryLoaded(this.data);
  final Map<String, dynamic> data;
}

class MarketplaceSettlementSummaryError extends MarketplaceSettlementSummaryState {
  const MarketplaceSettlementSummaryError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════════════════
// P12  Deployment & Release Management
// ═══════════════════════════════════════════════════════════════════════════

// --- Deployment Overview ---
sealed class DeploymentOverviewState {
  const DeploymentOverviewState();
}

class DeploymentOverviewInitial extends DeploymentOverviewState {
  const DeploymentOverviewInitial();
}

class DeploymentOverviewLoading extends DeploymentOverviewState {
  const DeploymentOverviewLoading();
}

class DeploymentOverviewLoaded extends DeploymentOverviewState {
  const DeploymentOverviewLoaded(this.data);
  final Map<String, dynamic> data;
}

class DeploymentOverviewError extends DeploymentOverviewState {
  const DeploymentOverviewError(this.message);
  final String message;
}

// --- Deployment Release List ---
sealed class DeploymentReleaseListState {
  const DeploymentReleaseListState();
}

class DeploymentReleaseListInitial extends DeploymentReleaseListState {
  const DeploymentReleaseListInitial();
}

class DeploymentReleaseListLoading extends DeploymentReleaseListState {
  const DeploymentReleaseListLoading();
}

class DeploymentReleaseListLoaded extends DeploymentReleaseListState {
  const DeploymentReleaseListLoaded(this.data);
  final Map<String, dynamic> data;
}

class DeploymentReleaseListError extends DeploymentReleaseListState {
  const DeploymentReleaseListError(this.message);
  final String message;
}

// --- Deployment Release Detail ---
sealed class DeploymentReleaseDetailState {
  const DeploymentReleaseDetailState();
}

class DeploymentReleaseDetailInitial extends DeploymentReleaseDetailState {
  const DeploymentReleaseDetailInitial();
}

class DeploymentReleaseDetailLoading extends DeploymentReleaseDetailState {
  const DeploymentReleaseDetailLoading();
}

class DeploymentReleaseDetailLoaded extends DeploymentReleaseDetailState {
  const DeploymentReleaseDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class DeploymentReleaseDetailError extends DeploymentReleaseDetailState {
  const DeploymentReleaseDetailError(this.message);
  final String message;
}

// --- Deployment Release Action ---
sealed class DeploymentReleaseActionState {
  const DeploymentReleaseActionState();
}

class DeploymentReleaseActionInitial extends DeploymentReleaseActionState {
  const DeploymentReleaseActionInitial();
}

class DeploymentReleaseActionLoading extends DeploymentReleaseActionState {
  const DeploymentReleaseActionLoading();
}

class DeploymentReleaseActionSuccess extends DeploymentReleaseActionState {
  const DeploymentReleaseActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class DeploymentReleaseActionError extends DeploymentReleaseActionState {
  const DeploymentReleaseActionError(this.message);
  final String message;
}

// --- Deployment Stats List ---
sealed class DeploymentStatsListState {
  const DeploymentStatsListState();
}

class DeploymentStatsListInitial extends DeploymentStatsListState {
  const DeploymentStatsListInitial();
}

class DeploymentStatsListLoading extends DeploymentStatsListState {
  const DeploymentStatsListLoading();
}

class DeploymentStatsListLoaded extends DeploymentStatsListState {
  const DeploymentStatsListLoaded(this.data);
  final Map<String, dynamic> data;
}

class DeploymentStatsListError extends DeploymentStatsListState {
  const DeploymentStatsListError(this.message);
  final String message;
}

// --- Deployment Release Summary ---
sealed class DeploymentReleaseSummaryState {
  const DeploymentReleaseSummaryState();
}

class DeploymentReleaseSummaryInitial extends DeploymentReleaseSummaryState {
  const DeploymentReleaseSummaryInitial();
}

class DeploymentReleaseSummaryLoading extends DeploymentReleaseSummaryState {
  const DeploymentReleaseSummaryLoading();
}

class DeploymentReleaseSummaryLoaded extends DeploymentReleaseSummaryState {
  const DeploymentReleaseSummaryLoaded(this.data);
  final Map<String, dynamic> data;
}

class DeploymentReleaseSummaryError extends DeploymentReleaseSummaryState {
  const DeploymentReleaseSummaryError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════════════════
// P13  Data Management & Migration
// ═══════════════════════════════════════════════════════════════════════════

sealed class DataManagementOverviewState {
  const DataManagementOverviewState();
}

class DataManagementOverviewInitial extends DataManagementOverviewState {
  const DataManagementOverviewInitial();
}

class DataManagementOverviewLoading extends DataManagementOverviewState {
  const DataManagementOverviewLoading();
}

class DataManagementOverviewLoaded extends DataManagementOverviewState {
  const DataManagementOverviewLoaded(this.data);
  final Map<String, dynamic> data;
}

class DataManagementOverviewError extends DataManagementOverviewState {
  const DataManagementOverviewError(this.message);
  final String message;
}

sealed class DatabaseBackupListState {
  const DatabaseBackupListState();
}

class DatabaseBackupListInitial extends DatabaseBackupListState {
  const DatabaseBackupListInitial();
}

class DatabaseBackupListLoading extends DatabaseBackupListState {
  const DatabaseBackupListLoading();
}

class DatabaseBackupListLoaded extends DatabaseBackupListState {
  const DatabaseBackupListLoaded(this.data);
  final Map<String, dynamic> data;
}

class DatabaseBackupListError extends DatabaseBackupListState {
  const DatabaseBackupListError(this.message);
  final String message;
}

sealed class DatabaseBackupActionState {
  const DatabaseBackupActionState();
}

class DatabaseBackupActionInitial extends DatabaseBackupActionState {
  const DatabaseBackupActionInitial();
}

class DatabaseBackupActionLoading extends DatabaseBackupActionState {
  const DatabaseBackupActionLoading();
}

class DatabaseBackupActionSuccess extends DatabaseBackupActionState {
  const DatabaseBackupActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class DatabaseBackupActionError extends DatabaseBackupActionState {
  const DatabaseBackupActionError(this.message);
  final String message;
}

sealed class BackupHistoryListState {
  const BackupHistoryListState();
}

class BackupHistoryListInitial extends BackupHistoryListState {
  const BackupHistoryListInitial();
}

class BackupHistoryListLoading extends BackupHistoryListState {
  const BackupHistoryListLoading();
}

class BackupHistoryListLoaded extends BackupHistoryListState {
  const BackupHistoryListLoaded(this.data);
  final Map<String, dynamic> data;
}

class BackupHistoryListError extends BackupHistoryListState {
  const BackupHistoryListError(this.message);
  final String message;
}

sealed class SyncLogListState {
  const SyncLogListState();
}

class SyncLogListInitial extends SyncLogListState {
  const SyncLogListInitial();
}

class SyncLogListLoading extends SyncLogListState {
  const SyncLogListLoading();
}

class SyncLogListLoaded extends SyncLogListState {
  const SyncLogListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SyncLogListError extends SyncLogListState {
  const SyncLogListError(this.message);
  final String message;
}

sealed class SyncLogSummaryState {
  const SyncLogSummaryState();
}

class SyncLogSummaryInitial extends SyncLogSummaryState {
  const SyncLogSummaryInitial();
}

class SyncLogSummaryLoading extends SyncLogSummaryState {
  const SyncLogSummaryLoading();
}

class SyncLogSummaryLoaded extends SyncLogSummaryState {
  const SyncLogSummaryLoaded(this.data);
  final Map<String, dynamic> data;
}

class SyncLogSummaryError extends SyncLogSummaryState {
  const SyncLogSummaryError(this.message);
  final String message;
}

sealed class SyncConflictListState {
  const SyncConflictListState();
}

class SyncConflictListInitial extends SyncConflictListState {
  const SyncConflictListInitial();
}

class SyncConflictListLoading extends SyncConflictListState {
  const SyncConflictListLoading();
}

class SyncConflictListLoaded extends SyncConflictListState {
  const SyncConflictListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SyncConflictListError extends SyncConflictListState {
  const SyncConflictListError(this.message);
  final String message;
}

sealed class SyncConflictActionState {
  const SyncConflictActionState();
}

class SyncConflictActionInitial extends SyncConflictActionState {
  const SyncConflictActionInitial();
}

class SyncConflictActionLoading extends SyncConflictActionState {
  const SyncConflictActionLoading();
}

class SyncConflictActionSuccess extends SyncConflictActionState {
  const SyncConflictActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class SyncConflictActionError extends SyncConflictActionState {
  const SyncConflictActionError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════════════════════
// P14  Security Center
// ═══════════════════════════════════════════════════════════════════════════════

sealed class SecurityOverviewState {
  const SecurityOverviewState();
}

class SecurityOverviewInitial extends SecurityOverviewState {
  const SecurityOverviewInitial();
}

class SecurityOverviewLoading extends SecurityOverviewState {
  const SecurityOverviewLoading();
}

class SecurityOverviewLoaded extends SecurityOverviewState {
  const SecurityOverviewLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecurityOverviewError extends SecurityOverviewState {
  const SecurityOverviewError(this.message);
  final String message;
}

sealed class SecCenterAlertListState {
  const SecCenterAlertListState();
}

class SecCenterAlertListInitial extends SecCenterAlertListState {
  const SecCenterAlertListInitial();
}

class SecCenterAlertListLoading extends SecCenterAlertListState {
  const SecCenterAlertListLoading();
}

class SecCenterAlertListLoaded extends SecCenterAlertListState {
  const SecCenterAlertListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecCenterAlertListError extends SecCenterAlertListState {
  const SecCenterAlertListError(this.message);
  final String message;
}

sealed class SecCenterAlertActionState {
  const SecCenterAlertActionState();
}

class SecCenterAlertActionInitial extends SecCenterAlertActionState {
  const SecCenterAlertActionInitial();
}

class SecCenterAlertActionLoading extends SecCenterAlertActionState {
  const SecCenterAlertActionLoading();
}

class SecCenterAlertActionSuccess extends SecCenterAlertActionState {
  const SecCenterAlertActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class SecCenterAlertActionError extends SecCenterAlertActionState {
  const SecCenterAlertActionError(this.message);
  final String message;
}

sealed class SecuritySessionListState {
  const SecuritySessionListState();
}

class SecuritySessionListInitial extends SecuritySessionListState {
  const SecuritySessionListInitial();
}

class SecuritySessionListLoading extends SecuritySessionListState {
  const SecuritySessionListLoading();
}

class SecuritySessionListLoaded extends SecuritySessionListState {
  const SecuritySessionListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecuritySessionListError extends SecuritySessionListState {
  const SecuritySessionListError(this.message);
  final String message;
}

sealed class SecurityDeviceListState {
  const SecurityDeviceListState();
}

class SecurityDeviceListInitial extends SecurityDeviceListState {
  const SecurityDeviceListInitial();
}

class SecurityDeviceListLoading extends SecurityDeviceListState {
  const SecurityDeviceListLoading();
}

class SecurityDeviceListLoaded extends SecurityDeviceListState {
  const SecurityDeviceListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecurityDeviceListError extends SecurityDeviceListState {
  const SecurityDeviceListError(this.message);
  final String message;
}

sealed class SecurityPolicyListState {
  const SecurityPolicyListState();
}

class SecurityPolicyListInitial extends SecurityPolicyListState {
  const SecurityPolicyListInitial();
}

class SecurityPolicyListLoading extends SecurityPolicyListState {
  const SecurityPolicyListLoading();
}

class SecurityPolicyListLoaded extends SecurityPolicyListState {
  const SecurityPolicyListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecurityPolicyListError extends SecurityPolicyListState {
  const SecurityPolicyListError(this.message);
  final String message;
}

sealed class SecurityPolicyActionState {
  const SecurityPolicyActionState();
}

class SecurityPolicyActionInitial extends SecurityPolicyActionState {
  const SecurityPolicyActionInitial();
}

class SecurityPolicyActionLoading extends SecurityPolicyActionState {
  const SecurityPolicyActionLoading();
}

class SecurityPolicyActionSuccess extends SecurityPolicyActionState {
  const SecurityPolicyActionSuccess(this.data);
  final Map<String, dynamic> data;
}

class SecurityPolicyActionError extends SecurityPolicyActionState {
  const SecurityPolicyActionError(this.message);
  final String message;
}

sealed class SecurityIpListState {
  const SecurityIpListState();
}

class SecurityIpListInitial extends SecurityIpListState {
  const SecurityIpListInitial();
}

class SecurityIpListLoading extends SecurityIpListState {
  const SecurityIpListLoading();
}

class SecurityIpListLoaded extends SecurityIpListState {
  const SecurityIpListLoaded(this.data);
  final Map<String, dynamic> data;
}

class SecurityIpListError extends SecurityIpListState {
  const SecurityIpListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P15: Financial Operations
// ═══════════════════════════════════════════════════════════════

sealed class FinOpsOverviewState {
  const FinOpsOverviewState();
}

class FinOpsOverviewInitial extends FinOpsOverviewState {
  const FinOpsOverviewInitial();
}

class FinOpsOverviewLoading extends FinOpsOverviewState {
  const FinOpsOverviewLoading();
}

class FinOpsOverviewLoaded extends FinOpsOverviewState {
  const FinOpsOverviewLoaded(this.data);
  final Map<String, dynamic> data;
}

class FinOpsOverviewError extends FinOpsOverviewState {
  const FinOpsOverviewError(this.message);
  final String message;
}

sealed class FinOpsListState {
  const FinOpsListState();
}

class FinOpsListInitial extends FinOpsListState {
  const FinOpsListInitial();
}

class FinOpsListLoading extends FinOpsListState {
  const FinOpsListLoading();
}

class FinOpsListLoaded extends FinOpsListState {
  const FinOpsListLoaded(this.data);
  final Map<String, dynamic> data;
}

class FinOpsListError extends FinOpsListState {
  const FinOpsListError(this.message);
  final String message;
}

sealed class FinOpsDetailState {
  const FinOpsDetailState();
}

class FinOpsDetailInitial extends FinOpsDetailState {
  const FinOpsDetailInitial();
}

class FinOpsDetailLoading extends FinOpsDetailState {
  const FinOpsDetailLoading();
}

class FinOpsDetailLoaded extends FinOpsDetailState {
  const FinOpsDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class FinOpsDetailError extends FinOpsDetailState {
  const FinOpsDetailError(this.message);
  final String message;
}

sealed class FinOpsActionState {
  const FinOpsActionState();
}

class FinOpsActionInitial extends FinOpsActionState {
  const FinOpsActionInitial();
}

class FinOpsActionLoading extends FinOpsActionState {
  const FinOpsActionLoading();
}

class FinOpsActionSuccess extends FinOpsActionState {
  const FinOpsActionSuccess([this.data]);
  final Map<String, dynamic>? data;
}

class FinOpsActionError extends FinOpsActionState {
  const FinOpsActionError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P16: Infrastructure & Operations
// ═══════════════════════════════════════════════════════════════

sealed class InfraOverviewState {
  const InfraOverviewState();
}

class InfraOverviewInitial extends InfraOverviewState {
  const InfraOverviewInitial();
}

class InfraOverviewLoading extends InfraOverviewState {
  const InfraOverviewLoading();
}

class InfraOverviewLoaded extends InfraOverviewState {
  const InfraOverviewLoaded(this.data);
  final Map<String, dynamic> data;
}

class InfraOverviewError extends InfraOverviewState {
  const InfraOverviewError(this.message);
  final String message;
}

sealed class InfraListState {
  const InfraListState();
}

class InfraListInitial extends InfraListState {
  const InfraListInitial();
}

class InfraListLoading extends InfraListState {
  const InfraListLoading();
}

class InfraListLoaded extends InfraListState {
  const InfraListLoaded(this.data);
  final Map<String, dynamic> data;
}

class InfraListError extends InfraListState {
  const InfraListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P17: Provider Roles & Permissions
// ═══════════════════════════════════════════════════════════════

sealed class ProviderRoleTemplateListState {
  const ProviderRoleTemplateListState();
}

class ProviderRoleTemplateListInitial extends ProviderRoleTemplateListState {
  const ProviderRoleTemplateListInitial();
}

class ProviderRoleTemplateListLoading extends ProviderRoleTemplateListState {
  const ProviderRoleTemplateListLoading();
}

class ProviderRoleTemplateListLoaded extends ProviderRoleTemplateListState {
  const ProviderRoleTemplateListLoaded(this.data);
  final Map<String, dynamic> data;
}

class ProviderRoleTemplateListError extends ProviderRoleTemplateListState {
  const ProviderRoleTemplateListError(this.message);
  final String message;
}

sealed class ProviderRoleTemplateDetailState {
  const ProviderRoleTemplateDetailState();
}

class ProviderRoleTemplateDetailInitial extends ProviderRoleTemplateDetailState {
  const ProviderRoleTemplateDetailInitial();
}

class ProviderRoleTemplateDetailLoading extends ProviderRoleTemplateDetailState {
  const ProviderRoleTemplateDetailLoading();
}

class ProviderRoleTemplateDetailLoaded extends ProviderRoleTemplateDetailState {
  const ProviderRoleTemplateDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class ProviderRoleTemplateDetailError extends ProviderRoleTemplateDetailState {
  const ProviderRoleTemplateDetailError(this.message);
  final String message;
}

sealed class ProviderPermissionListState {
  const ProviderPermissionListState();
}

class ProviderPermissionListInitial extends ProviderPermissionListState {
  const ProviderPermissionListInitial();
}

class ProviderPermissionListLoading extends ProviderPermissionListState {
  const ProviderPermissionListLoading();
}

class ProviderPermissionListLoaded extends ProviderPermissionListState {
  const ProviderPermissionListLoaded(this.data);
  final Map<String, dynamic> data;
}

class ProviderPermissionListError extends ProviderPermissionListState {
  const ProviderPermissionListError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// P18: Wameed AI Admin
// ═══════════════════════════════════════════════════════════════

sealed class WameedAIAdminDashboardState {
  const WameedAIAdminDashboardState();
}

class WameedAIAdminDashboardInitial extends WameedAIAdminDashboardState {
  const WameedAIAdminDashboardInitial();
}

class WameedAIAdminDashboardLoading extends WameedAIAdminDashboardState {
  const WameedAIAdminDashboardLoading();
}

class WameedAIAdminDashboardLoaded extends WameedAIAdminDashboardState {
  const WameedAIAdminDashboardLoaded(this.data);
  final Map<String, dynamic> data;
}

class WameedAIAdminDashboardError extends WameedAIAdminDashboardState {
  const WameedAIAdminDashboardError(this.message);
  final String message;
}

sealed class WameedAIAdminListState {
  const WameedAIAdminListState();
}

class WameedAIAdminListInitial extends WameedAIAdminListState {
  const WameedAIAdminListInitial();
}

class WameedAIAdminListLoading extends WameedAIAdminListState {
  const WameedAIAdminListLoading();
}

class WameedAIAdminListLoaded extends WameedAIAdminListState {
  const WameedAIAdminListLoaded(this.data);
  final Map<String, dynamic> data;
}

class WameedAIAdminListError extends WameedAIAdminListState {
  const WameedAIAdminListError(this.message);
  final String message;
}

sealed class WameedAIAdminDetailState {
  const WameedAIAdminDetailState();
}

class WameedAIAdminDetailInitial extends WameedAIAdminDetailState {
  const WameedAIAdminDetailInitial();
}

class WameedAIAdminDetailLoading extends WameedAIAdminDetailState {
  const WameedAIAdminDetailLoading();
}

class WameedAIAdminDetailLoaded extends WameedAIAdminDetailState {
  const WameedAIAdminDetailLoaded(this.data);
  final Map<String, dynamic> data;
}

class WameedAIAdminDetailError extends WameedAIAdminDetailState {
  const WameedAIAdminDetailError(this.message);
  final String message;
}

sealed class WameedAIAdminActionState {
  const WameedAIAdminActionState();
}

class WameedAIAdminActionInitial extends WameedAIAdminActionState {
  const WameedAIAdminActionInitial();
}

class WameedAIAdminActionLoading extends WameedAIAdminActionState {
  const WameedAIAdminActionLoading();
}

class WameedAIAdminActionSuccess extends WameedAIAdminActionState {
  const WameedAIAdminActionSuccess([this.data]);
  final Map<String, dynamic>? data;
}

class WameedAIAdminActionError extends WameedAIAdminActionState {
  const WameedAIAdminActionError(this.message);
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// Generic Admin Stats State (used for user/log/flag/support stats)
// ═══════════════════════════════════════════════════════════════

sealed class AdminStatsState {
  const AdminStatsState();
}

class AdminStatsInitial extends AdminStatsState {
  const AdminStatsInitial();
}

class AdminStatsLoading extends AdminStatsState {
  const AdminStatsLoading();
}

class AdminStatsLoaded extends AdminStatsState {
  const AdminStatsLoaded(this.data);
  final Map<String, dynamic> data;
}

class AdminStatsError extends AdminStatsState {
  const AdminStatsError(this.message);
  final String message;
}
