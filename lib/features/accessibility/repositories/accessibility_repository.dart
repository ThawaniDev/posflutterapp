import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/accessibility/data/remote/accessibility_api_service.dart';

final accessibilityRepositoryProvider = Provider<AccessibilityRepository>((ref) {
  return AccessibilityRepository(ref.read(accessibilityApiServiceProvider));
});

class AccessibilityRepository {
  final AccessibilityApiService _api;
  AccessibilityRepository(this._api);

  Future<Map<String, dynamic>> getPreferences() => _api.getPreferences();

  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> data) => _api.updatePreferences(data);

  Future<Map<String, dynamic>> resetPreferences() => _api.resetPreferences();

  Future<Map<String, dynamic>> getShortcuts() => _api.getShortcuts();

  Future<Map<String, dynamic>> updateShortcuts(Map<String, String> shortcuts) => _api.updateShortcuts(shortcuts);
}
