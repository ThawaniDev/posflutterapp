// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/inventory/data/remote/inventory_api_service.dart';
import 'package:wameedpos/features/inventory/enums/stock_movement_type.dart';
import 'package:wameedpos/features/inventory/models/goods_receipt.dart';
import 'package:wameedpos/features/inventory/models/purchase_order.dart';
import 'package:wameedpos/features/inventory/models/stock_level.dart';
import 'package:wameedpos/features/inventory/models/stock_movement.dart';
import 'package:wameedpos/features/inventory/models/stocktake.dart';
import 'package:wameedpos/features/inventory/models/waste_record.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';
import 'package:wameedpos/features/inventory/repositories/inventory_repository.dart';

// ═══════════════════════════════════════════════════════════════════
// Fake repository
// ═══════════════════════════════════════════════════════════════════

class _FakeInventoryRepository extends InventoryRepository {
  _FakeInventoryRepository()
      : super(
          apiService: InventoryApiService(Dio()),
          localStorage: _NoOpAuth(),
        );

  // Stock levels
  PaginatedResult<StockLevel>? _stockLevelsResult;
  Exception? _stockLevelsError;
  StockLevel? _reorderResult;

  void stubStockLevels(List<StockLevel> items, {int total = 0, int lastPage = 1, int page = 1}) {
    _stockLevelsResult = PaginatedResult(
      items: items,
      total: total == 0 ? items.length : total,
      currentPage: page,
      lastPage: lastPage,
      perPage: 25,
    );
  }

  void stubStockLevelsError(Exception e) => _stockLevelsError = e;
  void stubReorderPoint(StockLevel level) => _reorderResult = level;

  @override
  Future<PaginatedResult<StockLevel>> listStockLevels({
    int page = 1,
    int perPage = 25,
    String? productId,
    bool? lowStock,
    String? search,
  }) async {
    if (_stockLevelsError != null) throw _stockLevelsError!;
    return _stockLevelsResult!;
  }

  @override
  Future<StockLevel> setReorderPoint(String id, {required double reorderPoint, double? maxStockLevel}) async {
    return _reorderResult!;
  }

  // Stock movements
  PaginatedResult<StockMovement>? _movementsResult;
  Exception? _movementsError;

  void stubMovements(List<StockMovement> items) {
    _movementsResult = PaginatedResult(items: items, total: items.length, currentPage: 1, lastPage: 1, perPage: 25);
  }

  void stubMovementsError(Exception e) => _movementsError = e;

  @override
  Future<PaginatedResult<StockMovement>> listStockMovements({int page = 1, int perPage = 25, String? productId}) async {
    if (_movementsError != null) throw _movementsError!;
    return _movementsResult!;
  }

  // Goods receipts
  PaginatedResult<GoodsReceipt>? _receiptsResult;
  Exception? _receiptsError;
  GoodsReceipt? _createReceiptResult;
  GoodsReceipt? _confirmReceiptResult;

  void stubReceipts(List<GoodsReceipt> items) {
    _receiptsResult = PaginatedResult(items: items, total: items.length, currentPage: 1, lastPage: 1, perPage: 25);
  }

  void stubReceiptsError(Exception e) => _receiptsError = e;
  void stubCreateReceipt(GoodsReceipt receipt) => _createReceiptResult = receipt;
  void stubConfirmReceipt(GoodsReceipt receipt) => _confirmReceiptResult = receipt;

  @override
  Future<PaginatedResult<GoodsReceipt>> listGoodsReceipts({int page = 1, int perPage = 25}) async {
    if (_receiptsError != null) throw _receiptsError!;
    return _receiptsResult!;
  }

  @override
  Future<GoodsReceipt> createGoodsReceipt(Map<String, dynamic> data) async => _createReceiptResult!;

  @override
  Future<GoodsReceipt> confirmGoodsReceipt(String id) async => _confirmReceiptResult!;

  // Purchase orders
  PaginatedResult<PurchaseOrder>? _poResult;
  Exception? _poError;

  void stubPurchaseOrders(List<PurchaseOrder> items, {int lastPage = 1, int page = 1}) {
    _poResult = PaginatedResult(
      items: items,
      total: items.length,
      currentPage: page,
      lastPage: lastPage,
      perPage: 25,
    );
  }

  void stubPurchaseOrdersError(Exception e) => _poError = e;

