import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/branches/repositories/branch_repository.dart';
import 'package:thawani_pos/features/branches/providers/branch_state.dart';

class BranchListNotifier extends StateNotifier<BranchListState> {
  final BranchRepository _repository;
  BranchListNotifier(this._repository) : super(const BranchListInitial());

  Future<void> load() async {
    if (state is! BranchListLoaded) state = const BranchListLoading();
    try {
      final result = await _repository.listBranches();
      final data = result['data'] as List<dynamic>? ?? [];
      state = BranchListLoaded(data.cast<Map<String, dynamic>>());
    } catch (e) {
      if (state is! BranchListLoaded) state = BranchListError(e.toString());
    }
  }
}

final branchListProvider = StateNotifierProvider<BranchListNotifier, BranchListState>((ref) {
  return BranchListNotifier(ref.watch(branchRepositoryProvider));
});
