// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/inventory/data/remote/inventory_api_service.dart';
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

// ─── Helpers ──────────────────────────────────────────────────────

/// Creates a Dio instance whose interceptor immediately resolves every request
/// with the data returned by [handler].
Dio _fakeDio(Map<String, dynamic> Function(RequestOptions opts) handler) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (opts, requestHandler) {
        try {
          requestHandler.resolve(
            Response(data: handler(opts), requestOptions: opts, statusCode: 200),
          );
        } catch (e) {
          requestHandler.reject(DioException(requestOptions: opts, error: e));
        }
      },
    ),
  );
  return dio;
}

/// Standard API envelope.
Map<String, dynamic> _envelope(dynamic data, {String message = 'ok'}) => {
      'success': true,
      'message': message,
      'data': data,
    };

/// Standard paginated envelope wrapping a list.
Map<String, dynamic> _paginated(
  List<dynamic> items, {
  int total = 0,
  int currentPage = 1,
  int lastPage = 1,
  int perPage = 25,
}) =>
    _envelope({
      'data': items,
      'total': total == 0 ? items.length : total,
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
    });

// ─── Minimal model fixtures ───────────────────────────────────────

Map<String, dynamic> _stockLevelJson({String id = 'sl-001', double qty = 10.0}) => {
      'id': id,
      'store_id': 'store-001',
      'product_id': 'prod-001',
      'quantity': qty.toString(),
      'sync_version': 1,
    };

Map<String, dynamic> _stockMovementJson({String id = 'sm-001'}) => {
      'id': id,
      'store_id': 'store-001',
      'product_id': 'prod-001',
      'type': 'receipt',
      'quantity': '10.00',
      'reference_type': 'goods_receipt',
    };

Map<String, dynamic> _goodsReceiptJson({String id = 'gr-001', String status = 'draft'}) => {
      'id': id,
      'store_id': 'store-001',
      'received_by': 'user-001',
      'status': status,
    };

Map<String, dynamic> _stockAdjustmentJson({String id = 'adj-001'}) => {
      'id': id,
      'store_id': 'store-001',
      'type': 'increase',
      'reason': 'Found extra stock',
      'created_by': 'user-001',
    };

Map<String, dynamic> _stockTransferJson({String id = 'st-001', String status = 'draft'}) => {
      'id': id,
      'organization_id': 'org-001',
      'from_store_id': 'store-001',
      'to_store_id': 'store-002',
      'status': status,
      'created_by': 'user-001',
    };

Map<String, dynamic> _purchaseOrderJson({String id = 'po-001', String status = 'draft'}) => {
      'id': id,
      'organization_id': 'org-001',
      'store_id': 'store-001',
      'supplier_id': 'sup-001',
      'status': status,
      'created_by': 'user-001',
    };

Map<String, dynamic> _recipeJson({String id = 'rec-001'}) => {
      'id': id,
      'organization_id': 'org-001',
      'product_id': 'prod-001',
      'name': 'Test Recipe',
      'yield_quantity': '1.00',
      'is_active': true,
      'ingredients': <dynamic>[],
    };

Map<String, dynamic> _stocktakeJson({String id = 'skt-001', String status = 'in_progress'}) => {
      'id': id,
      'store_id': 'store-001',
      'status': status,
      'type': 'full',
      'created_by': 'user-001',
    };

Map<String, dynamic> _wasteRecordJson({String id = 'wr-001'}) => {
      'id': id,
      'store_id': 'store-001',
      'product_id': 'prod-001',
      'quantity': '2.00',
      'reason': 'expired',
    };

Map<String, dynamic> _supplierReturnJson({String id = 'sr-001', String status = 'draft'}) => {
      'id': id,
      'organization_id': 'org-001',
      'store_id': 'store-001',
      'supplier_id': 'sup-001',
      'status': status,
      'created_by': 'user-001',
    };

Map<String, dynamic> _stockBatchJson({String id = 'sb-001'}) => {
      'id': id,
      'store_id': 'store-001',
      'product_id': 'prod-001',
      'quantity': '5.00',
      'batch_number': 'BATCH-001',
    };

// ═══════════════════════════════════════════════════════════════════
// Tests
// ═══════════════════════════════════════════════════════════════════

