import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final settingsApiServiceProvider = Provider<SettingsApiService>((ref) {
  return SettingsApiService(ref.watch(dioClientProvider));
});

class SettingsApiService {
  final Dio _dio;

  SettingsApiService(this._dio);

  // ─── Store Settings ─────────────────────────────────────────

  Future<Map<String, dynamic>> getSettings({required String storeId}) async {
    final res = await _dio.get(ApiEndpoints.storeSettings(storeId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateSettings({required String storeId, required Map<String, dynamic> data}) async {
    final res = await _dio.put(ApiEndpoints.storeSettings(storeId), data: data);
    return res.data as Map<String, dynamic>;
  }

  // ─── Working Hours ──────────────────────────────────────────

  Future<Map<String, dynamic>> getWorkingHours({required String storeId}) async {
    final res = await _dio.get(ApiEndpoints.storeWorkingHours(storeId));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateWorkingHours({required String storeId, required List<Map<String, dynamic>> days}) async {
    final res = await _dio.put(ApiEndpoints.storeWorkingHours(storeId), data: {'days': days});
    return res.data as Map<String, dynamic>;
  }
}
