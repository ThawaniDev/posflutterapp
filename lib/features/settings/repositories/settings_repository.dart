import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/settings/data/remote/settings_api_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(settingsApiServiceProvider));
});

class SettingsRepository {

  SettingsRepository(this._api);
  final SettingsApiService _api;

  // Store Settings
  Future<Map<String, dynamic>> getSettings({required String storeId}) => _api.getSettings(storeId: storeId);

  Future<Map<String, dynamic>> updateSettings({required String storeId, required Map<String, dynamic> data}) =>
      _api.updateSettings(storeId: storeId, data: data);

  // Working Hours
  Future<Map<String, dynamic>> getWorkingHours({required String storeId}) => _api.getWorkingHours(storeId: storeId);

  Future<Map<String, dynamic>> updateWorkingHours({required String storeId, required List<Map<String, dynamic>> days}) =>
      _api.updateWorkingHours(storeId: storeId, days: days);
}
