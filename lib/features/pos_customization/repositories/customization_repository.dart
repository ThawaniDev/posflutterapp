import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/pos_customization/data/remote/customization_api_service.dart';
import 'package:thawani_pos/features/pos_customization/models/cfd_theme.dart';
import 'package:thawani_pos/features/pos_customization/models/label_layout_template.dart';
import 'package:thawani_pos/features/pos_customization/models/receipt_layout_template.dart';

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

  Future<List<ReceiptLayoutTemplate>> listReceiptLayoutTemplates() => _api.listReceiptLayoutTemplates();
  Future<ReceiptLayoutTemplate> getReceiptLayoutTemplate(String slug) => _api.getReceiptLayoutTemplate(slug);
  Future<List<CfdTheme>> listCfdThemes() => _api.listCfdThemes();
  Future<CfdTheme> getCfdTheme(String slug) => _api.getCfdTheme(slug);

  Future<String> getReceiptTemplatePreviewUrl(String id) => _api.getReceiptTemplatePreviewUrl(id);
  Future<String> getCfdThemePreviewUrl(String id) => _api.getCfdThemePreviewUrl(id);

  Future<List<LabelLayoutTemplate>> listLabelLayoutTemplates() => _api.listLabelLayoutTemplates();
  Future<LabelLayoutTemplate> getLabelLayoutTemplate(String slug) => _api.getLabelLayoutTemplate(slug);
  Future<String> getLabelTemplatePreviewUrl(String id) => _api.getLabelTemplatePreviewUrl(id);
  Future<String> getMarketplaceListingPreviewUrl(String id) => _api.getMarketplaceListingPreviewUrl(id);
}
