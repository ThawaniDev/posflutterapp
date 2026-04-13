import 'package:thawani_pos/features/cashier_gamification/models/cashier_anomaly.dart';
import 'package:thawani_pos/features/cashier_gamification/models/cashier_badge.dart';
import 'package:thawani_pos/features/cashier_gamification/models/cashier_badge_award.dart';
import 'package:thawani_pos/features/cashier_gamification/models/cashier_performance_snapshot.dart';
import 'package:thawani_pos/features/cashier_gamification/models/cashier_shift_report.dart';
import 'package:thawani_pos/features/cashier_gamification/models/gamification_settings.dart';

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
  final List<CashierPerformanceSnapshot> snapshots;
  final String? selectedDate;
  final String? periodType;
  final String? sortBy;
  const LeaderboardLoaded({required this.snapshots, this.selectedDate, this.periodType, this.sortBy});
}

class LeaderboardError extends LeaderboardState {
  final String message;
  const LeaderboardError({required this.message});
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
  final List<CashierPerformanceSnapshot> history;
  final String cashierId;
  const CashierHistoryLoaded({required this.history, required this.cashierId});
}

class CashierHistoryError extends CashierHistoryState {
  final String message;
  const CashierHistoryError({required this.message});
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
  final List<CashierBadge> badges;
  const BadgesLoaded({required this.badges});
}

class BadgesError extends BadgesState {
  final String message;
  const BadgesError({required this.message});
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
  final List<CashierBadgeAward> awards;
  const BadgeAwardsLoaded({required this.awards});
}

class BadgeAwardsError extends BadgeAwardsState {
  final String message;
  const BadgeAwardsError({required this.message});
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
  final List<CashierAnomaly> anomalies;
  final String? severityFilter;
  final String? cashierFilter;
  const AnomaliesLoaded({required this.anomalies, this.severityFilter, this.cashierFilter});
}

class AnomaliesError extends AnomaliesState {
  final String message;
  const AnomaliesError({required this.message});
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
  final List<CashierShiftReport> reports;
  const ShiftReportsLoaded({required this.reports});
}

class ShiftReportsError extends ShiftReportsState {
  final String message;
  const ShiftReportsError({required this.message});
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
  final GamificationSettings settings;
  const GamificationSettingsLoaded({required this.settings});
}

class GamificationSettingsError extends GamificationSettingsState {
  final String message;
  const GamificationSettingsError({required this.message});
}
