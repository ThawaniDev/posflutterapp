import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';
import 'package:thawani_pos/features/catalog/repositories/catalog_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Products
// ═══════════════════════════════════════════════════════════════

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(ref.watch(catalogRepositoryProvider));
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final CatalogRepository _repository;

  ProductsNotifier(this._repository) : super(const ProductsInitial());

  String? _categoryFilter;
  String? _searchQuery;

  Future<void> load({int page = 1}) async {
    state = const ProductsLoading();
    try {
      final result = await _repository.listProducts(page: page, categoryId: _categoryFilter, search: _searchQuery);
      state = ProductsLoaded(
        products: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        selectedCategoryId: _categoryFilter,
        searchQuery: _searchQuery,
      );
    } on DioException catch (e) {
      state = ProductsError(message: _extractError(e));
    } catch (e) {
      state = ProductsError(message: e.toString());
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
    if (state is ProductsLoaded) {
      final loaded = state as ProductsLoaded;
      if (loaded.hasMore) {
        await load(page: loaded.currentPage + 1);
      }
    }
  }

  Future<void> previousPage() async {
    if (state is ProductsLoaded) {
      final loaded = state as ProductsLoaded;
      if (loaded.currentPage > 1) {
        await load(page: loaded.currentPage - 1);
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _repository.deleteProduct(productId);
      if (state is ProductsLoaded) {
        final loaded = state as ProductsLoaded;
        state = loaded.copyWith(products: loaded.products.where((p) => p.id != productId).toList(), total: loaded.total - 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Product Detail / Form
// ═══════════════════════════════════════════════════════════════

final productDetailProvider = StateNotifierProvider.family<ProductDetailNotifier, ProductDetailState, String?>((ref, productId) {
  return ProductDetailNotifier(ref.watch(catalogRepositoryProvider), productId);
});

class ProductDetailNotifier extends StateNotifier<ProductDetailState> {
  final CatalogRepository _repository;
  final String? _productId;

  ProductDetailNotifier(this._repository, this._productId) : super(const ProductDetailInitial());

  Future<void> load() async {
    if (_productId == null) return; // New product — no load needed
    state = const ProductDetailLoading();
    try {
      final product = await _repository.getProduct(_productId);
      state = ProductDetailLoaded(product: product);
    } on DioException catch (e) {
      state = ProductDetailError(message: _extractError(e));
    } catch (e) {
      state = ProductDetailError(message: e.toString());
    }
  }

  Future<void> save(Map<String, dynamic> data) async {
    state = const ProductDetailSaving();
    try {
      final product = _productId != null
          ? await _repository.updateProduct(_productId, data)
          : await _repository.createProduct(data);
      state = ProductDetailSaved(product: product);
    } on DioException catch (e) {
      state = ProductDetailError(message: _extractError(e));
    } catch (e) {
      state = ProductDetailError(message: e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Categories
// ═══════════════════════════════════════════════════════════════

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  return CategoriesNotifier(ref.watch(catalogRepositoryProvider));
});

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final CatalogRepository _repository;

  CategoriesNotifier(this._repository) : super(const CategoriesInitial());

  Future<void> load({bool activeOnly = false}) async {
    state = const CategoriesLoading();
    try {
      final categories = await _repository.getCategoryTree(activeOnly: activeOnly);
      state = CategoriesLoaded(categories: categories);
    } on DioException catch (e) {
      state = CategoriesError(message: _extractError(e));
    } catch (e) {
      state = CategoriesError(message: e.toString());
    }
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    try {
      final category = await _repository.createCategory(data);
      if (state is CategoriesLoaded) {
        final current = (state as CategoriesLoaded).categories;
        state = CategoriesLoaded(categories: [...current, category]);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
    try {
      final updated = await _repository.updateCategory(categoryId, data);
      if (state is CategoriesLoaded) {
        final current = (state as CategoriesLoaded).categories;
        state = CategoriesLoaded(categories: current.map((c) => c.id == categoryId ? updated : c).toList());
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _repository.deleteCategory(categoryId);
      if (state is CategoriesLoaded) {
        final current = (state as CategoriesLoaded).categories;
        state = CategoriesLoaded(categories: current.where((c) => c.id != categoryId).toList());
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Suppliers
// ═══════════════════════════════════════════════════════════════

final suppliersProvider = StateNotifierProvider<SuppliersNotifier, SuppliersState>((ref) {
  return SuppliersNotifier(ref.watch(catalogRepositoryProvider));
});

class SuppliersNotifier extends StateNotifier<SuppliersState> {
  final CatalogRepository _repository;

  SuppliersNotifier(this._repository) : super(const SuppliersInitial());

  String? _searchQuery;

  Future<void> load({int page = 1}) async {
    state = const SuppliersLoading();
    try {
      final result = await _repository.listSuppliers(page: page, search: _searchQuery);
      state = SuppliersLoaded(
        suppliers: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = SuppliersError(message: _extractError(e));
    } catch (e) {
      state = SuppliersError(message: e.toString());
    }
  }

  Future<void> search(String? query) async {
    _searchQuery = (query != null && query.isEmpty) ? null : query;
    await load();
  }

  Future<void> createSupplier(Map<String, dynamic> data) async {
    try {
      final supplier = await _repository.createSupplier(data);
      if (state is SuppliersLoaded) {
        final loaded = state as SuppliersLoaded;
        state = loaded.copyWith(suppliers: [...loaded.suppliers, supplier], total: loaded.total + 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> updateSupplier(String supplierId, Map<String, dynamic> data) async {
    try {
      final updated = await _repository.updateSupplier(supplierId, data);
      if (state is SuppliersLoaded) {
        final loaded = state as SuppliersLoaded;
        state = loaded.copyWith(suppliers: loaded.suppliers.map((s) => s.id == supplierId ? updated : s).toList());
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      await _repository.deleteSupplier(supplierId);
      if (state is SuppliersLoaded) {
        final loaded = state as SuppliersLoaded;
        state = loaded.copyWith(suppliers: loaded.suppliers.where((s) => s.id != supplierId).toList(), total: loaded.total - 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ─── Shared Helpers ────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    if (data.containsKey('message')) {
      return data['message'] as String;
    }
    if (data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
    }
  }
  return e.message ?? 'An unexpected error occurred.';
}
