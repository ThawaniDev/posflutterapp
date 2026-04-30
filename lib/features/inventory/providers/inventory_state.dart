import 'package:wameedpos/features/inventory/models/goods_receipt.dart';
import 'package:wameedpos/features/inventory/models/purchase_order.dart';
import 'package:wameedpos/features/inventory/models/recipe.dart';
import 'package:wameedpos/features/inventory/models/stock_adjustment.dart';
import 'package:wameedpos/features/inventory/models/stock_batch.dart';
import 'package:wameedpos/features/inventory/models/stock_level.dart';
import 'package:wameedpos/features/inventory/models/stock_movement.dart';
import 'package:wameedpos/features/inventory/models/stock_transfer.dart';
import 'package:wameedpos/features/inventory/models/stocktake.dart';
import 'package:wameedpos/features/inventory/models/supplier_return.dart';
import 'package:wameedpos/features/inventory/models/waste_record.dart';

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

  const StockLevelsLoaded({
    required this.levels,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.lowStockOnly = false,
    this.search,
  });
  final List<StockLevel> levels;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool lowStockOnly;
  final String? search;

  bool get hasMore => currentPage < lastPage;
}

class StockLevelsError extends StockLevelsState {
  const StockLevelsError({required this.message});
  final String message;
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

  const StockMovementsLoaded({required this.movements, this.total = 0, this.currentPage = 1, this.lastPage = 1});
  final List<StockMovement> movements;
  final int total;
  final int currentPage;
  final int lastPage;

  bool get hasMore => currentPage < lastPage;
}

class StockMovementsError extends StockMovementsState {
  const StockMovementsError({required this.message});
  final String message;
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

  const GoodsReceiptsLoaded({required this.receipts, this.total = 0, this.currentPage = 1, this.lastPage = 1});
  final List<GoodsReceipt> receipts;
  final int total;
  final int currentPage;
  final int lastPage;
}

class GoodsReceiptsError extends GoodsReceiptsState {
  const GoodsReceiptsError({required this.message});
  final String message;
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
  const StockAdjustmentsLoaded({required this.adjustments, this.total = 0});
  final List<StockAdjustment> adjustments;
  final int total;
}

class StockAdjustmentsError extends StockAdjustmentsState {
  const StockAdjustmentsError({required this.message});
  final String message;
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
  const StockTransfersLoaded({required this.transfers, this.total = 0});
  final List<StockTransfer> transfers;
  final int total;
}

class StockTransfersError extends StockTransfersState {
  const StockTransfersError({required this.message});
  final String message;
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
  const PurchaseOrdersLoaded({required this.orders, this.total = 0});
  final List<PurchaseOrder> orders;
  final int total;
}

class PurchaseOrdersError extends PurchaseOrdersState {
  const PurchaseOrdersError({required this.message});
  final String message;
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
  const RecipesLoaded({required this.recipes, this.total = 0});
  final List<Recipe> recipes;
  final int total;
}

class RecipesError extends RecipesState {
  const RecipesError({required this.message});
  final String message;
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

  const SupplierReturnsLoaded({
    required this.returns,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 25,
  });
  final List<SupplierReturn> returns;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
}

class SupplierReturnsError extends SupplierReturnsState {
  const SupplierReturnsError({required this.message});
  final String message;
}

// ═══════════════════════════════════════════════════════════════════
// Stocktakes State
// ═══════════════════════════════════════════════════════════════════

sealed class StocktakesState {
  const StocktakesState();
}

class StocktakesInitial extends StocktakesState {
  const StocktakesInitial();
}

class StocktakesLoading extends StocktakesState {
  const StocktakesLoading();
}

class StocktakesLoaded extends StocktakesState {
  const StocktakesLoaded({
    required this.stocktakes,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.statusFilter,
  });
  final List<Stocktake> stocktakes;
  final int total;
  final int currentPage;
  final int lastPage;
  final String? statusFilter;

  bool get hasMore => currentPage < lastPage;
}

class StocktakesError extends StocktakesState {
  const StocktakesError({required this.message});
  final String message;
}

// ═══════════════════════════════════════════════════════════════════
// Waste Records State
// ═══════════════════════════════════════════════════════════════════

sealed class WasteRecordsState {
  const WasteRecordsState();
}

class WasteRecordsInitial extends WasteRecordsState {
  const WasteRecordsInitial();
}

class WasteRecordsLoading extends WasteRecordsState {
  const WasteRecordsLoading();
}

class WasteRecordsLoaded extends WasteRecordsState {
  const WasteRecordsLoaded({
    required this.records,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
  });
  final List<WasteRecord> records;
  final int total;
  final int currentPage;
  final int lastPage;

  bool get hasMore => currentPage < lastPage;
}

class WasteRecordsError extends WasteRecordsState {
  const WasteRecordsError({required this.message});
  final String message;
}

// ═══════════════════════════════════════════════════════════════════
// Expiry Alerts State
// ═══════════════════════════════════════════════════════════════════

sealed class ExpiryAlertsState {
  const ExpiryAlertsState();
}

class ExpiryAlertsInitial extends ExpiryAlertsState {
  const ExpiryAlertsInitial();
}

class ExpiryAlertsLoading extends ExpiryAlertsState {
  const ExpiryAlertsLoading();
}

class ExpiryAlertsLoaded extends ExpiryAlertsState {
  const ExpiryAlertsLoaded({
    required this.batches,
    this.total = 0,
  });
  final List<StockBatch> batches;
  final int total;

  List<StockBatch> get expired =>
      batches.where((b) => b.expiryDate != null && b.expiryDate!.isBefore(DateTime.now())).toList();

  List<StockBatch> get expiringSoon7 => batches
      .where((b) =>
          b.expiryDate != null &&
          !b.expiryDate!.isBefore(DateTime.now()) &&
          b.expiryDate!.isBefore(DateTime.now().add(const Duration(days: 7))))
      .toList();

  List<StockBatch> get expiringSoon30 => batches
      .where((b) =>
          b.expiryDate != null &&
          !b.expiryDate!.isBefore(DateTime.now().add(const Duration(days: 7))) &&
          b.expiryDate!.isBefore(DateTime.now().add(const Duration(days: 30))))
      .toList();
}

class ExpiryAlertsError extends ExpiryAlertsState {
  const ExpiryAlertsError({required this.message});
  final String message;
}
