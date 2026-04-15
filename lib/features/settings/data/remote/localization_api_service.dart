import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final localizationApiServiceProvider = Provider<LocalizationApiService>((ref) {
  return LocalizationApiService(ref.watch(dioClientProvider));
});

class LocalizationApiService {
  final Dio _dio;

  LocalizationApiService(this._dio);

  /// GET /settings/locales
  Future<Response> listLocales({bool? activeOnly}) async {
    final params = <String, dynamic>{};
    if (activeOnly != null) params['active_only'] = activeOnly;
    return _dio.get(ApiEndpoints.locales, queryParameters: params);
  }

  /// POST /settings/locales
  Future<Response> saveLocale(Map<String, dynamic> data) async {
    return _dio.post(ApiEndpoints.locales, data: data);
  }

  /// GET /settings/translations
  Future<Response> getTranslations({
    required String locale,
    String? category,
    String? search,
    String? storeId,
    int? perPage,
  }) async {
    final params = <String, dynamic>{'locale': locale};
    if (category != null) params['category'] = category;
    if (search != null) params['search'] = search;
    if (storeId != null) params['store_id'] = storeId;
    if (perPage != null) params['per_page'] = perPage;
    return _dio.get(ApiEndpoints.translations, queryParameters: params);
  }

  /// POST /settings/translations
  Future<Response> saveTranslation(Map<String, dynamic> data) async {
    return _dio.post(ApiEndpoints.translations, data: data);
  }

  /// POST /settings/translations/bulk-import
  Future<Response> bulkImportTranslations(List<Map<String, dynamic>> translations) async {
    return _dio.post(ApiEndpoints.translationsBulkImport, data: {'translations': translations});
  }

  /// GET /settings/export-translations
  Future<Response> exportTranslations({required String locale, String? storeId}) async {
    final params = <String, dynamic>{'locale': locale};
    if (storeId != null) params['store_id'] = storeId;
    return _dio.get(ApiEndpoints.exportTranslations, queryParameters: params);
  }

  /// GET /settings/translation-overrides
  Future<Response> getOverrides({required String storeId, String? locale}) async {
    final params = <String, dynamic>{'store_id': storeId};
    if (locale != null) params['locale'] = locale;
    return _dio.get(ApiEndpoints.translationOverrides, queryParameters: params);
  }

  /// POST /settings/translation-overrides
  Future<Response> saveOverride(Map<String, dynamic> data) async {
    return _dio.post(ApiEndpoints.translationOverrides, data: data);
  }

  /// DELETE /settings/translation-overrides/{id}
  Future<Response> removeOverride(String id) async {
    return _dio.delete(ApiEndpoints.translationOverrideDelete(id));
  }

  /// POST /settings/publish-translations
  Future<Response> publishVersion({String? notes}) async {
    return _dio.post(ApiEndpoints.publishTranslations, data: {'notes': notes});
  }

  /// GET /settings/translation-versions
  Future<Response> listVersions({int? perPage}) async {
    final params = <String, dynamic>{};
    if (perPage != null) params['per_page'] = perPage;
    return _dio.get(ApiEndpoints.translationVersions, queryParameters: params);
  }
}
