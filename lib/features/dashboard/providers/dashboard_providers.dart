import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/dashboard/providers/dashboard_state.dart';
import 'package:wameedpos/features/dashboard/repositories/dashboard_repository.dart';

// ─── Main Dashboard Provider ───────────────────────────────────

final ownerDashboardProvider = StateNotifierProvider<OwnerDashboardNotifier, OwnerDashboardState>((ref) {
  return OwnerDashboardNotifier(ref.watch(dashboardRepositoryProvider));
});

class OwnerDashboardNotifier extends StateNotifier<OwnerDashboardState> {

  OwnerDashboardNotifier(this._repo) : super(const OwnerDashboardInitial());
  final DashboardRepository _repo;

  Future<void> load({int? days}) async {
    if (state is! OwnerDashboardLoaded) state = const OwnerDashboardLoading();
    try {
      final summary = await _repo.getDashboardSummary(days: days);
      state = OwnerDashboardLoaded(
        stats: summary['stats'] as Map<String, dynamic>,
        salesTrend: summary['sales_trend'] as Map<String, dynamic>,
        topProducts: (summary['top_products'] as List).cast<Map<String, dynamic>>(),
        lowStock: (summary['low_stock'] as List).cast<Map<String, dynamic>>(),
        activeCashiers: (summary['active_cashiers'] as List).cast<Map<String, dynamic>>(),
        recentOrders: (summary['recent_orders'] as List).cast<Map<String, dynamic>>(),
        financialSummary: summary['financial_summary'] as Map<String, dynamic>,
        hourlySales: (summary['hourly_sales'] as List).cast<Map<String, dynamic>>(),
        staffPerformance: (summary['staff_performance'] as List).cast<Map<String, dynamic>>(),
        branches: (summary['branches'] as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      if (state is! OwnerDashboardLoaded) state = OwnerDashboardError(message: e.toString());
    }
  }
}

// ─── Financial Summary Provider ────────────────────────────────

final financialSummaryProvider = StateNotifierProvider<FinancialSummaryNotifier, FinancialSummaryState>((ref) {
  return FinancialSummaryNotifier(ref.watch(dashboardRepositoryProvider));
});

class FinancialSummaryNotifier extends StateNotifier<FinancialSummaryState> {

  FinancialSummaryNotifier(this._repo) : super(const FinancialSummaryInitial());
  final DashboardRepository _repo;

  Future<void> load({String? dateFrom, String? dateTo, int? days}) async {
    if (state is! FinancialSummaryLoaded) state = const FinancialSummaryLoading();
    try {
      final data = await _repo.getFinancialSummary(dateFrom: dateFrom, dateTo: dateTo, days: days);
      state = FinancialSummaryLoaded(data: data);
    } catch (e) {
      if (state is! FinancialSummaryLoaded) state = FinancialSummaryError(message: e.toString());
    }
  }
}

// ─── Staff Performance Provider ────────────────────────────────

final staffPerformanceDashboardProvider = StateNotifierProvider<StaffPerformanceNotifier, StaffPerformanceState>((ref) {
  return StaffPerformanceNotifier(ref.watch(dashboardRepositoryProvider));
});

class StaffPerformanceNotifier extends StateNotifier<StaffPerformanceState> {

  StaffPerformanceNotifier(this._repo) : super(const StaffPerformanceInitial());
  final DashboardRepository _repo;

  Future<void> load({String? dateFrom, String? dateTo, int? days}) async {
    if (state is! StaffPerformanceLoaded) state = const StaffPerformanceLoading();
    try {
      final staff = await _repo.getStaffPerformance(dateFrom: dateFrom, dateTo: dateTo, days: days);
      state = StaffPerformanceLoaded(staff: staff);
    } catch (e) {
      if (state is! StaffPerformanceLoaded) state = StaffPerformanceError(message: e.toString());
    }
  }
}

// ─── Branch Overview Provider ──────────────────────────────────

final branchOverviewProvider = StateNotifierProvider<BranchOverviewNotifier, BranchOverviewState>((ref) {
  return BranchOverviewNotifier(ref.watch(dashboardRepositoryProvider));
});

class BranchOverviewNotifier extends StateNotifier<BranchOverviewState> {

  BranchOverviewNotifier(this._repo) : super(const BranchOverviewInitial());
  final DashboardRepository _repo;

  Future<void> load() async {
    if (state is! BranchOverviewLoaded) state = const BranchOverviewLoading();
    try {
      final branches = await _repo.getBranches();
      state = BranchOverviewLoaded(branches: branches);
    } catch (e) {
      if (state is! BranchOverviewLoaded) state = BranchOverviewError(message: e.toString());
    }
  }
}
