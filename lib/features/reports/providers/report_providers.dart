import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/repositories/report_repository.dart';

// ─── Sales Summary ───────────────────────────────────────────

final salesSummaryProvider = StateNotifierProvider<SalesSummaryNotifier, SalesSummaryState>((ref) {
  return SalesSummaryNotifier(ref.watch(reportRepositoryProvider));
});

class SalesSummaryNotifier extends StateNotifier<SalesSummaryState> {

  SalesSummaryNotifier(this._repo) : super(const SalesSummaryInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! SalesSummaryLoaded) state = const SalesSummaryLoading();
    try {
      final data = await _repo.getSalesSummary(filters: filters);
      state = SalesSummaryLoaded(
        totals: data['totals'] as Map<String, dynamic>,
        daily: ((data['series'] ?? data['daily']) as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      if (state is! SalesSummaryLoaded) state = SalesSummaryError(message: e.toString());
    }
  }
}

// ─── Product Performance ─────────────────────────────────────

final productPerformanceProvider = StateNotifierProvider<ProductPerformanceNotifier, ProductPerformanceState>((ref) {
  return ProductPerformanceNotifier(ref.watch(reportRepositoryProvider));
});

class ProductPerformanceNotifier extends StateNotifier<ProductPerformanceState> {

  ProductPerformanceNotifier(this._repo) : super(const ProductPerformanceInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! ProductPerformanceLoaded) state = const ProductPerformanceLoading();
    try {
      final data = await _repo.getProductPerformance(filters: filters);
      state = ProductPerformanceLoaded(products: data);
    } catch (e) {
      if (state is! ProductPerformanceLoaded) state = ProductPerformanceError(message: e.toString());
    }
  }
}

// ─── Category Breakdown ──────────────────────────────────────

final categoryBreakdownProvider = StateNotifierProvider<CategoryBreakdownNotifier, CategoryBreakdownState>((ref) {
  return CategoryBreakdownNotifier(ref.watch(reportRepositoryProvider));
});

class CategoryBreakdownNotifier extends StateNotifier<CategoryBreakdownState> {

  CategoryBreakdownNotifier(this._repo) : super(const CategoryBreakdownInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! CategoryBreakdownLoaded) state = const CategoryBreakdownLoading();
    try {
      final data = await _repo.getCategoryBreakdown(filters: filters);
      state = CategoryBreakdownLoaded(categories: data);
    } catch (e) {
      if (state is! CategoryBreakdownLoaded) state = CategoryBreakdownError(message: e.toString());
    }
  }
}

// ─── Staff Performance ───────────────────────────────────────

final staffPerformanceProvider = StateNotifierProvider<StaffPerformanceNotifier, StaffPerformanceState>((ref) {
  return StaffPerformanceNotifier(ref.watch(reportRepositoryProvider));
});

class StaffPerformanceNotifier extends StateNotifier<StaffPerformanceState> {

  StaffPerformanceNotifier(this._repo) : super(const StaffPerformanceInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! StaffPerformanceLoaded) state = const StaffPerformanceLoading();
    try {
      final data = await _repo.getStaffPerformance(filters: filters);
      state = StaffPerformanceLoaded(staff: data);
    } catch (e) {
      if (state is! StaffPerformanceLoaded) state = StaffPerformanceError(message: e.toString());
    }
  }
}

// ─── Hourly Sales ────────────────────────────────────────────

final hourlySalesProvider = StateNotifierProvider<HourlySalesNotifier, HourlySalesState>((ref) {
  return HourlySalesNotifier(ref.watch(reportRepositoryProvider));
});

class HourlySalesNotifier extends StateNotifier<HourlySalesState> {

  HourlySalesNotifier(this._repo) : super(const HourlySalesInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! HourlySalesLoaded) state = const HourlySalesLoading();
    try {
      final data = await _repo.getHourlySales(filters: filters);
      state = HourlySalesLoaded(hours: data);
    } catch (e) {
      if (state is! HourlySalesLoaded) state = HourlySalesError(message: e.toString());
    }
  }
}

// ─── Payment Methods ─────────────────────────────────────────

final paymentMethodsProvider = StateNotifierProvider<PaymentMethodsNotifier, PaymentMethodsState>((ref) {
  return PaymentMethodsNotifier(ref.watch(reportRepositoryProvider));
});

