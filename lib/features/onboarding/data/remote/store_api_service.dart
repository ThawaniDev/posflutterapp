import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/onboarding/models/store_settings.dart';
import 'package:wameedpos/features/onboarding/models/store_working_hour.dart';
import 'package:wameedpos/features/onboarding/models/business_type_template.dart';

final storeApiServiceProvider = Provider<StoreApiService>((ref) {
  return StoreApiService(ref.watch(dioClientProvider));
});

class StoreApiService {
  StoreApiService(this._dio);
  final Dio _dio;

  static const String _myStoreCacheKey = 'cached_my_store_v1';

  // ─── Store CRUD ──────────────────────────────────

  /// GET /core/stores/mine
  ///
  /// The store profile (name, CR/VAT numbers, address) is printed on every
  /// receipt, so it must survive offline operation. We cache the raw payload
  /// on each successful fetch and fall back to that cache when the request
  /// fails (offline, a transient 5xx, or a permission hiccup), guaranteeing
  /// the receipt header is never blank once the store has loaded at least once.
  Future<Store> getMyStore() async {
    try {
      final response = await _dio.get(ApiEndpoints.storesMine);
      final data = response.data['data'] as Map<String, dynamic>;
      await _cacheMyStore(data);
      return Store.fromJson(data);
    } on DioException {
      final cached = await _readCachedMyStore();
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<void> _cacheMyStore(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_myStoreCacheKey, jsonEncode(data));
    } catch (_) {
      // Best-effort cache; never let persistence break the live fetch.
    }
  }

  Future<Store?> _readCachedMyStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_myStoreCacheKey);
      if (raw == null) return null;
      return Store.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// GET /core/stores
  Future<List<Store>> listStores() async {
    final response = await _dio.get(ApiEndpoints.stores);
    final List data = response.data['data'] as List;
    return data.map((j) => Store.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// GET /core/stores/:id
  Future<Store> getStore(String storeId) async {
    final response = await _dio.get(ApiEndpoints.storeById(storeId));
    return Store.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// PUT /core/stores/:id
  Future<Store> updateStore(String storeId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.storeById(storeId), data: data);
    return Store.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ─── Store Settings ────────────────────────────────────────────

  /// GET /core/stores/:id/settings
  Future<StoreSettings> getSettings(String storeId) async {
    final response = await _dio.get(ApiEndpoints.storeSettings(storeId));
    return StoreSettings.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// PUT /core/stores/:id/settings
  Future<StoreSettings> updateSettings(String storeId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.storeSettings(storeId), data: data);
    return StoreSettings.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ─── Working Hours ─────────────────────────────────────────────

  /// GET /core/stores/:id/working-hours
  Future<List<StoreWorkingHour>> getWorkingHours(String storeId) async {
    final response = await _dio.get(ApiEndpoints.storeWorkingHours(storeId));
    final List data = response.data['data'] as List;
    return data.map((j) => StoreWorkingHour.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// PUT /core/stores/:id/working-hours
  Future<List<StoreWorkingHour>> updateWorkingHours(String storeId, List<Map<String, dynamic>> days) async {
    final response = await _dio.put(ApiEndpoints.storeWorkingHours(storeId), data: {'store_id': storeId, 'days': days});
    final List data = response.data['data'] as List;
    return data.map((j) => StoreWorkingHour.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Business Types ────────────────────────────────────────────

  /// GET /core/business-types
  Future<List<BusinessTypeTemplate>> getBusinessTypes() async {
    final response = await _dio.get(ApiEndpoints.businessTypes);
    final List data = response.data['data'] as List;
    return data.map((j) => BusinessTypeTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// POST /core/stores/:id/business-type
  Future<Store> applyBusinessType(String storeId, String businessTypeCode) async {
    final response = await _dio.post(ApiEndpoints.storeApplyBusinessType(storeId), data: {'business_type': businessTypeCode});
    return Store.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
