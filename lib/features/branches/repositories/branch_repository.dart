import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/branches/data/remote/branch_api_service.dart';

class BranchRepository {
  final BranchApiService _apiService;

  BranchRepository(this._apiService);

  Future<Map<String, dynamic>> listBranches() => _apiService.listBranches();
  Future<Map<String, dynamic>> getBranch(String id) => _apiService.getBranch(id);
  Future<Map<String, dynamic>> updateBranch(String id, Map<String, dynamic> data) => _apiService.updateBranch(id, data);
  Future<Map<String, dynamic>> getBranchSettings(String id) => _apiService.getBranchSettings(id);
  Future<Map<String, dynamic>> getBranchWorkingHours(String id) => _apiService.getBranchWorkingHours(id);
}

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepository(ref.watch(branchApiServiceProvider));
});
