// ignore_for_file: prefer_const_constructors

/// End-to-end workflow tests that exercise multi-step inventory flows
/// through the providers layer using a fake InventoryRepository.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/inventory/data/remote/inventory_api_service.dart';
import 'package:wameedpos/features/inventory/enums/purchase_order_status.dart';
import 'package:wameedpos/features/inventory/enums/stock_transfer_status.dart';
import 'package:wameedpos/features/inventory/enums/supplier_return_status.dart';
import 'package:wameedpos/features/inventory/models/goods_receipt.dart';
import 'package:wameedpos/features/inventory/models/purchase_order.dart';
import 'package:wameedpos/features/inventory/models/recipe.dart';
import 'package:wameedpos/features/inventory/models/stock_adjustment.dart';
import 'package:wameedpos/features/inventory/models/stock_level.dart';
import 'package:wameedpos/features/inventory/models/stock_movement.dart';
import 'package:wameedpos/features/inventory/models/stock_transfer.dart';
import 'package:wameedpos/features/inventory/models/stocktake.dart';
import 'package:wameedpos/features/inventory/models/supplier_return.dart';
import 'package:wameedpos/features/inventory/models/waste_record.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';
import 'package:wameedpos/features/inventory/repositories/inventory_repository.dart';

// ═══════════════════════════════════════════════════════════════════
// Full-featured fake repository
// ═══════════════════════════════════════════════════════════════════

class _WorkflowRepo extends InventoryRepository {
  _WorkflowRepo()
      : super(
          apiService: InventoryApiService(Dio()),
          localStorage: _NoOpAuth(),
        );

  // ── Stock Levels ──────────────────────────────────────────────
  final List<StockLevel> _levels = [];
  StockLevel? _reorderResult;
  void addLevel(StockLevel l) => _levels.add(l);
  void stubReorderPoint(StockLevel l) => _reorderResult = l;

