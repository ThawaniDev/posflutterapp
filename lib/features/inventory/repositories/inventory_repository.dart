import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/auth/data/local/auth_local_storage.dart';
import 'package:thawani_pos/features/inventory/data/remote/inventory_api_service.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/inventory/models/goods_receipt.dart';
import 'package:thawani_pos/features/inventory/models/purchase_order.dart';
import 'package:thawani_pos/features/inventory/models/recipe.dart';
import 'package:thawani_pos/features/inventory/models/stock_adjustment.dart';
import 'package:thawani_pos/features/inventory/models/stock_level.dart';
import 'package:thawani_pos/features/inventory/models/stock_movement.dart';
import 'package:thawani_pos/features/inventory/models/stock_transfer.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(
    apiService: ref.watch(inventoryApiServiceProvider),
    localStorage: ref.watch(authLocalStorageProvider),
  );
});

/// Repository that orchestrates inventory API calls.
/// Automatically resolves the current store ID from auth session.
class InventoryRepository {
  final InventoryApiService _apiService;
  final AuthLocalStorage _localStorage;

  InventoryRepository({required InventoryApiService apiService, required AuthLocalStorage localStorage})
    : _apiService = apiService,
      _localStorage = localStorage;

  Future<String> _getStoreId() async {
    final storeId = await _localStorage.getStoreId();
    if (storeId == null) {
      throw Exception('No store selected. Please log in again.');
    }
    return storeId;
  }

  // ─── Stock Levels ─────────────────────────────────────────────

  Future<PaginatedResult<StockLevel>> listStockLevels({
    int page = 1,
    int perPage = 25,
    String? productId,
    bool? lowStock,
    String? search,
  }) async {
    final storeId = await _getStoreId();
    return _apiService.listStockLevels(
      storeId: storeId,
      page: page,
      perPage: perPage,
      productId: productId,
      lowStock: lowStock,
      search: search,
    );
  }

  Future<StockLevel> setReorderPoint(String stockLevelId, {required double reorderPoint, double? maxStockLevel}) async {
    return _apiService.setReorderPoint(stockLevelId, reorderPoint: reorderPoint, maxStockLevel: maxStockLevel);
  }

  // ─── Stock Movements ──────────────────────────────────────────

  Future<PaginatedResult<StockMovement>> listStockMovements({int page = 1, int perPage = 25, String? productId}) async {
    final storeId = await _getStoreId();
    return _apiService.listStockMovements(storeId: storeId, page: page, perPage: perPage, productId: productId);
  }

  // ─── Goods Receipts ───────────────────────────────────────────

  Future<PaginatedResult<GoodsReceipt>> listGoodsReceipts({int page = 1, int perPage = 25}) async {
    final storeId = await _getStoreId();
    return _apiService.listGoodsReceipts(storeId: storeId, page: page, perPage: perPage);
  }

  Future<GoodsReceipt> createGoodsReceipt(Map<String, dynamic> data) async {
    final storeId = await _getStoreId();
    return _apiService.createGoodsReceipt({'store_id': storeId, ...data});
  }

  Future<GoodsReceipt> getGoodsReceipt(String id) => _apiService.getGoodsReceipt(id);

  Future<GoodsReceipt> confirmGoodsReceipt(String id) => _apiService.confirmGoodsReceipt(id);

  // ─── Stock Adjustments ────────────────────────────────────────

  Future<PaginatedResult<StockAdjustment>> listStockAdjustments({int page = 1, int perPage = 25}) async {
    final storeId = await _getStoreId();
    return _apiService.listStockAdjustments(storeId: storeId, page: page, perPage: perPage);
  }

  Future<StockAdjustment> createStockAdjustment(Map<String, dynamic> data) async {
    final storeId = await _getStoreId();
    return _apiService.createStockAdjustment({'store_id': storeId, ...data});
  }

  Future<StockAdjustment> getStockAdjustment(String id) => _apiService.getStockAdjustment(id);

  // ─── Stock Transfers ──────────────────────────────────────────

  Future<PaginatedResult<StockTransfer>> listStockTransfers({int page = 1, int perPage = 25}) {
    return _apiService.listStockTransfers(page: page, perPage: perPage);
  }

  Future<StockTransfer> createStockTransfer(Map<String, dynamic> data) {
    return _apiService.createStockTransfer(data);
  }

  Future<StockTransfer> getStockTransfer(String id) => _apiService.getStockTransfer(id);
  Future<StockTransfer> approveTransfer(String id) => _apiService.approveTransfer(id);
  Future<StockTransfer> receiveTransfer(String id, {List<Map<String, dynamic>>? items}) =>
      _apiService.receiveTransfer(id, items: items);
  Future<StockTransfer> cancelTransfer(String id) => _apiService.cancelTransfer(id);

  // ─── Purchase Orders ──────────────────────────────────────────

  Future<PaginatedResult<PurchaseOrder>> listPurchaseOrders({int page = 1, int perPage = 25, String? status}) async {
    final storeId = await _getStoreId();
    return _apiService.listPurchaseOrders(storeId: storeId, page: page, perPage: perPage, status: status);
  }

  Future<PurchaseOrder> createPurchaseOrder(Map<String, dynamic> data) async {
    final storeId = await _getStoreId();
    return _apiService.createPurchaseOrder({'store_id': storeId, ...data});
  }

  Future<PurchaseOrder> getPurchaseOrder(String id) => _apiService.getPurchaseOrder(id);
  Future<PurchaseOrder> sendPurchaseOrder(String id) => _apiService.sendPurchaseOrder(id);
  Future<PurchaseOrder> receivePurchaseOrder(String id, List<Map<String, dynamic>> items) =>
      _apiService.receivePurchaseOrder(id, items);
  Future<PurchaseOrder> cancelPurchaseOrder(String id) => _apiService.cancelPurchaseOrder(id);

  // ─── Recipes ──────────────────────────────────────────────────

  Future<PaginatedResult<Recipe>> listRecipes({int page = 1, int perPage = 25}) {
    return _apiService.listRecipes(page: page, perPage: perPage);
  }

  Future<Recipe> createRecipe(Map<String, dynamic> data) => _apiService.createRecipe(data);
  Future<Recipe> getRecipe(String id) => _apiService.getRecipe(id);
  Future<Recipe> updateRecipe(String id, Map<String, dynamic> data) => _apiService.updateRecipe(id, data);
  Future<void> deleteRecipe(String id) => _apiService.deleteRecipe(id);
}
