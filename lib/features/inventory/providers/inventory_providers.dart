import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/inventory/models/purchase_order.dart';
import 'package:thawani_pos/features/inventory/models/stock_transfer.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';
import 'package:thawani_pos/features/inventory/repositories/inventory_repository.dart';

// ═══════════════════════════════════════════════════════════════════
// Stock Levels
// ═══════════════════════════════════════════════════════════════════

final stockLevelsProvider = StateNotifierProvider<StockLevelsNotifier, StockLevelsState>((ref) {
  return StockLevelsNotifier(ref.watch(inventoryRepositoryProvider));
});

class StockLevelsNotifier extends StateNotifier<StockLevelsState> {
  final InventoryRepository _repository;

  StockLevelsNotifier(this._repository) : super(const StockLevelsInitial());

  bool _lowStockOnly = false;
  String? _search;
  int _currentPage = 1;

  Future<void> load({int page = 1}) async {
    state = const StockLevelsLoading();
    _currentPage = page;
    try {
      final result = await _repository.listStockLevels(page: page, lowStock: _lowStockOnly ? true : null, search: _search);
      state = StockLevelsLoaded(
        levels: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        lowStockOnly: _lowStockOnly,
        search: _search,
      );
    } on DioException catch (e) {
      state = StockLevelsError(message: _extractError(e));
    } catch (e) {
      state = StockLevelsError(message: e.toString());
    }
  }

  Future<void> toggleLowStockFilter(bool value) async {
    _lowStockOnly = value;
    _currentPage = 1;
    await load();
  }

  Future<void> search(String? query) async {
    _search = (query != null && query.isEmpty) ? null : query;
    _currentPage = 1;
    await load();
  }

  Future<void> nextPage() async {
    if (state is StockLevelsLoaded) {
      final loaded = state as StockLevelsLoaded;
      if (loaded.hasMore) {
        await load(page: loaded.currentPage + 1);
      }
    }
  }

  Future<void> previousPage() async {
    if (state is StockLevelsLoaded) {
      final loaded = state as StockLevelsLoaded;
      if (loaded.currentPage > 1) {
        await load(page: loaded.currentPage - 1);
      }
    }
  }

