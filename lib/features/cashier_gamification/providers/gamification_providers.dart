import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/cashier_gamification/data/gamification_repository.dart';
import 'package:wameedpos/features/cashier_gamification/providers/gamification_state.dart';

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}

// ─── Leaderboard Provider ───────────────────────────────────────

final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, LeaderboardState>((ref) {
  return LeaderboardNotifier(ref.watch(gamificationRepositoryProvider));
});

class LeaderboardNotifier extends StateNotifier<LeaderboardState> {
  final GamificationRepository _repo;

  LeaderboardNotifier(this._repo) : super(const LeaderboardInitial());

  Future<void> load({String? date, String? periodType, String? sortBy}) async {
    state = const LeaderboardLoading();
    try {
      final snapshots = await _repo.getLeaderboard(date: date, periodType: periodType, sortBy: sortBy);
      state = LeaderboardLoaded(snapshots: snapshots, selectedDate: date, periodType: periodType, sortBy: sortBy);
    } on DioException catch (e) {
      state = LeaderboardError(message: _extractError(e));
    } catch (e) {
      state = LeaderboardError(message: e.toString());
    }
  }
}

// ─── Cashier History Provider ───────────────────────────────────

final cashierHistoryProvider = StateNotifierProvider<CashierHistoryNotifier, CashierHistoryState>((ref) {
  return CashierHistoryNotifier(ref.watch(gamificationRepositoryProvider));
});

class CashierHistoryNotifier extends StateNotifier<CashierHistoryState> {
  final GamificationRepository _repo;

  CashierHistoryNotifier(this._repo) : super(const CashierHistoryInitial());

  Future<void> load(String cashierId, {String? dateFrom, String? dateTo}) async {
    state = const CashierHistoryLoading();
    try {
      final history = await _repo.getCashierHistory(cashierId, dateFrom: dateFrom, dateTo: dateTo);
      state = CashierHistoryLoaded(history: history, cashierId: cashierId);
    } on DioException catch (e) {
      state = CashierHistoryError(message: _extractError(e));
    } catch (e) {
      state = CashierHistoryError(message: e.toString());
    }
  }
}

// ─── Badges Provider ────────────────────────────────────────────

final badgesProvider = StateNotifierProvider<BadgesNotifier, BadgesState>((ref) {
  return BadgesNotifier(ref.watch(gamificationRepositoryProvider));
});

class BadgesNotifier extends StateNotifier<BadgesState> {
  final GamificationRepository _repo;

  BadgesNotifier(this._repo) : super(const BadgesInitial());

  Future<void> load() async {
    state = const BadgesLoading();
    try {
      final badges = await _repo.getBadges();
      state = BadgesLoaded(badges: badges);
    } on DioException catch (e) {
      state = BadgesError(message: _extractError(e));
    } catch (e) {
      state = BadgesError(message: e.toString());
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    try {
      await _repo.createBadge(data);
      await load();
    } on DioException catch (e) {
      state = BadgesError(message: _extractError(e));
    }
  }

  Future<void> update(String badgeId, Map<String, dynamic> data) async {
    try {
      await _repo.updateBadge(badgeId, data);
      await load();
    } on DioException catch (e) {
      state = BadgesError(message: _extractError(e));
    }
  }

  Future<void> delete(String badgeId) async {
    try {
      await _repo.deleteBadge(badgeId);
      await load();
    } on DioException catch (e) {
      state = BadgesError(message: _extractError(e));
    }
  }

  Future<void> seed() async {
    try {
      await _repo.seedBadges();
      await load();
    } on DioException catch (e) {
      state = BadgesError(message: _extractError(e));
    }
  }
}

// ─── Badge Awards Provider ──────────────────────────────────────

final badgeAwardsProvider = StateNotifierProvider<BadgeAwardsNotifier, BadgeAwardsState>((ref) {
  return BadgeAwardsNotifier(ref.watch(gamificationRepositoryProvider));
});

class BadgeAwardsNotifier extends StateNotifier<BadgeAwardsState> {
  final GamificationRepository _repo;

  BadgeAwardsNotifier(this._repo) : super(const BadgeAwardsInitial());

