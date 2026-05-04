import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/customers/data/local/daos/customer_dao.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';

void main() {
  late PosOfflineDatabase db;
  late CustomerDao dao;

  setUp(() {
    db = PosOfflineDatabase.forTesting(NativeDatabase.memory());
    dao = CustomerDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  Customer sample({String id = 'c-1', String orgId = 'org-1', String name = 'Alice', String phone = '+96812345678'}) {
    return Customer(
      id: id,
      organizationId: orgId,
      name: name,
      phone: phone,
      loyaltyPoints: 100,
      storeCreditBalance: 25.0,
      totalSpend: 500.0,
      visitCount: 4,
      syncVersion: 1,
      updatedAt: DateTime.utc(2024, 1, 1),
    );
  }

  group('CustomerDao', () {
    test('upsert + list round-trip preserves fields', () async {
      await dao.upsertCustomers([sample()]);
      final rows = await dao.listCustomers('org-1');
      expect(rows, hasLength(1));
      expect(rows.first.id, 'c-1');
      expect(rows.first.name, 'Alice');
      expect(rows.first.loyaltyPoints, 100);
      expect(rows.first.storeCreditBalance, 25.0);
    });

    test('list isolates by organization', () async {
      await dao.upsertCustomers([sample(id: 'c-1', orgId: 'org-1'), sample(id: 'c-2', orgId: 'org-2', name: 'Bob')]);
      final org1 = await dao.listCustomers('org-1');
      final org2 = await dao.listCustomers('org-2');
      expect(org1, hasLength(1));
      expect(org2, hasLength(1));
      expect(org1.first.id, 'c-1');
      expect(org2.first.id, 'c-2');
    });

    test('soft-deleted customers are excluded from list', () async {
      await dao.upsertCustomers([sample()]);
      await dao.markDeleted('c-1');
      final rows = await dao.listCustomers('org-1');
      expect(rows, isEmpty);
    });

    test('search filters by name (case-insensitive)', () async {
      await dao.upsertCustomers([
        sample(id: 'c-1', name: 'Alice Anderson'),
        sample(id: 'c-2', name: 'Bob Builder', phone: '+96898765432'),
      ]);
      final result = await dao.listCustomers('org-1', search: 'alice');
      expect(result, hasLength(1));
      expect(result.first.name, 'Alice Anderson');
    });

    test('upsertGroups + listGroups round-trip', () async {
      const g = CustomerGroup(id: 'g-1', organizationId: 'org-1', name: 'VIP', discountPercent: 10.0);
      await dao.upsertGroups([g]);
      final groups = await dao.listGroups('org-1');
      expect(groups, hasLength(1));
      expect(groups.first.name, 'VIP');
      expect(groups.first.discountPercent, 10.0);
    });

    test('repeated upsert acts as update (insertOrReplace)', () async {
      await dao.upsertCustomers([sample()]);
      final updated = sample().copyWith(name: 'Alice Updated', loyaltyPoints: 999);
      await dao.upsertCustomers([updated]);
      final rows = await dao.listCustomers('org-1');
      expect(rows, hasLength(1));
      expect(rows.first.name, 'Alice Updated');
      expect(rows.first.loyaltyPoints, 999);
    });
  });
}
