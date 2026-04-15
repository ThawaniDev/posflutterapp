import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/staff/models/role.dart';
import 'package:wameedpos/features/staff/models/permission.dart';

void main() {
  group('Role', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 5,
        'name': 'custom_cashier',
        'display_name': 'Custom Cashier',
        'display_name_ar': 'كاشير مخصص',
        'store_id': 'store-uuid-123',
        'guard_name': 'staff',
        'is_predefined': false,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
        'permissions': [
          {'id': 1, 'name': 'pos.sell', 'display_name': 'Sell', 'module': 'pos', 'requires_pin': false},
          {'id': 2, 'name': 'pos.refund', 'display_name': 'Refund', 'module': 'pos', 'requires_pin': true},
        ],
      };

      final role = Role.fromJson(json);

      expect(role.id, 5); // int, not String
      expect(role.name, 'custom_cashier');
      expect(role.displayName, 'Custom Cashier');
      expect(role.displayNameAr, 'كاشير مخصص');
      expect(role.storeId, 'store-uuid-123');
      expect(role.guardName, 'staff');
      expect(role.isPredefined, false);
      expect(role.permissions, isNotNull);
      expect(role.permissions!.length, 2);
      expect(role.permissions![0].name, 'pos.sell');
      expect(role.permissions![1].requiresPin, true);
    });

    test('fromJson handles null permissions', () {
      final json = {'id': 1, 'name': 'basic', 'display_name': 'Basic'};

      final role = Role.fromJson(json);
      expect(role.permissions, isNull);
    });

    test('fromJson handles empty permissions array', () {
      final json = {'id': 1, 'name': 'empty', 'display_name': 'Empty', 'permissions': []};

      final role = Role.fromJson(json);
      expect(role.permissions, isNotNull);
      expect(role.permissions!.isEmpty, true);
    });

    test('fromJson defaults guard_name to staff', () {
      final json = {'id': 1, 'name': 'test', 'display_name': 'Test'};

      final role = Role.fromJson(json);
      expect(role.guardName, 'staff');
    });

    test('toJson serializes back to JSON including permissions', () {
      final role = Role(
        id: 3,
        name: 'manager',
        displayName: 'Branch Manager',
        storeId: 'store-1',
        isPredefined: true,
        permissions: [Permission(id: 1, name: 'orders.view', displayName: 'View Orders', module: 'orders', requiresPin: false)],
      );

      final json = role.toJson();
      expect(json['id'], 3);
      expect(json['name'], 'manager');
      expect(json['display_name'], 'Branch Manager');
      expect(json['permissions'], isNotNull);
      expect((json['permissions'] as List).length, 1);
    });

    test('toJson round-trip preserves data', () {
      final original = Role(
        id: 7,
        name: 'test_role',
        displayName: 'Test Role',
        displayNameAr: 'دور تجريبي',
        storeId: 'store-1',
        guardName: 'staff',
        isPredefined: false,
      );

      final json = original.toJson();
      final restored = Role.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.displayName, original.displayName);
      expect(restored.displayNameAr, original.displayNameAr);
    });
  });

  group('Permission', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 42,
        'name': 'orders.refund',
        'display_name': 'Refund Orders',
        'display_name_ar': 'استرداد الطلبات',
        'module': 'orders',
        'requires_pin': true,
        'guard_name': 'staff',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final perm = Permission.fromJson(json);

      expect(perm.id, 42); // int
      expect(perm.name, 'orders.refund');
      expect(perm.displayName, 'Refund Orders');
      expect(perm.displayNameAr, 'استرداد الطلبات');
      expect(perm.module, 'orders');
      expect(perm.requiresPin, true);
    });

    test('fromJson defaults requiresPin to false', () {
      final json = {'id': 1, 'name': 'pos.sell', 'display_name': 'Sell', 'module': 'pos'};

      final perm = Permission.fromJson(json);
      expect(perm.requiresPin, false);
    });

    test('toJson serializes correctly', () {
      final perm = Permission(id: 10, name: 'catalog.edit', displayName: 'Edit Catalog', module: 'catalog', requiresPin: false);

      final json = perm.toJson();
      expect(json['id'], 10);
      expect(json['name'], 'catalog.edit');
      expect(json['module'], 'catalog');
      expect(json['requires_pin'], false);
    });

    test('handles Arabic display names', () {
      final json = {'id': 1, 'name': 'pos.sell', 'display_name': 'Sell', 'display_name_ar': 'بيع', 'module': 'pos'};

      final perm = Permission.fromJson(json);
      expect(perm.displayNameAr, 'بيع');
    });
  });
}
