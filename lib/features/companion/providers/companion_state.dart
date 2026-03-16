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
