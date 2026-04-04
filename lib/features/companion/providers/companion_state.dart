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
  final double todayRevenue;
  final int todayTransactions;
  final int todayOrders;
  final int pendingOrders;
  final int activeStaff;
  final int lowStockItems;
  final String? lastSync;
  final String currency;
  final Map<String, dynamic> raw;

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
}

class QuickStatsError extends QuickStatsState {
  final String message;
  const QuickStatsError(this.message);
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
  final String theme;
  final String language;
  final bool compactMode;
  final bool notificationsEnabled;
  final bool biometricLock;
  final String defaultPage;
  final String currencyDisplay;
  final Map<String, dynamic> raw;

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
}

class PreferencesError extends PreferencesState {
  final String message;
  const PreferencesError(this.message);
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
  final List<Map<String, dynamic>> actions;

  const QuickActionsLoaded({required this.actions});
}

class QuickActionsError extends QuickActionsState {
  final String message;
  const QuickActionsError(this.message);
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
  final String operation;
  const CompanionOperationRunning(this.operation);
}

class CompanionOperationSuccess extends CompanionOperationState {
  final String message;
  final Map<String, dynamic>? data;
  const CompanionOperationSuccess(this.message, {this.data});
}

class CompanionOperationError extends CompanionOperationState {
  final String message;
  const CompanionOperationError(this.message);
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
}

class CompanionDashboardError extends CompanionDashboardState {
  final String message;
  const CompanionDashboardError(this.message);
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
  final String period;
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final List<Map<String, dynamic>> dailyBreakdown;
  final Map<String, dynamic> raw;

  const SalesSummaryLoaded({
    required this.period,
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.dailyBreakdown,
    required this.raw,
  });
}

class SalesSummaryError extends SalesSummaryState {
  final String message;
  const SalesSummaryError(this.message);
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
  final List<Map<String, dynamic>> orders;
  final int total;

  const ActiveOrdersLoaded({required this.orders, required this.total});
}

class ActiveOrdersError extends ActiveOrdersState {
  final String message;
  const ActiveOrdersError(this.message);
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
  final List<Map<String, dynamic>> alerts;
  final int lowStockCount;
  final int outOfStockCount;

  const InventoryAlertsLoaded({required this.alerts, required this.lowStockCount, required this.outOfStockCount});
}

class InventoryAlertsError extends InventoryAlertsState {
  final String message;
  const InventoryAlertsError(this.message);
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
  final List<Map<String, dynamic>> staff;
  final int totalActive;

  const ActiveStaffLoaded({required this.staff, required this.totalActive});
}

class ActiveStaffError extends ActiveStaffState {
  final String message;
  const ActiveStaffError(this.message);
}