void main() {
  // ─── listStockLevels ──────────────────────────────────────────

  group('InventoryApiService.listStockLevels', () {
    test('sends store_id, page, per_page as query params', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.stockLevels);
        expect(opts.method, 'GET');
        expect(opts.queryParameters['store_id'], 'store-001');
        expect(opts.queryParameters['page'], 1);
        expect(opts.queryParameters['per_page'], 25);
        return _paginated([_stockLevelJson()]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listStockLevels(storeId: 'store-001');

      expect(result.items, hasLength(1));
      expect(result.items.first.id, 'sl-001');
      expect(result.total, 1);
    });

    test('sends optional low_stock filter when true', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['low_stock'], 1);
        return _paginated([]);
      });

      final svc = InventoryApiService(dio);
      await svc.listStockLevels(storeId: 'store-001', lowStock: true);
    });

    test('sends search param when provided', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['search'], 'milk');
        return _paginated([]);
      });

      final svc = InventoryApiService(dio);
      await svc.listStockLevels(storeId: 'store-001', search: 'milk');
    });

    test('parses StockLevel.quantity correctly', () async {
      final dio = _fakeDio((_) => _paginated([_stockLevelJson(qty: 42.5)]));

      final svc = InventoryApiService(dio);
      final result = await svc.listStockLevels(storeId: 'store-001');

      expect(result.items.first.quantity, 42.5);
    });

    test('handles pagination metadata', () async {
      final dio = _fakeDio(
        (_) => _paginated([_stockLevelJson(), _stockLevelJson(id: 'sl-002')],
            total: 50, currentPage: 2, lastPage: 5),
      );

      final svc = InventoryApiService(dio);
      final result = await svc.listStockLevels(storeId: 'store-001');

      expect(result.total, 50);
      expect(result.currentPage, 2);
      expect(result.lastPage, 5);
      expect(result.hasMore, true);
    });
  });

  // ─── setReorderPoint ──────────────────────────────────────────

  group('InventoryApiService.setReorderPoint', () {
    test('sends PUT to correct URL with reorder_point', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.stockLevels}/sl-001/reorder-point');
        expect(opts.method, 'PUT');
        expect((opts.data as Map)['reorder_point'], 5.0);
        return _envelope(_stockLevelJson());
      });

      final svc = InventoryApiService(dio);
      final result = await svc.setReorderPoint('sl-001', reorderPoint: 5.0);

      expect(result, isA<StockLevel>());
      expect(result.id, 'sl-001');
    });
  });

  // ─── listStockMovements ───────────────────────────────────────

  group('InventoryApiService.listStockMovements', () {
    test('sends store_id and parses movements', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.stockMovements);
        expect(opts.queryParameters['store_id'], 'store-001');
        return _paginated([_stockMovementJson()]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listStockMovements(storeId: 'store-001');

      expect(result.items, hasLength(1));
      expect(result.items.first.id, 'sm-001');
    });
  });

  // ─── Goods Receipts ───────────────────────────────────────────

  group('InventoryApiService.listGoodsReceipts', () {
    test('sends store_id and parses list', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.goodsReceipts);
        expect(opts.queryParameters['store_id'], 'store-001');
        return _paginated([_goodsReceiptJson(), _goodsReceiptJson(id: 'gr-002')]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listGoodsReceipts(storeId: 'store-001');

      expect(result.items, hasLength(2));
      expect(result.items.first, isA<GoodsReceipt>());
    });
  });

  group('InventoryApiService.createGoodsReceipt', () {
    test('sends POST with data and returns parsed receipt', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.goodsReceipts);
        return _envelope(_goodsReceiptJson(id: 'gr-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createGoodsReceipt({'store_id': 'store-001', 'items': []});

      expect(result.id, 'gr-new');
    });
  });

  group('InventoryApiService.getGoodsReceipt', () {
    test('sends GET to /goods-receipts/:id', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.goodsReceipts}/gr-001');
        return _envelope(_goodsReceiptJson());
      });

      final svc = InventoryApiService(dio);
      final result = await svc.getGoodsReceipt('gr-001');

      expect(result.id, 'gr-001');
    });
  });

  group('InventoryApiService.confirmGoodsReceipt', () {
    test('sends POST to /goods-receipts/:id/confirm', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.goodsReceipts}/gr-001/confirm');
        expect(opts.method, 'POST');
        return _envelope(_goodsReceiptJson(status: 'confirmed'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.confirmGoodsReceipt('gr-001');

      expect(result.id, 'gr-001');
    });
  });

  // ─── Stock Adjustments ────────────────────────────────────────

  group('InventoryApiService.listStockAdjustments', () {
    test('sends store_id and parses list', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.stockAdjustments);
        expect(opts.queryParameters['store_id'], 'store-001');
        return _paginated([_stockAdjustmentJson()]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listStockAdjustments(storeId: 'store-001');

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<StockAdjustment>());
    });
  });

  group('InventoryApiService.createStockAdjustment', () {
    test('sends POST and returns parsed adjustment', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        return _envelope(_stockAdjustmentJson(id: 'adj-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createStockAdjustment({'store_id': 'store-001', 'type': 'increase'});

      expect(result.id, 'adj-new');
    });
  });

  // ─── Stock Transfers ──────────────────────────────────────────

  group('InventoryApiService.listStockTransfers', () {
    test('parses transfer list', () async {
      final dio = _fakeDio((_) => _paginated([_stockTransferJson()]));

      final svc = InventoryApiService(dio);
      final result = await svc.listStockTransfers();

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<StockTransfer>());
    });
  });

  group('InventoryApiService.createStockTransfer', () {
    test('sends POST and returns transfer', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        return _envelope(_stockTransferJson(id: 'st-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createStockTransfer({'from_store_id': 'store-001', 'to_store_id': 'store-002'});

      expect(result.id, 'st-new');
    });
  });

  group('InventoryApiService.approveTransfer', () {
    test('sends POST to /stock-transfers/:id/approve', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.stockTransfers}/st-001/approve');
        return _envelope(_stockTransferJson(status: 'approved'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.approveTransfer('st-001');

      expect(result, isA<StockTransfer>());
    });
  });

  group('InventoryApiService.receiveTransfer', () {
    test('sends POST to /stock-transfers/:id/receive', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.stockTransfers}/st-001/receive');
        return _envelope(_stockTransferJson(status: 'received'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.receiveTransfer('st-001');

      expect(result, isA<StockTransfer>());
    });
  });

  group('InventoryApiService.cancelTransfer', () {
    test('sends POST to /stock-transfers/:id/cancel', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.stockTransfers}/st-001/cancel');
        return _envelope(_stockTransferJson(status: 'cancelled'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.cancelTransfer('st-001');

      expect(result, isA<StockTransfer>());
    });
  });

  // ─── Purchase Orders ──────────────────────────────────────────

  group('InventoryApiService.listPurchaseOrders', () {
    test('sends store_id and parses list', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.purchaseOrders);
        expect(opts.queryParameters['store_id'], 'store-001');
        return _paginated([_purchaseOrderJson()]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listPurchaseOrders(storeId: 'store-001');

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<PurchaseOrder>());
    });

    test('sends status filter when provided', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['status'], 'draft');
        return _paginated([]);
      });

      final svc = InventoryApiService(dio);
      await svc.listPurchaseOrders(storeId: 'store-001', status: 'draft');
    });
  });

  group('InventoryApiService.createPurchaseOrder', () {
    test('sends POST and returns parsed PO', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        return _envelope(_purchaseOrderJson(id: 'po-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createPurchaseOrder({'store_id': 'store-001', 'supplier_id': 'sup-001'});

      expect(result.id, 'po-new');
    });
  });

  group('InventoryApiService.sendPurchaseOrder', () {
    test('sends POST to /purchase-orders/:id/send', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.purchaseOrders}/po-001/send');
        return _envelope(_purchaseOrderJson(status: 'sent'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.sendPurchaseOrder('po-001');

      expect(result, isA<PurchaseOrder>());
    });
  });

  group('InventoryApiService.receivePurchaseOrder', () {
    test('sends POST with items to /purchase-orders/:id/receive', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.purchaseOrders}/po-001/receive');
        expect((opts.data as Map).containsKey('items'), true);
        return _envelope(_purchaseOrderJson(status: 'received'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.receivePurchaseOrder('po-001', [
        {'product_id': 'prod-001', 'quantity': 10, 'unit_cost': 5.0},
      ]);

      expect(result, isA<PurchaseOrder>());
    });
  });

  group('InventoryApiService.cancelPurchaseOrder', () {
    test('sends POST to /purchase-orders/:id/cancel', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.purchaseOrders}/po-001/cancel');
        return _envelope(_purchaseOrderJson(status: 'cancelled'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.cancelPurchaseOrder('po-001');

      expect(result, isA<PurchaseOrder>());
    });
  });

  // ─── Recipes ──────────────────────────────────────────────────

  group('InventoryApiService.listRecipes', () {
    test('parses recipe list', () async {
      final dio = _fakeDio((_) => _paginated([_recipeJson()]));

      final svc = InventoryApiService(dio);
      final result = await svc.listRecipes();

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<Recipe>());
    });
  });

  group('InventoryApiService.createRecipe', () {
    test('sends POST and returns recipe', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        return _envelope(_recipeJson(id: 'rec-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createRecipe({'product_id': 'prod-001', 'name': 'New Recipe'});

      expect(result.id, 'rec-new');
    });
  });

  group('InventoryApiService.updateRecipe', () {
    test('sends PUT to /recipes/:id', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.recipes}/rec-001');
        expect(opts.method, 'PUT');
        return _envelope(_recipeJson());
      });

      final svc = InventoryApiService(dio);
      final result = await svc.updateRecipe('rec-001', {'name': 'Updated'});

      expect(result.id, 'rec-001');
    });
  });

  group('InventoryApiService.deleteRecipe', () {
    test('sends DELETE to /recipes/:id', () async {
      bool called = false;
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.recipes}/rec-001');
        expect(opts.method, 'DELETE');
        called = true;
        return _envelope(null);
      });

      final svc = InventoryApiService(dio);
      await svc.deleteRecipe('rec-001');
      expect(called, true);
    });
  });

  // ─── Stocktakes ───────────────────────────────────────────────

  group('InventoryApiService.listStocktakes', () {
    test('sends store_id and parses list', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.stocktakes);
        expect(opts.queryParameters['store_id'], 'store-001');
        return _paginated([_stocktakeJson()]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listStocktakes(storeId: 'store-001');

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<Stocktake>());
    });

    test('sends status filter when provided', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['status'], 'in_progress');
        return _paginated([]);
      });

      final svc = InventoryApiService(dio);
      await svc.listStocktakes(storeId: 'store-001', status: 'in_progress');
    });
  });

  group('InventoryApiService.createStocktake', () {
    test('sends POST and returns stocktake', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        return _envelope(_stocktakeJson(id: 'skt-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createStocktake({'store_id': 'store-001', 'type': 'full'});

      expect(result.id, 'skt-new');
    });
  });

  group('InventoryApiService.updateStocktakeCounts', () {
    test('sends PUT to /stocktakes/:id/counts with items', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.stocktakes}/skt-001/counts');
        expect(opts.method, 'PUT');
        expect((opts.data as Map).containsKey('items'), true);
        return _envelope(_stocktakeJson());
      });

      final svc = InventoryApiService(dio);
      final result = await svc.updateStocktakeCounts('skt-001', [
        {'product_id': 'prod-001', 'counted_quantity': 10},
      ]);

      expect(result, isA<Stocktake>());
    });
  });

  group('InventoryApiService.applyStocktake', () {
    test('sends POST to /stocktakes/:id/apply', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.stocktakes}/skt-001/apply');
        return _envelope(_stocktakeJson(status: 'completed'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.applyStocktake('skt-001');

      expect(result, isA<Stocktake>());
    });
  });

  group('InventoryApiService.cancelStocktake', () {
    test('sends POST to /stocktakes/:id/cancel', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.stocktakes}/skt-001/cancel');
        return _envelope(_stocktakeJson(status: 'cancelled'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.cancelStocktake('skt-001');

      expect(result, isA<Stocktake>());
    });
  });

  // ─── Waste Records ────────────────────────────────────────────

  group('InventoryApiService.listWasteRecords', () {
    test('sends store_id and parses list', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.wasteRecords);
        expect(opts.queryParameters['store_id'], 'store-001');
        return _paginated([_wasteRecordJson()]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listWasteRecords(storeId: 'store-001');

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<WasteRecord>());
    });

    test('sends optional filters when provided', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['product_id'], 'prod-001');
        expect(opts.queryParameters['reason'], 'expired');
        expect(opts.queryParameters['date_from'], '2024-01-01');
        return _paginated([]);
      });

      final svc = InventoryApiService(dio);
      await svc.listWasteRecords(
        storeId: 'store-001',
        productId: 'prod-001',
        reason: 'expired',
        dateFrom: '2024-01-01',
      );
    });
  });

  group('InventoryApiService.createWasteRecord', () {
    test('sends POST and returns waste record', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        return _envelope(_wasteRecordJson(id: 'wr-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createWasteRecord({
        'store_id': 'store-001',
        'product_id': 'prod-001',
        'quantity': 2,
        'reason': 'expired',
      });

      expect(result.id, 'wr-new');
    });
  });

  // ─── Supplier Returns ─────────────────────────────────────────

  group('InventoryApiService.listSupplierReturns', () {
    test('parses supplier return list', () async {
      final dio = _fakeDio((_) => _paginated([_supplierReturnJson()]));

      final svc = InventoryApiService(dio);
      final result = await svc.listSupplierReturns();

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<SupplierReturn>());
    });

    test('sends status and supplier_id filters when provided', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['status'], 'submitted');
        expect(opts.queryParameters['supplier_id'], 'sup-001');
        return _paginated([]);
      });

      final svc = InventoryApiService(dio);
      await svc.listSupplierReturns(status: 'submitted', supplierId: 'sup-001');
    });
  });

  group('InventoryApiService.createSupplierReturn', () {
    test('sends POST and returns supplier return', () async {
      final dio = _fakeDio((opts) {
        expect(opts.method, 'POST');
        return _envelope(_supplierReturnJson(id: 'sr-new'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.createSupplierReturn({'store_id': 'store-001', 'supplier_id': 'sup-001'});

      expect(result.id, 'sr-new');
    });
  });

  group('InventoryApiService.submitSupplierReturn', () {
    test('sends POST to /supplier-returns/:id/submit', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.supplierReturns}/sr-001/submit');
        return _envelope(_supplierReturnJson(status: 'submitted'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.submitSupplierReturn('sr-001');

      expect(result, isA<SupplierReturn>());
    });
  });

  group('InventoryApiService.approveSupplierReturn', () {
    test('sends POST to /supplier-returns/:id/approve', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.supplierReturns}/sr-001/approve');
        return _envelope(_supplierReturnJson(status: 'approved'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.approveSupplierReturn('sr-001');

      expect(result, isA<SupplierReturn>());
    });
  });

  group('InventoryApiService.completeSupplierReturn', () {
    test('sends POST to /supplier-returns/:id/complete', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.supplierReturns}/sr-001/complete');
        return _envelope(_supplierReturnJson(status: 'completed'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.completeSupplierReturn('sr-001');

      expect(result, isA<SupplierReturn>());
    });
  });

  group('InventoryApiService.cancelSupplierReturn', () {
    test('sends POST to /supplier-returns/:id/cancel', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.supplierReturns}/sr-001/cancel');
        return _envelope(_supplierReturnJson(status: 'cancelled'));
      });

      final svc = InventoryApiService(dio);
      final result = await svc.cancelSupplierReturn('sr-001');

      expect(result, isA<SupplierReturn>());
    });
  });

  // ─── Expiry Alerts ────────────────────────────────────────────

  group('InventoryApiService.listExpiryAlerts', () {
    test('sends store_id and days_ahead, parses batches', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.expiryAlerts);
        expect(opts.queryParameters['store_id'], 'store-001');
        expect(opts.queryParameters['days_ahead'], 30);
        return _paginated([_stockBatchJson()]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.listExpiryAlerts(storeId: 'store-001');

      expect(result.items, hasLength(1));
      expect(result.items.first, isA<StockBatch>());
    });

    test('allows custom days_ahead value', () async {
      final dio = _fakeDio((opts) {
        expect(opts.queryParameters['days_ahead'], 7);
        return _paginated([]);
      });

      final svc = InventoryApiService(dio);
      await svc.listExpiryAlerts(storeId: 'store-001', daysAhead: 7);
    });
  });

  // ─── Low Stock ────────────────────────────────────────────────

  group('InventoryApiService.getLowStockItems', () {
    test('sends store_id and returns flat list of stock levels', () async {
      final dio = _fakeDio((opts) {
        expect(opts.path, ApiEndpoints.lowStock);
        expect(opts.queryParameters['store_id'], 'store-001');
        return _envelope([_stockLevelJson(), _stockLevelJson(id: 'sl-002', qty: 1.0)]);
      });

      final svc = InventoryApiService(dio);
      final result = await svc.getLowStockItems('store-001');

      expect(result, hasLength(2));
      expect(result.first, isA<StockLevel>());
      expect(result.last.quantity, 1.0);
    });

    test('returns empty list when no low-stock items', () async {
      final dio = _fakeDio((_) => _envelope([]));

      final svc = InventoryApiService(dio);
      final result = await svc.getLowStockItems('store-001');

      expect(result, isEmpty);
    });
  });
}