  @override
  Future<PaginatedResult<StockLevel>> listStockLevels({
    int page = 1, int perPage = 25, String? productId, bool? lowStock, String? search,
  }) async => PaginatedResult(items: _levels, total: _levels.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<StockLevel> setReorderPoint(String id, {required double reorderPoint, double? maxStockLevel}) async =>
      _reorderResult!;

  // ── Stock Movements ───────────────────────────────────────────
  final List<StockMovement> _movements = [];

  @override
  Future<PaginatedResult<StockMovement>> listStockMovements({
    int page = 1, int perPage = 25, String? productId,
  }) async => PaginatedResult(items: _movements, total: _movements.length, currentPage: 1, lastPage: 1, perPage: 25);

  // ── Stock Adjustments ─────────────────────────────────────────
  final List<StockAdjustment> _adjustments = [];
  StockAdjustment? _newAdjustment;
  void stubNewAdjustment(StockAdjustment a) => _newAdjustment = a;

  @override
  Future<PaginatedResult<StockAdjustment>> listStockAdjustments({int page = 1, int perPage = 25}) async =>
      PaginatedResult(items: _adjustments, total: _adjustments.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<StockAdjustment> createStockAdjustment(Map<String, dynamic> data) async => _newAdjustment!;

  // ── Goods Receipts ────────────────────────────────────────────
  final List<GoodsReceipt> _receipts = [];
  GoodsReceipt? _newReceipt;
  GoodsReceipt? _confirmedReceipt;
  void stubNewReceipt(GoodsReceipt r) => _newReceipt = r;
  void stubConfirmedReceipt(GoodsReceipt r) => _confirmedReceipt = r;

  @override
  Future<PaginatedResult<GoodsReceipt>> listGoodsReceipts({int page = 1, int perPage = 25}) async =>
      PaginatedResult(items: _receipts, total: _receipts.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<GoodsReceipt> createGoodsReceipt(Map<String, dynamic> data) async => _newReceipt!;

  @override
  Future<GoodsReceipt> confirmGoodsReceipt(String id) async => _confirmedReceipt!;

  // ── Stock Transfers ───────────────────────────────────────────
  final List<StockTransfer> _transfers = [];
  StockTransfer? _newTransfer;
  final Map<String, StockTransfer> _transferUpdates = {};
  void addTransfer(StockTransfer t) => _transfers.add(t);
  void stubNewTransfer(StockTransfer t) => _newTransfer = t;
  void stubTransferUpdate(String id, StockTransfer t) => _transferUpdates[id] = t;

  @override
  Future<PaginatedResult<StockTransfer>> listStockTransfers({int page = 1, int perPage = 25}) async =>
      PaginatedResult(items: _transfers, total: _transfers.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<StockTransfer> createStockTransfer(Map<String, dynamic> data) async => _newTransfer!;

  @override
  Future<StockTransfer> approveTransfer(String id) async => _transferUpdates[id]!;

  @override
  Future<StockTransfer> receiveTransfer(String id, {List<Map<String, dynamic>>? items}) async =>
      _transferUpdates[id]!;

  @override
  Future<StockTransfer> cancelTransfer(String id) async => _transferUpdates[id]!;

  // ── Purchase Orders ───────────────────────────────────────────
  final List<PurchaseOrder> _orders = [];
  PurchaseOrder? _newOrder;
  final Map<String, PurchaseOrder> _orderUpdates = {};
  void addOrder(PurchaseOrder o) => _orders.add(o);
  void stubNewOrder(PurchaseOrder o) => _newOrder = o;
  void stubOrderUpdate(String id, PurchaseOrder o) => _orderUpdates[id] = o;

  @override
  Future<PaginatedResult<PurchaseOrder>> listPurchaseOrders({int page = 1, int perPage = 25, String? status}) async =>
      PaginatedResult(items: _orders, total: _orders.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<PurchaseOrder> createPurchaseOrder(Map<String, dynamic> data) async => _newOrder!;

  @override
  Future<PurchaseOrder> sendPurchaseOrder(String id) async => _orderUpdates[id]!;

  @override
  Future<PurchaseOrder> receivePurchaseOrder(String id, List<Map<String, dynamic>> items) async =>
      _orderUpdates[id]!;

  @override
  Future<PurchaseOrder> cancelPurchaseOrder(String id) async => _orderUpdates[id]!;

  // ── Recipes ───────────────────────────────────────────────────
  final List<Recipe> _recipes = [];
  Recipe? _newRecipe;
  Recipe? _updatedRecipe;
  void addRecipe(Recipe r) => _recipes.add(r);
  void stubNewRecipe(Recipe r) => _newRecipe = r;
  void stubUpdatedRecipe(Recipe r) => _updatedRecipe = r;

  @override
  Future<PaginatedResult<Recipe>> listRecipes({int page = 1, int perPage = 25}) async =>
      PaginatedResult(items: _recipes, total: _recipes.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<Recipe> createRecipe(Map<String, dynamic> data) async => _newRecipe!;

  @override
  Future<Recipe> updateRecipe(String id, Map<String, dynamic> data) async => _updatedRecipe!;

  @override
  Future<void> deleteRecipe(String id) async {}

  // ── Stocktakes ────────────────────────────────────────────────
  final List<Stocktake> _stocktakes = [];
  Stocktake? _newStocktake;
  final Map<String, Stocktake> _stocktakeUpdates = {};
  void addStocktake(Stocktake s) => _stocktakes.add(s);
  void stubNewStocktake(Stocktake s) => _newStocktake = s;
  void stubStocktakeUpdate(String id, Stocktake s) => _stocktakeUpdates[id] = s;

  @override
  Future<PaginatedResult<Stocktake>> listStocktakes({int page = 1, int perPage = 25, String? status}) async =>
      PaginatedResult(items: _stocktakes, total: _stocktakes.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<Stocktake> createStocktake(Map<String, dynamic> data) async => _newStocktake!;

  @override
  Future<Stocktake> updateStocktakeCounts(String id, List<Map<String, dynamic>> items) async =>
      _stocktakeUpdates[id]!;

  @override
  Future<Stocktake> applyStocktake(String id) async => _stocktakeUpdates[id]!;

  @override
  Future<Stocktake> cancelStocktake(String id) async => _stocktakeUpdates[id]!;

  // ── Supplier Returns ──────────────────────────────────────────
  final List<SupplierReturn> _supplierReturns = [];
  SupplierReturn? _newReturn;
  final Map<String, SupplierReturn> _returnUpdates = {};
  void addReturn(SupplierReturn r) => _supplierReturns.add(r);
  void stubNewReturn(SupplierReturn r) => _newReturn = r;
  void stubReturnUpdate(String id, SupplierReturn r) => _returnUpdates[id] = r;

  @override
  Future<PaginatedResult<SupplierReturn>> listSupplierReturns({
    int page = 1, int perPage = 25, String? status, String? supplierId, String? search,
  }) async => PaginatedResult(items: _supplierReturns, total: _supplierReturns.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<SupplierReturn> createSupplierReturn(Map<String, dynamic> data) async => _newReturn!;

  @override
  Future<SupplierReturn> submitSupplierReturn(String id) async => _returnUpdates[id]!;

  @override
  Future<SupplierReturn> approveSupplierReturn(String id) async => _returnUpdates[id]!;

  @override
  Future<SupplierReturn> completeSupplierReturn(String id) async => _returnUpdates[id]!;

  @override
  Future<SupplierReturn> cancelSupplierReturn(String id) async => _returnUpdates[id]!;

  // ── Waste Records ─────────────────────────────────────────────
  final List<WasteRecord> _wasteRecords = [];
  WasteRecord? _newWasteRecord;
  void addWasteRecord(WasteRecord r) => _wasteRecords.add(r);
  void stubNewWasteRecord(WasteRecord r) => _newWasteRecord = r;

  @override
  Future<PaginatedResult<WasteRecord>> listWasteRecords({
    int page = 1, int perPage = 25, String? productId, String? reason, String? dateFrom, String? dateTo,
  }) async => PaginatedResult(items: _wasteRecords, total: _wasteRecords.length, currentPage: 1, lastPage: 1, perPage: 25);

  @override
  Future<WasteRecord> createWasteRecord(Map<String, dynamic> data) async => _newWasteRecord!;
}

class _NoOpAuth extends AuthLocalStorage {
  @override Future<String?> getStoreId() async => 'store-test';
  @override Future<String?> getToken() async => null;
  @override Future<void> saveToken(String token) async {}
  @override Future<void> deleteToken() async {}
}

// ─── Model helpers ───────────────────────────────────────────────

GoodsReceipt _receipt({String id = 'gr-1'}) =>
    GoodsReceipt(id: id, storeId: 'store-1', receivedBy: 'user-1');

StockTransfer _transfer({String id = 'st-1', StockTransferStatus? status}) => StockTransfer(
  id: id, organizationId: 'org-1', fromStoreId: 'store-1', toStoreId: 'store-2',
  status: status, createdBy: 'user-1',
);

PurchaseOrder _order({String id = 'po-1', PurchaseOrderStatus? status}) => PurchaseOrder(
  id: id, organizationId: 'org-1', storeId: 'store-1', supplierId: 'sup-1',
  status: status, createdBy: 'user-1',
);

Stocktake _stocktake({String id = 'skt-1'}) => Stocktake(id: id, storeId: 'store-1');

Recipe _recipe({String id = 'rec-1'}) =>
    Recipe(id: id, organizationId: 'org-1', productId: 'prod-1', yieldQuantity: 1.0);

SupplierReturn _supplierReturn({String id = 'sr-1', SupplierReturnStatus? status}) => SupplierReturn(
  id: id, organizationId: 'org-1', storeId: 'store-1', supplierId: 'sup-1',
  status: status, createdBy: 'user-1',
);

WasteRecord _waste({String id = 'wr-1'}) =>
    WasteRecord(id: id, storeId: 'store-1', productId: 'prod-1', quantity: 2.0);

StockAdjustment _adjustment({String id = 'sa-1'}) => StockAdjustment(id: id, storeId: 'store-1');

StockLevel _level({String id = 'sl-1', double qty = 10.0}) =>
    StockLevel(id: id, storeId: 'store-1', productId: 'prod-1', quantity: qty);

// ─── Container factory ───────────────────────────────────────────

ProviderContainer _container(_WorkflowRepo repo) => ProviderContainer(
  overrides: [inventoryRepositoryProvider.overrideWithValue(repo)],
);

// ═══════════════════════════════════════════════════════════════════
// Tests
// ═══════════════════════════════════════════════════════════════════

void main() {
  // ─── Goods Receipt Workflow ───────────────────────────────────

  group('Goods Receipt workflow', () {
    test('create receipt → item appears in list; confirm → item replaced', () async {
      final repo = _WorkflowRepo();
      final container = _container(repo);
      addTearDown(container.dispose);

      // Step 0: Load empty list
      await container.read(goodsReceiptsProvider.notifier).load();
      final empty = container.read(goodsReceiptsProvider) as GoodsReceiptsLoaded;
      expect(empty.receipts, isEmpty);

      // Step 1: Create receipt
      repo.stubNewReceipt(_receipt(id: 'gr-new'));
      await container.read(goodsReceiptsProvider.notifier).createReceipt({'supplier_id': 'sup-1'});
      final afterCreate = container.read(goodsReceiptsProvider) as GoodsReceiptsLoaded;
      expect(afterCreate.receipts.first.id, 'gr-new');
      expect(afterCreate.total, 1);

      // Step 2: Confirm receipt → list still contains the updated receipt
      repo.stubConfirmedReceipt(_receipt(id: 'gr-new'));
      await container.read(goodsReceiptsProvider.notifier).confirmReceipt('gr-new');
      final afterConfirm = container.read(goodsReceiptsProvider) as GoodsReceiptsLoaded;
      expect(afterConfirm.receipts, hasLength(1));
      expect(afterConfirm.receipts.first.id, 'gr-new');
    });
  });

  // ─── Stock Adjustment Workflow ────────────────────────────────

  group('Stock Adjustment workflow', () {
    test('create adjustment → prepended to list', () async {
      final repo = _WorkflowRepo();
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockAdjustmentsProvider.notifier).load();
      repo.stubNewAdjustment(_adjustment());
      await container.read(stockAdjustmentsProvider.notifier).createAdjustment({'product_id': 'p', 'quantity': 5});

      final state = container.read(stockAdjustmentsProvider) as StockAdjustmentsLoaded;
      expect(state.adjustments.first.id, 'sa-1');
      expect(state.total, 1);
    });
  });

  // ─── Stock Transfer Workflow ──────────────────────────────────

  group('Stock Transfer workflow: pending → inTransit → completed', () {
    test('full transfer lifecycle is reflected in state', () async {
      final repo = _WorkflowRepo();
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockTransfersProvider.notifier).load();
      expect((container.read(stockTransfersProvider) as StockTransfersLoaded).transfers, isEmpty);

      // Create pending transfer
      repo.stubNewTransfer(_transfer(id: 'st-1', status: StockTransferStatus.pending));
      await container.read(stockTransfersProvider.notifier).createTransfer({});
      final afterCreate = container.read(stockTransfersProvider) as StockTransfersLoaded;
      expect(afterCreate.transfers.first.status, StockTransferStatus.pending);

      // Approve → in transit
      repo.stubTransferUpdate('st-1', _transfer(id: 'st-1', status: StockTransferStatus.inTransit));
      await container.read(stockTransfersProvider.notifier).approveTransfer('st-1');
      final afterApprove = container.read(stockTransfersProvider) as StockTransfersLoaded;
      expect(afterApprove.transfers.first.status, StockTransferStatus.inTransit);

      // Receive → completed
      repo.stubTransferUpdate('st-1', _transfer(id: 'st-1', status: StockTransferStatus.completed));
      await container.read(stockTransfersProvider.notifier).receiveTransfer('st-1');
      final afterReceive = container.read(stockTransfersProvider) as StockTransfersLoaded;
      expect(afterReceive.transfers.first.status, StockTransferStatus.completed);
    });

    test('cancel transfer updates status to cancelled', () async {
      final repo = _WorkflowRepo();
      repo.addTransfer(_transfer(id: 'st-x', status: StockTransferStatus.pending));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockTransfersProvider.notifier).load();
      repo.stubTransferUpdate('st-x', _transfer(id: 'st-x', status: StockTransferStatus.cancelled));
      await container.read(stockTransfersProvider.notifier).cancelTransfer('st-x');

      final state = container.read(stockTransfersProvider) as StockTransfersLoaded;
      expect(state.transfers.first.status, StockTransferStatus.cancelled);
    });
  });

  // ─── Purchase Order Workflow ──────────────────────────────────

  group('Purchase Order workflow: draft → sent → received', () {
    test('full PO lifecycle is reflected in state', () async {
      final repo = _WorkflowRepo();
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(purchaseOrdersProvider.notifier).load();

      // Create draft PO
      repo.stubNewOrder(_order(id: 'po-1', status: PurchaseOrderStatus.draft));
      await container.read(purchaseOrdersProvider.notifier).createOrder({'supplier_id': 'sup-1'});
      final afterCreate = container.read(purchaseOrdersProvider) as PurchaseOrdersLoaded;
      expect(afterCreate.orders.first.status, PurchaseOrderStatus.draft);

      // Send → status sent
      repo.stubOrderUpdate('po-1', _order(id: 'po-1', status: PurchaseOrderStatus.sent));
      await container.read(purchaseOrdersProvider.notifier).sendOrder('po-1');
      final afterSend = container.read(purchaseOrdersProvider) as PurchaseOrdersLoaded;
      expect(afterSend.orders.first.status, PurchaseOrderStatus.sent);

      // Receive fully
      repo.stubOrderUpdate('po-1', _order(id: 'po-1', status: PurchaseOrderStatus.fullyReceived));
      await container.read(purchaseOrdersProvider.notifier).receiveOrder('po-1', []);
      final afterReceive = container.read(purchaseOrdersProvider) as PurchaseOrdersLoaded;
      expect(afterReceive.orders.first.status, PurchaseOrderStatus.fullyReceived);
    });

    test('cancel PO updates status', () async {
      final repo = _WorkflowRepo();
      repo.addOrder(_order(id: 'po-x', status: PurchaseOrderStatus.draft));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(purchaseOrdersProvider.notifier).load();
      repo.stubOrderUpdate('po-x', _order(id: 'po-x', status: PurchaseOrderStatus.cancelled));
      await container.read(purchaseOrdersProvider.notifier).cancelOrder('po-x');

      final state = container.read(purchaseOrdersProvider) as PurchaseOrdersLoaded;
      expect(state.orders.first.status, PurchaseOrderStatus.cancelled);
    });
  });

  // ─── Stocktake Workflow ───────────────────────────────────────

  group('Stocktake workflow: create → update counts → apply', () {
    test('stocktake lifecycle reflected in state', () async {
      final repo = _WorkflowRepo();
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stocktakesProvider.notifier).load();
      expect((container.read(stocktakesProvider) as StocktakesLoaded).stocktakes, isEmpty);

      // Create
      repo.stubNewStocktake(_stocktake(id: 'skt-1'));
      final created = await container.read(stocktakesProvider.notifier).createStocktake({'type': 'full'});
      expect(created.id, 'skt-1');
      expect((container.read(stocktakesProvider) as StocktakesLoaded).stocktakes, hasLength(1));

      // Update counts
      repo.stubStocktakeUpdate('skt-1', _stocktake(id: 'skt-1'));
      await container.read(stocktakesProvider.notifier).updateCounts('skt-1', [
        {'product_id': 'prod-1', 'counted_quantity': 8},
      ]);
      expect((container.read(stocktakesProvider) as StocktakesLoaded).stocktakes, hasLength(1));

      // Apply
      repo.stubStocktakeUpdate('skt-1', _stocktake(id: 'skt-1'));
      await container.read(stocktakesProvider.notifier).applyStocktake('skt-1');
      expect((container.read(stocktakesProvider) as StocktakesLoaded).stocktakes, hasLength(1));
    });

    test('cancel stocktake replaces it in state', () async {
      final repo = _WorkflowRepo();
      repo.addStocktake(_stocktake(id: 'skt-x'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stocktakesProvider.notifier).load();
      repo.stubStocktakeUpdate('skt-x', _stocktake(id: 'skt-x'));
      await container.read(stocktakesProvider.notifier).cancelStocktake('skt-x');

      expect((container.read(stocktakesProvider) as StocktakesLoaded).stocktakes, hasLength(1));
    });
  });

  // ─── Recipe CRUD Workflow ─────────────────────────────────────

  group('Recipe workflow: create → update → delete', () {
    test('full recipe CRUD lifecycle', () async {
      final repo = _WorkflowRepo();
      repo.addRecipe(_recipe(id: 'rec-existing'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(recipesProvider.notifier).load();
      expect((container.read(recipesProvider) as RecipesLoaded).recipes, hasLength(1));

      // Create
      repo.stubNewRecipe(_recipe(id: 'rec-new'));
      await container.read(recipesProvider.notifier).createRecipe({'product_id': 'prod-2'});
      final afterCreate = container.read(recipesProvider) as RecipesLoaded;
      expect(afterCreate.recipes.first.id, 'rec-new');
      expect(afterCreate.total, 2);

      // Update
      repo.stubUpdatedRecipe(_recipe(id: 'rec-new'));
      await container.read(recipesProvider.notifier).updateRecipe('rec-new', {'yield_quantity': '2.0'});
      expect((container.read(recipesProvider) as RecipesLoaded).recipes.any((r) => r.id == 'rec-new'), true);

      // Delete
      await container.read(recipesProvider.notifier).deleteRecipe('rec-new');
      final afterDelete = container.read(recipesProvider) as RecipesLoaded;
      expect(afterDelete.recipes.any((r) => r.id == 'rec-new'), false);
      expect(afterDelete.total, 1);
    });
  });

  // ─── Supplier Return Workflow ─────────────────────────────────

  group('Supplier Return workflow: draft → submitted → approved → completed', () {
    test('full supplier return lifecycle', () async {
      final repo = _WorkflowRepo();
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(supplierReturnsProvider.notifier).load();

      // Create
      repo.stubNewReturn(_supplierReturn(id: 'sr-1', status: SupplierReturnStatus.draft));
      await container.read(supplierReturnsProvider.notifier).createReturn({'supplier_id': 'sup-1'});
      final afterCreate = container.read(supplierReturnsProvider) as SupplierReturnsLoaded;
      expect(afterCreate.returns.first.status, SupplierReturnStatus.draft);

      // Submit
      repo.stubReturnUpdate('sr-1', _supplierReturn(id: 'sr-1', status: SupplierReturnStatus.submitted));
      await container.read(supplierReturnsProvider.notifier).submitReturn('sr-1');
      final afterSubmit = container.read(supplierReturnsProvider) as SupplierReturnsLoaded;
      expect(afterSubmit.returns.first.status, SupplierReturnStatus.submitted);

      // Approve
      repo.stubReturnUpdate('sr-1', _supplierReturn(id: 'sr-1', status: SupplierReturnStatus.approved));
      await container.read(supplierReturnsProvider.notifier).approveReturn('sr-1');
      final afterApprove = container.read(supplierReturnsProvider) as SupplierReturnsLoaded;
      expect(afterApprove.returns.first.status, SupplierReturnStatus.approved);

      // Complete
      repo.stubReturnUpdate('sr-1', _supplierReturn(id: 'sr-1', status: SupplierReturnStatus.completed));
      await container.read(supplierReturnsProvider.notifier).completeReturn('sr-1');
      final afterComplete = container.read(supplierReturnsProvider) as SupplierReturnsLoaded;
      expect(afterComplete.returns.first.status, SupplierReturnStatus.completed);
    });

    test('cancel supplier return updates state', () async {
      final repo = _WorkflowRepo();
      repo.addReturn(_supplierReturn(id: 'sr-x', status: SupplierReturnStatus.draft));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(supplierReturnsProvider.notifier).load();
      repo.stubReturnUpdate('sr-x', _supplierReturn(id: 'sr-x', status: SupplierReturnStatus.cancelled));
      await container.read(supplierReturnsProvider.notifier).cancelReturn('sr-x');

      final state = container.read(supplierReturnsProvider) as SupplierReturnsLoaded;
      expect(state.returns.first.status, SupplierReturnStatus.cancelled);
    });
  });

  // ─── Waste Record Workflow ────────────────────────────────────

  group('Waste Record workflow', () {
    test('new waste record is prepended to list', () async {
      final repo = _WorkflowRepo();
      repo.addWasteRecord(_waste(id: 'wr-existing'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(wasteRecordsProvider.notifier).load();
      expect((container.read(wasteRecordsProvider) as WasteRecordsLoaded).records, hasLength(1));

      repo.stubNewWasteRecord(_waste(id: 'wr-new'));
      await container.read(wasteRecordsProvider.notifier).createWasteRecord({'product_id': 'prod-1', 'quantity': 2});
      final afterCreate = container.read(wasteRecordsProvider) as WasteRecordsLoaded;
      expect(afterCreate.records.first.id, 'wr-new');
      expect(afterCreate.total, 2);
    });
  });

  // ─── Stock Level Reorder Point Workflow ───────────────────────

  group('Stock Level workflow: set reorder point', () {
    test('reorder point is updated in-place in the levels list', () async {
      final repo = _WorkflowRepo();
      repo.addLevel(_level(id: 'sl-1', qty: 10.0));
      repo.addLevel(_level(id: 'sl-2', qty: 5.0));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockLevelsProvider.notifier).load();

      repo.stubReorderPoint(StockLevel(
        id: 'sl-1', storeId: 'store-1', productId: 'prod-1', quantity: 10.0, reorderPoint: 3.0,
      ));
      await container.read(stockLevelsProvider.notifier).setReorderPoint('sl-1', reorderPoint: 3.0);

      final state = container.read(stockLevelsProvider) as StockLevelsLoaded;
      expect(state.levels.firstWhere((l) => l.id == 'sl-1').reorderPoint, 3.0);
      expect(state.levels.firstWhere((l) => l.id == 'sl-2').reorderPoint, null);
    });
  });
}
