import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final accessibilityApiServiceProvider = Provider<AccessibilityApiService>((ref) {
  return AccessibilityApiService(ref);
});

class AccessibilityApiService {
  AccessibilityApiService(this._ref);
  final Ref _ref;

  /// GET /accessibility/preferences
  Future<Map<String, dynamic>> getPreferences() async {
    final res = await _ref.read(dioClientProvider).get(ApiEndpoints.accessibilityPreferences);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// PUT /accessibility/preferences
  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> data) async {
    final res = await _ref.read(dioClientProvider).put(ApiEndpoints.accessibilityPreferences, data: data);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// DELETE /accessibility/preferences
  Future<Map<String, dynamic>> resetPreferences() async {
    final res = await _ref.read(dioClientProvider).delete(ApiEndpoints.accessibilityPreferences);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// GET /accessibility/shortcuts
  Future<Map<String, dynamic>> getShortcuts() async {
    final res = await _ref.read(dioClientProvider).get(ApiEndpoints.accessibilityShortcuts);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// PUT /accessibility/shortcuts
  Future<Map<String, dynamic>> updateShortcuts(Map<String, String> shortcuts) async {
    final res = await _ref.read(dioClientProvider).put(ApiEndpoints.accessibilityShortcuts, data: {'shortcuts': shortcuts});
    return Map<String, dynamic>.from(res.data as Map);
  }
}
