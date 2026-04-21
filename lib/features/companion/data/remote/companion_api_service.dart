import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final companionApiServiceProvider = Provider<CompanionApiService>((ref) {
  return CompanionApiService(ref.watch(dioClientProvider));
});

class CompanionApiService {

  CompanionApiService(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> quickStats() async {
    final res = await _dio.get(ApiEndpoints.companionQuickStats);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> mobileSummary() async {
    final res = await _dio.get(ApiEndpoints.companionSummary);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> registerSession({
    required String deviceName,
    required String deviceOs,
    required String appVersion,
  }) async {
    final res = await _dio.post(
      ApiEndpoints.companionSessions,
      data: {'device_name': deviceName, 'device_os': deviceOs, 'app_version': appVersion},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> endSession(String sessionId) async {
    final res = await _dio.post(ApiEndpoints.companionSessionEnd(sessionId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> listSessions() async {
    final res = await _dio.get(ApiEndpoints.companionSessions);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPreferences() async {
    final res = await _dio.get(ApiEndpoints.companionPreferences);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> data) async {
    final res = await _dio.put(ApiEndpoints.companionPreferences, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getQuickActions() async {
    final res = await _dio.get(ApiEndpoints.companionQuickActions);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateQuickActions(List<Map<String, dynamic>> actions) async {
    final res = await _dio.put(ApiEndpoints.companionQuickActions, data: {'actions': actions});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> logEvent({required String eventType, Map<String, dynamic>? eventData}) async {
    final res = await _dio.post(
      ApiEndpoints.companionEvents,
      data: {'event_type': eventType, 'event_data': ?eventData},
    );
    return res.data as Map<String, dynamic>;
  }

  // ─── New Companion Endpoints ───────────────────────────

  Future<Map<String, dynamic>> getDashboard() async {
    final res = await _dio.get(ApiEndpoints.companionDashboard);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBranches() async {
    final res = await _dio.get(ApiEndpoints.companionBranches);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSalesSummary({String? period, String? storeId}) async {
    final res = await _dio.get(
      ApiEndpoints.companionSalesSummary,
      queryParameters: {'period': ?period, 'store_id': ?storeId},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getActiveOrders({String? storeId}) async {
    final res = await _dio.get(ApiEndpoints.companionActiveOrders, queryParameters: {'store_id': ?storeId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInventoryAlerts({String? storeId}) async {
    final res = await _dio.get(
      ApiEndpoints.companionInventoryAlerts,
      queryParameters: {'store_id': ?storeId},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getActiveStaff({String? storeId}) async {
    final res = await _dio.get(ApiEndpoints.companionActiveStaff, queryParameters: {'store_id': ?storeId});
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleStoreAvailability({required bool isOpen}) async {
    final res = await _dio.put(ApiEndpoints.companionStoreAvailability, data: {'is_active': isOpen});
    return res.data as Map<String, dynamic>;
  }
}
