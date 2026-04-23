import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // ComboDefinition.fromJson — must tolerate `combo: null`
  // ═══════════════════════════════════════════════════════════════

  group('ComboDefinition.fromJson', () {
    test('parses populated combo with items', () {
      final json = {
        'is_combo': true,
        'combo': {
          'id': 'combo-1',
          'name': 'Big Breakfast',
          'combo_price': 19.99,
          'items': [
            {
              'id': 'i-1',
              'product_id': 'p-1',
              'product_name': 'Burger',
              'product_name_ar': 'برجر',
              'quantity': 1,
              'is_optional': false,
            },
            {
              'id': 'i-2',
              'product_id': 'p-2',
              'product_name': 'Fries',
              'product_name_ar': null,
              'quantity': 2.5,
              'is_optional': true,
            },
          ],
        },
      };

      final combo = ComboDefinition.fromJson(json);

      expect(combo.isCombo, isTrue);
      expect(combo.id, 'combo-1');
      expect(combo.name, 'Big Breakfast');
      expect(combo.comboPrice, 19.99);
      expect(combo.items, hasLength(2));
      expect(combo.items[0].productId, 'p-1');
      expect(combo.items[0].productName, 'Burger');
      expect(combo.items[0].productNameAr, 'برجر');
      expect(combo.items[0].quantity, 1);
      expect(combo.items[0].isOptional, isFalse);
      expect(combo.items[1].quantity, 2.5);
      expect(combo.items[1].isOptional, isTrue);
      expect(combo.items[1].productNameAr, isNull);
    });

    test('handles is_combo=false with combo:null', () {
      final json = {'is_combo': false, 'combo': null};
      final combo = ComboDefinition.fromJson(json);
      expect(combo.isCombo, isFalse);
      expect(combo.id, isNull);
      expect(combo.name, isNull);
      expect(combo.comboPrice, isNull);
      expect(combo.items, isEmpty);
    });

    test('treats combo_price as null when missing', () {
      final json = {
        'is_combo': true,
        'combo': {'id': 'c', 'name': 'X', 'combo_price': null, 'items': const []},
      };
      final combo = ComboDefinition.fromJson(json);
      expect(combo.comboPrice, isNull);
      expect(combo.items, isEmpty);
    });

    test('parses combo_price coming back as a numeric string', () {
      // Laravel's decimal cast often serialises to "5.50" instead of 5.5.
      final json = {
        'is_combo': true,
        'combo': {
          'id': 'c',
          'name': 'X',
          'combo_price': '5.50',
          'items': [
            {
              'id': 'i',
              'product_id': 'p',
              'product_name': 'P',
              'product_name_ar': null,
              'quantity': '3.000',
              'is_optional': false,
            },
          ],
        },
      };
      final combo = ComboDefinition.fromJson(json);
      expect(combo.comboPrice, 5.5);
      expect(combo.items.single.quantity, 3.0);
    });

    test('quantity defaults to 1 if missing', () {
      final json = {
        'is_combo': true,
        'combo': {
          'id': 'c',
          'name': 'X',
          'combo_price': null,
          'items': [
            {'id': 'i', 'product_id': 'p', 'product_name': 'P', 'product_name_ar': null, 'is_optional': false},
          ],
        },
      };
      final combo = ComboDefinition.fromJson(json);
      expect(combo.items.single.quantity, 1);
    });

    test('skips malformed item entries instead of throwing', () {
      // The real server should never send these, but the parser
      // must not crash a release build if it ever does.
      final json = {
        'is_combo': true,
        'combo': {'id': 'c', 'name': 'X', 'combo_price': 0, 'items': null},
      };
      final combo = ComboDefinition.fromJson(json);
      expect(combo.items, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ComboItemPayload.toJson — outbound shape for PUT /combo
  // ═══════════════════════════════════════════════════════════════

  group('ComboItemPayload.toJson', () {
    test('includes all three fields with safe defaults', () {
      const payload = ComboItemPayload(productId: 'p-1', quantity: 2);
      expect(payload.toJson(), {'product_id': 'p-1', 'quantity': 2, 'is_optional': false});
    });

    test('round-trips is_optional=true', () {
      const payload = ComboItemPayload(productId: 'p-2', quantity: 1.5, isOptional: true);
      expect(payload.toJson(), {'product_id': 'p-2', 'quantity': 1.5, 'is_optional': true});
    });
  });
}