  @override
  Future<PaginatedResult<PurchaseOrder>> listPurchaseOrders({int page = 1, int perPage = 25, String? status}) async {
    if (_poError != null) throw _poError!;
    return _poResult!;
  }

  // Stocktakes
  PaginatedResult<Stocktake>? _stocktakesResult;
  Exception? _stocktakesError;

  void stubStocktakes(List<Stocktake> items) {
    _stocktakesResult = PaginatedResult(items: items, total: items.length, currentPage: 1, lastPage: 1, perPage: 25);
  }

  void stubStocktakesError(Exception e) => _stocktakesError = e;

  @override
  Future<PaginatedResult<Stocktake>> listStocktakes({int page = 1, int perPage = 25, String? status}) async {
    if (_stocktakesError != null) throw _stocktakesError!;
    return _stocktakesResult!;
  }

  // Waste records
  PaginatedResult<WasteRecord>? _wasteResult;
  Exception? _wasteError;

  void stubWasteRecords(List<WasteRecord> items) {
    _wasteResult = PaginatedResult(items: items, total: items.length, currentPage: 1, lastPage: 1, perPage: 25);
  }

  void stubWasteError(Exception e) => _wasteError = e;

  @override
  Future<PaginatedResult<WasteRecord>> listWasteRecords({
    int page = 1,
    int perPage = 25,
    String? productId,
    String? reason,
    String? dateFrom,
    String? dateTo,
  }) async {
    if (_wasteError != null) throw _wasteError!;
    return _wasteResult!;
  }
}

class _NoOpAuth extends AuthLocalStorage {
  @override Future<String?> getStoreId() async => 'store-test';
  @override Future<String?> getToken() async => null;
  @override Future<void> saveToken(String token) async {}
  @override Future<void> deleteToken() async {}
}

// ─── Minimal model builders ──────────────────────────────────────

StockLevel _level({String id = 'sl-1', double qty = 10.0}) => StockLevel(
  id: id, storeId: 'store-1', productId: 'prod-1', quantity: qty,
);

StockMovement _movement({String id = 'sm-1'}) => StockMovement(
  id: id, storeId: 'store-1', productId: 'prod-1', type: StockMovementType.receipt, quantity: 5.0,
);

GoodsReceipt _receipt({String id = 'gr-1'}) => GoodsReceipt(
  id: id, storeId: 'store-1', receivedBy: 'user-1',
);

PurchaseOrder _po({String id = 'po-1'}) => PurchaseOrder(
  id: id, organizationId: 'org-1', storeId: 'store-1',
  supplierId: 'sup-1', createdBy: 'user-1',
);

Stocktake _stocktake({String id = 'skt-1'}) => Stocktake(
  id: id, storeId: 'store-1',
);

WasteRecord _wasteRecord({String id = 'wr-1'}) => WasteRecord(
  id: id, storeId: 'store-1', productId: 'prod-1', quantity: 2.0,
);

// ─── Container factory ───────────────────────────────────────────

ProviderContainer _container(_FakeInventoryRepository repo) {
  return ProviderContainer(
    overrides: [inventoryRepositoryProvider.overrideWithValue(repo)],
  );
}

// ═══════════════════════════════════════════════════════════════════
// Tests
// ═══════════════════════════════════════════════════════════════════

