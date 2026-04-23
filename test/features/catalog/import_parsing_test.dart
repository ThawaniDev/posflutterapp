import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // ImportPreview.fromJson — happy path + tolerant defaults
  // ═══════════════════════════════════════════════════════════════

  group('ImportPreview.fromJson', () {
    test('parses a normal preview payload', () {
      final json = {
        'header': ['Name', 'SKU', 'Price'],
        'preview': [
          ['Apple', 'A-1', '0.500'],
          ['Banana', 'B-2', '0.250'],
        ],
        'total_rows': 42,
        'available_fields': ['name', 'sku', 'selling_price'],
      };

      final preview = ImportPreview.fromJson(json);

      expect(preview.header, ['Name', 'SKU', 'Price']);
      expect(preview.preview, hasLength(2));
      expect(preview.preview[0], ['Apple', 'A-1', '0.500']);
      expect(preview.totalRows, 42);
      expect(preview.availableFields, ['name', 'sku', 'selling_price']);
    });

    test('coerces non-string cells to strings and tolerates nulls', () {
      final json = {
        'header': ['A', null, 1],
        'preview': [
          [1, true, null],
        ],
        'total_rows': '7',
        'available_fields': const [],
      };

      final preview = ImportPreview.fromJson(json);
      expect(preview.header, ['A', '', '1']);
      expect(preview.preview.single, ['1', 'true', '']);
      // total_rows arriving as a numeric string is parsed leniently.
      expect(preview.totalRows, 7);
      expect(preview.availableFields, isEmpty);
    });

    test('returns empty lists when fields are missing', () {
      final preview = ImportPreview.fromJson(<String, dynamic>{});
      expect(preview.header, isEmpty);
      expect(preview.preview, isEmpty);
      expect(preview.availableFields, isEmpty);
      expect(preview.totalRows, 0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ImportResult.fromJson + ImportError.fromJson
  // ═══════════════════════════════════════════════════════════════

  group('ImportResult.fromJson', () {
    test('parses created / failed / nested errors', () {
      final json = {
        'created': 12,
        'failed': 2,
        'errors': [
          {'row': 5, 'message': 'SKU duplicated'},
          {'row': 9, 'message': 'Missing name'},
        ],
      };

      final result = ImportResult.fromJson(json, message: '12 products imported');

      expect(result.created, 12);
      expect(result.failed, 2);
      expect(result.errors, hasLength(2));
      expect(result.errors[0].row, 5);
      expect(result.errors[0].message, 'SKU duplicated');
      expect(result.errors[1].row, 9);
      expect(result.message, '12 products imported');
    });

    test('handles missing errors list and missing counts', () {
      final result = ImportResult.fromJson(<String, dynamic>{});
      expect(result.created, 0);
      expect(result.failed, 0);
      expect(result.errors, isEmpty);
      expect(result.message, isNull);
    });

    test('skips malformed error entries silently', () {
      final json = {
        'created': 1,
        'failed': 3,
        'errors': [
          'string instead of object',
          {'row': 4, 'message': 'ok'},
          null,
        ],
      };
      final result = ImportResult.fromJson(json);
      expect(result.errors, hasLength(1));
      expect(result.errors.single.row, 4);
    });

    test('ImportError.fromJson defaults missing fields', () {
      final err = ImportError.fromJson(<String, dynamic>{});
      expect(err.row, 0);
      expect(err.message, '');
    });
  });
}