class PaymentMethodsNotifier extends StateNotifier<PaymentMethodsState> {

  PaymentMethodsNotifier(this._repo) : super(const PaymentMethodsInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! PaymentMethodsLoaded) state = const PaymentMethodsLoading();
    try {
      final data = await _repo.getPaymentMethods(filters: filters);
      state = PaymentMethodsLoaded(methods: data);
    } catch (e) {
      if (state is! PaymentMethodsLoaded) state = PaymentMethodsError(message: e.toString());
    }
  }
}

// ─── Dashboard ───────────────────────────────────────────────

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref.watch(reportRepositoryProvider));
});

class DashboardNotifier extends StateNotifier<DashboardState> {

  DashboardNotifier(this._repo) : super(const DashboardInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! DashboardLoaded) state = const DashboardLoading();
    try {
      final data = await _repo.getDashboard(filters: filters);
      state = DashboardLoaded(
        today: data['today'] as Map<String, dynamic>,
        yesterday: data['yesterday'] as Map<String, dynamic>,
        topProducts: (data['top_products'] as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      if (state is! DashboardLoaded) state = DashboardError(message: e.toString());
    }
  }
}

// ─── Inventory Valuation ─────────────────────────────────────

final inventoryValuationProvider = StateNotifierProvider<InventoryValuationNotifier, InventoryValuationState>((ref) {
  return InventoryValuationNotifier(ref.watch(reportRepositoryProvider));
});

class InventoryValuationNotifier extends StateNotifier<InventoryValuationState> {

  InventoryValuationNotifier(this._repo) : super(const InventoryValuationInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! InventoryValuationLoaded) state = const InventoryValuationLoading();
    try {
      final data = await _repo.getInventoryValuation(filters: filters);
      state = InventoryValuationLoaded(data: data);
    } catch (e) {
      if (state is! InventoryValuationLoaded) state = InventoryValuationError(message: e.toString());
    }
  }
}

// ─── Inventory Turnover ──────────────────────────────────────

final inventoryTurnoverProvider = StateNotifierProvider<InventoryTurnoverNotifier, InventoryTurnoverState>((ref) {
  return InventoryTurnoverNotifier(ref.watch(reportRepositoryProvider));
});

class InventoryTurnoverNotifier extends StateNotifier<InventoryTurnoverState> {

  InventoryTurnoverNotifier(this._repo) : super(const InventoryTurnoverInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! InventoryTurnoverLoaded) state = const InventoryTurnoverLoading();
    try {
      final data = await _repo.getInventoryTurnover(filters: filters);
      state = InventoryTurnoverLoaded(products: data);
    } catch (e) {
      if (state is! InventoryTurnoverLoaded) state = InventoryTurnoverError(message: e.toString());
    }
  }
}

// ─── Inventory Shrinkage ─────────────────────────────────────

final inventoryShrinkageProvider = StateNotifierProvider<InventoryShrinkageNotifier, InventoryShrinkageState>((ref) {
  return InventoryShrinkageNotifier(ref.watch(reportRepositoryProvider));
});

class InventoryShrinkageNotifier extends StateNotifier<InventoryShrinkageState> {

  InventoryShrinkageNotifier(this._repo) : super(const InventoryShrinkageInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! InventoryShrinkageLoaded) state = const InventoryShrinkageLoading();
    try {
      final data = await _repo.getInventoryShrinkage(filters: filters);
      state = InventoryShrinkageLoaded(data: data);
    } catch (e) {
      if (state is! InventoryShrinkageLoaded) state = InventoryShrinkageError(message: e.toString());
    }
  }
}

// ─── Inventory Low Stock ─────────────────────────────────────

final inventoryLowStockProvider = StateNotifierProvider<InventoryLowStockNotifier, InventoryLowStockState>((ref) {
  return InventoryLowStockNotifier(ref.watch(reportRepositoryProvider));
});

class InventoryLowStockNotifier extends StateNotifier<InventoryLowStockState> {

  InventoryLowStockNotifier(this._repo) : super(const InventoryLowStockInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! InventoryLowStockLoaded) state = const InventoryLowStockLoading();
    try {
      final data = await _repo.getInventoryLowStock(filters: filters);
      state = InventoryLowStockLoaded(products: data);
    } catch (e) {
      if (state is! InventoryLowStockLoaded) state = InventoryLowStockError(message: e.toString());
    }
  }
}

