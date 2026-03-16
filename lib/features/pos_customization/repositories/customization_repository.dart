import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/pos_customization/data/remote/customization_api_service.dart';

final customizationRepositoryProvider = Provider<CustomizationRepository>((ref) {
  return CustomizationRepository(ref.watch(customizationApiServiceProvider));
});

class CustomizationRepository {
  final CustomizationApiService _api;

  CustomizationRepository(this._api);

  Future<Map<String, dynamic>> getSettings() => _api.getSettings();
  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> data) => _api.updateSettings(data);
  Future<Map<String, dynamic>> resetSettings() => _api.resetSettings();

  Future<Map<String, dynamic>> getReceiptTemplate() => _api.getReceiptTemplate();
  Future<Map<String, dynamic>> updateReceiptTemplate(Map<String, dynamic> data) => _api.updateReceiptTemplate(data);
  Future<Map<String, dynamic>> resetReceiptTemplate() => _api.resetReceiptTemplate();

  Future<Map<String, dynamic>> getQuickAccess() => _api.getQuickAccess();
  Future<Map<String, dynamic>> updateQuickAccess(Map<String, dynamic> data) => _api.updateQuickAccess(data);
  Future<Map<String, dynamic>> resetQuickAccess() => _api.resetQuickAccess();

  Future<Map<String, dynamic>> exportAll() => _api.exportAll();
}
