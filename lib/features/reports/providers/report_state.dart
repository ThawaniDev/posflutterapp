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

// Inventory Valuation
sealed class InventoryValuationState {
  const InventoryValuationState();
}

class InventoryValuationInitial extends InventoryValuationState {
  const InventoryValuationInitial();
}

class InventoryValuationLoading extends InventoryValuationState {
  const InventoryValuationLoading();
}

class InventoryValuationLoaded extends InventoryValuationState {
  final Map<String, dynamic> data;
  const InventoryValuationLoaded({required this.data});
}

class InventoryValuationError extends InventoryValuationState {
  final String message;
  const InventoryValuationError({required this.message});
}

// Inventory Turnover
sealed class InventoryTurnoverState {
  const InventoryTurnoverState();
}

class InventoryTurnoverInitial extends InventoryTurnoverState {
  const InventoryTurnoverInitial();
}

class InventoryTurnoverLoading extends InventoryTurnoverState {
  const InventoryTurnoverLoading();
}

class InventoryTurnoverLoaded extends InventoryTurnoverState {
  final List<Map<String, dynamic>> products;
  const InventoryTurnoverLoaded({required this.products});
}

class InventoryTurnoverError extends InventoryTurnoverState {
  final String message;
  const InventoryTurnoverError({required this.message});
}

// Inventory Shrinkage
sealed class InventoryShrinkageState {
  const InventoryShrinkageState();
}

class InventoryShrinkageInitial extends InventoryShrinkageState {
  const InventoryShrinkageInitial();
}

class InventoryShrinkageLoading extends InventoryShrinkageState {
  const InventoryShrinkageLoading();
}

class InventoryShrinkageLoaded extends InventoryShrinkageState {
  final Map<String, dynamic> data;
  const InventoryShrinkageLoaded({required this.data});
}

class InventoryShrinkageError extends InventoryShrinkageState {
  final String message;
  const InventoryShrinkageError({required this.message});
}

// Inventory Low Stock
sealed class InventoryLowStockState {
  const InventoryLowStockState();
}

class InventoryLowStockInitial extends InventoryLowStockState {
  const InventoryLowStockInitial();
}

class InventoryLowStockLoading extends InventoryLowStockState {
  const InventoryLowStockLoading();
}

class InventoryLowStockLoaded extends InventoryLowStockState {
  final List<Map<String, dynamic>> products;
  const InventoryLowStockLoaded({required this.products});
}

class InventoryLowStockError extends InventoryLowStockState {
  final String message;
  const InventoryLowStockError({required this.message});
}

// Financial Daily P&L
sealed class FinancialDailyPlState {
  const FinancialDailyPlState();
}

class FinancialDailyPlInitial extends FinancialDailyPlState {
  const FinancialDailyPlInitial();
}

class FinancialDailyPlLoading extends FinancialDailyPlState {
  const FinancialDailyPlLoading();
}

class FinancialDailyPlLoaded extends FinancialDailyPlState {
  final Map<String, dynamic> totals;
  final List<Map<String, dynamic>> daily;
  const FinancialDailyPlLoaded({required this.totals, required this.daily});
}

class FinancialDailyPlError extends FinancialDailyPlState {
  final String message;
  const FinancialDailyPlError({required this.message});
}

// Financial Expenses
sealed class FinancialExpensesState {
  const FinancialExpensesState();
}

class FinancialExpensesInitial extends FinancialExpensesState {
  const FinancialExpensesInitial();
}

class FinancialExpensesLoading extends FinancialExpensesState {
  const FinancialExpensesLoading();
}

class FinancialExpensesLoaded extends FinancialExpensesState {
  final double totalExpenses;
  final List<Map<String, dynamic>> categories;
  const FinancialExpensesLoaded({required this.totalExpenses, required this.categories});
}

class FinancialExpensesError extends FinancialExpensesState {
  final String message;
  const FinancialExpensesError({required this.message});
}

// Financial Cash Variance
sealed class CashVarianceState {
  const CashVarianceState();
}

class CashVarianceInitial extends CashVarianceState {
  const CashVarianceInitial();
}

class CashVarianceLoading extends CashVarianceState {
  const CashVarianceLoading();
}

class CashVarianceLoaded extends CashVarianceState {
  final Map<String, dynamic> data;
  const CashVarianceLoaded({required this.data});
}

class CashVarianceError extends CashVarianceState {
  final String message;
  const CashVarianceError({required this.message});
}

// Top Customers
sealed class TopCustomersState {
  const TopCustomersState();
}

class TopCustomersInitial extends TopCustomersState {
  const TopCustomersInitial();
}

class TopCustomersLoading extends TopCustomersState {
  const TopCustomersLoading();
}

class TopCustomersLoaded extends TopCustomersState {
  final List<Map<String, dynamic>> customers;
  const TopCustomersLoaded({required this.customers});
}

class TopCustomersError extends TopCustomersState {
  final String message;
  const TopCustomersError({required this.message});
}

// Customer Retention
sealed class CustomerRetentionState {
  const CustomerRetentionState();
}

class CustomerRetentionInitial extends CustomerRetentionState {
  const CustomerRetentionInitial();
}

class CustomerRetentionLoading extends CustomerRetentionState {
  const CustomerRetentionLoading();
}

class CustomerRetentionLoaded extends CustomerRetentionState {
  final Map<String, dynamic> data;
  const CustomerRetentionLoaded({required this.data});
}

class CustomerRetentionError extends CustomerRetentionState {
  final String message;
  const CustomerRetentionError({required this.message});
}