// ─── Financial: Daily P&L ────────────────────────────────────

final financialDailyPlProvider = StateNotifierProvider<FinancialDailyPlNotifier, FinancialDailyPlState>((ref) {
  return FinancialDailyPlNotifier(ref.watch(reportRepositoryProvider));
});

class FinancialDailyPlNotifier extends StateNotifier<FinancialDailyPlState> {

  FinancialDailyPlNotifier(this._repo) : super(const FinancialDailyPlInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! FinancialDailyPlLoaded) state = const FinancialDailyPlLoading();
    try {
      final data = await _repo.getFinancialDailyPl(filters: filters);
      state = FinancialDailyPlLoaded(
        totals: data['totals'] as Map<String, dynamic>,
        daily: (data['daily'] as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      if (state is! FinancialDailyPlLoaded) state = FinancialDailyPlError(message: e.toString());
    }
  }
}

// ─── Financial: Expenses ─────────────────────────────────────

final financialExpensesProvider = StateNotifierProvider<FinancialExpensesNotifier, FinancialExpensesState>((ref) {
  return FinancialExpensesNotifier(ref.watch(reportRepositoryProvider));
});

class FinancialExpensesNotifier extends StateNotifier<FinancialExpensesState> {

  FinancialExpensesNotifier(this._repo) : super(const FinancialExpensesInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! FinancialExpensesLoaded) state = const FinancialExpensesLoading();
    try {
      final data = await _repo.getFinancialExpenses(filters: filters);
      state = FinancialExpensesLoaded(
        totalExpenses: double.tryParse(data['total_expenses'].toString()) ?? 0.0,
        categories: (data['categories'] as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      if (state is! FinancialExpensesLoaded) state = FinancialExpensesError(message: e.toString());
    }
  }
}

// ─── Financial: Cash Variance ────────────────────────────────

final cashVarianceProvider = StateNotifierProvider<CashVarianceNotifier, CashVarianceState>((ref) {
  return CashVarianceNotifier(ref.watch(reportRepositoryProvider));
});

class CashVarianceNotifier extends StateNotifier<CashVarianceState> {

  CashVarianceNotifier(this._repo) : super(const CashVarianceInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! CashVarianceLoaded) state = const CashVarianceLoading();
    try {
      final data = await _repo.getFinancialCashVariance(filters: filters);
      state = CashVarianceLoaded(data: data);
    } catch (e) {
      if (state is! CashVarianceLoaded) state = CashVarianceError(message: e.toString());
    }
  }
}

// ─── Top Customers ───────────────────────────────────────────

final topCustomersProvider = StateNotifierProvider<TopCustomersNotifier, TopCustomersState>((ref) {
  return TopCustomersNotifier(ref.watch(reportRepositoryProvider));
});

class TopCustomersNotifier extends StateNotifier<TopCustomersState> {

  TopCustomersNotifier(this._repo) : super(const TopCustomersInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! TopCustomersLoaded) state = const TopCustomersLoading();
    try {
      final data = await _repo.getTopCustomers(filters: filters);
      state = TopCustomersLoaded(customers: data);
    } catch (e) {
      if (state is! TopCustomersLoaded) state = TopCustomersError(message: e.toString());
    }
  }
}

// ─── Customer Retention ──────────────────────────────────────

final customerRetentionProvider = StateNotifierProvider<CustomerRetentionNotifier, CustomerRetentionState>((ref) {
  return CustomerRetentionNotifier(ref.watch(reportRepositoryProvider));
});

class CustomerRetentionNotifier extends StateNotifier<CustomerRetentionState> {

  CustomerRetentionNotifier(this._repo) : super(const CustomerRetentionInitial());
  final ReportRepository _repo;

  Future<void> load({ReportFilters filters = const ReportFilters()}) async {
    if (state is! CustomerRetentionLoaded) state = const CustomerRetentionLoading();
    try {
      final data = await _repo.getCustomerRetention(filters: filters);
      state = CustomerRetentionLoaded(data: data);
    } catch (e) {
      if (state is! CustomerRetentionLoaded) state = CustomerRetentionError(message: e.toString());
    }
  }
}
