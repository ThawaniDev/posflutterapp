import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';

/// Local Drift cache for customers + groups so the POS terminal can lookup,
/// adjust loyalty, and read profile data when offline (spec §6.4).
class CustomerDao {
  CustomerDao(this._db);
  final PosOfflineDatabase _db;

  // ─── Upsert from server ────────────────────────────────────

  Future<void> upsertCustomers(List<Customer> rows) async {
    if (rows.isEmpty) return;
    await _db.batch((b) {
      for (final c in rows) {
        b.insert(
          _db.localCustomers,
          LocalCustomersCompanion.insert(
            id: c.id,
            organizationId: c.organizationId,
            name: c.name,
            phone: Value(c.phone),
            email: Value(c.email),
            address: Value(c.address),
            dateOfBirth: Value(c.dateOfBirth),
            loyaltyCode: Value(c.loyaltyCode),
            loyaltyPoints: Value(c.loyaltyPoints ?? 0),
            storeCreditBalance: Value(c.storeCreditBalance ?? 0),
            groupId: Value(c.groupId),
            taxRegistrationNumber: Value(c.taxRegistrationNumber),
            notes: Value(c.notes),
            totalSpend: Value(c.totalSpend ?? 0),
            visitCount: Value(c.visitCount ?? 0),
            lastVisitAt: Value(c.lastVisitAt),
            syncVersion: Value(c.syncVersion ?? 1),
            updatedAt: Value(c.updatedAt ?? DateTime.now()),
            deletedAt: Value(c.deletedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> upsertGroups(List<CustomerGroup> rows) async {
    if (rows.isEmpty) return;
    await _db.batch((b) {
      for (final g in rows) {
        b.insert(
          _db.localCustomerGroups,
          LocalCustomerGroupsCompanion.insert(
            id: g.id,
            organizationId: g.organizationId,
            name: g.name,
            discountPercent: Value(g.discountPercent ?? 0),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  // ─── Reads ─────────────────────────────────────────────────

  Future<List<Customer>> listCustomers(
    String organizationId, {
    String? search,
    String? groupId,
    int limit = 50,
    int offset = 0,
  }) async {
    final query = _db.select(_db.localCustomers)
      ..where((t) => t.organizationId.equals(organizationId) & t.deletedAt.isNull());

    if (search != null && search.trim().isNotEmpty) {
      final like = '%${search.toLowerCase()}%';
      query.where((t) =>
          t.name.lower().like(like) |
          t.phone.lower().like(like) |
          t.email.lower().like(like) |
          t.loyaltyCode.lower().like(like));
    }
    if (groupId != null) {
      query.where((t) => t.groupId.equals(groupId));
    }

    query.orderBy([(t) => OrderingTerm.asc(t.name)]);
    query.limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map(_rowToCustomer).toList();
  }

  Future<int> countCustomers(String organizationId) async {
    final q = _db.selectOnly(_db.localCustomers)
      ..addColumns([_db.localCustomers.id.count()])
      ..where(_db.localCustomers.organizationId.equals(organizationId) &
          _db.localCustomers.deletedAt.isNull());
    final row = await q.getSingle();
    return row.read(_db.localCustomers.id.count()) ?? 0;
  }

  Future<Customer?> getById(String id) async {
    final row = await (_db.select(_db.localCustomers)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _rowToCustomer(row);
  }

  Future<Customer?> getByPhone(String organizationId, String phone) async {
    final row = await (_db.select(_db.localCustomers)
          ..where((t) =>
              t.organizationId.equals(organizationId) &
              t.phone.equals(phone) &
              t.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _rowToCustomer(row);
  }

  Future<Customer?> getByLoyaltyCode(String organizationId, String code) async {
    final row = await (_db.select(_db.localCustomers)
          ..where((t) =>
              t.organizationId.equals(organizationId) &
              t.loyaltyCode.equals(code) &
              t.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _rowToCustomer(row);
  }

  Future<List<CustomerGroup>> listGroups(String organizationId) async {
    final rows = await (_db.select(_db.localCustomerGroups)
          ..where((t) => t.organizationId.equals(organizationId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return rows
        .map((r) => CustomerGroup(
              id: r.id,
              organizationId: r.organizationId,
              name: r.name,
              discountPercent: r.discountPercent,
            ))
        .toList();
  }

  Future<DateTime?> getMostRecentUpdatedAt(String organizationId) async {
    final q = _db.selectOnly(_db.localCustomers)
      ..addColumns([_db.localCustomers.updatedAt.max()])
      ..where(_db.localCustomers.organizationId.equals(organizationId));
    final row = await q.getSingleOrNull();
    return row?.read(_db.localCustomers.updatedAt.max());
  }

  Future<int> markDeleted(String id) async {
    return (_db.update(_db.localCustomers)..where((t) => t.id.equals(id)))
        .write(LocalCustomersCompanion(deletedAt: Value(DateTime.now())));
  }

  /// Hard reset (used by tests / org switch).
  Future<void> clearAll() async {
    await _db.delete(_db.localCustomers).go();
    await _db.delete(_db.localCustomerGroups).go();
  }

  // ─── Mapping ───────────────────────────────────────────────

  Customer _rowToCustomer(LocalCustomer r) => Customer(
        id: r.id,
        organizationId: r.organizationId,
        name: r.name,
        phone: r.phone ?? '',
        email: r.email,
        address: r.address,
        dateOfBirth: r.dateOfBirth,
        loyaltyCode: r.loyaltyCode,
        loyaltyPoints: r.loyaltyPoints,
        storeCreditBalance: r.storeCreditBalance,
        groupId: r.groupId,
        taxRegistrationNumber: r.taxRegistrationNumber,
        notes: r.notes,
        totalSpend: r.totalSpend,
        visitCount: r.visitCount,
        lastVisitAt: r.lastVisitAt,
        syncVersion: r.syncVersion,
        updatedAt: r.updatedAt,
        deletedAt: r.deletedAt,
      );
}

final customerDaoProvider = Provider<CustomerDao>((ref) {
  return CustomerDao(ref.watch(posOfflineDatabaseProvider));
});
