import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/inventory/models/stock_level.dart';
import 'package:thawani_pos/features/inventory/models/stock_movement.dart';
import 'package:thawani_pos/features/inventory/models/goods_receipt.dart';
import 'package:thawani_pos/features/inventory/models/stock_adjustment.dart';
import 'package:thawani_pos/features/inventory/models/stock_transfer.dart';
import 'package:thawani_pos/features/inventory/models/purchase_order.dart';
import 'package:thawani_pos/features/inventory/models/recipe.dart';
import 'package:thawani_pos/features/inventory/enums/stock_movement_type.dart';
import 'package:thawani_pos/features/inventory/enums/stock_reference_type.dart';
import 'package:thawani_pos/features/inventory/enums/goods_receipt_status.dart';
import 'package:thawani_pos/features/inventory/enums/stock_adjustment_type.dart';
import 'package:thawani_pos/features/inventory/enums/stock_transfer_status.dart';
import 'package:thawani_pos/features/inventory/enums/purchase_order_status.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // StockLevel
  // ═══════════════════════════════════════════════════════════════

  group('StockLevel', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'sl-uuid-1',
        'store_id': 'store-uuid-1',
        'product_id': 'prod-uuid-1',
        'quantity': 42.5,
        'reserved_quantity': 5.0,
        'reorder_point': 10.0,
        'max_stock_level': 100.0,
        'average_cost': 3.25,
        'sync_version': 7,
        'updated_at': '2024-06-20T14:00:00.000Z',
      };

      final model = StockLevel.fromJson(json);
      expect(model.id, 'sl-uuid-1');
      expect(model.storeId, 'store-uuid-1');
      expect(model.productId, 'prod-uuid-1');
      expect(model.quantity, 42.5);
      expect(model.reservedQuantity, 5.0);
      expect(model.reorderPoint, 10.0);
      expect(model.maxStockLevel, 100.0);
      expect(model.averageCost, 3.25);
      expect(model.syncVersion, 7);
      expect(model.updatedAt, isNotNull);
    });

    test('fromJson handles minimal fields', () {
      final json = {'id': 'sl-uuid-2', 'store_id': 'store-uuid-1', 'product_id': 'prod-uuid-2', 'quantity': 0};

      final model = StockLevel.fromJson(json);
      expect(model.quantity, 0.0);
      expect(model.reservedQuantity, isNull);
      expect(model.reorderPoint, isNull);
    });

    test('toJson round-trips', () {
      final json = {
        'id': 'sl-uuid-1',
        'store_id': 'store-uuid-1',
        'product_id': 'prod-uuid-1',
        'quantity': 10.0,
        'reserved_quantity': null,
        'reorder_point': 5.0,
        'max_stock_level': null,
        'average_cost': null,
        'sync_version': null,
        'updated_at': null,
      };
      final model = StockLevel.fromJson(json);
      final out = model.toJson();
      expect(out['id'], 'sl-uuid-1');
      expect(out['quantity'], 10.0);
      expect(out['reorder_point'], 5.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // StockMovement
  // ═══════════════════════════════════════════════════════════════

  group('StockMovement', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'sm-uuid-1',
        'store_id': 'store-uuid-1',
        'product_id': 'prod-uuid-1',
        'type': 'receipt',
        'quantity': 100.0,
        'unit_cost': 3.50,
        'reference_type': 'goods_receipt',
        'reference_id': 'gr-uuid-1',
        'reason': 'Initial stock',
        'performed_by': 'user-uuid-1',
        'created_at': '2024-06-20T14:00:00.000Z',
      };

      final model = StockMovement.fromJson(json);
      expect(model.id, 'sm-uuid-1');
      expect(model.type, StockMovementType.receipt);
      expect(model.quantity, 100.0);
      expect(model.unitCost, 3.50);
      expect(model.referenceType, StockReferenceType.goodsReceipt);
      expect(model.reason, 'Initial stock');
    });

    test('fromJson handles minimal fields', () {
      final json = {'id': 'sm-uuid-2', 'store_id': 'store-uuid-1', 'product_id': 'prod-uuid-1', 'type': 'sale', 'quantity': 5.0};

      final model = StockMovement.fromJson(json);
      expect(model.type, StockMovementType.sale);
      expect(model.unitCost, isNull);
      expect(model.referenceType, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // GoodsReceipt
  // ═══════════════════════════════════════════════════════════════

  group('GoodsReceipt', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'gr-uuid-1',
        'store_id': 'store-uuid-1',
        'supplier_id': 'sup-uuid-1',
        'purchase_order_id': 'po-uuid-1',
        'reference_number': 'GR-2024-001',
        'status': 'draft',
        'total_cost': 500.0,
        'notes': 'Test receipt',
        'received_by': 'user-uuid-1',
        'received_at': '2024-06-20T14:00:00.000Z',
        'confirmed_at': null,
      };

      final model = GoodsReceipt.fromJson(json);
      expect(model.id, 'gr-uuid-1');
      expect(model.supplierId, 'sup-uuid-1');
      expect(model.status, GoodsReceiptStatus.draft);
      expect(model.totalCost, 500.0);
      expect(model.confirmedAt, isNull);
    });

    test('status confirmed', () {
      final json = {'id': 'gr-uuid-2', 'store_id': 'store-uuid-1', 'status': 'confirmed', 'received_by': 'user-uuid-1'};

      final model = GoodsReceipt.fromJson(json);
      expect(model.status, GoodsReceiptStatus.confirmed);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // StockAdjustment
  // ═══════════════════════════════════════════════════════════════

  group('StockAdjustment', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'sa-uuid-1',
        'store_id': 'store-uuid-1',
        'type': 'increase',
        'reason_code': 'count_correction',
        'notes': 'Found extra items',
        'adjusted_by': 'user-uuid-1',
        'created_at': '2024-06-20T14:00:00.000Z',
      };

      final model = StockAdjustment.fromJson(json);
      expect(model.type, StockAdjustmentType.increase);
      expect(model.reasonCode, 'count_correction');
      expect(model.notes, 'Found extra items');
    });

    test('fromJson decrease type', () {
      final json = {
        'id': 'sa-uuid-2',
        'store_id': 'store-uuid-1',
        'type': 'decrease',
        'reason_code': 'damaged',
        'adjusted_by': 'user-uuid-1',
      };

      final model = StockAdjustment.fromJson(json);
      expect(model.type, StockAdjustmentType.decrease);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // StockTransfer
  // ═══════════════════════════════════════════════════════════════

  group('StockTransfer', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'st-uuid-1',
        'organization_id': 'org-uuid-1',
        'from_store_id': 'store-uuid-1',
        'to_store_id': 'store-uuid-2',
        'status': 'pending',
        'reference_number': 'TR-001',
        'notes': 'Transfer request',
        'created_by': 'user-uuid-1',
        'approved_by': null,
        'received_by': null,
        'created_at': '2024-06-20T14:00:00.000Z',
        'approved_at': null,
        'received_at': null,
      };

      final model = StockTransfer.fromJson(json);
      expect(model.id, 'st-uuid-1');
      expect(model.fromStoreId, 'store-uuid-1');
      expect(model.toStoreId, 'store-uuid-2');
      expect(model.status, StockTransferStatus.pending);
      expect(model.approvedBy, isNull);
    });

    test('all statuses parse correctly', () {
      for (final status in ['pending', 'in_transit', 'completed', 'cancelled']) {
        final json = {
          'id': 'st-uuid',
          'organization_id': 'org-uuid',
          'from_store_id': 'store-1',
          'to_store_id': 'store-2',
          'status': status,
          'created_by': 'user-uuid',
        };
        final model = StockTransfer.fromJson(json);
        expect(model.status, isNotNull);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // PurchaseOrder
  // ═══════════════════════════════════════════════════════════════

  group('PurchaseOrder', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'po-uuid-1',
        'organization_id': 'org-uuid-1',
        'store_id': 'store-uuid-1',
        'supplier_id': 'sup-uuid-1',
        'reference_number': 'PO-2024-001',
        'status': 'draft',
        'expected_date': '2024-07-01',
        'total_cost': 1250.50,
        'notes': 'Monthly order',
        'created_by': 'user-uuid-1',
        'created_at': '2024-06-20T14:00:00.000Z',
        'updated_at': '2024-06-20T14:00:00.000Z',
      };

      final model = PurchaseOrder.fromJson(json);
      expect(model.id, 'po-uuid-1');
      expect(model.supplierId, 'sup-uuid-1');
      expect(model.status, PurchaseOrderStatus.draft);
      expect(model.totalCost, 1250.50);
      expect(model.notes, 'Monthly order');
    });

    test('all statuses parse correctly', () {
      for (final status in ['draft', 'sent', 'partially_received', 'fully_received', 'cancelled']) {
        final json = {
          'id': 'po-uuid',
          'organization_id': 'org-uuid',
          'store_id': 'store-uuid',
          'supplier_id': 'sup-uuid',
          'status': status,
          'created_by': 'user-uuid',
        };
        final model = PurchaseOrder.fromJson(json);
        expect(model.status, isNotNull);
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Recipe
  // ═══════════════════════════════════════════════════════════════

  group('Recipe', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'rec-uuid-1',
        'organization_id': 'org-uuid-1',
        'product_id': 'prod-uuid-1',
        'yield_quantity': 1.5,
        'is_active': true,
        'created_at': '2024-06-20T14:00:00.000Z',
        'updated_at': '2024-06-20T14:00:00.000Z',
      };

      final model = Recipe.fromJson(json);
      expect(model.id, 'rec-uuid-1');
      expect(model.productId, 'prod-uuid-1');
      expect(model.yieldQuantity, 1.5);
      expect(model.isActive, true);
      expect(model.createdAt, isNotNull);
    });

    test('fromJson handles minimal fields', () {
      final json = {'id': 'rec-uuid-2', 'organization_id': 'org-uuid-1', 'product_id': 'prod-uuid-2', 'yield_quantity': 1};

      final model = Recipe.fromJson(json);
      expect(model.yieldQuantity, 1.0);
      expect(model.isActive, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Enums
  // ═══════════════════════════════════════════════════════════════

  group('Enums', () {
    test('StockMovementType values', () {
      expect(StockMovementType.receipt.value, 'receipt');
      expect(StockMovementType.sale.value, 'sale');
      expect(StockMovementType.adjustmentIn.value, 'adjustment_in');
      expect(StockMovementType.adjustmentOut.value, 'adjustment_out');
      expect(StockMovementType.transferOut.value, 'transfer_out');
      expect(StockMovementType.transferIn.value, 'transfer_in');
      expect(StockMovementType.waste.value, 'waste');
      expect(StockMovementType.recipeDeduction.value, 'recipe_deduction');
    });

    test('StockMovementType fromValue', () {
      expect(StockMovementType.fromValue('receipt'), StockMovementType.receipt);
      expect(StockMovementType.fromValue('adjustment_in'), StockMovementType.adjustmentIn);
    });

    test('StockReferenceType values', () {
      expect(StockReferenceType.goodsReceipt.value, 'goods_receipt');
      expect(StockReferenceType.adjustment.value, 'adjustment');
      expect(StockReferenceType.transfer.value, 'transfer');
    });

    test('GoodsReceiptStatus values', () {
      expect(GoodsReceiptStatus.draft.value, 'draft');
      expect(GoodsReceiptStatus.confirmed.value, 'confirmed');
    });

    test('StockAdjustmentType values', () {
      expect(StockAdjustmentType.increase.value, 'increase');
      expect(StockAdjustmentType.decrease.value, 'decrease');
    });

    test('StockTransferStatus values', () {
      expect(StockTransferStatus.pending.value, 'pending');
      expect(StockTransferStatus.inTransit.value, 'in_transit');
      expect(StockTransferStatus.completed.value, 'completed');
      expect(StockTransferStatus.cancelled.value, 'cancelled');
    });

    test('PurchaseOrderStatus values', () {
      expect(PurchaseOrderStatus.draft.value, 'draft');
      expect(PurchaseOrderStatus.sent.value, 'sent');
      expect(PurchaseOrderStatus.partiallyReceived.value, 'partially_received');
      expect(PurchaseOrderStatus.fullyReceived.value, 'fully_received');
      expect(PurchaseOrderStatus.cancelled.value, 'cancelled');
    });
  });
}