  Future<void> setReorderPoint(String stockLevelId, {required double reorderPoint, double? maxStockLevel}) async {
    try {
      final updated = await _repository.setReorderPoint(stockLevelId, reorderPoint: reorderPoint, maxStockLevel: maxStockLevel);
      if (state is StockLevelsLoaded) {
        final loaded = state as StockLevelsLoaded;
        state = StockLevelsLoaded(
          levels: loaded.levels.map((l) => l.id == updated.id ? updated : l).toList(),
          total: loaded.total,
          currentPage: loaded.currentPage,
          lastPage: loaded.lastPage,
          lowStockOnly: loaded.lowStockOnly,
          search: loaded.search,
        );
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Stock Movements
// ═══════════════════════════════════════════════════════════════════

final stockMovementsProvider = StateNotifierProvider<StockMovementsNotifier, StockMovementsState>((ref) {
  return StockMovementsNotifier(ref.watch(inventoryRepositoryProvider));
});

class StockMovementsNotifier extends StateNotifier<StockMovementsState> {
  final InventoryRepository _repository;

  StockMovementsNotifier(this._repository) : super(const StockMovementsInitial());

  String? _productId;
  int _currentPage = 1;

  Future<void> load({int page = 1, String? productId}) async {
    state = const StockMovementsLoading();
    _currentPage = page;
    if (productId != null) _productId = productId;
    try {
      final result = await _repository.listStockMovements(page: page, productId: _productId);
      state = StockMovementsLoaded(
        movements: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
      );
    } on DioException catch (e) {
      state = StockMovementsError(message: _extractError(e));
    } catch (e) {
      state = StockMovementsError(message: e.toString());
    }
  }

  Future<void> nextPage() async {
    if (state is StockMovementsLoaded) {
      final loaded = state as StockMovementsLoaded;
      if (loaded.hasMore) await load(page: loaded.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state is StockMovementsLoaded) {
      final loaded = state as StockMovementsLoaded;
      if (loaded.currentPage > 1) await load(page: loaded.currentPage - 1);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Goods Receipts
// ═══════════════════════════════════════════════════════════════════

final goodsReceiptsProvider = StateNotifierProvider<GoodsReceiptsNotifier, GoodsReceiptsState>((ref) {
  return GoodsReceiptsNotifier(ref.watch(inventoryRepositoryProvider));
});

class GoodsReceiptsNotifier extends StateNotifier<GoodsReceiptsState> {
  final InventoryRepository _repository;

  GoodsReceiptsNotifier(this._repository) : super(const GoodsReceiptsInitial());

  Future<void> load({int page = 1}) async {
    state = const GoodsReceiptsLoading();
    try {
      final result = await _repository.listGoodsReceipts(page: page);
      state = GoodsReceiptsLoaded(
        receipts: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
      );
    } on DioException catch (e) {
      state = GoodsReceiptsError(message: _extractError(e));
    } catch (e) {
      state = GoodsReceiptsError(message: e.toString());
    }
  }

  Future<void> createReceipt(Map<String, dynamic> data) async {
    try {
      final receipt = await _repository.createGoodsReceipt(data);
      if (state is GoodsReceiptsLoaded) {
        final loaded = state as GoodsReceiptsLoaded;
        state = GoodsReceiptsLoaded(
          receipts: [receipt, ...loaded.receipts],
          total: loaded.total + 1,
          currentPage: loaded.currentPage,
          lastPage: loaded.lastPage,
        );
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> confirmReceipt(String id) async {
    try {
      final confirmed = await _repository.confirmGoodsReceipt(id);
      if (state is GoodsReceiptsLoaded) {
        final loaded = state as GoodsReceiptsLoaded;
        state = GoodsReceiptsLoaded(
          receipts: loaded.receipts.map((r) => r.id == id ? confirmed : r).toList(),
          total: loaded.total,
          currentPage: loaded.currentPage,
          lastPage: loaded.lastPage,
        );
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Stock Adjustments
// ═══════════════════════════════════════════════════════════════════

final stockAdjustmentsProvider = StateNotifierProvider<StockAdjustmentsNotifier, StockAdjustmentsState>((ref) {
  return StockAdjustmentsNotifier(ref.watch(inventoryRepositoryProvider));
});

class StockAdjustmentsNotifier extends StateNotifier<StockAdjustmentsState> {
  final InventoryRepository _repository;

  StockAdjustmentsNotifier(this._repository) : super(const StockAdjustmentsInitial());

  Future<void> load({int page = 1}) async {
    state = const StockAdjustmentsLoading();
    try {
      final result = await _repository.listStockAdjustments(page: page);
      state = StockAdjustmentsLoaded(adjustments: result.items, total: result.total);
    } on DioException catch (e) {
      state = StockAdjustmentsError(message: _extractError(e));
    } catch (e) {
      state = StockAdjustmentsError(message: e.toString());
    }
  }

  Future<void> createAdjustment(Map<String, dynamic> data) async {
    try {
      final adjustment = await _repository.createStockAdjustment(data);
      if (state is StockAdjustmentsLoaded) {
        final loaded = state as StockAdjustmentsLoaded;
        state = StockAdjustmentsLoaded(adjustments: [adjustment, ...loaded.adjustments], total: loaded.total + 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Stock Transfers
// ═══════════════════════════════════════════════════════════════════

final stockTransfersProvider = StateNotifierProvider<StockTransfersNotifier, StockTransfersState>((ref) {
  return StockTransfersNotifier(ref.watch(inventoryRepositoryProvider));
});

class StockTransfersNotifier extends StateNotifier<StockTransfersState> {
  final InventoryRepository _repository;

  StockTransfersNotifier(this._repository) : super(const StockTransfersInitial());

  Future<void> load({int page = 1}) async {
    state = const StockTransfersLoading();
    try {
      final result = await _repository.listStockTransfers(page: page);
      state = StockTransfersLoaded(transfers: result.items, total: result.total);
    } on DioException catch (e) {
      state = StockTransfersError(message: _extractError(e));
    } catch (e) {
      state = StockTransfersError(message: e.toString());
    }
  }

  Future<void> createTransfer(Map<String, dynamic> data) async {
    try {
      final transfer = await _repository.createStockTransfer(data);
      if (state is StockTransfersLoaded) {
        final loaded = state as StockTransfersLoaded;
        state = StockTransfersLoaded(transfers: [transfer, ...loaded.transfers], total: loaded.total + 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> approveTransfer(String id) async {
    try {
      final updated = await _repository.approveTransfer(id);
      _updateTransferInState(id, updated);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> receiveTransfer(String id, {List<Map<String, dynamic>>? items}) async {
    try {
      final updated = await _repository.receiveTransfer(id, items: items);
      _updateTransferInState(id, updated);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> cancelTransfer(String id) async {
    try {
      final updated = await _repository.cancelTransfer(id);
      _updateTransferInState(id, updated);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  void _updateTransferInState(String id, dynamic updated) {
    if (state is StockTransfersLoaded) {
      final loaded = state as StockTransfersLoaded;
      state = StockTransfersLoaded(
        transfers: loaded.transfers.map((t) => t.id == id ? updated as StockTransfer : t).toList(),
        total: loaded.total,
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Purchase Orders
// ═══════════════════════════════════════════════════════════════════

final purchaseOrdersProvider = StateNotifierProvider<PurchaseOrdersNotifier, PurchaseOrdersState>((ref) {
  return PurchaseOrdersNotifier(ref.watch(inventoryRepositoryProvider));
});

class PurchaseOrdersNotifier extends StateNotifier<PurchaseOrdersState> {
  final InventoryRepository _repository;

  PurchaseOrdersNotifier(this._repository) : super(const PurchaseOrdersInitial());

  String? _statusFilter;

  Future<void> load({int page = 1}) async {
    state = const PurchaseOrdersLoading();
    try {
      final result = await _repository.listPurchaseOrders(page: page, status: _statusFilter);
      state = PurchaseOrdersLoaded(orders: result.items, total: result.total);
    } on DioException catch (e) {
      state = PurchaseOrdersError(message: _extractError(e));
    } catch (e) {
      state = PurchaseOrdersError(message: e.toString());
    }
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    await load();
  }

  Future<void> createOrder(Map<String, dynamic> data) async {
    try {
      final order = await _repository.createPurchaseOrder(data);
      if (state is PurchaseOrdersLoaded) {
        final loaded = state as PurchaseOrdersLoaded;
        state = PurchaseOrdersLoaded(orders: [order, ...loaded.orders], total: loaded.total + 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> sendOrder(String id) async {
    try {
      final updated = await _repository.sendPurchaseOrder(id);
      _updateOrderInState(id, updated);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> receiveOrder(String id, List<Map<String, dynamic>> items) async {
    try {
      final updated = await _repository.receivePurchaseOrder(id, items);
      _updateOrderInState(id, updated);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> cancelOrder(String id) async {
    try {
      final updated = await _repository.cancelPurchaseOrder(id);
      _updateOrderInState(id, updated);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  void _updateOrderInState(String id, dynamic updated) {
    if (state is PurchaseOrdersLoaded) {
      final loaded = state as PurchaseOrdersLoaded;
      state = PurchaseOrdersLoaded(
        orders: loaded.orders.map((o) => o.id == id ? updated as PurchaseOrder : o).toList(),
        total: loaded.total,
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Recipes
// ═══════════════════════════════════════════════════════════════════

final recipesProvider = StateNotifierProvider<RecipesNotifier, RecipesState>((ref) {
  return RecipesNotifier(ref.watch(inventoryRepositoryProvider));
});

class RecipesNotifier extends StateNotifier<RecipesState> {
  final InventoryRepository _repository;

  RecipesNotifier(this._repository) : super(const RecipesInitial());

  Future<void> load({int page = 1}) async {
    state = const RecipesLoading();
    try {
      final result = await _repository.listRecipes(page: page);
      state = RecipesLoaded(recipes: result.items, total: result.total);
    } on DioException catch (e) {
      state = RecipesError(message: _extractError(e));
    } catch (e) {
      state = RecipesError(message: e.toString());
    }
  }

  Future<void> createRecipe(Map<String, dynamic> data) async {
    try {
      final recipe = await _repository.createRecipe(data);
      if (state is RecipesLoaded) {
        final loaded = state as RecipesLoaded;
        state = RecipesLoaded(recipes: [recipe, ...loaded.recipes], total: loaded.total + 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> updateRecipe(String id, Map<String, dynamic> data) async {
    try {
      final updated = await _repository.updateRecipe(id, data);
      if (state is RecipesLoaded) {
        final loaded = state as RecipesLoaded;
        state = RecipesLoaded(recipes: loaded.recipes.map((r) => r.id == id ? updated : r).toList(), total: loaded.total);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _repository.deleteRecipe(id);
      if (state is RecipesLoaded) {
        final loaded = state as RecipesLoaded;
        state = RecipesLoaded(recipes: loaded.recipes.where((r) => r.id != id).toList(), total: loaded.total - 1);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}

// ─── Shared Helpers ────────────────────────────────────────────────

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
