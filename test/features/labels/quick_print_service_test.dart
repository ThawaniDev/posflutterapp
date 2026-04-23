import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/labels/services/quick_print_service.dart';

void main() {
  group('buildWeighableEan13', () {
    test('produces a 13-digit barcode', () {
      final code = buildWeighableEan13(prefix: 21, plu: 1234, payload: 567);
      expect(code.length, 13);
      expect(int.tryParse(code), isNotNull);
    });

    test('checksum is consistent: same input → same output', () {
      final a = buildWeighableEan13(prefix: 21, plu: 1, payload: 99999);
      final b = buildWeighableEan13(prefix: 21, plu: 1, payload: 99999);
      expect(a, equals(b));
    });

    test('different payload changes checksum digit', () {
      final a = buildWeighableEan13(prefix: 21, plu: 1234, payload: 100);
      final b = buildWeighableEan13(prefix: 21, plu: 1234, payload: 200);
      expect(a, isNot(equals(b)));
    });

    test('prefix is encoded in positions 0-1', () {
      final c = buildWeighableEan13(prefix: 23, plu: 13579, payload: 24680);
      expect(c.substring(0, 2), equals('23'));
      expect(c.substring(2, 7), equals('13579'));
      expect(c.substring(7, 12), equals('24680'));
    });

    test('throws on prefix overflow (>99)', () {
      expect(() => buildWeighableEan13(prefix: 100, plu: 1, payload: 1), throwsA(isA<AssertionError>()));
    });
  });

  group('resolveQuickPrintTemplate', () {
    test('returns null when template list is empty', () {
      expect(resolveQuickPrintTemplate(const []), isNull);
    });
  });
}
