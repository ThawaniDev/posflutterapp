import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/catalog/models/category.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/catalog/models/supplier.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(apiService: ref.watch(catalogApiServiceProvider));
});

/// Repository that orchestrates catalog API calls.
/// Resolves the current store/org context from auth session.
class CatalogRepository {
  final CatalogApiService _apiService;

  CatalogRepository({required CatalogApiService apiService}) : _apiService = apiService;

  // ─── Products ─────────────────────────────────────────────────

  Future<PaginatedResult<Product>> listProducts({
    int page = 1,
    int perPage = 25,
    String? categoryId,
    String? search,
    bool? isActive,
    String? sortBy,
    String? sortDir,
  }) {
    return _apiService.listProducts(
      page: page,
      perPage: perPage,
      categoryId: categoryId,
      search: search,
      isActive: isActive,
      sortBy: sortBy,
      sortDir: sortDir,
    );
  }

  Future<Product> getProduct(String productId) {
    return _apiService.getProduct(productId);
  }

  Future<Product> createProduct(Map<String, dynamic> data) {
    return _apiService.createProduct(data);
  }

  Future<Product> updateProduct(String productId, Map<String, dynamic> data) {
    return _apiService.updateProduct(productId, data);
  }

  Future<void> deleteProduct(String productId) {
    return _apiService.deleteProduct(productId);
  }

  Future<List<Product>> getCatalog() {
    return _apiService.getCatalog();
  }

  Future<List<Product>> getChanges(int sinceVersion) {
    return _apiService.getChanges(sinceVersion);
  }

  Future<String> generateBarcode(String productId) {
    return _apiService.generateBarcode(productId);
  }

  // ─── Categories ───────────────────────────────────────────────

  Future<List<Category>> getCategoryTree({bool activeOnly = false}) {
    return _apiService.getCategoryTree(activeOnly: activeOnly);
  }

  Future<Category> getCategory(String categoryId) {
    return _apiService.getCategory(categoryId);
  }

  Future<Category> createCategory(Map<String, dynamic> data) {
    return _apiService.createCategory(data);
  }

  Future<Category> updateCategory(String categoryId, Map<String, dynamic> data) {
    return _apiService.updateCategory(categoryId, data);
  }

  Future<void> deleteCategory(String categoryId) {
    return _apiService.deleteCategory(categoryId);
  }

  // ─── Suppliers ────────────────────────────────────────────────

  Future<PaginatedResult<Supplier>> listSuppliers({int page = 1, int perPage = 25, String? search}) {
    return _apiService.listSuppliers(page: page, perPage: perPage, search: search);
  }

  Future<Supplier> createSupplier(Map<String, dynamic> data) {
    return _apiService.createSupplier(data);
  }

  Future<Supplier> updateSupplier(String supplierId, Map<String, dynamic> data) {
    return _apiService.updateSupplier(supplierId, data);
  }

  Future<void> deleteSupplier(String supplierId) {
    return _apiService.deleteSupplier(supplierId);
  }
}
