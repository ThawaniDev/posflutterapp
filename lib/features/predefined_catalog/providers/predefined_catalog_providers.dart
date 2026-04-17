import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/predefined_catalog/data/remote/predefined_catalog_api_service.dart';
import 'package:wameedpos/features/predefined_catalog/providers/predefined_catalog_state.dart';

// ═══════════════════════════════════════════════════════════════
// Predefined Categories
// ═══════════════════════════════════════════════════════════════

final predefinedCategoriesProvider = StateNotifierProvider<PredefinedCategoriesNotifier, PredefinedCategoriesState>((ref) {
  return PredefinedCategoriesNotifier(ref.watch(predefinedCatalogApiServiceProvider));
});

class PredefinedCategoriesNotifier extends StateNotifier<PredefinedCategoriesState> {
  final PredefinedCatalogApiService _api;

  PredefinedCategoriesNotifier(this._api) : super(const PredefinedCategoriesInitial());

  String? _businessTypeFilter;

  Future<void> load({int page = 1}) async {
    state = const PredefinedCategoriesLoading();
    try {
      final result = await _api.listCategories(page: page, businessTypeId: _businessTypeFilter);
      state = PredefinedCategoriesLoaded(
        categories: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        selectedBusinessTypeId: _businessTypeFilter,
      );
    } on DioException catch (e) {
      state = PredefinedCategoriesError(message: _extractError(e));
    } catch (e) {
      state = PredefinedCategoriesError(message: e.toString());
    }
  }

  Future<void> filterByBusinessType(String? businessTypeId) async {
    _businessTypeFilter = businessTypeId;
    await load();
  }

  Future<void> nextPage() async {
    if (state is PredefinedCategoriesLoaded) {
      final loaded = state as PredefinedCategoriesLoaded;
      if (loaded.hasMore) await load(page: loaded.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state is PredefinedCategoriesLoaded) {
      final loaded = state as PredefinedCategoriesLoaded;
      if (loaded.currentPage > 1) await load(page: loaded.currentPage - 1);
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data.containsKey('message')) return data['message'] as String;
    return e.message ?? 'An error occurred';
  }
}

// ═══════════════════════════════════════════════════════════════
// Category Tree
// ═══════════════════════════════════════════════════════════════

final predefinedCategoryTreeProvider = StateNotifierProvider<PredefinedCategoryTreeNotifier, PredefinedCategoryTreeState>((ref) {
  return PredefinedCategoryTreeNotifier(ref.watch(predefinedCatalogApiServiceProvider));
});

class PredefinedCategoryTreeNotifier extends StateNotifier<PredefinedCategoryTreeState> {
  final PredefinedCatalogApiService _api;

  PredefinedCategoryTreeNotifier(this._api) : super(const PredefinedCategoryTreeInitial());

  Future<void> load(String businessTypeId) async {
    state = const PredefinedCategoryTreeLoading();
    try {
      final tree = await _api.getCategoryTree(businessTypeId);
      state = PredefinedCategoryTreeLoaded(tree: tree);
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map && data.containsKey('message')) ? data['message'] as String : (e.message ?? 'An error occurred');
      state = PredefinedCategoryTreeError(message: msg);
    } catch (e) {
      state = PredefinedCategoryTreeError(message: e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Predefined Products
// ═══════════════════════════════════════════════════════════════

final predefinedProductsProvider = StateNotifierProvider<PredefinedProductsNotifier, PredefinedProductsState>((ref) {
  return PredefinedProductsNotifier(ref.watch(predefinedCatalogApiServiceProvider));
});

class PredefinedProductsNotifier extends StateNotifier<PredefinedProductsState> {
  final PredefinedCatalogApiService _api;

  PredefinedProductsNotifier(this._api) : super(const PredefinedProductsInitial());

  String? _businessTypeId;
  String? _categoryFilter;
  String? _searchQuery;

  Future<void> load({int page = 1, String? businessTypeId}) async {
    if (businessTypeId != null) _businessTypeId = businessTypeId;
    state = const PredefinedProductsLoading();
    try {
      final result = await _api.listProducts(
        page: page,
        businessTypeId: _businessTypeId,
        predefinedCategoryId: _categoryFilter,
        search: _searchQuery,
      );
      state = PredefinedProductsLoaded(
        products: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        selectedCategoryId: _categoryFilter,
        searchQuery: _searchQuery,
      );
    } on DioException catch (e) {
      state = PredefinedProductsError(message: _extractError(e));
    } catch (e) {
      state = PredefinedProductsError(message: e.toString());
    }
  }

  Future<void> filterByCategory(String? categoryId) async {
    _categoryFilter = categoryId;
    await load();
  }

  Future<void> search(String? query) async {
    _searchQuery = (query != null && query.isEmpty) ? null : query;
    await load();
  }

  Future<void> nextPage() async {
    if (state is PredefinedProductsLoaded) {
      final loaded = state as PredefinedProductsLoaded;
      if (loaded.hasMore) await load(page: loaded.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state is PredefinedProductsLoaded) {
      final loaded = state as PredefinedProductsLoaded;
      if (loaded.currentPage > 1) await load(page: loaded.currentPage - 1);
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data.containsKey('message')) return data['message'] as String;
    return e.message ?? 'An error occurred';
  }
}

// ═══════════════════════════════════════════════════════════════
// Clone Operations
// ═══════════════════════════════════════════════════════════════

final cloneProvider = StateNotifierProvider<CloneNotifier, CloneState>((ref) {
  return CloneNotifier(ref.watch(predefinedCatalogApiServiceProvider));
});

class CloneNotifier extends StateNotifier<CloneState> {
  final PredefinedCatalogApiService _api;

  CloneNotifier(this._api) : super(const CloneIdle());

  Future<void> cloneCategory(String categoryId) async {
    state = const CloneInProgress();
    try {
      final result = await _api.cloneCategory(categoryId);
      state = CloneSuccess(message: 'Category cloned successfully', result: result);
    } on DioException catch (e) {
      state = CloneError(message: _extractError(e));
    } catch (e) {
      state = CloneError(message: e.toString());
    }
  }

  Future<void> cloneProduct(String productId, {String? categoryId}) async {
    state = const CloneInProgress();
    try {
      final result = await _api.cloneProduct(productId, categoryId: categoryId);
      state = CloneSuccess(message: 'Product cloned successfully', result: result);
    } on DioException catch (e) {
      state = CloneError(message: _extractError(e));
    } catch (e) {
      state = CloneError(message: e.toString());
    }
  }

  Future<void> cloneAll() async {
    state = const CloneInProgress();
    try {
      final result = await _api.cloneAll();
      state = CloneSuccess(message: 'All predefined products cloned successfully', result: result);
    } on DioException catch (e) {
      state = CloneError(message: _extractError(e));
    } catch (e) {
      state = CloneError(message: e.toString());
    }
  }

  void reset() {
    state = const CloneIdle();
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data.containsKey('message')) return data['message'] as String;
    return e.message ?? 'An error occurred';
  }
}
