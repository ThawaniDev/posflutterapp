import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/branches/models/branch_stats.dart';
import 'package:wameedpos/features/branches/repositories/branch_repository.dart';
import 'package:wameedpos/features/branches/providers/branch_state.dart';

// ─── Branch List ───
class BranchListNotifier extends StateNotifier<BranchListState> {
  final BranchRepository _repository;
  BranchListNotifier(this._repository) : super(const BranchListInitial());

  String? _search;
  String? _city;
  bool? _isActive;
  bool? _isMainBranch;
  String _sortBy = 'sort_order';
  String _sortDir = 'asc';

  void setFilters({String? search, String? city, bool? isActive, bool? isMainBranch, String? sortBy, String? sortDir}) {
    _search = search;
    _city = city;
    _isActive = isActive;
    _isMainBranch = isMainBranch;
    if (sortBy != null) _sortBy = sortBy;
    if (sortDir != null) _sortDir = sortDir;
    load();
  }

  void clearFilters() {
    _search = null;
    _city = null;
    _isActive = null;
    _isMainBranch = null;
    _sortBy = 'sort_order';
    _sortDir = 'asc';
    load();
  }

  Future<void> load() async {
    if (state is! BranchListLoaded) state = const BranchListLoading();
    try {
      final params = <String, dynamic>{'sort_by': _sortBy, 'sort_dir': _sortDir};
      if (_search != null && _search!.isNotEmpty) params['search'] = _search;
      if (_city != null && _city!.isNotEmpty) params['city'] = _city;
      if (_isActive != null) params['is_active'] = _isActive! ? '1' : '0';
      if (_isMainBranch != null) params['is_main_branch'] = _isMainBranch! ? '1' : '0';

      final results = await Future.wait([_repository.listBranches(queryParams: params), _repository.getStats()]);

      final listResult = results[0];
      final statsResult = results[1];

      final data = listResult['data'] as List<dynamic>? ?? [];
      final branches = data.map((e) => Store.fromJson(e as Map<String, dynamic>)).toList();
      final statsData = statsResult['data'] as Map<String, dynamic>?;
      final stats = statsData != null ? BranchStats.fromJson(statsData) : null;

      state = BranchListLoaded(branches, stats: stats);
    } catch (e) {
      if (state is! BranchListLoaded) state = BranchListError(e.toString());
    }
  }

  Future<bool> toggleActive(String id) async {
    try {
      await _repository.toggleActive(id);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteBranch(String id) async {
    try {
      await _repository.deleteBranch(id);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final branchListProvider = StateNotifierProvider<BranchListNotifier, BranchListState>((ref) {
  return BranchListNotifier(ref.watch(branchRepositoryProvider));
});

// ─── Branch Detail ───
class BranchDetailNotifier extends StateNotifier<BranchDetailState> {
  final BranchRepository _repository;
  BranchDetailNotifier(this._repository) : super(const BranchDetailInitial());

  Future<void> load(String id) async {
    state = const BranchDetailLoading();
    try {
      final result = await _repository.getBranch(id);
      final data = result['data'] as Map<String, dynamic>;
      state = BranchDetailLoaded(Store.fromJson(data));
    } catch (e) {
      state = BranchDetailError(e.toString());
    }
  }
}

final branchDetailProvider = StateNotifierProvider.family<BranchDetailNotifier, BranchDetailState, String>((ref, id) {
  final notifier = BranchDetailNotifier(ref.watch(branchRepositoryProvider));
  notifier.load(id);
  return notifier;
});

// ─── Branch Form (Create/Update) ───
class BranchFormNotifier extends StateNotifier<BranchFormState> {
  final BranchRepository _repository;
  BranchFormNotifier(this._repository) : super(const BranchFormIdle());

  Future<void> create(Map<String, dynamic> data) async {
    state = const BranchFormSaving();
    try {
      final result = await _repository.createBranch(data);
      final branch = Store.fromJson(result['data'] as Map<String, dynamic>);
      state = BranchFormSuccess(branch, result['message'] as String? ?? 'Created');
    } catch (e) {
      state = BranchFormError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const BranchFormSaving();
    try {
      final result = await _repository.updateBranch(id, data);
      final branch = Store.fromJson(result['data'] as Map<String, dynamic>);
      state = BranchFormSuccess(branch, result['message'] as String? ?? 'Updated');
    } catch (e) {
      state = BranchFormError(e.toString());
    }
  }

  void reset() => state = const BranchFormIdle();
}

final branchFormProvider = StateNotifierProvider<BranchFormNotifier, BranchFormState>((ref) {
  return BranchFormNotifier(ref.watch(branchRepositoryProvider));
});

// ─── Available Managers ───
final branchManagersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(branchRepositoryProvider);
  final result = await repo.getManagers();
  final data = result['data'] as List<dynamic>? ?? [];
  return data.cast<Map<String, dynamic>>();
});