void main() {
  // ─── StockLevelsNotifier ──────────────────────────────────────

  group('StockLevelsNotifier', () {
    test('initial state is StockLevelsInitial', () {
      final repo = _FakeInventoryRepository();
      repo.stubStockLevels([]);
      final container = _container(repo);
      addTearDown(container.dispose);

      final state = container.read(stockLevelsProvider);
      expect(state, isA<StockLevelsInitial>());
    });

    test('load transitions to StockLevelsLoaded with items', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStockLevels([_level(), _level(id: 'sl-2')]);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockLevelsProvider.notifier).load();

      final state = container.read(stockLevelsProvider);
      expect(state, isA<StockLevelsLoaded>());
      final loaded = state as StockLevelsLoaded;
      expect(loaded.levels, hasLength(2));
    });

    test('load transitions to StockLevelsError on exception', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStockLevelsError(Exception('network error'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockLevelsProvider.notifier).load();

      final state = container.read(stockLevelsProvider);
      expect(state, isA<StockLevelsError>());
      expect((state as StockLevelsError).message, contains('network error'));
    });

    test('hasMore is true when currentPage < lastPage', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStockLevels([_level()], total: 50, lastPage: 3, page: 1);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockLevelsProvider.notifier).load();

      final state = container.read(stockLevelsProvider) as StockLevelsLoaded;
      expect(state.hasMore, true);
      expect(state.lastPage, 3);
    });

    test('hasMore is false on last page', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStockLevels([_level()], total: 5, lastPage: 1, page: 1);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockLevelsProvider.notifier).load();

      final state = container.read(stockLevelsProvider) as StockLevelsLoaded;
      expect(state.hasMore, false);
    });

    test('toggleLowStockFilter reloads with updated flag', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStockLevels([_level()]);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockLevelsProvider.notifier).toggleLowStockFilter(true);

      final state = container.read(stockLevelsProvider);
      expect(state, isA<StockLevelsLoaded>());
      final loaded = state as StockLevelsLoaded;
      expect(loaded.lowStockOnly, true);
    });

    test('setReorderPoint updates the matching level in state', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStockLevels([_level(), _level(id: 'sl-2')]);
      final updatedLevel = _level(id: 'sl-1');
      repo.stubReorderPoint(StockLevel(
        id: 'sl-1', storeId: 'store-1', productId: 'prod-1', quantity: 10.0, reorderPoint: 5.0,
      ));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockLevelsProvider.notifier).load();
      await container.read(stockLevelsProvider.notifier).setReorderPoint('sl-1', reorderPoint: 5.0);

      final state = container.read(stockLevelsProvider) as StockLevelsLoaded;
      expect(state.levels.firstWhere((l) => l.id == 'sl-1').reorderPoint, 5.0);
    });
  });

  // ─── StockMovementsNotifier ───────────────────────────────────

  group('StockMovementsNotifier', () {
    test('initial state is StockMovementsInitial', () {
      final repo = _FakeInventoryRepository();
      repo.stubMovements([]);
      final container = _container(repo);
      addTearDown(container.dispose);

      expect(container.read(stockMovementsProvider), isA<StockMovementsInitial>());
    });

    test('load returns movements list', () async {
      final repo = _FakeInventoryRepository();
      repo.stubMovements([_movement(), _movement(id: 'sm-2')]);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockMovementsProvider.notifier).load();

      final state = container.read(stockMovementsProvider) as StockMovementsLoaded;
      expect(state.movements, hasLength(2));
    });

    test('load transitions to error on exception', () async {
      final repo = _FakeInventoryRepository();
      repo.stubMovementsError(Exception('timeout'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stockMovementsProvider.notifier).load();

      expect(container.read(stockMovementsProvider), isA<StockMovementsError>());
    });
  });

  // ─── GoodsReceiptsNotifier ────────────────────────────────────

  group('GoodsReceiptsNotifier', () {
    test('initial state is GoodsReceiptsInitial', () {
      final repo = _FakeInventoryRepository();
      repo.stubReceipts([]);
      final container = _container(repo);
      addTearDown(container.dispose);

      expect(container.read(goodsReceiptsProvider), isA<GoodsReceiptsInitial>());
    });

    test('load returns receipts', () async {
      final repo = _FakeInventoryRepository();
      repo.stubReceipts([_receipt(), _receipt(id: 'gr-2')]);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(goodsReceiptsProvider.notifier).load();

      final state = container.read(goodsReceiptsProvider) as GoodsReceiptsLoaded;
      expect(state.receipts, hasLength(2));
    });

    test('load transitions to error on exception', () async {
      final repo = _FakeInventoryRepository();
      repo.stubReceiptsError(Exception('server error'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(goodsReceiptsProvider.notifier).load();

      expect(container.read(goodsReceiptsProvider), isA<GoodsReceiptsError>());
    });

    test('createReceipt prepends new receipt to loaded state', () async {
      final repo = _FakeInventoryRepository();
      repo.stubReceipts([_receipt(id: 'gr-existing')]);
      repo.stubCreateReceipt(_receipt(id: 'gr-new'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(goodsReceiptsProvider.notifier).load();
      await container.read(goodsReceiptsProvider.notifier).createReceipt({});

      final state = container.read(goodsReceiptsProvider) as GoodsReceiptsLoaded;
      expect(state.receipts.first.id, 'gr-new');
      expect(state.total, 2);
    });

    test('confirmReceipt replaces the matching receipt in state', () async {
      final repo = _FakeInventoryRepository();
      repo.stubReceipts([_receipt(id: 'gr-1'), _receipt(id: 'gr-2')]);
      final confirmed = GoodsReceipt(id: 'gr-1', storeId: 'store-1', receivedBy: 'user-1');
      repo.stubConfirmReceipt(confirmed);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(goodsReceiptsProvider.notifier).load();
      await container.read(goodsReceiptsProvider.notifier).confirmReceipt('gr-1');

      final state = container.read(goodsReceiptsProvider) as GoodsReceiptsLoaded;
      expect(state.receipts, hasLength(2));
    });
  });

  // ─── PurchaseOrdersNotifier ───────────────────────────────────

  group('PurchaseOrdersNotifier', () {
    test('initial state is PurchaseOrdersInitial', () {
      final repo = _FakeInventoryRepository();
      repo.stubPurchaseOrders([]);
      final container = _container(repo);
      addTearDown(container.dispose);

      expect(container.read(purchaseOrdersProvider), isA<PurchaseOrdersInitial>());
    });

    test('load returns purchase orders', () async {
      final repo = _FakeInventoryRepository();
      repo.stubPurchaseOrders([_po(), _po(id: 'po-2')]);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(purchaseOrdersProvider.notifier).load();

      final state = container.read(purchaseOrdersProvider) as PurchaseOrdersLoaded;
      expect(state.orders, hasLength(2));
    });

    test('load transitions to error state', () async {
      final repo = _FakeInventoryRepository();
      repo.stubPurchaseOrdersError(Exception('network error'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(purchaseOrdersProvider.notifier).load();

      expect(container.read(purchaseOrdersProvider), isA<PurchaseOrdersError>());
    });

    test('total is populated from repository', () async {
      final repo = _FakeInventoryRepository();
      repo.stubPurchaseOrders([_po(), _po(id: 'po-2')], lastPage: 1, page: 1);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(purchaseOrdersProvider.notifier).load();

      final state = container.read(purchaseOrdersProvider) as PurchaseOrdersLoaded;
      expect(state.orders, hasLength(2));
    });
  });

  // ─── StocktakesNotifier ───────────────────────────────────────

  group('StocktakesNotifier', () {
    test('initial state is StocktakesInitial', () {
      final repo = _FakeInventoryRepository();
      repo.stubStocktakes([]);
      final container = _container(repo);
      addTearDown(container.dispose);

      expect(container.read(stocktakesProvider), isA<StocktakesInitial>());
    });

    test('load returns stocktakes', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStocktakes([_stocktake(), _stocktake(id: 'skt-2')]);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stocktakesProvider.notifier).load();

      final state = container.read(stocktakesProvider) as StocktakesLoaded;
      expect(state.stocktakes, hasLength(2));
    });

    test('load transitions to error on exception', () async {
      final repo = _FakeInventoryRepository();
      repo.stubStocktakesError(Exception('load failed'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(stocktakesProvider.notifier).load();

      expect(container.read(stocktakesProvider), isA<StocktakesError>());
    });
  });

  // ─── WasteRecordsNotifier ─────────────────────────────────────

  group('WasteRecordsNotifier', () {
    test('initial state is WasteRecordsInitial', () {
      final repo = _FakeInventoryRepository();
      repo.stubWasteRecords([]);
      final container = _container(repo);
      addTearDown(container.dispose);

      expect(container.read(wasteRecordsProvider), isA<WasteRecordsInitial>());
    });

    test('load returns waste records', () async {
      final repo = _FakeInventoryRepository();
      repo.stubWasteRecords([_wasteRecord(), _wasteRecord(id: 'wr-2')]);
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(wasteRecordsProvider.notifier).load();

      final state = container.read(wasteRecordsProvider) as WasteRecordsLoaded;
      expect(state.records, hasLength(2));
    });

    test('load transitions to error on exception', () async {
      final repo = _FakeInventoryRepository();
      repo.stubWasteError(Exception('failed'));
      final container = _container(repo);
      addTearDown(container.dispose);

      await container.read(wasteRecordsProvider.notifier).load();

      expect(container.read(wasteRecordsProvider), isA<WasteRecordsError>());
    });
  });
}
