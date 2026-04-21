import 'package:wameedpos/features/cashier_gamification/models/cashier_anomaly.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_badge.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_badge_award.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_shift_report.dart';
import 'package:wameedpos/features/cashier_gamification/models/gamification_settings.dart';

// ─── Leaderboard State ──────────────────────────────────────────

sealed class LeaderboardState {
  const LeaderboardState();
}

class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading();
}

class LeaderboardLoaded extends LeaderboardState {
  const LeaderboardLoaded({required this.snapshots, this.selectedDate, this.periodType, this.sortBy});
  final List<CashierPerformanceSnapshot> snapshots;
  final String? selectedDate;
  final String? periodType;
  final String? sortBy;
}

class LeaderboardError extends LeaderboardState {
  const LeaderboardError({required this.message});
  final String message;
}

// ─── Cashier History State ──────────────────────────────────────

sealed class CashierHistoryState {
  const CashierHistoryState();
}

class CashierHistoryInitial extends CashierHistoryState {
  const CashierHistoryInitial();
}

class CashierHistoryLoading extends CashierHistoryState {
  const CashierHistoryLoading();
}

class CashierHistoryLoaded extends CashierHistoryState {
  const CashierHistoryLoaded({required this.history, required this.cashierId});
  final List<CashierPerformanceSnapshot> history;
  final String cashierId;
}

class CashierHistoryError extends CashierHistoryState {
  const CashierHistoryError({required this.message});
  final String message;
}

// ─── Badges State ───────────────────────────────────────────────

sealed class BadgesState {
  const BadgesState();
}

class BadgesInitial extends BadgesState {
  const BadgesInitial();
}

class BadgesLoading extends BadgesState {
  const BadgesLoading();
}

class BadgesLoaded extends BadgesState {
  const BadgesLoaded({required this.badges});
  final List<CashierBadge> badges;
}

class BadgesError extends BadgesState {
  const BadgesError({required this.message});
  final String message;
}

// ─── Badge Awards State ─────────────────────────────────────────

sealed class BadgeAwardsState {
  const BadgeAwardsState();
}

class BadgeAwardsInitial extends BadgeAwardsState {
  const BadgeAwardsInitial();
}

class BadgeAwardsLoading extends BadgeAwardsState {
  const BadgeAwardsLoading();
}

class BadgeAwardsLoaded extends BadgeAwardsState {
  const BadgeAwardsLoaded({required this.awards});
  final List<CashierBadgeAward> awards;
}

class BadgeAwardsError extends BadgeAwardsState {
  const BadgeAwardsError({required this.message});
  final String message;
}

// ─── Anomalies State ────────────────────────────────────────────

sealed class AnomaliesState {
  const AnomaliesState();
}

class AnomaliesInitial extends AnomaliesState {
  const AnomaliesInitial();
}

class AnomaliesLoading extends AnomaliesState {
  const AnomaliesLoading();
}

class AnomaliesLoaded extends AnomaliesState {
  const AnomaliesLoaded({required this.anomalies, this.severityFilter, this.cashierFilter});
  final List<CashierAnomaly> anomalies;
  final String? severityFilter;
  final String? cashierFilter;
}

class AnomaliesError extends AnomaliesState {
  const AnomaliesError({required this.message});
  final String message;
}

// ─── Shift Reports State ────────────────────────────────────────

sealed class ShiftReportsState {
  const ShiftReportsState();
}

class ShiftReportsInitial extends ShiftReportsState {
  const ShiftReportsInitial();
}

class ShiftReportsLoading extends ShiftReportsState {
  const ShiftReportsLoading();
}

class ShiftReportsLoaded extends ShiftReportsState {
  const ShiftReportsLoaded({required this.reports});
  final List<CashierShiftReport> reports;
}

class ShiftReportsError extends ShiftReportsState {
  const ShiftReportsError({required this.message});
  final String message;
}

// ─── Settings State ─────────────────────────────────────────────

sealed class GamificationSettingsState {
  const GamificationSettingsState();
}

class GamificationSettingsInitial extends GamificationSettingsState {
  const GamificationSettingsInitial();
}

class GamificationSettingsLoading extends GamificationSettingsState {
  const GamificationSettingsLoading();
}

class GamificationSettingsLoaded extends GamificationSettingsState {
  const GamificationSettingsLoaded({required this.settings});
  final GamificationSettings settings;
}

class GamificationSettingsError extends GamificationSettingsState {
  const GamificationSettingsError({required this.message});
  final String message;
}
