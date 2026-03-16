import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/companion/data/remote/companion_api_service.dart';

final companionRepositoryProvider = Provider<CompanionRepository>((ref) {
  return CompanionRepository(ref.watch(companionApiServiceProvider));
});

class CompanionRepository {
  final CompanionApiService _api;

  CompanionRepository(this._api);

  Future<Map<String, dynamic>> quickStats() => _api.quickStats();

  Future<Map<String, dynamic>> mobileSummary() => _api.mobileSummary();

  Future<Map<String, dynamic>> registerSession({
    required String deviceName,
    required String deviceOs,
    required String appVersion,
  }) => _api.registerSession(deviceName: deviceName, deviceOs: deviceOs, appVersion: appVersion);

  Future<Map<String, dynamic>> endSession(String sessionId) => _api.endSession(sessionId);

  Future<Map<String, dynamic>> listSessions() => _api.listSessions();

  Future<Map<String, dynamic>> getPreferences() => _api.getPreferences();

  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> data) => _api.updatePreferences(data);

  Future<Map<String, dynamic>> getQuickActions() => _api.getQuickActions();

  Future<Map<String, dynamic>> updateQuickActions(List<Map<String, dynamic>> actions) => _api.updateQuickActions(actions);

  Future<Map<String, dynamic>> logEvent({required String eventType, Map<String, dynamic>? eventData}) =>
      _api.logEvent(eventType: eventType, eventData: eventData);
}
