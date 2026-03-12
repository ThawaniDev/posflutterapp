import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/branches/models/store.dart';
import 'package:thawani_pos/features/onboarding/models/store_settings.dart';
import 'package:thawani_pos/features/onboarding/models/store_working_hour.dart';
import 'package:thawani_pos/features/onboarding/models/business_type_template.dart';

final storeApiServiceProvider = Provider<StoreApiService>((ref) {
  return StoreApiService(ref.watch(dioClientProvider));
});

class StoreApiService {
  final Dio _dio;

  StoreApiService(this._dio);

  // ─── Store CRUD ────────────────────────────────────────────────

  /// GET /core/stores/mine
  Future<Store> getMyStore() async {
    final response = await _dio.get(ApiEndpoints.storesMine);
    return Store.fromJson(response.data['data'] as Map<String, dynamic>);
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
