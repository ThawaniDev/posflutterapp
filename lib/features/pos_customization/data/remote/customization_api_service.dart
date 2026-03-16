import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

final customizationApiServiceProvider = Provider<CustomizationApiService>((ref) {
  return CustomizationApiService(ref.watch(dioClientProvider));
});

class CustomizationApiService {
  final Dio _dio;

  CustomizationApiService(this._dio);

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
}
