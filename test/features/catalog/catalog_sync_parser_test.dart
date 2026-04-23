import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/services/catalog_sync_service.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // parseModifierResponse — pure parsing logic
  // ═══════════════════════════════════════════════════════════════

  group('parseModifierResponse', () {
    test('returns empty result for empty input', () {
      final parsed = parseModifierResponse('p-1', const []);
      expect(parsed.groups, isEmpty);
      expect(parsed.options, isEmpty);
    });

    test('parses one group with two options', () {
      final raw = [
        {
          'id': 'g-1',
          'name': 'Size',
          'name_ar': 'الحجم',
          'is_required': true,
          'min_select': 1,
          'max_select': 1,
          'sort_order': 0,
          'options': [
            {'id': 'o-1', 'name': 'Small', 'name_ar': 'صغير', 'price_adjustment': 0, 'sort_order': 0, 'is_active': true},
            {'id': 'o-2', 'name': 'Large', 'name_ar': null, 'price_adjustment': '2.50', 'sort_order': 1, 'is_active': true},
          ],
        },
      ];

      final parsed = parseModifierResponse('p-1', raw);

      expect(parsed.groups, hasLength(1));
      expect(parsed.options, hasLength(2));
      expect(parsed.groups[0].id, equals(const Value('g-1')));
      expect(parsed.groups[0].productId, equals(const Value('p-1')));
      expect(parsed.groups[0].name, equals(const Value('Size')));
      expect(parsed.groups[0].isRequired, equals(const Value(true)));
      expect(parsed.options[1].priceDelta, equals(const Value(2.5)));
      expect(parsed.options[1].nameAr.value, isNull);
    });

    test('skips entries that are not maps or have no id', () {
      final raw = <dynamic>[
        'not a map',
        {'no_id_here': true},
        {
          'id': 'g-ok',
          'name': 'Sauce',
          'options': [
            'string in array',
            {'no_id': true},
            {'id': 'o-ok', 'name': 'Ketchup'},
          ],
        },
      ];

      final parsed = parseModifierResponse('p', raw);
      expect(parsed.groups, hasLength(1));
      expect(parsed.groups.single.id.value, 'g-ok');
      expect(parsed.options, hasLength(1));
      expect(parsed.options.single.id.value, 'o-ok');
    });

    test('falls back when min_select / sort_order missing', () {
      final raw = [
        {'id': 'g', 'name': 'X', 'options': const []},
      ];

      final parsed = parseModifierResponse('p', raw);
      expect(parsed.groups.single.minSelect, equals(const Value(0)));
      expect(parsed.groups.single.sortOrder, equals(const Value(0)));
      expect(parsed.groups.single.isRequired, equals(const Value(false)));
      expect(parsed.groups.single.maxSelect.value, isNull);
    });

    test('treats is_active=false explicitly, defaults to true otherwise', () {
      final raw = [
        {
          'id': 'g',
          'name': 'X',
          'options': [
            {'id': 'a', 'name': 'A'},
            {'id': 'b', 'name': 'B', 'is_active': false},
          ],
        },
      ];

      final parsed = parseModifierResponse('p', raw);
      expect(parsed.options[0].isActive, equals(const Value(true)));
      expect(parsed.options[1].isActive, equals(const Value(false)));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Drift round-trip — feed parsed companions into a real
  // in-memory PosOfflineDatabase and read them back.
  // ═══════════════════════════════════════════════════════════════

  group('PosOfflineDatabase + parseModifierResponse round-trip', () {
    late PosOfflineDatabase db;

    setUp(() {
      db = PosOfflineDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async => db.close());

    test('upsert + query retrieves groups and options for the product', () async {
      final raw = [
        {
          'id': 'g-1',
          'name': 'Size',
          'min_select': 1,
          'max_select': 2,
          'is_required': true,
          'sort_order': 0,
          'options': [
            {'id': 'o-1', 'name': 'Small', 'price_adjustment': 0, 'sort_order': 0},
            {'id': 'o-2', 'name': 'Large', 'price_adjustment': 1.5, 'sort_order': 1},
          ],
        },
      ];
      final parsed = parseModifierResponse('p-99', raw);

      await db.upsertModifierGroups(parsed.groups);
      await db.upsertModifierOptions(parsed.options);

      final groups = await db.modifierGroupsFor('p-99');
      expect(groups, hasLength(1));
      expect(groups.single.name, 'Size');
      expect(groups.single.maxSelect, 2);

      final options = await db.modifierOptionsFor('g-1');
      expect(options, hasLength(2));
      expect(options[0].name, 'Small');
      expect(options[1].priceDelta, 1.5);
    });

    test('upsertCategories overwrites by id', () async {
      await db.upsertCategories([
        LocalCategoriesCompanion(
          id: const Value('c-1'),
          name: const Value('Beverages'),
          parentId: const Value(null),
          nameAr: const Value('مشروبات'),
          colorHex: const Value(null),
          iconName: const Value(null),
          sortOrder: const Value(0),
          isActive: const Value(true),
          updatedAt: Value(DateTime(2026, 1, 1)),
        ),
      ]);

      // Same id, new name → upsert.
      await db.upsertCategories([
        LocalCategoriesCompanion(
          id: const Value('c-1'),
          name: const Value('Drinks'),
          parentId: const Value(null),
          nameAr: const Value(null),
          colorHex: const Value(null),
          iconName: const Value(null),
          sortOrder: const Value(0),
          isActive: const Value(true),
          updatedAt: Value(DateTime(2026, 2, 1)),
        ),
      ]);

      final rows = await db.activeCategories();
      expect(rows, hasLength(1));
      expect(rows.single.name, 'Drinks');
    });
  });
}
