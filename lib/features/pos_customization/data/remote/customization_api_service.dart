import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/pos_customization/models/cfd_theme.dart';
import 'package:wameedpos/features/pos_customization/models/label_layout_template.dart';
import 'package:wameedpos/features/pos_customization/models/receipt_layout_template.dart';

final customizationApiServiceProvider = Provider<CustomizationApiService>((ref) {
  return CustomizationApiService(ref.watch(dioClientProvider));
});

class CustomizationApiService {

  CustomizationApiService(this._dio);
  final Dio _dio;

  // ─── Settings ────────────────────────────────

  Future<Map<String, dynamic>> getSettings() async {
    final res = await _dio.get(ApiEndpoints.customizationSettings);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> data) async {
    final res = await _dio.put(ApiEndpoints.customizationSettings, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetSettings() async {
    final res = await _dio.delete(ApiEndpoints.customizationSettings);
    return res.data as Map<String, dynamic>;
  }

  // ─── Receipt Template ────────────────────────

  Future<Map<String, dynamic>> getReceiptTemplate() async {
    final res = await _dio.get(ApiEndpoints.customizationReceipt);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateReceiptTemplate(Map<String, dynamic> data) async {
    final res = await _dio.put(ApiEndpoints.customizationReceipt, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetReceiptTemplate() async {
    final res = await _dio.delete(ApiEndpoints.customizationReceipt);
    return res.data as Map<String, dynamic>;
  }

  // ─── Quick Access ────────────────────────────

  Future<Map<String, dynamic>> getQuickAccess() async {
    final res = await _dio.get(ApiEndpoints.customizationQuickAccess);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateQuickAccess(Map<String, dynamic> data) async {
    final res = await _dio.put(ApiEndpoints.customizationQuickAccess, data: data);
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resetQuickAccess() async {
    final res = await _dio.delete(ApiEndpoints.customizationQuickAccess);
    return res.data as Map<String, dynamic>;
  }

  // ─── Export ──────────────────────────────────

  Future<Map<String, dynamic>> exportAll() async {
    final res = await _dio.get(ApiEndpoints.customizationExport);
    return res.data as Map<String, dynamic>;
  }

  // ─── Receipt Layout Templates ────────────────

  Future<List<ReceiptLayoutTemplate>> listReceiptLayoutTemplates() async {
    final res = await _dio.get(ApiEndpoints.uiReceiptTemplates);
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ReceiptLayoutTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ReceiptLayoutTemplate> getReceiptLayoutTemplate(String slug) async {
    final res = await _dio.get(ApiEndpoints.uiReceiptTemplateBySlug(slug));
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    return ReceiptLayoutTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── CFD Themes ──────────────────────────────

  Future<List<CfdTheme>> listCfdThemes() async {
    final res = await _dio.get(ApiEndpoints.uiCfdThemes);
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CfdTheme.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<CfdTheme> getCfdTheme(String slug) async {
    final res = await _dio.get(ApiEndpoints.uiCfdThemeBySlug(slug));
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    return CfdTheme.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Preview URLs ───────────────────────────────

  Future<String> getReceiptTemplatePreviewUrl(String id) async {
    final res = await _dio.get(ApiEndpoints.uiReceiptTemplatePreviewUrl(id));
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return data['preview_url'] as String;
  }

  Future<String> getCfdThemePreviewUrl(String id) async {
    final res = await _dio.get(ApiEndpoints.uiCfdThemePreviewUrl(id));
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return data['preview_url'] as String;
  }

  // ─── Label Layout Templates ──────────────────

  Future<List<LabelLayoutTemplate>> listLabelLayoutTemplates() async {
    final res = await _dio.get(ApiEndpoints.uiLabelTemplates);
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => LabelLayoutTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<LabelLayoutTemplate> getLabelLayoutTemplate(String slug) async {
    final res = await _dio.get(ApiEndpoints.uiLabelTemplateBySlug(slug));
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    return LabelLayoutTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Preview URLs ───────────────────────────────

  Future<String> getLabelTemplatePreviewUrl(String id) async {
    final res = await _dio.get(ApiEndpoints.uiLabelTemplatePreviewUrl(id));
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return data['preview_url'] as String;
  }

  Future<String> getMarketplaceListingPreviewUrl(String id) async {
    final res = await _dio.get(ApiEndpoints.marketplaceListingPreviewUrl(id));
    final apiResponse = ApiResponse.fromJson(res.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return data['preview_url'] as String;
  }
}
