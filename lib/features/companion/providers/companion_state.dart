import 'package:flutter/foundation.dart';

// --- Quick Stats ---
@immutable
sealed class QuickStatsState {
  const QuickStatsState();
}

class QuickStatsInitial extends QuickStatsState {
  const QuickStatsInitial();
}

class QuickStatsLoading extends QuickStatsState {
  const QuickStatsLoading();
}

class QuickStatsLoaded extends QuickStatsState {

  const QuickStatsLoaded({
    required this.todayRevenue,
    required this.todayTransactions,
    required this.todayOrders,
    required this.pendingOrders,
    required this.activeStaff,
    required this.lowStockItems,
    this.lastSync,
    required this.currency,
    required this.raw,
  });
  final double todayRevenue;
  final int todayTransactions;
  final int todayOrders;
  final int pendingOrders;
  final int activeStaff;
  final int lowStockItems;
  final String? lastSync;
  final String currency;
  final Map<String, dynamic> raw;
}

class QuickStatsError extends QuickStatsState {
  const QuickStatsError(this.message);
  final String message;
}

// --- Preferences ---
@immutable
sealed class PreferencesState {
  const PreferencesState();
}

class PreferencesInitial extends PreferencesState {
  const PreferencesInitial();
}

class PreferencesLoading extends PreferencesState {
  const PreferencesLoading();
}

class PreferencesLoaded extends PreferencesState {

  const PreferencesLoaded({
    required this.theme,
    required this.language,
    required this.compactMode,
    required this.notificationsEnabled,
    required this.biometricLock,
    required this.defaultPage,
    required this.currencyDisplay,
    required this.raw,
  });
  final String theme;
  final String language;
  final bool compactMode;
  final bool notificationsEnabled;
  final bool biometricLock;
  final String defaultPage;
  final String currencyDisplay;
  final Map<String, dynamic> raw;
}

class PreferencesError extends PreferencesState {
  const PreferencesError(this.message);
  final String message;
}

// --- Quick Actions ---
@immutable
sealed class QuickActionsState {
  const QuickActionsState();
}

class QuickActionsInitial extends QuickActionsState {
  const QuickActionsInitial();
}

class QuickActionsLoading extends QuickActionsState {
  const QuickActionsLoading();
}

class QuickActionsLoaded extends QuickActionsState {

  const QuickActionsLoaded({required this.actions});
  final List<Map<String, dynamic>> actions;
}

class QuickActionsError extends QuickActionsState {
  const QuickActionsError(this.message);
  final String message;
}

// --- Companion Operation ---
@immutable
sealed class CompanionOperationState {
  const CompanionOperationState();
}

class CompanionOperationIdle extends CompanionOperationState {
  const CompanionOperationIdle();
}

class CompanionOperationRunning extends CompanionOperationState {
  const CompanionOperationRunning(this.operation);
  final String operation;
}

class CompanionOperationSuccess extends CompanionOperationState {
  const CompanionOperationSuccess(this.message, {this.data});
  final String message;
  final Map<String, dynamic>? data;
}

class CompanionOperationError extends CompanionOperationState {
  const CompanionOperationError(this.message);
  final String message;
}

// --- Companion Dashboard ---
@immutable
sealed class CompanionDashboardState {
  const CompanionDashboardState();
}

class CompanionDashboardInitial extends CompanionDashboardState {
  const CompanionDashboardInitial();
}

class CompanionDashboardLoading extends CompanionDashboardState {
  const CompanionDashboardLoading();
}

class CompanionDashboardLoaded extends CompanionDashboardState {

  const CompanionDashboardLoaded({
    required this.todayRevenue,
    required this.yesterdayRevenue,
    required this.todayOrders,
    required this.yesterdayOrders,
    required this.activeStaff,
    required this.lowStockItems,
    required this.pendingOrders,
    required this.storeIsOpen,
    required this.currency,
    required this.raw,
  });
  final double todayRevenue;
  final double yesterdayRevenue;
  final int todayOrders;
  final int yesterdayOrders;
  final int activeStaff;
  final int lowStockItems;
  final int pendingOrders;
  final bool storeIsOpen;
  final String currency;
  final Map<String, dynamic> raw;
}

class CompanionDashboardError extends CompanionDashboardState {
  const CompanionDashboardError(this.message);
  final String message;
}

// --- Sales Summary ---
@immutable
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
    required this.period,
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.dailyBreakdown,
    required this.raw,
  });
  final Map<String, dynamic> period;
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final List<Map<String, dynamic>> dailyBreakdown;
  final Map<String, dynamic> raw;
}

class SalesSummaryError extends SalesSummaryState {
  const SalesSummaryError(this.message);
  final String message;
}

// --- Active Orders ---
@immutable
sealed class ActiveOrdersState {
  const ActiveOrdersState();
}

class ActiveOrdersInitial extends ActiveOrdersState {
  const ActiveOrdersInitial();
}

class ActiveOrdersLoading extends ActiveOrdersState {
  const ActiveOrdersLoading();
}

class ActiveOrdersLoaded extends ActiveOrdersState {

  const ActiveOrdersLoaded({required this.orders, required this.total});
  final List<Map<String, dynamic>> orders;
  final int total;
}

class ActiveOrdersError extends ActiveOrdersState {
  const ActiveOrdersError(this.message);
  final String message;
}

// --- Inventory Alerts ---
@immutable
sealed class InventoryAlertsState {
  const InventoryAlertsState();
}

class InventoryAlertsInitial extends InventoryAlertsState {
  const InventoryAlertsInitial();
}

class InventoryAlertsLoading extends InventoryAlertsState {
  const InventoryAlertsLoading();
}

class InventoryAlertsLoaded extends InventoryAlertsState {

  const InventoryAlertsLoaded({required this.alerts, required this.lowStockCount, required this.outOfStockCount});
  final List<Map<String, dynamic>> alerts;
  final int lowStockCount;
  final int outOfStockCount;
}

class InventoryAlertsError extends InventoryAlertsState {
  const InventoryAlertsError(this.message);
  final String message;
}

// --- Active Staff ---
@immutable
sealed class ActiveStaffState {
  const ActiveStaffState();
}

class ActiveStaffInitial extends ActiveStaffState {
  const ActiveStaffInitial();
}

class ActiveStaffLoading extends ActiveStaffState {
  const ActiveStaffLoading();
}

class ActiveStaffLoaded extends ActiveStaffState {

  const ActiveStaffLoaded({required this.staff, required this.totalActive});
  final List<Map<String, dynamic>> staff;
  final int totalActive;
}

class ActiveStaffError extends ActiveStaffState {
  const ActiveStaffError(this.message);
  final String message;
}
