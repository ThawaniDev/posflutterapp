import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/features/catalog/models/modifier_group.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/models/product_barcode.dart';
import 'package:wameedpos/features/catalog/models/product_supplier.dart';
import 'package:wameedpos/features/catalog/models/product_variant.dart';
import 'package:wameedpos/features/catalog/models/store_price.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(apiService: ref.watch(catalogApiServiceProvider));
});

/// Repository that orchestrates catalog API calls.
/// Resolves the current store/org context from auth session.
class CatalogRepository {

  CatalogRepository({required CatalogApiService apiService}) : _apiService = apiService;
  final CatalogApiService _apiService;

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

  // ─── Product Extended Operations ──────────────────────────────

  Future<void> bulkAction({required List<String> productIds, required String action, String? categoryId}) {
    return _apiService.bulkAction(productIds: productIds, action: action, categoryId: categoryId);
  }

  Future<Product> duplicateProduct(String productId) {
    return _apiService.duplicateProduct(productId);
  }

  Future<List<StorePrice>> getStorePrices(String productId) {
    return _apiService.getStorePrices(productId);
  }

  Future<void> syncStorePrices(String productId, List<Map<String, dynamic>> prices) {
    return _apiService.syncStorePrices(productId, prices);
  }

  Future<List<ProductSupplier>> getProductSuppliers(String productId) {
    return _apiService.getProductSuppliers(productId);
  }

  Future<void> syncProductSuppliers(String productId, List<Map<String, dynamic>> suppliers) {
    return _apiService.syncProductSuppliers(productId, suppliers);
  }

  Future<List<ModifierGroup>> getModifiers(String productId) {
    return _apiService.getModifiers(productId);
  }

  Future<void> syncModifiers(String productId, List<Map<String, dynamic>> groups) {
    return _apiService.syncModifiers(productId, groups);
  }

  Future<List<ProductVariant>> getVariants(String productId) {
    return _apiService.getVariants(productId);
  }

  Future<void> syncVariants(String productId, List<Map<String, dynamic>> variants) {
    return _apiService.syncVariants(productId, variants);
  }

  Future<List<ProductBarcode>> getBarcodes(String productId) {
    return _apiService.getBarcodes(productId);
  }

  Future<String> generateBarcode(String productId) {
    return _apiService.generateBarcode(productId);
  }

  // ─── Bulk Import ──────────────────────────────────────────────

  Future<ImportPreview> importPreview({required String filePath, required String fileName}) {
    return _apiService.importPreview(filePath, fileName);
  }

  Future<ImportResult> bulkImport({
    required String filePath,
    required String fileName,
    required Map<String, int> mapping,
  }) {
    return _apiService.bulkImport(
      filePath: filePath,
      fileName: fileName,
      mapping: mapping,
    );
  }
}
