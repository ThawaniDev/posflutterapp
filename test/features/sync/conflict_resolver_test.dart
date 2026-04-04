import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/sync/services/conflict_resolver_service.dart';

void main() {
  group('ConflictResolutionStrategy', () {
    test('has all expected values', () {
      expect(
        ConflictResolutionStrategy.values,
        containsAll([
          ConflictResolutionStrategy.acceptLocal,
          ConflictResolutionStrategy.acceptCloud,
          ConflictResolutionStrategy.lastWriteWins,
          ConflictResolutionStrategy.merge,
          ConflictResolutionStrategy.manual,
        ]),
      );
    });
  });

  group('SyncConflict', () {
    test('fromJson creates correct conflict', () {
      final json = {
        'id': 'c1',
        'table': 'products',
        'record_id': 'p1',
        'local_data': {'name': 'Local'},
        'cloud_data': {'name': 'Cloud'},
        'detected_at': '2024-01-01T12:00:00Z',
      };

      final conflict = SyncConflict.fromJson(json);

      expect(conflict.id, 'c1');
      expect(conflict.table, 'products');
      expect(conflict.recordId, 'p1');
      expect(conflict.localData['name'], 'Local');
      expect(conflict.cloudData['name'], 'Cloud');
      expect(conflict.detectedAt, DateTime.parse('2024-01-01T12:00:00Z'));
    });

    test('fromJson handles missing optional fields', () {
      final json = {'id': 'c2', 'table': 'orders', 'record_id': 'o1'};

      final conflict = SyncConflict.fromJson(json);
      expect(conflict.id, 'c2');
      expect(conflict.localData, isEmpty);
      expect(conflict.cloudData, isEmpty);
      expect(conflict.suggestedStrategy, isNull);
    });
  });

  group('ConflictResolution', () {
    test('constructor and fields', () {
      final resolution = ConflictResolution(
        conflictId: 'c1',
        resolved: true,
        strategy: ConflictResolutionStrategy.acceptCloud,
        mergedData: {'name': 'Cloud'},
      );

      expect(resolution.conflictId, 'c1');
      expect(resolution.resolved, isTrue);
      expect(resolution.strategy, ConflictResolutionStrategy.acceptCloud);
      expect(resolution.mergedData?['name'], 'Cloud');
    });
  });
}