  Future<void> load({String? cashierId}) async {
    state = const BadgeAwardsLoading();
    try {
      final awards = await _repo.getBadgeAwards(cashierId: cashierId);
      state = BadgeAwardsLoaded(awards: awards);
    } on DioException catch (e) {
      state = BadgeAwardsError(message: _extractError(e));
    } catch (e) {
      state = BadgeAwardsError(message: e.toString());
    }
  }
}

// ─── Anomalies Provider ─────────────────────────────────────────

final anomaliesProvider = StateNotifierProvider<AnomaliesNotifier, AnomaliesState>((ref) {
  return AnomaliesNotifier(ref.watch(gamificationRepositoryProvider));
});

class AnomaliesNotifier extends StateNotifier<AnomaliesState> {
  final GamificationRepository _repo;

  AnomaliesNotifier(this._repo) : super(const AnomaliesInitial());

  Future<void> load({String? severity, String? cashierId}) async {
    state = const AnomaliesLoading();
    try {
      final anomalies = await _repo.getAnomalies(severity: severity, cashierId: cashierId);
      state = AnomaliesLoaded(anomalies: anomalies, severityFilter: severity, cashierFilter: cashierId);
    } on DioException catch (e) {
      state = AnomaliesError(message: _extractError(e));
    } catch (e) {
      state = AnomaliesError(message: e.toString());
    }
  }

  Future<void> review(String anomalyId, {required String reviewNotes, required bool confirmed}) async {
    try {
      await _repo.reviewAnomaly(anomalyId, reviewNotes: reviewNotes, confirmed: confirmed);
      // Reload with current filters
      final current = state;
      if (current is AnomaliesLoaded) {
        await load(severity: current.severityFilter, cashierId: current.cashierFilter);
      } else {
        await load();
      }
    } on DioException catch (e) {
      state = AnomaliesError(message: _extractError(e));
    }
  }
}

// ─── Shift Reports Provider ─────────────────────────────────────

final shiftReportsProvider = StateNotifierProvider<ShiftReportsNotifier, ShiftReportsState>((ref) {
  return ShiftReportsNotifier(ref.watch(gamificationRepositoryProvider));
});

class ShiftReportsNotifier extends StateNotifier<ShiftReportsState> {
  final GamificationRepository _repo;

  ShiftReportsNotifier(this._repo) : super(const ShiftReportsInitial());

  Future<void> load({String? cashierId, String? dateFrom, String? dateTo}) async {
    state = const ShiftReportsLoading();
    try {
      final reports = await _repo.getShiftReports(cashierId: cashierId, dateFrom: dateFrom, dateTo: dateTo);
      state = ShiftReportsLoaded(reports: reports);
    } on DioException catch (e) {
      state = ShiftReportsError(message: _extractError(e));
    } catch (e) {
      state = ShiftReportsError(message: e.toString());
    }
  }

  Future<void> markSent(String reportId) async {
    try {
      await _repo.markShiftReportSent(reportId);
      await load();
    } on DioException catch (e) {
      state = ShiftReportsError(message: _extractError(e));
    }
  }
}

// ─── Settings Provider ──────────────────────────────────────────

final gamificationSettingsProvider = StateNotifierProvider<GamificationSettingsNotifier, GamificationSettingsState>((ref) {
  return GamificationSettingsNotifier(ref.watch(gamificationRepositoryProvider));
});

class GamificationSettingsNotifier extends StateNotifier<GamificationSettingsState> {
  final GamificationRepository _repo;

  GamificationSettingsNotifier(this._repo) : super(const GamificationSettingsInitial());

  Future<void> load() async {
    state = const GamificationSettingsLoading();
    try {
      final settings = await _repo.getSettings();
      state = GamificationSettingsLoaded(settings: settings);
    } on DioException catch (e) {
      state = GamificationSettingsError(message: _extractError(e));
    } catch (e) {
      state = GamificationSettingsError(message: e.toString());
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    try {
      final settings = await _repo.updateSettings(data);
      state = GamificationSettingsLoaded(settings: settings);
    } on DioException catch (e) {
      state = GamificationSettingsError(message: _extractError(e));
    }
  }
}
