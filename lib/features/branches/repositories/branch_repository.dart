import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/branches/data/remote/branch_api_service.dart';

class BranchRepository {
  final BranchApiService _apiService;

  BranchRepository(this._apiService);

  Future<Map<String, dynamic>> listBranches({Map<String, dynamic>? queryParams}) =>
      _apiService.listBranches(queryParams: queryParams);
  Future<Map<String, dynamic>> getBranch(String id) => _apiService.getBranch(id);
  Future<Map<String, dynamic>> createBranch(Map<String, dynamic> data) => _apiService.createBranch(data);
  Future<Map<String, dynamic>> updateBranch(String id, Map<String, dynamic> data) => _apiService.updateBranch(id, data);
  Future<Map<String, dynamic>> deleteBranch(String id) => _apiService.deleteBranch(id);
  Future<Map<String, dynamic>> toggleActive(String id) => _apiService.toggleActive(id);
  Future<Map<String, dynamic>> getStats() => _apiService.getStats();
  Future<Map<String, dynamic>> getManagers() => _apiService.getManagers();
  Future<Map<String, dynamic>> updateSortOrder(List<Map<String, dynamic>> order) => _apiService.updateSortOrder(order);
  Future<Map<String, dynamic>> getBranchSettings(String id) => _apiService.getBranchSettings(id);
  Future<Map<String, dynamic>> updateBranchSettings(String id, Map<String, dynamic> data) =>
      _apiService.updateBranchSettings(id, data);
  Future<Map<String, dynamic>> copySettings(String id, String sourceStoreId) => _apiService.copySettings(id, sourceStoreId);
  Future<Map<String, dynamic>> getBranchWorkingHours(String id) => _apiService.getBranchWorkingHours(id);
  Future<Map<String, dynamic>> updateBranchWorkingHours(String id, List<Map<String, dynamic>> days) =>
      _apiService.updateBranchWorkingHours(id, days);
  Future<Map<String, dynamic>> copyWorkingHours(String id, String sourceStoreId) =>
      _apiService.copyWorkingHours(id, sourceStoreId);
}

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepository(ref.watch(branchApiServiceProvider));
});
