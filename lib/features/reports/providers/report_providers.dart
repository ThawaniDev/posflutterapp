import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/repositories/report_repository.dart';

// ─── Sales Summary ───────────────────────────────────────────

final salesSummaryProvider = StateNotifierProvider<SalesSummaryNotifier, SalesSummaryState>((ref) {
  return SalesSummaryNotifier(ref.watch(reportRepositoryProvider));
});

class SalesSummaryNotifier extends StateNotifier<SalesSummaryState> {
  final ReportRepository _repo;

  SalesSummaryNotifier(this._repo) : super(const SalesSummaryInitial());

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const SalesSummaryLoading();
    try {
      final data = await _repo.getSalesSummary(dateFrom: dateFrom, dateTo: dateTo);
      state = SalesSummaryLoaded(
        totals: data['totals'] as Map<String, dynamic>,
        daily: (data['daily'] as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      state = SalesSummaryError(message: e.toString());
    }
  }
}

// ─── Product Performance ─────────────────────────────────────

final productPerformanceProvider = StateNotifierProvider<ProductPerformanceNotifier, ProductPerformanceState>((ref) {
  return ProductPerformanceNotifier(ref.watch(reportRepositoryProvider));
});

class ProductPerformanceNotifier extends StateNotifier<ProductPerformanceState> {
  final ReportRepository _repo;

  ProductPerformanceNotifier(this._repo) : super(const ProductPerformanceInitial());

  Future<void> load({String? dateFrom, String? dateTo, String? categoryId, int? limit}) async {
    state = const ProductPerformanceLoading();
    try {
      final data = await _repo.getProductPerformance(dateFrom: dateFrom, dateTo: dateTo, categoryId: categoryId, limit: limit);
      state = ProductPerformanceLoaded(products: data);
    } catch (e) {
      state = ProductPerformanceError(message: e.toString());
    }
  }
}

// ─── Category Breakdown ──────────────────────────────────────

final categoryBreakdownProvider = StateNotifierProvider<CategoryBreakdownNotifier, CategoryBreakdownState>((ref) {
  return CategoryBreakdownNotifier(ref.watch(reportRepositoryProvider));
});

class CategoryBreakdownNotifier extends StateNotifier<CategoryBreakdownState> {
  final ReportRepository _repo;

  CategoryBreakdownNotifier(this._repo) : super(const CategoryBreakdownInitial());

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const CategoryBreakdownLoading();
    try {
      final data = await _repo.getCategoryBreakdown(dateFrom: dateFrom, dateTo: dateTo);
      state = CategoryBreakdownLoaded(categories: data);
    } catch (e) {
      state = CategoryBreakdownError(message: e.toString());
    }
  }
}

// ─── Staff Performance ───────────────────────────────────────

final staffPerformanceProvider = StateNotifierProvider<StaffPerformanceNotifier, StaffPerformanceState>((ref) {
  return StaffPerformanceNotifier(ref.watch(reportRepositoryProvider));
});

class StaffPerformanceNotifier extends StateNotifier<StaffPerformanceState> {
  final ReportRepository _repo;

  StaffPerformanceNotifier(this._repo) : super(const StaffPerformanceInitial());

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const StaffPerformanceLoading();
    try {
      final data = await _repo.getStaffPerformance(dateFrom: dateFrom, dateTo: dateTo);
      state = StaffPerformanceLoaded(staff: data);
    } catch (e) {
      state = StaffPerformanceError(message: e.toString());
    }
  }
}

// ─── Hourly Sales ────────────────────────────────────────────

final hourlySalesProvider = StateNotifierProvider<HourlySalesNotifier, HourlySalesState>((ref) {
  return HourlySalesNotifier(ref.watch(reportRepositoryProvider));
});

class HourlySalesNotifier extends StateNotifier<HourlySalesState> {
  final ReportRepository _repo;

  HourlySalesNotifier(this._repo) : super(const HourlySalesInitial());

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const HourlySalesLoading();
    try {
      final data = await _repo.getHourlySales(dateFrom: dateFrom, dateTo: dateTo);
      state = HourlySalesLoaded(hours: data);
    } catch (e) {
      state = HourlySalesError(message: e.toString());
    }
  }
}

// ─── Payment Methods ─────────────────────────────────────────

final paymentMethodsProvider = StateNotifierProvider<PaymentMethodsNotifier, PaymentMethodsState>((ref) {
  return PaymentMethodsNotifier(ref.watch(reportRepositoryProvider));
});

class PaymentMethodsNotifier extends StateNotifier<PaymentMethodsState> {
  final ReportRepository _repo;

  PaymentMethodsNotifier(this._repo) : super(const PaymentMethodsInitial());

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const PaymentMethodsLoading();
    try {
      final data = await _repo.getPaymentMethods(dateFrom: dateFrom, dateTo: dateTo);
      state = PaymentMethodsLoaded(methods: data);
    } catch (e) {
      state = PaymentMethodsError(message: e.toString());
    }
  }
}

// ─── Dashboard ───────────────────────────────────────────────

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref.watch(reportRepositoryProvider));
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final ReportRepository _repo;

  DashboardNotifier(this._repo) : super(const DashboardInitial());

  Future<void> load() async {
    state = const DashboardLoading();
    try {
      final data = await _repo.getDashboard();
      state = DashboardLoaded(
        today: data['today'] as Map<String, dynamic>,
        yesterday: data['yesterday'] as Map<String, dynamic>,
        topProducts: (data['top_products'] as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      state = DashboardError(message: e.toString());
    }
  }
}
