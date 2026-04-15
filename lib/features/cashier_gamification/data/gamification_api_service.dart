import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_anomaly.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_badge.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_badge_award.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_performance_snapshot.dart';
import 'package:wameedpos/features/cashier_gamification/models/cashier_shift_report.dart';
import 'package:wameedpos/features/cashier_gamification/models/gamification_settings.dart';

final gamificationApiServiceProvider = Provider<GamificationApiService>((ref) {
  return GamificationApiService(ref.watch(dioClientProvider));
});

class GamificationApiService {
  final Dio _dio;

  GamificationApiService(this._dio);

  // ─── Leaderboard ──────────────────────────────────────────────

  Future<List<CashierPerformanceSnapshot>> getLeaderboard({String? date, String? periodType, String? sortBy}) async {
    final response = await _dio.get(
      ApiEndpoints.gamificationLeaderboard,
      queryParameters: {
        if (date != null) 'date': date,
        if (periodType != null) 'period_type': periodType,
        if (sortBy != null) 'sort_by': sortBy,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CashierPerformanceSnapshot.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<CashierPerformanceSnapshot>> getCashierHistory(String cashierId, {String? dateFrom, String? dateTo}) async {
    final response = await _dio.get(
      ApiEndpoints.gamificationCashierHistory(cashierId),
      queryParameters: {if (dateFrom != null) 'date_from': dateFrom, if (dateTo != null) 'date_to': dateTo},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CashierPerformanceSnapshot.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> generateSnapshot({String? posSessionId}) async {
    await _dio.post(ApiEndpoints.gamificationGenerateSnapshot, data: {if (posSessionId != null) 'pos_session_id': posSessionId});
  }

  // ─── Badges ───────────────────────────────────────────────────

  Future<List<CashierBadge>> getBadges() async {
    final response = await _dio.get(ApiEndpoints.gamificationBadges);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CashierBadge.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<CashierBadge> createBadge(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.gamificationBadges, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashierBadge.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<CashierBadge> updateBadge(String badgeId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.gamificationBadge(badgeId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashierBadge.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteBadge(String badgeId) async {
    await _dio.delete(ApiEndpoints.gamificationBadge(badgeId));
  }

  Future<void> seedBadges() async {
    await _dio.post(ApiEndpoints.gamificationBadgesSeed);
  }

  // ─── Badge Awards ─────────────────────────────────────────────

  Future<List<CashierBadgeAward>> getBadgeAwards({String? cashierId}) async {
    final response = await _dio.get(
      ApiEndpoints.gamificationBadgeAwards,
      queryParameters: {if (cashierId != null) 'cashier_id': cashierId},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CashierBadgeAward.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Anomalies ────────────────────────────────────────────────

  Future<List<CashierAnomaly>> getAnomalies({String? severity, String? cashierId}) async {
    final response = await _dio.get(
      ApiEndpoints.gamificationAnomalies,
      queryParameters: {if (severity != null) 'severity': severity, if (cashierId != null) 'cashier_id': cashierId},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CashierAnomaly.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<CashierAnomaly> reviewAnomaly(String anomalyId, {required String reviewNotes, required bool confirmed}) async {
    final response = await _dio.post(
      ApiEndpoints.gamificationAnomalyReview(anomalyId),
      data: {'review_notes': reviewNotes, 'confirmed': confirmed},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashierAnomaly.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Shift Reports ────────────────────────────────────────────

  Future<List<CashierShiftReport>> getShiftReports({String? cashierId, String? dateFrom, String? dateTo}) async {
    final response = await _dio.get(
      ApiEndpoints.gamificationShiftReports,
      queryParameters: {
        if (cashierId != null) 'cashier_id': cashierId,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CashierShiftReport.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<CashierShiftReport> getShiftReport(String reportId) async {
    final response = await _dio.get(ApiEndpoints.gamificationShiftReport(reportId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashierShiftReport.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> markShiftReportSent(String reportId) async {
    await _dio.post(ApiEndpoints.gamificationShiftReportMarkSent(reportId));
  }

  // ─── Settings ─────────────────────────────────────────────────

  Future<GamificationSettings> getSettings() async {
    final response = await _dio.get(ApiEndpoints.gamificationSettings);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return GamificationSettings.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<GamificationSettings> updateSettings(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.gamificationSettings, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return GamificationSettings.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
