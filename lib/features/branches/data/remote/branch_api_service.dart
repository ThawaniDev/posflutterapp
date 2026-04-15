import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

class BranchApiService {
  final Dio _dio;

  BranchApiService(this._dio);

  /// GET /core/stores — List branches with optional filters
  Future<Map<String, dynamic>> listBranches({Map<String, dynamic>? queryParams}) async {
    final response = await _dio.get(ApiEndpoints.branches, queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/{id}
  Future<Map<String, dynamic>> getBranch(String id) async {
    final response = await _dio.get(ApiEndpoints.branchById(id));
    return response.data as Map<String, dynamic>;
  }

  /// POST /core/stores — Create branch
  Future<Map<String, dynamic>> createBranch(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.branches, data: data);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /core/stores/{id}
  Future<Map<String, dynamic>> updateBranch(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.branchById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /core/stores/{id}
  Future<Map<String, dynamic>> deleteBranch(String id) async {
    final response = await _dio.delete(ApiEndpoints.branchById(id));
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /core/stores/{id}/toggle-active
  Future<Map<String, dynamic>> toggleActive(String id) async {
    final response = await _dio.patch(ApiEndpoints.branchToggleActive(id));
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/stats
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(ApiEndpoints.branchStats);
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/managers
  Future<Map<String, dynamic>> getManagers() async {
    final response = await _dio.get(ApiEndpoints.branchManagers);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /core/stores/sort-order
  Future<Map<String, dynamic>> updateSortOrder(List<Map<String, dynamic>> order) async {
    final response = await _dio.put(ApiEndpoints.branchSortOrder, data: {'order': order});
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/{id}/settings
  Future<Map<String, dynamic>> getBranchSettings(String id) async {
    final response = await _dio.get(ApiEndpoints.branchSettings(id));
    return response.data as Map<String, dynamic>;
  }

  /// PUT /core/stores/{id}/settings
  Future<Map<String, dynamic>> updateBranchSettings(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.branchSettings(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  /// POST /core/stores/{id}/copy-settings
  Future<Map<String, dynamic>> copySettings(String id, String sourceStoreId) async {
    final response = await _dio.post(ApiEndpoints.branchCopySettings(id), data: {'source_store_id': sourceStoreId});
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/{id}/working-hours
  Future<Map<String, dynamic>> getBranchWorkingHours(String id) async {
    final response = await _dio.get(ApiEndpoints.branchWorkingHours(id));
    return response.data as Map<String, dynamic>;
  }

  /// PUT /core/stores/{id}/working-hours
  Future<Map<String, dynamic>> updateBranchWorkingHours(String id, List<Map<String, dynamic>> days) async {
    final response = await _dio.put(ApiEndpoints.branchWorkingHours(id), data: {'days': days});
    return response.data as Map<String, dynamic>;
  }

  /// POST /core/stores/{id}/copy-working-hours
  Future<Map<String, dynamic>> copyWorkingHours(String id, String sourceStoreId) async {
    final response = await _dio.post(ApiEndpoints.branchCopyWorkingHours(id), data: {'source_store_id': sourceStoreId});
    return response.data as Map<String, dynamic>;
  }
}

final branchApiServiceProvider = Provider<BranchApiService>((ref) {
  return BranchApiService(ref.watch(dioClientProvider));
});
