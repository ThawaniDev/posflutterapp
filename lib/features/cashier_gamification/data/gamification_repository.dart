import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/cashier_gamification/data/gamification_api_service.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_anomaly.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_badge.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_badge_award.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_shift_report.dart';
import 'package:wameedpos/features/cashier_gamification/models/gamification_settings.dart';

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepository(ref.watch(gamificationApiServiceProvider));
});

class GamificationRepository {

  GamificationRepository(this._api);
  final GamificationApiService _api;

  // ─── Leaderboard ──────────────────────────────────────────────
  Future<List<CashierPerformanceSnapshot>> getLeaderboard({String? date, String? periodType, String? sortBy}) =>
      _api.getLeaderboard(date: date, periodType: periodType, sortBy: sortBy);

  Future<List<CashierPerformanceSnapshot>> getCashierHistory(String cashierId, {String? dateFrom, String? dateTo}) =>
      _api.getCashierHistory(cashierId, dateFrom: dateFrom, dateTo: dateTo);

  Future<void> generateSnapshot({String? posSessionId}) => _api.generateSnapshot(posSessionId: posSessionId);

  // ─── Badges ───────────────────────────────────────────────────
  Future<List<CashierBadge>> getBadges() => _api.getBadges();
  Future<CashierBadge> createBadge(Map<String, dynamic> data) => _api.createBadge(data);
  Future<CashierBadge> updateBadge(String badgeId, Map<String, dynamic> data) => _api.updateBadge(badgeId, data);
  Future<void> deleteBadge(String badgeId) => _api.deleteBadge(badgeId);
  Future<void> seedBadges() => _api.seedBadges();

  // ─── Badge Awards ─────────────────────────────────────────────
  Future<List<CashierBadgeAward>> getBadgeAwards({String? cashierId}) => _api.getBadgeAwards(cashierId: cashierId);

  // ─── Anomalies ────────────────────────────────────────────────
  Future<List<CashierAnomaly>> getAnomalies({String? severity, String? cashierId}) =>
      _api.getAnomalies(severity: severity, cashierId: cashierId);
  Future<CashierAnomaly> reviewAnomaly(String anomalyId, {required String reviewNotes, required bool confirmed}) =>
      _api.reviewAnomaly(anomalyId, reviewNotes: reviewNotes, confirmed: confirmed);

  // ─── Shift Reports ────────────────────────────────────────────
  Future<List<CashierShiftReport>> getShiftReports({String? cashierId, String? dateFrom, String? dateTo}) =>
      _api.getShiftReports(cashierId: cashierId, dateFrom: dateFrom, dateTo: dateTo);
  Future<CashierShiftReport> getShiftReport(String reportId) => _api.getShiftReport(reportId);
  Future<void> markShiftReportSent(String reportId) => _api.markShiftReportSent(reportId);

  // ─── Settings ─────────────────────────────────────────────────
  Future<GamificationSettings> getSettings() => _api.getSettings();
  Future<GamificationSettings> updateSettings(Map<String, dynamic> data) => _api.updateSettings(data);
}
