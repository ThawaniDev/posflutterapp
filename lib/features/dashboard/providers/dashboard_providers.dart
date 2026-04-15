import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/dashboard/providers/dashboard_state.dart';
import 'package:wameedpos/features/dashboard/repositories/dashboard_repository.dart';

// ─── Main Dashboard Provider ───────────────────────────────────

final ownerDashboardProvider = StateNotifierProvider<OwnerDashboardNotifier, OwnerDashboardState>((ref) {
  return OwnerDashboardNotifier(ref.watch(dashboardRepositoryProvider));
});

class OwnerDashboardNotifier extends StateNotifier<OwnerDashboardState> {
  final DashboardRepository _repo;

  OwnerDashboardNotifier(this._repo) : super(const OwnerDashboardInitial());

  Future<void> load({int? days}) async {
    if (state is! OwnerDashboardLoaded) state = const OwnerDashboardLoading();
    try {
      final results = await Future.wait([
        _repo.getStats(days: days),
        _repo.getSalesTrend(days: days ?? 7),
        _repo.getTopProducts(limit: 5),
        _repo.getLowStock(limit: 10),
        _repo.getActiveCashiers(),
        _repo.getRecentOrders(limit: 10),
        _repo.getFinancialSummary(days: days),
        _repo.getHourlySales(),
        _repo.getStaffPerformance(days: days),
        _repo.getBranches(),
      ]);
      state = OwnerDashboardLoaded(
        stats: results[0] as Map<String, dynamic>,
        salesTrend: results[1] as Map<String, dynamic>,
        topProducts: results[2] as List<Map<String, dynamic>>,
        lowStock: results[3] as List<Map<String, dynamic>>,
        activeCashiers: results[4] as List<Map<String, dynamic>>,
        recentOrders: results[5] as List<Map<String, dynamic>>,
        financialSummary: results[6] as Map<String, dynamic>,
        hourlySales: results[7] as List<Map<String, dynamic>>,
        staffPerformance: results[8] as List<Map<String, dynamic>>,
        branches: results[9] as List<Map<String, dynamic>>,
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
  final DashboardRepository _repo;

  FinancialSummaryNotifier(this._repo) : super(const FinancialSummaryInitial());

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
  final DashboardRepository _repo;

  StaffPerformanceNotifier(this._repo) : super(const StaffPerformanceInitial());

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
  final DashboardRepository _repo;

  BranchOverviewNotifier(this._repo) : super(const BranchOverviewInitial());

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
