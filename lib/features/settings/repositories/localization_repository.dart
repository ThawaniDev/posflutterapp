import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/settings/data/remote/localization_api_service.dart';

final localizationRepositoryProvider = Provider<LocalizationRepository>((ref) {
  return LocalizationRepository(ref.watch(localizationApiServiceProvider));
});

class LocalizationRepository {
  final LocalizationApiService _api;

  LocalizationRepository(this._api);

  Future<Response> listLocales({bool? activeOnly}) => _api.listLocales(activeOnly: activeOnly);

  Future<Response> saveLocale(Map<String, dynamic> data) => _api.saveLocale(data);

  Future<Response> getTranslations({required String locale, String? category, String? search, String? storeId, int? perPage}) =>
      _api.getTranslations(locale: locale, category: category, search: search, storeId: storeId, perPage: perPage);

  Future<Response> saveTranslation(Map<String, dynamic> data) => _api.saveTranslation(data);

  Future<Response> bulkImportTranslations(List<Map<String, dynamic>> translations) => _api.bulkImportTranslations(translations);

  Future<Response> exportTranslations({required String locale, String? storeId}) =>
      _api.exportTranslations(locale: locale, storeId: storeId);

  Future<Response> getOverrides({required String storeId, String? locale}) => _api.getOverrides(storeId: storeId, locale: locale);

  Future<Response> saveOverride(Map<String, dynamic> data) => _api.saveOverride(data);

  Future<Response> removeOverride(String id) => _api.removeOverride(id);

  Future<Response> publishVersion({String? notes}) => _api.publishVersion(notes: notes);

  Future<Response> listVersions({int? perPage}) => _api.listVersions(perPage: perPage);
}
