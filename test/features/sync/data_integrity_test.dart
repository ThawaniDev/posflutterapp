import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/sync/services/data_integrity_service.dart';

void main() {
  group('DataIntegrityService', () {
    late DataIntegrityService service;

    setUp(() {
      service = DataIntegrityService();
    });

    test('computeChecksum returns consistent SHA-256 hash', () {
      final data = [
        {'id': '1', 'name': 'Product A'},
        {'id': '2', 'name': 'Product B'},
      ];

      final hash1 = service.computeChecksum(data);
      final hash2 = service.computeChecksum(data);

      expect(hash1, isNotEmpty);
      expect(hash1, hash2); // deterministic
      expect(hash1.length, 64); // SHA-256 hex
    });

    test('computeChecksum normalizes key order', () {
      final data1 = [
        {'name': 'A', 'id': '1'},
      ];
      final data2 = [
        {'id': '1', 'name': 'A'},
      ];

      expect(service.computeChecksum(data1), service.computeChecksum(data2));
    });

    test('computeChecksum sorts by id field', () {
      final data1 = [
        {'id': '2', 'name': 'B'},
        {'id': '1', 'name': 'A'},
      ];
      final data2 = [
        {'id': '1', 'name': 'A'},
        {'id': '2', 'name': 'B'},
      ];

      expect(service.computeChecksum(data1), service.computeChecksum(data2));
    });

    test('verifyChecksum returns true for matching data', () {
      final data = [
        {'id': '1', 'value': 42},
      ];
      final checksum = service.computeChecksum(data);

      expect(service.verifyChecksum(data, checksum), isTrue);
    });

    test('verifyChecksum returns false for tampered data', () {
      final data = [
        {'id': '1', 'value': 42},
      ];
      final checksum = service.computeChecksum(data);

      final tampered = [
        {'id': '1', 'value': 99},
      ];

      expect(service.verifyChecksum(tampered, checksum), isFalse);
    });

    test('computeChecksum handles empty list', () {
      final hash = service.computeChecksum([]);
      expect(hash, isNotEmpty);
      expect(hash.length, 64);
    });

    test('computeChecksum handles nested maps', () {
      final data = [
        {
          'id': '1',
          'meta': {'key': 'val'},
        },
      ];

      final hash = service.computeChecksum(data);
      expect(hash, isNotEmpty);
    });
  });
}
