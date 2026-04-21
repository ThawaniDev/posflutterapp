import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/inventory/models/goods_receipt.dart';
import 'package:wameedpos/features/inventory/models/purchase_order.dart';
import 'package:wameedpos/features/inventory/models/recipe.dart';
import 'package:wameedpos/features/inventory/models/stock_adjustment.dart';
import 'package:wameedpos/features/inventory/models/stock_level.dart';
import 'package:wameedpos/features/inventory/models/stock_movement.dart';
import 'package:wameedpos/features/inventory/models/stock_transfer.dart';
import 'package:wameedpos/features/inventory/models/supplier_return.dart';

final inventoryApiServiceProvider = Provider<InventoryApiService>((ref) {
  return InventoryApiService(ref.watch(dioClientProvider));
});

/// Remote API service for all inventory endpoints.
class InventoryApiService {

  InventoryApiService(this._dio);
  final Dio _dio;

  // ─── Stock Levels ─────────────────────────────────────────────

  /// GET /inventory/stock-levels
  Future<PaginatedResult<StockLevel>> listStockLevels({
    required String storeId,
    int page = 1,
    int perPage = 25,
    String? productId,
    bool? lowStock,
    String? search,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.stockLevels,
      queryParameters: {
        'store_id': storeId,
        'page': page,
        'per_page': perPage,
        'product_id': ?productId,
        if (lowStock == true) 'low_stock': 1,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => StockLevel.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// PUT /inventory/stock-levels/:id/reorder-point
  Future<StockLevel> setReorderPoint(String stockLevelId, {required double reorderPoint, double? maxStockLevel}) async {
    final response = await _dio.put(
      '${ApiEndpoints.stockLevels}/$stockLevelId/reorder-point',
      data: {'reorder_point': reorderPoint, 'max_stock_level': ?maxStockLevel},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StockLevel.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Stock Movements ──────────────────────────────────────────

  /// GET /inventory/stock-movements
  Future<PaginatedResult<StockMovement>> listStockMovements({
    required String storeId,
    int page = 1,
    int perPage = 25,
    String? productId,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.stockMovements,
      queryParameters: {'store_id': storeId, 'page': page, 'per_page': perPage, 'product_id': ?productId},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => StockMovement.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  // ─── Goods Receipts ───────────────────────────────────────────

  /// GET /inventory/goods-receipts
  Future<PaginatedResult<GoodsReceipt>> listGoodsReceipts({required String storeId, int page = 1, int perPage = 25}) async {
    final response = await _dio.get(
      ApiEndpoints.goodsReceipts,
      queryParameters: {'store_id': storeId, 'page': page, 'per_page': perPage},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => GoodsReceipt.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// POST /inventory/goods-receipts
  Future<GoodsReceipt> createGoodsReceipt(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.goodsReceipts, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return GoodsReceipt.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// GET /inventory/goods-receipts/:id
  Future<GoodsReceipt> getGoodsReceipt(String id) async {
    final response = await _dio.get('${ApiEndpoints.goodsReceipts}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return GoodsReceipt.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/goods-receipts/:id/confirm
  Future<GoodsReceipt> confirmGoodsReceipt(String id) async {
    final response = await _dio.post('${ApiEndpoints.goodsReceipts}/$id/confirm');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return GoodsReceipt.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Stock Adjustments ────────────────────────────────────────

  /// GET /inventory/stock-adjustments
  Future<PaginatedResult<StockAdjustment>> listStockAdjustments({required String storeId, int page = 1, int perPage = 25}) async {
    final response = await _dio.get(
      ApiEndpoints.stockAdjustments,
      queryParameters: {'store_id': storeId, 'page': page, 'per_page': perPage},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => StockAdjustment.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// POST /inventory/stock-adjustments
  Future<StockAdjustment> createStockAdjustment(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.stockAdjustments, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StockAdjustment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// GET /inventory/stock-adjustments/:id
  Future<StockAdjustment> getStockAdjustment(String id) async {
    final response = await _dio.get('${ApiEndpoints.stockAdjustments}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StockAdjustment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Stock Transfers ──────────────────────────────────────────

  /// GET /inventory/stock-transfers
  Future<PaginatedResult<StockTransfer>> listStockTransfers({int page = 1, int perPage = 25}) async {
    final response = await _dio.get(ApiEndpoints.stockTransfers, queryParameters: {'page': page, 'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => StockTransfer.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// POST /inventory/stock-transfers
  Future<StockTransfer> createStockTransfer(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.stockTransfers, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StockTransfer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// GET /inventory/stock-transfers/:id
  Future<StockTransfer> getStockTransfer(String id) async {
    final response = await _dio.get('${ApiEndpoints.stockTransfers}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StockTransfer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/stock-transfers/:id/approve
  Future<StockTransfer> approveTransfer(String id) async {
    final response = await _dio.post('${ApiEndpoints.stockTransfers}/$id/approve');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StockTransfer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/stock-transfers/:id/receive
  Future<StockTransfer> receiveTransfer(String id, {List<Map<String, dynamic>>? items}) async {
    final response = await _dio.post('${ApiEndpoints.stockTransfers}/$id/receive', data: items != null ? {'items': items} : null);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StockTransfer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/stock-transfers/:id/cancel
  Future<StockTransfer> cancelTransfer(String id) async {
    final response = await _dio.post('${ApiEndpoints.stockTransfers}/$id/cancel');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StockTransfer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Purchase Orders ──────────────────────────────────────────

  /// GET /inventory/purchase-orders
  Future<PaginatedResult<PurchaseOrder>> listPurchaseOrders({
    required String storeId,
    int page = 1,
    int perPage = 25,
    String? status,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.purchaseOrders,
      queryParameters: {'store_id': storeId, 'page': page, 'per_page': perPage, 'status': ?status},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => PurchaseOrder.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// POST /inventory/purchase-orders
  Future<PurchaseOrder> createPurchaseOrder(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.purchaseOrders, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return PurchaseOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// GET /inventory/purchase-orders/:id
  Future<PurchaseOrder> getPurchaseOrder(String id) async {
    final response = await _dio.get('${ApiEndpoints.purchaseOrders}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return PurchaseOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/purchase-orders/:id/send
  Future<PurchaseOrder> sendPurchaseOrder(String id) async {
    final response = await _dio.post('${ApiEndpoints.purchaseOrders}/$id/send');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return PurchaseOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/purchase-orders/:id/receive
  Future<PurchaseOrder> receivePurchaseOrder(String id, List<Map<String, dynamic>> items) async {
    final response = await _dio.post('${ApiEndpoints.purchaseOrders}/$id/receive', data: {'items': items});
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return PurchaseOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/purchase-orders/:id/cancel
  Future<PurchaseOrder> cancelPurchaseOrder(String id) async {
    final response = await _dio.post('${ApiEndpoints.purchaseOrders}/$id/cancel');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return PurchaseOrder.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Recipes ──────────────────────────────────────────────────

  /// GET /inventory/recipes
  Future<PaginatedResult<Recipe>> listRecipes({int page = 1, int perPage = 25}) async {
    final response = await _dio.get(ApiEndpoints.recipes, queryParameters: {'page': page, 'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Recipe.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// POST /inventory/recipes
  Future<Recipe> createRecipe(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.recipes, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return Recipe.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// GET /inventory/recipes/:id
  Future<Recipe> getRecipe(String id) async {
    final response = await _dio.get('${ApiEndpoints.recipes}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return Recipe.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// PUT /inventory/recipes/:id
  Future<Recipe> updateRecipe(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.recipes}/$id', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return Recipe.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// DELETE /inventory/recipes/:id
  Future<void> deleteRecipe(String id) async {
    await _dio.delete('${ApiEndpoints.recipes}/$id');
  }

  // ─── Supplier Returns ─────────────────────────────────────────

  /// GET /inventory/supplier-returns
  Future<PaginatedResult<SupplierReturn>> listSupplierReturns({
    int page = 1,
    int perPage = 25,
    String? status,
    String? supplierId,
    String? search,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.supplierReturns,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'status': ?status,
        'supplier_id': ?supplierId,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => SupplierReturn.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// POST /inventory/supplier-returns
  Future<SupplierReturn> createSupplierReturn(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.supplierReturns, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return SupplierReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// GET /inventory/supplier-returns/:id
  Future<SupplierReturn> getSupplierReturn(String id) async {
    final response = await _dio.get('${ApiEndpoints.supplierReturns}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return SupplierReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// PUT /inventory/supplier-returns/:id
  Future<SupplierReturn> updateSupplierReturn(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.supplierReturns}/$id', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return SupplierReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// DELETE /inventory/supplier-returns/:id
  Future<void> deleteSupplierReturn(String id) async {
    await _dio.delete('${ApiEndpoints.supplierReturns}/$id');
  }

  /// POST /inventory/supplier-returns/:id/submit
  Future<SupplierReturn> submitSupplierReturn(String id) async {
    final response = await _dio.post('${ApiEndpoints.supplierReturns}/$id/submit');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return SupplierReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/supplier-returns/:id/approve
  Future<SupplierReturn> approveSupplierReturn(String id) async {
    final response = await _dio.post('${ApiEndpoints.supplierReturns}/$id/approve');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return SupplierReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/supplier-returns/:id/complete
  Future<SupplierReturn> completeSupplierReturn(String id) async {
    final response = await _dio.post('${ApiEndpoints.supplierReturns}/$id/complete');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return SupplierReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /inventory/supplier-returns/:id/cancel
  Future<SupplierReturn> cancelSupplierReturn(String id) async {
    final response = await _dio.post('${ApiEndpoints.supplierReturns}/$id/cancel');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return SupplierReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
