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
  final List<Map<String, dynamic>> stores;
  final int total;
  final int currentPage;
  final int lastPage;

  const AdminStoreListLoaded({required this.stores, required this.total, required this.currentPage, required this.lastPage});
}

class AdminStoreListError extends AdminStoreListState {
  final String message;
  const AdminStoreListError(this.message);
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
  final Map<String, dynamic> store;

  const AdminStoreDetailLoaded(this.store);
}

class AdminStoreDetailError extends AdminStoreDetailState {
  final String message;
  const AdminStoreDetailError(this.message);
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
  final String message;
  final Map<String, dynamic>? data;
  const AdminActionSuccess(this.message, {this.data});
}

class AdminActionError extends AdminActionState {
  final String message;
  const AdminActionError(this.message);
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
  final List<Map<String, dynamic>> registrations;
  final int total;
  final int currentPage;
  final int lastPage;

  const RegistrationListLoaded({
    required this.registrations,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
}

class RegistrationListError extends RegistrationListState {
  final String message;
  const RegistrationListError(this.message);
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
  final List<Map<String, dynamic>> overrides;

  const LimitOverrideListLoaded(this.overrides);
}

class LimitOverrideListError extends LimitOverrideListState {
  final String message;
  const LimitOverrideListError(this.message);
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
  final List<Map<String, dynamic>> notes;

  const ProviderNotesLoaded(this.notes);
}

class ProviderNotesError extends ProviderNotesState {
  final String message;
  const ProviderNotesError(this.message);
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
  final List<Map<String, dynamic>> roles;

  const AdminRoleListLoaded(this.roles);
}

class AdminRoleListError extends AdminRoleListState {
  final String message;
  const AdminRoleListError(this.message);
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
  final Map<String, dynamic> role;

  const AdminRoleDetailLoaded(this.role);
}

class AdminRoleDetailError extends AdminRoleDetailState {
  final String message;
  const AdminRoleDetailError(this.message);
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
  final Map<String, List<Map<String, dynamic>>> groupedPermissions;

  const PermissionListLoaded(this.groupedPermissions);
}

class PermissionListError extends PermissionListState {
  final String message;
  const PermissionListError(this.message);
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
  final List<Map<String, dynamic>> users;
  final int total;
  final int currentPage;
  final int lastPage;

  const AdminTeamListLoaded({required this.users, required this.total, required this.currentPage, required this.lastPage});
}

class AdminTeamListError extends AdminTeamListState {
  final String message;
  const AdminTeamListError(this.message);
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
  final Map<String, dynamic> user;

  const AdminTeamUserDetailLoaded(this.user);
}

class AdminTeamUserDetailError extends AdminTeamUserDetailState {
  final String message;
  const AdminTeamUserDetailError(this.message);
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
  final Map<String, dynamic> profile;

  const AdminProfileLoaded(this.profile);
}

class AdminProfileError extends AdminProfileState {
  final String message;
  const AdminProfileError(this.message);
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
  final List<Map<String, dynamic>> logs;
  final int total;
  final int currentPage;
  final int lastPage;

  const ActivityLogLoaded({required this.logs, required this.total, required this.currentPage, required this.lastPage});
}

class ActivityLogError extends ActivityLogState {
  final String message;
  const ActivityLogError(this.message);
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
  final List<Map<String, dynamic>> plans;
  const PlanListLoaded(this.plans);
}

class PlanListError extends PlanListState {
  final String message;
  const PlanListError(this.message);
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
  final Map<String, dynamic> plan;
  const PlanDetailLoaded(this.plan);
}

class PlanDetailError extends PlanDetailState {
  final String message;
  const PlanDetailError(this.message);
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
  final List<Map<String, dynamic>> addOns;
  const AddOnListLoaded(this.addOns);
}

class AddOnListError extends AddOnListState {
  final String message;
  const AddOnListError(this.message);
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
  final List<Map<String, dynamic>> discounts;
  final int total;
  final int currentPage;
  final int lastPage;

  const DiscountListLoaded({required this.discounts, required this.total, required this.currentPage, required this.lastPage});
}

class DiscountListError extends DiscountListState {
  final String message;
  const DiscountListError(this.message);
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
  final List<Map<String, dynamic>> subscriptions;
  final int total;
  final int currentPage;
  final int lastPage;

  const SubscriptionListLoaded({
    required this.subscriptions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
}

class SubscriptionListError extends SubscriptionListState {
  final String message;
  const SubscriptionListError(this.message);
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
  final List<Map<String, dynamic>> invoices;
  final int total;
  final int currentPage;
  final int lastPage;

  const InvoiceListLoaded({required this.invoices, required this.total, required this.currentPage, required this.lastPage});
}

class InvoiceListError extends InvoiceListState {
  final String message;
  const InvoiceListError(this.message);
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
  final List<Map<String, dynamic>> users;
  final int total;
  final int currentPage;
  final int lastPage;

  const ProviderUserListLoaded({required this.users, required this.total, required this.currentPage, required this.lastPage});
}

class ProviderUserListError extends ProviderUserListState {
  final String message;
  const ProviderUserListError(this.message);
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
  final Map<String, dynamic> user;
  const ProviderUserDetailLoaded(this.user);
}

class ProviderUserDetailError extends ProviderUserDetailState {
  final String message;
  const ProviderUserDetailError(this.message);
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
  final List<Map<String, dynamic>> admins;
  const AdminUserListLoaded(this.admins);
}

class AdminUserListError extends AdminUserListState {
  final String message;
  const AdminUserListError(this.message);
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
  final Map<String, dynamic> admin;
  const AdminUserDetailLoaded(this.admin);
}

class AdminUserDetailError extends AdminUserDetailState {
  final String message;
  const AdminUserDetailError(this.message);
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
  final List<Map<String, dynamic>> logs;
  const UserActivityLoaded(this.logs);
}

class UserActivityError extends UserActivityState {
  final String message;
  const UserActivityError(this.message);
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
  final List<Map<String, dynamic>> invoices;
  final Map<String, dynamic> pagination;
  const BillingInvoiceListLoaded(this.invoices, this.pagination);
}

class BillingInvoiceListError extends BillingInvoiceListState {
  final String message;
  const BillingInvoiceListError(this.message);
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
  final Map<String, dynamic> invoice;
  const BillingInvoiceDetailLoaded(this.invoice);
}

class BillingInvoiceDetailError extends BillingInvoiceDetailState {
  final String message;
  const BillingInvoiceDetailError(this.message);
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
  final double mrr;
  final double arr;
  final List<Map<String, dynamic>> revenueByStatus;
  final int upcomingRenewals;
  final double hardwareRevenue;
  final double implementationRevenue;
  final int totalInvoices;
  final int paidInvoices;
  final int failedInvoices;
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
}

class RevenueDashboardError extends RevenueDashboardState {
  final String message;
  const RevenueDashboardError(this.message);
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
  final List<Map<String, dynamic>> gateways;
  const GatewayListLoaded(this.gateways);
}

class GatewayListError extends GatewayListState {
  final String message;
  const GatewayListError(this.message);
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
  final List<Map<String, dynamic>> sales;
  final Map<String, dynamic> pagination;
  const HardwareSaleListLoaded(this.sales, this.pagination);
}

class HardwareSaleListError extends HardwareSaleListState {
  final String message;
  const HardwareSaleListError(this.message);
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
  final List<Map<String, dynamic>> fees;
  final Map<String, dynamic> pagination;
  const ImplementationFeeListLoaded(this.fees, this.pagination);
}

class ImplementationFeeListError extends ImplementationFeeListState {
  final String message;
  const ImplementationFeeListError(this.message);
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
  final int maxRetries;
  final int retryIntervalHours;
  final int gracePeriodDays;
  const RetryRulesLoaded({required this.maxRetries, required this.retryIntervalHours, required this.gracePeriodDays});
}

class RetryRulesError extends RetryRulesState {
  final String message;
  const RetryRulesError(this.message);
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
  final Map<String, dynamic> kpi;
  final List<Map<String, dynamic>> recentActivity;
  const AnalyticsDashboardLoaded({required this.kpi, required this.recentActivity});
}

class AnalyticsDashboardError extends AnalyticsDashboardState {
  final String message;
  const AnalyticsDashboardError(this.message);
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
  final double mrr;
  final double arr;
  final List<Map<String, dynamic>> revenueTrend;
  final List<Map<String, dynamic>> revenueByPlan;
  final int failedPaymentsCount;
  final int upcomingRenewals;
  const AnalyticsRevenueLoaded({
    required this.mrr,
    required this.arr,
    required this.revenueTrend,
    required this.revenueByPlan,
    required this.failedPaymentsCount,
    required this.upcomingRenewals,
  });
}

class AnalyticsRevenueError extends AnalyticsRevenueState {
  final String message;
  const AnalyticsRevenueError(this.message);
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
  final Map<String, dynamic> statusCounts;
  final List<Map<String, dynamic>> lifecycleTrend;
  final double averageSubscriptionAgeDays;
  final int totalChurnInPeriod;
  final double trialToPaidConversionRate;
  const AnalyticsSubscriptionsLoaded({
    required this.statusCounts,
    required this.lifecycleTrend,
    required this.averageSubscriptionAgeDays,
    required this.totalChurnInPeriod,
    required this.trialToPaidConversionRate,
  });
}

class AnalyticsSubscriptionsError extends AnalyticsSubscriptionsState {
  final String message;
  const AnalyticsSubscriptionsError(this.message);
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
  final int totalStores;
  final int activeStores;
  final List<Map<String, dynamic>> topStores;
  final Map<String, dynamic> healthSummary;
  const AnalyticsStoresLoaded({
    required this.totalStores,
    required this.activeStores,
    required this.topStores,
    required this.healthSummary,
  });
}

class AnalyticsStoresError extends AnalyticsStoresState {
  final String message;
  const AnalyticsStoresError(this.message);
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
  final List<Map<String, dynamic>> features;
  final List<Map<String, dynamic>> trend;
  const AnalyticsFeaturesLoaded({required this.features, required this.trend});
}

class AnalyticsFeaturesError extends AnalyticsFeaturesState {
  final String message;
  const AnalyticsFeaturesError(this.message);
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
  final int storesMonitored;
  final int storesWithErrors;
  final int totalErrorsToday;
  final Map<String, dynamic> syncStatusBreakdown;
  const AnalyticsSystemHealthLoaded({
    required this.storesMonitored,
    required this.storesWithErrors,
    required this.totalErrorsToday,
    required this.syncStatusBreakdown,
  });
}

class AnalyticsSystemHealthError extends AnalyticsSystemHealthState {
  final String message;
  const AnalyticsSystemHealthError(this.message);
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
  final String exportType;
  final String format;
  final int recordCount;
  final String? downloadUrl;
  const AnalyticsExportSuccess({required this.exportType, required this.format, required this.recordCount, this.downloadUrl});
}

class AnalyticsExportError extends AnalyticsExportState {
  final String message;
  const AnalyticsExportError(this.message);
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
  final List<Map<String, dynamic>> flags;
  final int total;
  const FeatureFlagListLoaded({required this.flags, required this.total});
}

class FeatureFlagListError extends FeatureFlagListState {
  final String message;
  const FeatureFlagListError(this.message);
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
  final Map<String, dynamic> flag;
  final List<Map<String, dynamic>> abTests;
  const FeatureFlagDetailLoaded({required this.flag, required this.abTests});
}

class FeatureFlagDetailError extends FeatureFlagDetailState {
  final String message;
  const FeatureFlagDetailError(this.message);
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
  final String message;
  const FeatureFlagActionSuccess(this.message);
}

class FeatureFlagActionError extends FeatureFlagActionState {
  final String message;
  const FeatureFlagActionError(this.message);
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
  final List<Map<String, dynamic>> tests;
  final int total;
  final int currentPage;
  final int lastPage;
  const ABTestListLoaded({required this.tests, required this.total, required this.currentPage, required this.lastPage});
}

class ABTestListError extends ABTestListState {
  final String message;
  const ABTestListError(this.message);
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
  final Map<String, dynamic> test;
  final List<Map<String, dynamic>> variants;
  const ABTestDetailLoaded({required this.test, required this.variants});
}

class ABTestDetailError extends ABTestDetailState {
  final String message;
  const ABTestDetailError(this.message);
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
  final Map<String, dynamic> test;
  final List<Map<String, dynamic>> results;
  final String? winner;
  final double confidence;
  const ABTestResultsLoaded({required this.test, required this.results, this.winner, required this.confidence});
}

class ABTestResultsError extends ABTestResultsState {
  final String message;
  const ABTestResultsError(this.message);
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
  final String message;
  const ABTestActionSuccess(this.message);
}

class ABTestActionError extends ABTestActionState {
  final String message;
  const ABTestActionError(this.message);
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
  final List<Map<String, dynamic>> pages;
  final int total;
  const CmsPageListLoaded({required this.pages, required this.total});
}

class CmsPageListError extends CmsPageListState {
  final String message;
  const CmsPageListError(this.message);
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
  final Map<String, dynamic> page;
  const CmsPageDetailLoaded({required this.page});
}

class CmsPageDetailError extends CmsPageDetailState {
  final String message;
  const CmsPageDetailError(this.message);
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
  final String message;
  const CmsPageActionSuccess(this.message);
}

class CmsPageActionError extends CmsPageActionState {
  final String message;
  const CmsPageActionError(this.message);
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
  final List<Map<String, dynamic>> articles;
  final int total;
  final int currentPage;
  final int lastPage;
  const ArticleListLoaded({required this.articles, required this.total, required this.currentPage, required this.lastPage});
}

class ArticleListError extends ArticleListState {
  final String message;
  const ArticleListError(this.message);
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
  final Map<String, dynamic> article;
  const ArticleDetailLoaded({required this.article});
}

class ArticleDetailError extends ArticleDetailState {
  final String message;
  const ArticleDetailError(this.message);
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
  final String message;
  const ArticleActionSuccess(this.message);
}

class ArticleActionError extends ArticleActionState {
  final String message;
  const ArticleActionError(this.message);
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
  final List<Map<String, dynamic>> announcements;
  final int total;
  final int currentPage;
  final int lastPage;
  const AnnouncementListLoaded({
    required this.announcements,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
}

class AnnouncementListError extends AnnouncementListState {
  final String message;
  const AnnouncementListError(this.message);
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
  final Map<String, dynamic> announcement;
  const AnnouncementDetailLoaded({required this.announcement});
}

class AnnouncementDetailError extends AnnouncementDetailState {
  final String message;
  const AnnouncementDetailError(this.message);
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
  final String message;
  const AnnouncementActionSuccess(this.message);
}

class AnnouncementActionError extends AnnouncementActionState {
  final String message;
  const AnnouncementActionError(this.message);
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
  final List<Map<String, dynamic>> templates;
  final int total;
  const NotificationTemplateListLoaded({required this.templates, required this.total});
}

class NotificationTemplateListError extends NotificationTemplateListState {
  final String message;
  const NotificationTemplateListError(this.message);
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
  final Map<String, dynamic> template;
  const NotificationTemplateDetailLoaded({required this.template});
}

class NotificationTemplateDetailError extends NotificationTemplateDetailState {
  final String message;
  const NotificationTemplateDetailError(this.message);
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
  final String message;
  const NotificationTemplateActionSuccess(this.message);
}

class NotificationTemplateActionError extends NotificationTemplateActionState {
  final String message;
  const NotificationTemplateActionError(this.message);
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
  final Map<String, dynamic> data;
  const ActivityLogListLoaded(this.data);
}

class ActivityLogListError extends ActivityLogListState {
  final String message;
  const ActivityLogListError(this.message);
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
  final Map<String, dynamic> data;
  const ActivityLogDetailLoaded(this.data);
}

class ActivityLogDetailError extends ActivityLogDetailState {
  final String message;
  const ActivityLogDetailError(this.message);
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
  final Map<String, dynamic> data;
  const SecurityAlertListLoaded(this.data);
}

class SecurityAlertListError extends SecurityAlertListState {
  final String message;
  const SecurityAlertListError(this.message);
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
  final Map<String, dynamic> data;
  const SecurityAlertDetailLoaded(this.data);
}

class SecurityAlertDetailError extends SecurityAlertDetailState {
  final String message;
  const SecurityAlertDetailError(this.message);
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
  final String message;
  const SecurityAlertActionSuccess(this.message);
}

class SecurityAlertActionError extends SecurityAlertActionState {
  final String message;
  const SecurityAlertActionError(this.message);
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
  final Map<String, dynamic> data;
  const NotificationLogListLoaded(this.data);
}

class NotificationLogListError extends NotificationLogListState {
  final String message;
  const NotificationLogListError(this.message);
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
  final Map<String, dynamic> data;
  const PlatformEventListLoaded(this.data);
}

class PlatformEventListError extends PlatformEventListState {
  final String message;
  const PlatformEventListError(this.message);
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
  final Map<String, dynamic> data;
  const PlatformEventDetailLoaded(this.data);
}

class PlatformEventDetailError extends PlatformEventDetailState {
  final String message;
  const PlatformEventDetailError(this.message);
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
  final String message;
  const PlatformEventActionSuccess(this.message);
}

class PlatformEventActionError extends PlatformEventActionState {
  final String message;
  const PlatformEventActionError(this.message);
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
  final Map<String, dynamic> data;
  const HealthDashboardLoaded(this.data);
}

class HealthDashboardError extends HealthDashboardState {
  final String message;
  const HealthDashboardError(this.message);
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
  final Map<String, dynamic> data;
  const HealthCheckListLoaded(this.data);
}

class HealthCheckListError extends HealthCheckListState {
  final String message;
  const HealthCheckListError(this.message);
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
  final Map<String, dynamic> data;
  const StoreHealthListLoaded(this.data);
}

class StoreHealthListError extends StoreHealthListState {
  final String message;
  const StoreHealthListError(this.message);
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
  final Map<String, dynamic> data;
  const TicketListLoaded(this.data);
}

class TicketListError extends TicketListState {
  final String message;
  const TicketListError(this.message);
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
  final Map<String, dynamic> data;
  const TicketDetailLoaded(this.data);
}

class TicketDetailError extends TicketDetailState {
  final String message;
  const TicketDetailError(this.message);
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
  final Map<String, dynamic> data;
  const TicketActionSuccess(this.data);
}

class TicketActionError extends TicketActionState {
  final String message;
  const TicketActionError(this.message);
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
  final Map<String, dynamic> data;
  const TicketMessageListLoaded(this.data);
}

class TicketMessageListError extends TicketMessageListState {
  final String message;
  const TicketMessageListError(this.message);
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
  final Map<String, dynamic> data;
  const TicketMessageActionSuccess(this.data);
}

class TicketMessageActionError extends TicketMessageActionState {
  final String message;
  const TicketMessageActionError(this.message);
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
  final Map<String, dynamic> data;
  const CannedResponseListLoaded(this.data);
}

class CannedResponseListError extends CannedResponseListState {
  final String message;
  const CannedResponseListError(this.message);
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
  final Map<String, dynamic> data;
  const CannedResponseDetailLoaded(this.data);
}

class CannedResponseDetailError extends CannedResponseDetailState {
  final String message;
  const CannedResponseDetailError(this.message);
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
  final Map<String, dynamic> data;
  const CannedResponseActionSuccess(this.data);
}

class CannedResponseActionError extends CannedResponseActionState {
  final String message;
  const CannedResponseActionError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceStoreListLoaded(this.data);
}

class MarketplaceStoreListError extends MarketplaceStoreListState {
  final String message;
  const MarketplaceStoreListError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceStoreDetailLoaded(this.data);
}

class MarketplaceStoreDetailError extends MarketplaceStoreDetailState {
  final String message;
  const MarketplaceStoreDetailError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceStoreActionSuccess(this.data);
}

class MarketplaceStoreActionError extends MarketplaceStoreActionState {
  final String message;
  const MarketplaceStoreActionError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceProductListLoaded(this.data);
}

class MarketplaceProductListError extends MarketplaceProductListState {
  final String message;
  const MarketplaceProductListError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceProductActionSuccess(this.data);
}

class MarketplaceProductActionError extends MarketplaceProductActionState {
  final String message;
  const MarketplaceProductActionError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceOrderListLoaded(this.data);
}

class MarketplaceOrderListError extends MarketplaceOrderListState {
  final String message;
  const MarketplaceOrderListError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceOrderDetailLoaded(this.data);
}

class MarketplaceOrderDetailError extends MarketplaceOrderDetailState {
  final String message;
  const MarketplaceOrderDetailError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceSettlementListLoaded(this.data);
}

class MarketplaceSettlementListError extends MarketplaceSettlementListState {
  final String message;
  const MarketplaceSettlementListError(this.message);
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
  final Map<String, dynamic> data;
  const MarketplaceSettlementSummaryLoaded(this.data);
}

class MarketplaceSettlementSummaryError extends MarketplaceSettlementSummaryState {
  final String message;
  const MarketplaceSettlementSummaryError(this.message);
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
  final Map<String, dynamic> data;
  const DeploymentOverviewLoaded(this.data);
}

class DeploymentOverviewError extends DeploymentOverviewState {
  final String message;
  const DeploymentOverviewError(this.message);
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
  final Map<String, dynamic> data;
  const DeploymentReleaseListLoaded(this.data);
}

class DeploymentReleaseListError extends DeploymentReleaseListState {
  final String message;
  const DeploymentReleaseListError(this.message);
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
  final Map<String, dynamic> data;
  const DeploymentReleaseDetailLoaded(this.data);
}

class DeploymentReleaseDetailError extends DeploymentReleaseDetailState {
  final String message;
  const DeploymentReleaseDetailError(this.message);
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
  final Map<String, dynamic> data;
  const DeploymentReleaseActionSuccess(this.data);
}

class DeploymentReleaseActionError extends DeploymentReleaseActionState {
  final String message;
  const DeploymentReleaseActionError(this.message);
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
  final Map<String, dynamic> data;
  const DeploymentStatsListLoaded(this.data);
}

class DeploymentStatsListError extends DeploymentStatsListState {
  final String message;
  const DeploymentStatsListError(this.message);
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
  final Map<String, dynamic> data;
  const DeploymentReleaseSummaryLoaded(this.data);
}

class DeploymentReleaseSummaryError extends DeploymentReleaseSummaryState {
  final String message;
  const DeploymentReleaseSummaryError(this.message);
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
  final Map<String, dynamic> data;
  const DataManagementOverviewLoaded(this.data);
}

class DataManagementOverviewError extends DataManagementOverviewState {
  final String message;
  const DataManagementOverviewError(this.message);
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
  final Map<String, dynamic> data;
  const DatabaseBackupListLoaded(this.data);
}

class DatabaseBackupListError extends DatabaseBackupListState {
  final String message;
  const DatabaseBackupListError(this.message);
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
  final Map<String, dynamic> data;
  const DatabaseBackupActionSuccess(this.data);
}

class DatabaseBackupActionError extends DatabaseBackupActionState {
  final String message;
  const DatabaseBackupActionError(this.message);
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
  final Map<String, dynamic> data;
  const BackupHistoryListLoaded(this.data);
}

class BackupHistoryListError extends BackupHistoryListState {
  final String message;
  const BackupHistoryListError(this.message);
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
  final Map<String, dynamic> data;
  const SyncLogListLoaded(this.data);
}

class SyncLogListError extends SyncLogListState {
  final String message;
  const SyncLogListError(this.message);
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
  final Map<String, dynamic> data;
  const SyncLogSummaryLoaded(this.data);
}

class SyncLogSummaryError extends SyncLogSummaryState {
  final String message;
  const SyncLogSummaryError(this.message);
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
  final Map<String, dynamic> data;
  const SyncConflictListLoaded(this.data);
}

class SyncConflictListError extends SyncConflictListState {
  final String message;
  const SyncConflictListError(this.message);
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
  final Map<String, dynamic> data;
  const SyncConflictActionSuccess(this.data);
}

class SyncConflictActionError extends SyncConflictActionState {
  final String message;
  const SyncConflictActionError(this.message);
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
  final Map<String, dynamic> data;
  const SecurityOverviewLoaded(this.data);
}

class SecurityOverviewError extends SecurityOverviewState {
  final String message;
  const SecurityOverviewError(this.message);
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
  final Map<String, dynamic> data;
  const SecCenterAlertListLoaded(this.data);
}

class SecCenterAlertListError extends SecCenterAlertListState {
  final String message;
  const SecCenterAlertListError(this.message);
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
  final Map<String, dynamic> data;
  const SecCenterAlertActionSuccess(this.data);
}

class SecCenterAlertActionError extends SecCenterAlertActionState {
  final String message;
  const SecCenterAlertActionError(this.message);
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
  final Map<String, dynamic> data;
  const SecuritySessionListLoaded(this.data);
}

class SecuritySessionListError extends SecuritySessionListState {
  final String message;
  const SecuritySessionListError(this.message);
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
  final Map<String, dynamic> data;
  const SecurityDeviceListLoaded(this.data);
}

class SecurityDeviceListError extends SecurityDeviceListState {
  final String message;
  const SecurityDeviceListError(this.message);
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
  final Map<String, dynamic> data;
  const SecurityPolicyListLoaded(this.data);
}

class SecurityPolicyListError extends SecurityPolicyListState {
  final String message;
  const SecurityPolicyListError(this.message);
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
  final Map<String, dynamic> data;
  const SecurityPolicyActionSuccess(this.data);
}

class SecurityPolicyActionError extends SecurityPolicyActionState {
  final String message;
  const SecurityPolicyActionError(this.message);
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
  final Map<String, dynamic> data;
  const SecurityIpListLoaded(this.data);
}

class SecurityIpListError extends SecurityIpListState {
  final String message;
  const SecurityIpListError(this.message);
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
  final Map<String, dynamic> data;
  const FinOpsOverviewLoaded(this.data);
}

class FinOpsOverviewError extends FinOpsOverviewState {
  final String message;
  const FinOpsOverviewError(this.message);
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
  final Map<String, dynamic> data;
  const FinOpsListLoaded(this.data);
}

class FinOpsListError extends FinOpsListState {
  final String message;
  const FinOpsListError(this.message);
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
  final Map<String, dynamic> data;
  const FinOpsDetailLoaded(this.data);
}

class FinOpsDetailError extends FinOpsDetailState {
  final String message;
  const FinOpsDetailError(this.message);
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
  final Map<String, dynamic>? data;
  const FinOpsActionSuccess([this.data]);
}

class FinOpsActionError extends FinOpsActionState {
  final String message;
  const FinOpsActionError(this.message);
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
  final Map<String, dynamic> data;
  const InfraOverviewLoaded(this.data);
}

class InfraOverviewError extends InfraOverviewState {
  final String message;
  const InfraOverviewError(this.message);
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
  final Map<String, dynamic> data;
  const InfraListLoaded(this.data);
}

class InfraListError extends InfraListState {
  final String message;
  const InfraListError(this.message);
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
  final Map<String, dynamic> data;
  const ProviderRoleTemplateListLoaded(this.data);
}

class ProviderRoleTemplateListError extends ProviderRoleTemplateListState {
  final String message;
  const ProviderRoleTemplateListError(this.message);
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
  final Map<String, dynamic> data;
  const ProviderRoleTemplateDetailLoaded(this.data);
}

class ProviderRoleTemplateDetailError extends ProviderRoleTemplateDetailState {
  final String message;
  const ProviderRoleTemplateDetailError(this.message);
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
  final Map<String, dynamic> data;
  const ProviderPermissionListLoaded(this.data);
}

class ProviderPermissionListError extends ProviderPermissionListState {
  final String message;
  const ProviderPermissionListError(this.message);
}
