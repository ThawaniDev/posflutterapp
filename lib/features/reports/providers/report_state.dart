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

  const SalesSummaryLoaded({
    required this.totals,
    required this.daily,
    this.previousPeriod,
  });
  final Map<String, dynamic> totals;
  final List<Map<String, dynamic>> daily;
  final Map<String, dynamic>? previousPeriod;
}

class SalesSummaryError extends SalesSummaryState {
  const SalesSummaryError({required this.message});
  final String message;
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
  const ProductPerformanceLoaded({required this.products});
  final List<Map<String, dynamic>> products;
}

class ProductPerformanceError extends ProductPerformanceState {
  const ProductPerformanceError({required this.message});
  final String message;
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
  const CategoryBreakdownLoaded({required this.categories});
  final List<Map<String, dynamic>> categories;
}

class CategoryBreakdownError extends CategoryBreakdownState {
  const CategoryBreakdownError({required this.message});
  final String message;
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
  const StaffPerformanceLoaded({required this.staff});
  final List<Map<String, dynamic>> staff;
}

class StaffPerformanceError extends StaffPerformanceState {
  const StaffPerformanceError({required this.message});
  final String message;
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
  const HourlySalesLoaded({required this.hours});
  final List<Map<String, dynamic>> hours;
}

class HourlySalesError extends HourlySalesState {
  const HourlySalesError({required this.message});
  final String message;
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
  const PaymentMethodsLoaded({required this.methods});
  final List<Map<String, dynamic>> methods;
}

class PaymentMethodsError extends PaymentMethodsState {
  const PaymentMethodsError({required this.message});
  final String message;
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

  const DashboardLoaded({required this.today, required this.yesterday, required this.topProducts});
  final Map<String, dynamic> today;
  final Map<String, dynamic> yesterday;
  final List<Map<String, dynamic>> topProducts;
}

class DashboardError extends DashboardState {
  const DashboardError({required this.message});
  final String message;
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
  const InventoryValuationLoaded({required this.data});
  final Map<String, dynamic> data;
}

class InventoryValuationError extends InventoryValuationState {
  const InventoryValuationError({required this.message});
  final String message;
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
  const InventoryTurnoverLoaded({required this.products});
  final List<Map<String, dynamic>> products;
}

class InventoryTurnoverError extends InventoryTurnoverState {
  const InventoryTurnoverError({required this.message});
  final String message;
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
  const InventoryShrinkageLoaded({required this.data});
  final Map<String, dynamic> data;
}

class InventoryShrinkageError extends InventoryShrinkageState {
  const InventoryShrinkageError({required this.message});
  final String message;
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
  const InventoryLowStockLoaded({required this.products});
  final List<Map<String, dynamic>> products;
}

class InventoryLowStockError extends InventoryLowStockState {
  const InventoryLowStockError({required this.message});
  final String message;
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
  const FinancialDailyPlLoaded({required this.totals, required this.daily});
  final Map<String, dynamic> totals;
  final List<Map<String, dynamic>> daily;
}

class FinancialDailyPlError extends FinancialDailyPlState {
  const FinancialDailyPlError({required this.message});
  final String message;
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
  const FinancialExpensesLoaded({required this.totalExpenses, required this.categories});
  final double totalExpenses;
  final List<Map<String, dynamic>> categories;
}

class FinancialExpensesError extends FinancialExpensesState {
  const FinancialExpensesError({required this.message});
  final String message;
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
  const CashVarianceLoaded({required this.data});
  final Map<String, dynamic> data;
}

class CashVarianceError extends CashVarianceState {
  const CashVarianceError({required this.message});
  final String message;
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
  const TopCustomersLoaded({required this.customers});
  final List<Map<String, dynamic>> customers;
}

class TopCustomersError extends TopCustomersState {
  const TopCustomersError({required this.message});
  final String message;
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
  const CustomerRetentionLoaded({required this.data});
  final Map<String, dynamic> data;
}

class CustomerRetentionError extends CustomerRetentionState {
  const CustomerRetentionError({required this.message});
  final String message;
}

// Inventory Expiry
sealed class InventoryExpiryState {
  const InventoryExpiryState();
}

class InventoryExpiryInitial extends InventoryExpiryState {
  const InventoryExpiryInitial();
}

class InventoryExpiryLoading extends InventoryExpiryState {
  const InventoryExpiryLoading();
}

class InventoryExpiryLoaded extends InventoryExpiryState {
  const InventoryExpiryLoaded({required this.data});
  final Map<String, dynamic> data;
}

class InventoryExpiryError extends InventoryExpiryState {
  const InventoryExpiryError({required this.message});
  final String message;
}

// Delivery Commission
sealed class DeliveryCommissionState {
  const DeliveryCommissionState();
}

class DeliveryCommissionInitial extends DeliveryCommissionState {
  const DeliveryCommissionInitial();
}

class DeliveryCommissionLoading extends DeliveryCommissionState {
  const DeliveryCommissionLoading();
}

class DeliveryCommissionLoaded extends DeliveryCommissionState {
  const DeliveryCommissionLoaded({required this.data});
  final Map<String, dynamic> data;
}

class DeliveryCommissionError extends DeliveryCommissionState {
  const DeliveryCommissionError({required this.message});
  final String message;
}

// Report Export
sealed class ReportExportState {
  const ReportExportState();
}

class ReportExportInitial extends ReportExportState {
  const ReportExportInitial();
}

class ReportExportLoading extends ReportExportState {
  const ReportExportLoading();
}

class ReportExportSuccess extends ReportExportState {
  const ReportExportSuccess({required this.reportType, required this.format});
  final String reportType;
  final String format;
}

class ReportExportError extends ReportExportState {
  const ReportExportError({required this.message});
  final String message;
}

// Scheduled Reports
sealed class ScheduledReportsState {
  const ScheduledReportsState();
}

class ScheduledReportsInitial extends ScheduledReportsState {
  const ScheduledReportsInitial();
}

class ScheduledReportsLoading extends ScheduledReportsState {
  const ScheduledReportsLoading();
}

class ScheduledReportsLoaded extends ScheduledReportsState {
  const ScheduledReportsLoaded({required this.schedules});
  final List<Map<String, dynamic>> schedules;
}

class ScheduledReportsError extends ScheduledReportsState {
  const ScheduledReportsError({required this.message});
  final String message;
}

// Slow Movers
sealed class SlowMoversState {
  const SlowMoversState();
}

class SlowMoversInitial extends SlowMoversState {
  const SlowMoversInitial();
}

class SlowMoversLoading extends SlowMoversState {
  const SlowMoversLoading();
}

class SlowMoversLoaded extends SlowMoversState {
  const SlowMoversLoaded({required this.products});
  final List<Map<String, dynamic>> products;
}

class SlowMoversError extends SlowMoversState {
  const SlowMoversError({required this.message});
  final String message;
}

// Product Margin
sealed class ProductMarginState {
  const ProductMarginState();
}

class ProductMarginInitial extends ProductMarginState {
  const ProductMarginInitial();
}

class ProductMarginLoading extends ProductMarginState {
  const ProductMarginLoading();
}

class ProductMarginLoaded extends ProductMarginState {
  const ProductMarginLoaded({required this.products});
  final List<Map<String, dynamic>> products;
}

class ProductMarginError extends ProductMarginState {
  const ProductMarginError({required this.message});
  final String message;
}
