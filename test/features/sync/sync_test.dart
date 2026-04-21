import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/sync/enums/sync_direction.dart';
import 'package:wameedpos/features/sync/enums/sync_log_status.dart';
import 'package:wameedpos/features/sync/enums/sync_conflict_resolution.dart';
import 'package:wameedpos/features/sync/models/sync_log.dart';
import 'package:wameedpos/features/sync/models/sync_conflict.dart';
import 'package:wameedpos/features/sync/providers/sync_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // SyncDirection Enum
  // ═══════════════════════════════════════════════════════════

  group('SyncDirection enum', () {
    test('fromValue returns correct enum', () {
      expect(SyncDirection.fromValue('push'), SyncDirection.push);
      expect(SyncDirection.fromValue('pull'), SyncDirection.pull);
      expect(SyncDirection.fromValue('full'), SyncDirection.full);
    });

    test('tryFromValue returns null for invalid', () {
      expect(SyncDirection.tryFromValue('invalid'), isNull);
      expect(SyncDirection.tryFromValue(''), isNull);
    });

    test('value getter returns correct string', () {
      expect(SyncDirection.push.value, 'push');
      expect(SyncDirection.pull.value, 'pull');
      expect(SyncDirection.full.value, 'full');
    });

    test('all three values exist', () {
      expect(SyncDirection.values, hasLength(3));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncLogStatus Enum
  // ═══════════════════════════════════════════════════════════

  group('SyncLogStatus enum', () {
    test('fromValue returns correct enum', () {
      expect(SyncLogStatus.fromValue('success'), SyncLogStatus.success);
      expect(SyncLogStatus.fromValue('partial'), SyncLogStatus.partial);
      expect(SyncLogStatus.fromValue('failed'), SyncLogStatus.failed);
    });

    test('tryFromValue returns null for invalid', () {
      expect(SyncLogStatus.tryFromValue('unknown'), isNull);
    });

    test('value getter returns correct string', () {
      expect(SyncLogStatus.success.value, 'success');
      expect(SyncLogStatus.partial.value, 'partial');
      expect(SyncLogStatus.failed.value, 'failed');
    });

    test('all three values exist', () {
      expect(SyncLogStatus.values, hasLength(3));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncConflictResolution Enum
  // ═══════════════════════════════════════════════════════════

  group('SyncConflictResolution enum', () {
    test('fromValue returns correct enum', () {
      expect(SyncConflictResolution.fromValue('local_wins'), SyncConflictResolution.localWins);
      expect(SyncConflictResolution.fromValue('cloud_wins'), SyncConflictResolution.cloudWins);
      expect(SyncConflictResolution.fromValue('merged'), SyncConflictResolution.merged);
    });

    test('tryFromValue returns null for invalid', () {
      expect(SyncConflictResolution.tryFromValue('nope'), isNull);
    });

    test('value getter returns correct string', () {
      expect(SyncConflictResolution.localWins.value, 'local_wins');
      expect(SyncConflictResolution.cloudWins.value, 'cloud_wins');
      expect(SyncConflictResolution.merged.value, 'merged');
    });

    test('all three values exist', () {
      expect(SyncConflictResolution.values, hasLength(3));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncLog Model
  // ═══════════════════════════════════════════════════════════

  group('SyncLog model', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'log-001',
        'store_id': 'store-001',
        'terminal_id': 'term-001',
        'direction': 'push',
        'records_count': 42,
        'duration_ms': 1200,
        'status': 'success',
        'error_message': null,
        'started_at': '2024-06-01T10:00:00.000Z',
        'completed_at': '2024-06-01T10:00:01.200Z',
      };

      final log = SyncLog.fromJson(json);
      expect(log.id, 'log-001');
      expect(log.storeId, 'store-001');
      expect(log.terminalId, 'term-001');
      expect(log.direction, SyncDirection.push);
      expect(log.recordsCount, 42);
      expect(log.durationMs, 1200);
      expect(log.status, SyncLogStatus.success);
      expect(log.errorMessage, isNull);
      expect(log.startedAt, isNotNull);
      expect(log.completedAt, isNotNull);
    });

    test('fromJson handles failed status with error', () {
      final json = {
        'id': 'log-002',
        'store_id': 'store-001',
        'terminal_id': 'term-001',
        'direction': 'pull',
        'records_count': 0,
        'duration_ms': 500,
        'status': 'failed',
        'error_message': 'Connection timeout',
        'started_at': '2024-06-01T11:00:00.000Z',
        'completed_at': null,
      };

      final log = SyncLog.fromJson(json);
      expect(log.status, SyncLogStatus.failed);
      expect(log.errorMessage, 'Connection timeout');
      expect(log.completedAt, isNull);
    });

    test('toJson round-trip preserves data', () {
      final log = SyncLog(
        id: 'log-003',
        storeId: 'store-003',
        terminalId: 'term-003',
        direction: SyncDirection.full,
        recordsCount: 100,
        durationMs: 5000,
        status: SyncLogStatus.partial,
        errorMessage: 'Partial failure',
        startedAt: DateTime.parse('2024-06-01T12:00:00.000Z'),
        completedAt: DateTime.parse('2024-06-01T12:00:05.000Z'),
      );

      final json = log.toJson();
      final restored = SyncLog.fromJson(json);
      expect(restored.id, log.id);
      expect(restored.storeId, log.storeId);
      expect(restored.terminalId, log.terminalId);
      expect(restored.direction, log.direction);
      expect(restored.recordsCount, log.recordsCount);
      expect(restored.durationMs, log.durationMs);
      expect(restored.status, log.status);
      expect(restored.errorMessage, log.errorMessage);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'log-004',
        'store_id': 'store-004',
        'terminal_id': 'term-004',
        'direction': 'push',
        'records_count': 10,
        'duration_ms': 200,
        'status': 'success',
      };

      final log = SyncLog.fromJson(json);
      expect(log.errorMessage, isNull);
      expect(log.startedAt, isNull);
      expect(log.completedAt, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncConflict Model
  // ═══════════════════════════════════════════════════════════

  group('SyncConflict model', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'conflict-001',
        'store_id': 'store-001',
        'table_name': 'products',
        'record_id': 'prod-001',
        'local_data': {'name': 'Local Product', 'price': 10.0},
        'cloud_data': {'name': 'Cloud Product', 'price': 12.0},
        'resolution': null,
        'resolved_by': null,
        'detected_at': '2024-06-01T10:00:00.000Z',
        'resolved_at': null,
      };

      final conflict = SyncConflict.fromJson(json);
      expect(conflict.id, 'conflict-001');
      expect(conflict.storeId, 'store-001');
      expect(conflict.tableName, 'products');
      expect(conflict.recordId, 'prod-001');
      expect(conflict.localData, isA<Map<String, dynamic>>());
      expect(conflict.localData['name'], 'Local Product');
      expect(conflict.cloudData['price'], 12.0);
      expect(conflict.resolution, isNull);
      expect(conflict.resolvedBy, isNull);
      expect(conflict.detectedAt, isNotNull);
      expect(conflict.resolvedAt, isNull);
    });

    test('fromJson with resolved conflict', () {
      final json = {
        'id': 'conflict-002',
        'store_id': 'store-001',
        'table_name': 'orders',
        'record_id': 'order-001',
        'local_data': {'status': 'pending'},
        'cloud_data': {'status': 'completed'},
        'resolution': 'cloud_wins',
        'resolved_by': 'user-001',
        'detected_at': '2024-06-01T10:00:00.000Z',
        'resolved_at': '2024-06-01T10:05:00.000Z',
      };

      final conflict = SyncConflict.fromJson(json);
      expect(conflict.resolution, SyncConflictResolution.cloudWins);
      expect(conflict.resolvedBy, 'user-001');
      expect(conflict.resolvedAt, isNotNull);
    });

    test('toJson round-trip preserves data', () {
      final conflict = SyncConflict(
        id: 'conflict-003',
        storeId: 'store-003',
        tableName: 'categories',
        recordId: 'cat-003',
        localData: {'name': 'Local Cat'},
        cloudData: {'name': 'Cloud Cat'},
        resolution: SyncConflictResolution.localWins,
        resolvedBy: 'user-003',
        detectedAt: DateTime.parse('2024-06-01T10:00:00.000Z'),
        resolvedAt: DateTime.parse('2024-06-01T10:10:00.000Z'),
      );

      final json = conflict.toJson();
      final restored = SyncConflict.fromJson(json);
      expect(restored.id, conflict.id);
      expect(restored.tableName, conflict.tableName);
      expect(restored.recordId, conflict.recordId);
      expect(restored.resolution, conflict.resolution);
      expect(restored.resolvedBy, conflict.resolvedBy);
    });

    test('fromJson handles null local_data and cloud_data', () {
      final json = {
        'id': 'conflict-004',
        'store_id': 'store-004',
        'table_name': 'products',
        'record_id': 'prod-004',
        'local_data': null,
        'cloud_data': null,
        'detected_at': '2024-06-01T10:00:00.000Z',
      };

      final conflict = SyncConflict.fromJson(json);
      expect(conflict.localData, isEmpty);
      expect(conflict.cloudData, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncStatusState
  // ═══════════════════════════════════════════════════════════

  group('SyncStatusState', () {
    test('initial state', () {
      const state = SyncStatusInitial();
      expect(state, isA<SyncStatusState>());
    });

    test('loading state', () {
      const state = SyncStatusLoading();
      expect(state, isA<SyncStatusState>());
    });

    test('loaded state holds data', () {
      const state = SyncStatusLoaded(
        serverOnline: true,
        serverTimestamp: '2024-06-01T10:00:00Z',
        lastSync: {'synced_at': '2024-06-01T09:50:00Z', 'direction': 'push'},
        pendingConflicts: 3,
        failedSyncs24h: 1,
        recentLogs: [
          {'id': 'log-1', 'direction': 'push', 'status': 'success'},
        ],
      );
      expect(state, isA<SyncStatusState>());
      expect(state.serverOnline, isTrue);
      expect(state.pendingConflicts, 3);
      expect(state.failedSyncs24h, 1);
      expect(state.recentLogs, hasLength(1));
    });

    test('error state holds message', () {
      const state = SyncStatusError('Network error');
      expect(state, isA<SyncStatusState>());
      expect(state.message, 'Network error');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncOperationState
  // ═══════════════════════════════════════════════════════════

  group('SyncOperationState', () {
    test('idle state', () {
      const state = SyncOperationIdle();
      expect(state, isA<SyncOperationState>());
    });

    test('running state with operation name', () {
      const state = SyncOperationRunning('push');
      expect(state, isA<SyncOperationState>());
      expect(state.operation, 'push');
    });

    test('success state with records count', () {
      const state = SyncOperationSuccess(recordsSynced: 25, syncToken: 'token-abc-123');
      expect(state, isA<SyncOperationState>());
      expect(state.recordsSynced, 25);
      expect(state.syncToken, 'token-abc-123');
    });

    test('error state', () {
      const state = SyncOperationError('Sync failed: timeout');
      expect(state, isA<SyncOperationState>());
      expect(state.message, 'Sync failed: timeout');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncConflictListState
  // ═══════════════════════════════════════════════════════════

  group('SyncConflictListState', () {
    test('initial state', () {
      const state = SyncConflictListInitial();
      expect(state, isA<SyncConflictListState>());
    });

    test('loading state', () {
      const state = SyncConflictListLoading();
      expect(state, isA<SyncConflictListState>());
    });

    test('loaded state with conflicts and pagination', () {
      final conflicts = [
        SyncConflict(
          id: 'c1',
          storeId: 's1',
          tableName: 'products',
          recordId: 'p1',
          localData: {'name': 'A'},
          cloudData: {'name': 'B'},
          detectedAt: DateTime.now(),
        ),
      ];
      final state = SyncConflictListLoaded(conflicts: conflicts, currentPage: 1, lastPage: 3, total: 25);
      expect(state, isA<SyncConflictListState>());
      expect(state.conflicts, hasLength(1));
      expect(state.currentPage, 1);
      expect(state.lastPage, 3);
      expect(state.total, 25);
    });

    test('loaded state with empty conflicts', () {
      const state = SyncConflictListLoaded(conflicts: [], currentPage: 1, lastPage: 1, total: 0);
      expect(state.conflicts, isEmpty);
      expect(state.total, 0);
    });

    test('error state', () {
      const state = SyncConflictListError('Failed to load conflicts');
      expect(state, isA<SyncConflictListState>());
      expect(state.message, 'Failed to load conflicts');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Cross-cutting tests
  // ═══════════════════════════════════════════════════════════

  group('Cross-cutting sync tests', () {
    test('SyncLog direction maps correctly to SyncDirection', () {
      for (final direction in SyncDirection.values) {
        final log = SyncLog(
          id: 'log-${direction.value}',
          storeId: 'store-1',
          terminalId: 'term-1',
          direction: direction,
          recordsCount: 0,
          durationMs: 0,
          status: SyncLogStatus.success,
        );
        expect(log.direction, direction);
        final json = log.toJson();
        final restored = SyncLog.fromJson(json);
        expect(restored.direction, direction);
      }
    });

    test('SyncConflict resolution maps correctly', () {
      for (final res in SyncConflictResolution.values) {
        final conflict = SyncConflict(
          id: 'c-${res.value}',
          storeId: 's1',
          tableName: 'test',
          recordId: 'r1',
          localData: {},
          cloudData: {},
          resolution: res,
          detectedAt: DateTime.now(),
        );
        final json = conflict.toJson();
        final restored = SyncConflict.fromJson(json);
        expect(restored.resolution, res);
      }
    });

    test('SyncLog all status values round-trip', () {
      for (final status in SyncLogStatus.values) {
        final log = SyncLog(
          id: 'log-${status.value}',
          storeId: 's1',
          terminalId: 't1',
          direction: SyncDirection.push,
          recordsCount: 0,
          durationMs: 0,
          status: status,
        );
        final json = log.toJson();
        final restored = SyncLog.fromJson(json);
        expect(restored.status, status);
      }
    });
  });
}
