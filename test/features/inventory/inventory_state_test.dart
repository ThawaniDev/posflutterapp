import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';
import 'package:thawani_pos/features/inventory/models/stock_level.dart';
import 'package:thawani_pos/features/inventory/models/goods_receipt.dart';
import 'package:thawani_pos/features/inventory/models/stock_adjustment.dart';
import 'package:thawani_pos/features/inventory/models/stock_transfer.dart';
import 'package:thawani_pos/features/inventory/models/purchase_order.dart';
import 'package:thawani_pos/features/inventory/models/recipe.dart';
import 'package:thawani_pos/features/inventory/enums/stock_adjustment_type.dart';
import 'package:thawani_pos/features/inventory/enums/stock_transfer_status.dart';
import 'package:thawani_pos/features/inventory/enums/purchase_order_status.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // StockLevelsState
  // ═══════════════════════════════════════════════════════════════

  group('StockLevelsState', () {
    test('StockLevelsInitial is default state', () {
      const state = StockLevelsInitial();
      expect(state, isA<StockLevelsState>());
    });

    test('StockLevelsLoading', () {
      const state = StockLevelsLoading();
      expect(state, isA<StockLevelsState>());
    });

    test('StockLevelsLoaded holds levels and pagination', () {
      final levels = [
        StockLevel.fromJson({'id': 'sl-1', 'store_id': 'store-1', 'product_id': 'prod-1', 'quantity': 42.5}),
      ];

      final state = StockLevelsLoaded(levels: levels, total: 50, currentPage: 1, lastPage: 3);

      expect(state.levels, hasLength(1));
      expect(state.total, 50);
      expect(state.hasMore, true);
      expect(state.lowStockOnly, false);
    });

    test('StockLevelsLoaded hasMore false on last page', () {
      const state = StockLevelsLoaded(levels: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.hasMore, false);
    });

    test('StockLevelsError holds message', () {
      const state = StockLevelsError(message: 'Network error');
      expect(state.message, 'Network error');
    });

    test('sealed class exhaustive switch', () {
      StockLevelsState state = const StockLevelsLoading();
      final result = switch (state) {
        StockLevelsInitial() => 'initial',
        StockLevelsLoading() => 'loading',
        StockLevelsLoaded() => 'loaded',
        StockLevelsError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // StockMovementsState
  // ═══════════════════════════════════════════════════════════════

  group('StockMovementsState', () {
    test('all states are subtypes', () {
      expect(const StockMovementsInitial(), isA<StockMovementsState>());
      expect(const StockMovementsLoading(), isA<StockMovementsState>());
      expect(const StockMovementsLoaded(movements: []), isA<StockMovementsState>());
      expect(const StockMovementsError(message: 'err'), isA<StockMovementsState>());
    });

    test('StockMovementsLoaded hasMore', () {
      const state = StockMovementsLoaded(movements: [], currentPage: 1, lastPage: 3, total: 50);
      expect(state.hasMore, true);

      const lastState = StockMovementsLoaded(movements: [], currentPage: 3, lastPage: 3, total: 50);
      expect(lastState.hasMore, false);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // GoodsReceiptsState
  // ═══════════════════════════════════════════════════════════════

  group('GoodsReceiptsState', () {
    test('all states are subtypes', () {
      expect(const GoodsReceiptsInitial(), isA<GoodsReceiptsState>());
      expect(const GoodsReceiptsLoading(), isA<GoodsReceiptsState>());
      expect(const GoodsReceiptsLoaded(receipts: []), isA<GoodsReceiptsState>());
      expect(const GoodsReceiptsError(message: 'err'), isA<GoodsReceiptsState>());
    });

    test('GoodsReceiptsLoaded holds data', () {
      final receipts = [
        GoodsReceipt.fromJson({'id': 'gr-1', 'store_id': 'store-1', 'status': 'draft', 'received_by': 'user-1'}),
      ];

      final state = GoodsReceiptsLoaded(receipts: receipts, total: 1);
      expect(state.receipts, hasLength(1));
      expect(state.total, 1);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // StockAdjustmentsState
  // ═══════════════════════════════════════════════════════════════

  group('StockAdjustmentsState', () {
    test('all states are subtypes', () {
      expect(const StockAdjustmentsInitial(), isA<StockAdjustmentsState>());
      expect(const StockAdjustmentsLoading(), isA<StockAdjustmentsState>());
      expect(const StockAdjustmentsLoaded(adjustments: []), isA<StockAdjustmentsState>());
      expect(const StockAdjustmentsError(message: 'err'), isA<StockAdjustmentsState>());
    });

    test('StockAdjustmentsLoaded holds data', () {
      final adj = StockAdjustment.fromJson({
        'id': 'sa-1',
        'store_id': 'store-1',
        'type': 'increase',
        'reason_code': 'correction',
        'adjusted_by': 'user-1',
      });

      final state = StockAdjustmentsLoaded(adjustments: [adj], total: 1);
      expect(state.adjustments.first.type, StockAdjustmentType.increase);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // StockTransfersState
  // ═══════════════════════════════════════════════════════════════

  group('StockTransfersState', () {
    test('all states are subtypes', () {
      expect(const StockTransfersInitial(), isA<StockTransfersState>());
      expect(const StockTransfersLoading(), isA<StockTransfersState>());
      expect(const StockTransfersLoaded(transfers: []), isA<StockTransfersState>());
      expect(const StockTransfersError(message: 'err'), isA<StockTransfersState>());
    });

    test('StockTransfersLoaded holds data', () {
      final transfer = StockTransfer.fromJson({
        'id': 'st-1',
        'organization_id': 'org-1',
        'from_store_id': 'store-1',
        'to_store_id': 'store-2',
        'status': 'in_transit',
        'created_by': 'user-1',
      });

      final state = StockTransfersLoaded(transfers: [transfer], total: 1);
      expect(state.transfers.first.status, StockTransferStatus.inTransit);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // PurchaseOrdersState
  // ═══════════════════════════════════════════════════════════════

  group('PurchaseOrdersState', () {
    test('all states are subtypes', () {
      expect(const PurchaseOrdersInitial(), isA<PurchaseOrdersState>());
      expect(const PurchaseOrdersLoading(), isA<PurchaseOrdersState>());
      expect(const PurchaseOrdersLoaded(orders: []), isA<PurchaseOrdersState>());
      expect(const PurchaseOrdersError(message: 'err'), isA<PurchaseOrdersState>());
    });

    test('PurchaseOrdersLoaded holds data', () {
      final po = PurchaseOrder.fromJson({
        'id': 'po-1',
        'organization_id': 'org-1',
        'store_id': 'store-1',
        'supplier_id': 'sup-1',
        'status': 'sent',
        'created_by': 'user-1',
      });

      final state = PurchaseOrdersLoaded(orders: [po], total: 1);
      expect(state.orders.first.status, PurchaseOrderStatus.sent);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // RecipesState
  // ═══════════════════════════════════════════════════════════════

  group('RecipesState', () {
    test('all states are subtypes', () {
      expect(const RecipesInitial(), isA<RecipesState>());
      expect(const RecipesLoading(), isA<RecipesState>());
      expect(const RecipesLoaded(recipes: []), isA<RecipesState>());
      expect(const RecipesError(message: 'err'), isA<RecipesState>());
    });

    test('RecipesLoaded holds data', () {
      final recipe = Recipe.fromJson({
        'id': 'rec-1',
        'organization_id': 'org-1',
        'product_id': 'prod-1',
        'yield_quantity': 2.0,
        'is_active': true,
      });

      final state = RecipesLoaded(recipes: [recipe], total: 1);
      expect(state.recipes.first.yieldQuantity, 2.0);
      expect(state.recipes.first.isActive, true);
    });
  });
}
