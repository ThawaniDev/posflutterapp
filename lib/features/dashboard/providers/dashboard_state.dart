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
  final Map<String, dynamic> stats;
  final Map<String, dynamic> salesTrend;
  final List<Map<String, dynamic>> topProducts;
  final List<Map<String, dynamic>> lowStock;
  final List<Map<String, dynamic>> activeCashiers;
  final List<Map<String, dynamic>> recentOrders;

  const OwnerDashboardLoaded({
    required this.stats,
    required this.salesTrend,
    required this.topProducts,
    required this.lowStock,
    required this.activeCashiers,
    required this.recentOrders,
  });
}

class OwnerDashboardError extends OwnerDashboardState {
  final String message;
  const OwnerDashboardError({required this.message});
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
  final Map<String, dynamic> data;
  const FinancialSummaryLoaded({required this.data});
}

class FinancialSummaryError extends FinancialSummaryState {
  final String message;
  const FinancialSummaryError({required this.message});
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
  final List<Map<String, dynamic>> staff;
  const StaffPerformanceLoaded({required this.staff});
}

class StaffPerformanceError extends StaffPerformanceState {
  final String message;
  const StaffPerformanceError({required this.message});
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
  final List<Map<String, dynamic>> branches;
  const BranchOverviewLoaded({required this.branches});
}

class BranchOverviewError extends BranchOverviewState {
  final String message;
  const BranchOverviewError({required this.message});
}
