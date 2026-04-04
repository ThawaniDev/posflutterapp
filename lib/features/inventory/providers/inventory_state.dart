import 'package:thawani_pos/features/inventory/models/goods_receipt.dart';
import 'package:thawani_pos/features/inventory/models/purchase_order.dart';
import 'package:thawani_pos/features/inventory/models/recipe.dart';
import 'package:thawani_pos/features/inventory/models/stock_adjustment.dart';
import 'package:thawani_pos/features/inventory/models/stock_level.dart';
import 'package:thawani_pos/features/inventory/models/stock_movement.dart';
import 'package:thawani_pos/features/inventory/models/stock_transfer.dart';
import 'package:thawani_pos/features/inventory/models/supplier_return.dart';

// ═══════════════════════════════════════════════════════════════════
// Stock Levels State
// ═══════════════════════════════════════════════════════════════════

sealed class StockLevelsState {
  const StockLevelsState();
}

class StockLevelsInitial extends StockLevelsState {
  const StockLevelsInitial();
}

class StockLevelsLoading extends StockLevelsState {
  const StockLevelsLoading();
}

class StockLevelsLoaded extends StockLevelsState {
  final List<StockLevel> levels;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool lowStockOnly;
  final String? search;

  const StockLevelsLoaded({
    required this.levels,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.lowStockOnly = false,
    this.search,
  });

  bool get hasMore => currentPage < lastPage;
}

class StockLevelsError extends StockLevelsState {
  final String message;
  const StockLevelsError({required this.message});
}

// ═══════════════════════════════════════════════════════════════════
// Stock Movements State
// ═══════════════════════════════════════════════════════════════════

sealed class StockMovementsState {
  const StockMovementsState();
}

class StockMovementsInitial extends StockMovementsState {
  const StockMovementsInitial();
}

class StockMovementsLoading extends StockMovementsState {
  const StockMovementsLoading();
}

class StockMovementsLoaded extends StockMovementsState {
  final List<StockMovement> movements;
  final int total;
  final int currentPage;
  final int lastPage;

  const StockMovementsLoaded({required this.movements, this.total = 0, this.currentPage = 1, this.lastPage = 1});

  bool get hasMore => currentPage < lastPage;
}

class StockMovementsError extends StockMovementsState {
  final String message;
  const StockMovementsError({required this.message});
}

// ═══════════════════════════════════════════════════════════════════
// Goods Receipts State
// ═══════════════════════════════════════════════════════════════════

sealed class GoodsReceiptsState {
  const GoodsReceiptsState();
}

class GoodsReceiptsInitial extends GoodsReceiptsState {
  const GoodsReceiptsInitial();
}

class GoodsReceiptsLoading extends GoodsReceiptsState {
  const GoodsReceiptsLoading();
}

class GoodsReceiptsLoaded extends GoodsReceiptsState {
  final List<GoodsReceipt> receipts;
  final int total;
  final int currentPage;
  final int lastPage;

  const GoodsReceiptsLoaded({required this.receipts, this.total = 0, this.currentPage = 1, this.lastPage = 1});
}

class GoodsReceiptsError extends GoodsReceiptsState {
  final String message;
  const GoodsReceiptsError({required this.message});
}

// ═══════════════════════════════════════════════════════════════════
// Stock Adjustments State
// ═══════════════════════════════════════════════════════════════════

sealed class StockAdjustmentsState {
  const StockAdjustmentsState();
}

class StockAdjustmentsInitial extends StockAdjustmentsState {
  const StockAdjustmentsInitial();
}

class StockAdjustmentsLoading extends StockAdjustmentsState {
  const StockAdjustmentsLoading();
}

class StockAdjustmentsLoaded extends StockAdjustmentsState {
  final List<StockAdjustment> adjustments;
  final int total;
  const StockAdjustmentsLoaded({required this.adjustments, this.total = 0});
}

class StockAdjustmentsError extends StockAdjustmentsState {
  final String message;
  const StockAdjustmentsError({required this.message});
}

// ═══════════════════════════════════════════════════════════════════
// Stock Transfers State
// ═══════════════════════════════════════════════════════════════════

sealed class StockTransfersState {
  const StockTransfersState();
}

class StockTransfersInitial extends StockTransfersState {
  const StockTransfersInitial();
}

class StockTransfersLoading extends StockTransfersState {
  const StockTransfersLoading();
}

class StockTransfersLoaded extends StockTransfersState {
  final List<StockTransfer> transfers;
  final int total;
  const StockTransfersLoaded({required this.transfers, this.total = 0});
}

class StockTransfersError extends StockTransfersState {
  final String message;
  const StockTransfersError({required this.message});
}

// ═══════════════════════════════════════════════════════════════════
// Purchase Orders State
// ═══════════════════════════════════════════════════════════════════

sealed class PurchaseOrdersState {
  const PurchaseOrdersState();
}

class PurchaseOrdersInitial extends PurchaseOrdersState {
  const PurchaseOrdersInitial();
}

class PurchaseOrdersLoading extends PurchaseOrdersState {
  const PurchaseOrdersLoading();
}

class PurchaseOrdersLoaded extends PurchaseOrdersState {
  final List<PurchaseOrder> orders;
  final int total;
  const PurchaseOrdersLoaded({required this.orders, this.total = 0});
}

class PurchaseOrdersError extends PurchaseOrdersState {
  final String message;
  const PurchaseOrdersError({required this.message});
}

// ═══════════════════════════════════════════════════════════════════
// Recipes State
// ═══════════════════════════════════════════════════════════════════

sealed class RecipesState {
  const RecipesState();
}

class RecipesInitial extends RecipesState {
  const RecipesInitial();
}

class RecipesLoading extends RecipesState {
  const RecipesLoading();
}

class RecipesLoaded extends RecipesState {
  final List<Recipe> recipes;
  final int total;
  const RecipesLoaded({required this.recipes, this.total = 0});
}

class RecipesError extends RecipesState {
  final String message;
  const RecipesError({required this.message});
}

// ═══════════════════════════════════════════════════════════════════
// Supplier Returns State
// ═══════════════════════════════════════════════════════════════════

sealed class SupplierReturnsState {
  const SupplierReturnsState();
}

class SupplierReturnsInitial extends SupplierReturnsState {
  const SupplierReturnsInitial();
}

class SupplierReturnsLoading extends SupplierReturnsState {
  const SupplierReturnsLoading();
}

class SupplierReturnsLoaded extends SupplierReturnsState {
  final List<SupplierReturn> returns;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const SupplierReturnsLoaded({
    required this.returns,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 25,
  });
}

class SupplierReturnsError extends SupplierReturnsState {
  final String message;
  const SupplierReturnsError({required this.message});
}
