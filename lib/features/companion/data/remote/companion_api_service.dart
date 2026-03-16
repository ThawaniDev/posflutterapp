import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

final companionApiServiceProvider = Provider<CompanionApiService>((ref) {
  return CompanionApiService(ref.watch(dioClientProvider));
});

class CompanionApiService {
  final Dio _dio;

  CompanionApiService(this._dio);

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
      data: {'event_type': eventType, if (eventData != null) 'event_data': eventData},
    );
    return res.data as Map<String, dynamic>;
  }
}
