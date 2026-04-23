import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'pos_offline_database.g.dart';

/// Local-first POS terminal database. Drains queued mutations to the backend
/// via `POST /api/v2/pos/transactions/batch` once connectivity is restored.
///
/// Each row uses a client-side UUID (`client_uuid`) so the backend can
/// idempotently swallow duplicate retries.

class LocalProducts extends Table {
  TextColumn get id => text()();
  TextColumn get sku => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  RealColumn get price => real()();
  RealColumn get costPrice => real().nullable()();
  RealColumn get taxRate => real().withDefault(const Constant(0))();
  TextColumn get unit => text().nullable()();
  BoolColumn get isWeighted => boolean().withDefault(const Constant(false))();
  BoolColumn get isAgeRestricted => boolean().withDefault(const Constant(false))();
  IntColumn get minimumAge => integer().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalInventory extends Table {
  TextColumn get productId => text()();
  TextColumn get storeId => text()();
  RealColumn get quantity => real().withDefault(const Constant(0))();
  RealColumn get reserved => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {productId, storeId};
}

class LocalHeldCarts extends Table {
  TextColumn get clientUuid => text()();
  TextColumn get storeId => text()();
  TextColumn get registerId => text().nullable()();
  TextColumn get cashierId => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get itemsJson => text()();
  RealColumn get total => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column> get primaryKey => {clientUuid};
}

class LocalTransactions extends Table {
  TextColumn get clientUuid => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get transactionNumber => text()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  TextColumn get storeId => text()();
  TextColumn get registerId => text().nullable()();
  TextColumn get cashierId => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get sessionId => text().nullable()();
  RealColumn get subtotal => real()();
  RealColumn get taxAmount => real().withDefault(const Constant(0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0))();
  RealColumn get totalAmount => real()();
  TextColumn get itemsJson => text()();
  TextColumn get paymentsJson => text()();
  TextColumn get taxExemptionJson => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get returnTransactionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {clientUuid};
}

/// Mutations that need to be replayed when the device is back online.
/// `payloadJson` is the raw JSON body the API expects.
class LocalSyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clientUuid => text()();
  TextColumn get kind => text()(); // transaction|inventory_adjustment|held_cart|customer
  TextColumn get payloadJson => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending|in_progress|done|failed
}

// ─── Catalog-supporting tables (offline-first browsing) ────────

class LocalCategories extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  TextColumn get iconName => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSuppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get contactPerson => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalProductSuppliers extends Table {
  TextColumn get productId => text()();
  TextColumn get supplierId => text()();
  RealColumn get costPrice => real().nullable()();
  TextColumn get supplierSku => text().nullable()();
  IntColumn get leadTimeDays => integer().nullable()();
  BoolColumn get isPreferred => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {productId, supplierId};
}

class LocalProductVariants extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get sku => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get name => text()();
  TextColumn get attributesJson => text().withDefault(const Constant('{}'))();
  RealColumn get priceDelta => real().withDefault(const Constant(0))();
  RealColumn get costPrice => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalModifierGroups extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  IntColumn get minSelect => integer().withDefault(const Constant(0))();
  IntColumn get maxSelect => integer().nullable()();
  BoolColumn get isRequired => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalModifierOptions extends Table {
  TextColumn get id => text()();
  TextColumn get groupId => text()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  RealColumn get priceDelta => real().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  LocalProducts,
  LocalInventory,
  LocalHeldCarts,
  LocalTransactions,
  LocalSyncQueue,
  LocalCategories,
  LocalSuppliers,
  LocalProductSuppliers,
  LocalProductVariants,
  LocalModifierGroups,
  LocalModifierOptions,
])
class PosOfflineDatabase extends _$PosOfflineDatabase {
  PosOfflineDatabase() : super(_openConnection());

  PosOfflineDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(localCategories);
            await m.createTable(localSuppliers);
            await m.createTable(localProductSuppliers);
            await m.createTable(localProductVariants);
            await m.createTable(localModifierGroups);
            await m.createTable(localModifierOptions);
          }
        },
      );

  // ─── Products ──────────────────────────────────────────────

  Future<void> upsertProducts(List<LocalProductsCompanion> rows) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(localProducts, rows);
    });
  }

  Future<List<LocalProduct>> searchProducts(String query, {int limit = 50}) {
    final like = '%${query.toLowerCase()}%';
    return (select(localProducts)
          ..where((t) =>
              t.isActive.equals(true) &
              (t.name.lower().like(like) |
                  t.sku.lower().like(like) |
                  t.barcode.lower().like(like)))
          ..limit(limit))
        .get();
  }

  Future<LocalProduct?> findByBarcode(String barcode) =>
      (select(localProducts)..where((t) => t.barcode.equals(barcode))).getSingleOrNull();

  // ─── Inventory ─────────────────────────────────────────────

  Future<void> upsertInventory(List<LocalInventoryCompanion> rows) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(localInventory, rows);
    });
  }

  Future<double> stockOf(String productId, String storeId) async {
    final row = await (select(localInventory)
          ..where((t) => t.productId.equals(productId) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    return row?.quantity ?? 0;
  }

  // ─── Held carts ────────────────────────────────────────────

  Future<void> saveHeldCart(LocalHeldCartsCompanion row) =>
      into(localHeldCarts).insertOnConflictUpdate(row);

  Future<List<LocalHeldCart>> activeHeldCarts(String storeId) =>
      (select(localHeldCarts)..where((t) => t.storeId.equals(storeId))).get();

  Future<int> deleteHeldCart(String clientUuid) =>
      (delete(localHeldCarts)..where((t) => t.clientUuid.equals(clientUuid))).go();

  // ─── Transactions ──────────────────────────────────────────

  Future<void> saveTransaction(LocalTransactionsCompanion row) =>
      into(localTransactions).insertOnConflictUpdate(row);

  Future<List<LocalTransaction>> transactionsAwaitingSync() =>
      (select(localTransactions)..where((t) => t.serverId.isNull())).get();

  Future<int> markTransactionSynced(String clientUuid, String serverId) =>
      (update(localTransactions)..where((t) => t.clientUuid.equals(clientUuid)))
          .write(LocalTransactionsCompanion(serverId: Value(serverId)));

  // ─── Sync queue ────────────────────────────────────────────

  Future<int> enqueue(LocalSyncQueueCompanion row) => into(localSyncQueue).insert(row);

  Future<List<LocalSyncQueueData>> dueQueueEntries({int limit = 50}) {
    final now = DateTime.now();
    return (select(localSyncQueue)
          ..where((t) => t.status.equals('pending') & t.nextAttemptAt.isSmallerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<int> markEntryStatus(int id, String status, {String? error, DateTime? nextAttemptAt}) =>
      (update(localSyncQueue)..where((t) => t.id.equals(id))).write(
        LocalSyncQueueCompanion(
          status: Value(status),
          lastError: Value(error),
          nextAttemptAt: nextAttemptAt == null ? const Value.absent() : Value(nextAttemptAt),
          attempts: const Value.absent(),
        ),
      );

  Future<int> incrementAttempts(int id) => customUpdate(
        'UPDATE local_sync_queue SET attempts = attempts + 1 WHERE id = ?',
        variables: [Variable.withInt(id)],
        updates: {localSyncQueue},
      );

  // ─── Catalog: categories ───────────────────────────────────

  Future<void> upsertCategories(List<LocalCategoriesCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localCategories, rows));
  }

  Future<List<LocalCategory>> activeCategories() =>
      (select(localCategories)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  // ─── Catalog: suppliers ────────────────────────────────────

  Future<void> upsertSuppliers(List<LocalSuppliersCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localSuppliers, rows));
  }

  Future<List<LocalSupplier>> activeSuppliers() =>
      (select(localSuppliers)..where((t) => t.isActive.equals(true))).get();

  Future<void> upsertProductSuppliers(List<LocalProductSuppliersCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localProductSuppliers, rows));
  }

  Future<List<LocalProductSupplier>> suppliersForProduct(String productId) =>
      (select(localProductSuppliers)..where((t) => t.productId.equals(productId))).get();

  // ─── Catalog: variants ─────────────────────────────────────

  Future<void> upsertVariants(List<LocalProductVariantsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localProductVariants, rows));
  }

  Future<List<LocalProductVariant>> variantsFor(String productId) =>
      (select(localProductVariants)
            ..where((t) => t.productId.equals(productId) & t.isActive.equals(true)))
          .get();

  // ─── Catalog: modifiers ────────────────────────────────────

  Future<void> upsertModifierGroups(List<LocalModifierGroupsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localModifierGroups, rows));
  }

  Future<void> upsertModifierOptions(List<LocalModifierOptionsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(localModifierOptions, rows));
  }

  Future<List<LocalModifierGroup>> modifierGroupsFor(String productId) =>
      (select(localModifierGroups)
            ..where((t) => t.productId.equals(productId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<List<LocalModifierOption>> modifierOptionsFor(String groupId) =>
      (select(localModifierOptions)
            ..where((t) => t.groupId.equals(groupId) & t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'wameedpos_offline.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final posOfflineDatabaseProvider = Provider<PosOfflineDatabase>((ref) {
  final db = PosOfflineDatabase();
  ref.onDispose(db.close);
  return db;
});
