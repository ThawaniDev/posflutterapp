import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class BranchApiService {
  final Dio _dio;

  BranchApiService(this._dio);

  /// GET /core/stores — List all branches (stores) in the organization
  Future<Map<String, dynamic>> listBranches() async {
    final response = await _dio.get(ApiEndpoints.branches);
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/{id}
  Future<Map<String, dynamic>> getBranch(String id) async {
    final response = await _dio.get(ApiEndpoints.storeById(id));
    return response.data as Map<String, dynamic>;
  }

  /// PUT /core/stores/{id}
  Future<Map<String, dynamic>> updateBranch(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.storeById(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/{id}/settings
  Future<Map<String, dynamic>> getBranchSettings(String id) async {
    final response = await _dio.get(ApiEndpoints.storeSettings(id));
    return response.data as Map<String, dynamic>;
  }

  /// GET /core/stores/{id}/working-hours
  Future<Map<String, dynamic>> getBranchWorkingHours(String id) async {
    final response = await _dio.get(ApiEndpoints.storeWorkingHours(id));
    return response.data as Map<String, dynamic>;
  }
}

final branchApiServiceProvider = Provider<BranchApiService>((ref) {
  return BranchApiService(ref.watch(dioClientProvider));
});
