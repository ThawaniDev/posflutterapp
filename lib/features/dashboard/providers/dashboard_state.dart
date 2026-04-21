// ─── Owner Dashboard State ─────────────────────────────────────
// Aggregated state for the entire dashboard view

sealed class OwnerDashboardState {
  const OwnerDashboardState();
}

class OwnerDashboardInitial extends OwnerDashboardState {
  const OwnerDashboardInitial();
}

class OwnerDashboardLoading extends OwnerDashboardState {
  const OwnerDashboardLoading();
}

class OwnerDashboardLoaded extends OwnerDashboardState {

  const OwnerDashboardLoaded({
    required this.stats,
    required this.salesTrend,
    required this.topProducts,
    required this.lowStock,
    required this.activeCashiers,
    required this.recentOrders,
    required this.financialSummary,
    required this.hourlySales,
    required this.staffPerformance,
    required this.branches,
  });
  final Map<String, dynamic> stats;
  final Map<String, dynamic> salesTrend;
  final List<Map<String, dynamic>> topProducts;
  final List<Map<String, dynamic>> lowStock;
  final List<Map<String, dynamic>> activeCashiers;
  final List<Map<String, dynamic>> recentOrders;
  final Map<String, dynamic> financialSummary;
  final List<Map<String, dynamic>> hourlySales;
  final List<Map<String, dynamic>> staffPerformance;
  final List<Map<String, dynamic>> branches;
}

class OwnerDashboardError extends OwnerDashboardState {
  const OwnerDashboardError({required this.message});
  final String message;
}

// ─── Financial Summary State ───────────────────────────────────

sealed class FinancialSummaryState {
  const FinancialSummaryState();
}

class FinancialSummaryInitial extends FinancialSummaryState {
  const FinancialSummaryInitial();
}

class FinancialSummaryLoading extends FinancialSummaryState {
  const FinancialSummaryLoading();
}

class FinancialSummaryLoaded extends FinancialSummaryState {
  const FinancialSummaryLoaded({required this.data});
  final Map<String, dynamic> data;
}

class FinancialSummaryError extends FinancialSummaryState {
  const FinancialSummaryError({required this.message});
  final String message;
}

// ─── Staff Performance State ───────────────────────────────────

sealed class StaffPerformanceState {
  const StaffPerformanceState();
}

class StaffPerformanceInitial extends StaffPerformanceState {
  const StaffPerformanceInitial();
}

class StaffPerformanceLoading extends StaffPerformanceState {
  const StaffPerformanceLoading();
}

class StaffPerformanceLoaded extends StaffPerformanceState {
  const StaffPerformanceLoaded({required this.staff});
  final List<Map<String, dynamic>> staff;
}

class StaffPerformanceError extends StaffPerformanceState {
  const StaffPerformanceError({required this.message});
  final String message;
}

// ─── Branch Overview State ─────────────────────────────────────

sealed class BranchOverviewState {
  const BranchOverviewState();
}

class BranchOverviewInitial extends BranchOverviewState {
  const BranchOverviewInitial();
}

class BranchOverviewLoading extends BranchOverviewState {
  const BranchOverviewLoading();
}

class BranchOverviewLoaded extends BranchOverviewState {
  const BranchOverviewLoaded({required this.branches});
  final List<Map<String, dynamic>> branches;
}

class BranchOverviewError extends BranchOverviewState {
  const BranchOverviewError({required this.message});
  final String message;
}
