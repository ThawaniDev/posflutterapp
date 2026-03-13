// ─── Report States ───────────────────────────────────────────

// Sales Summary
sealed class SalesSummaryState {
  const SalesSummaryState();
}

class SalesSummaryInitial extends SalesSummaryState {
  const SalesSummaryInitial();
}

class SalesSummaryLoading extends SalesSummaryState {
  const SalesSummaryLoading();
}

class SalesSummaryLoaded extends SalesSummaryState {
  final Map<String, dynamic> totals;
  final List<Map<String, dynamic>> daily;

  const SalesSummaryLoaded({required this.totals, required this.daily});
}

class SalesSummaryError extends SalesSummaryState {
  final String message;
  const SalesSummaryError({required this.message});
}

// Product Performance
sealed class ProductPerformanceState {
  const ProductPerformanceState();
}

class ProductPerformanceInitial extends ProductPerformanceState {
  const ProductPerformanceInitial();
}

class ProductPerformanceLoading extends ProductPerformanceState {
  const ProductPerformanceLoading();
}

class ProductPerformanceLoaded extends ProductPerformanceState {
  final List<Map<String, dynamic>> products;
  const ProductPerformanceLoaded({required this.products});
}

class ProductPerformanceError extends ProductPerformanceState {
  final String message;
  const ProductPerformanceError({required this.message});
}

// Category Breakdown
sealed class CategoryBreakdownState {
  const CategoryBreakdownState();
}

class CategoryBreakdownInitial extends CategoryBreakdownState {
  const CategoryBreakdownInitial();
}

class CategoryBreakdownLoading extends CategoryBreakdownState {
  const CategoryBreakdownLoading();
}

class CategoryBreakdownLoaded extends CategoryBreakdownState {
  final List<Map<String, dynamic>> categories;
  const CategoryBreakdownLoaded({required this.categories});
}

class CategoryBreakdownError extends CategoryBreakdownState {
  final String message;
  const CategoryBreakdownError({required this.message});
}

// Staff Performance
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

// Hourly Sales
sealed class HourlySalesState {
  const HourlySalesState();
}

class HourlySalesInitial extends HourlySalesState {
  const HourlySalesInitial();
}

class HourlySalesLoading extends HourlySalesState {
  const HourlySalesLoading();
}

class HourlySalesLoaded extends HourlySalesState {
  final List<Map<String, dynamic>> hours;
  const HourlySalesLoaded({required this.hours});
}

class HourlySalesError extends HourlySalesState {
  final String message;
  const HourlySalesError({required this.message});
}

// Payment Methods
sealed class PaymentMethodsState {
  const PaymentMethodsState();
}

class PaymentMethodsInitial extends PaymentMethodsState {
  const PaymentMethodsInitial();
}

class PaymentMethodsLoading extends PaymentMethodsState {
  const PaymentMethodsLoading();
}

class PaymentMethodsLoaded extends PaymentMethodsState {
  final List<Map<String, dynamic>> methods;
  const PaymentMethodsLoaded({required this.methods});
}

class PaymentMethodsError extends PaymentMethodsState {
  final String message;
  const PaymentMethodsError({required this.message});
}

// Dashboard
sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final Map<String, dynamic> today;
  final Map<String, dynamic> yesterday;
  final List<Map<String, dynamic>> topProducts;

  const DashboardLoaded({required this.today, required this.yesterday, required this.topProducts});
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
}
