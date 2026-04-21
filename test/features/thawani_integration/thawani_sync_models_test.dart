import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/thawani_integration/models/thawani_category_mapping.dart';
import 'package:wameedpos/features/thawani_integration/models/thawani_column_mapping.dart';
import 'package:wameedpos/features/thawani_integration/models/thawani_sync_log.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // MODEL: ThawaniCategoryMapping
  // ════════════════════════════════════════════════════════

  group('ThawaniCategoryMapping', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 42,
        'store_id': 7,
        'category_id': 'uuid-cat-1',
        'thawani_category_id': 99,
        'sync_status': 'synced',
        'sync_direction': 'push',
        'sync_error': null,
        'last_synced_at': '2025-01-15T10:30:00.000Z',
        'category': {'name': 'Food', 'name_ar': 'طعام'},
      };

      final mapping = ThawaniCategoryMapping.fromJson(json);

      expect(mapping.id, '42');
      expect(mapping.storeId, '7');
      expect(mapping.categoryId, 'uuid-cat-1');
      expect(mapping.thawaniCategoryId, '99');
      expect(mapping.syncStatus, 'synced');
      expect(mapping.syncDirection, 'push');
      expect(mapping.syncError, isNull);
      expect(mapping.lastSyncedAt, isA<DateTime>());
      expect(mapping.category?['name'], 'Food');
    });

    test('fromJson handles missing optional fields', () {
      final json = {'id': 1, 'store_id': 2};

      final mapping = ThawaniCategoryMapping.fromJson(json);

      expect(mapping.id, '1');
      expect(mapping.storeId, '2');
      expect(mapping.categoryId, isNull);
      expect(mapping.thawaniCategoryId, isNull);
      expect(mapping.syncStatus, isNull);
      expect(mapping.syncDirection, isNull);
      expect(mapping.syncError, isNull);
      expect(mapping.lastSyncedAt, isNull);
      expect(mapping.category, isNull);
    });

    test('fromJson handles null id and store_id gracefully', () {
      final json = <String, dynamic>{};
      final mapping = ThawaniCategoryMapping.fromJson(json);
      expect(mapping.id, '');
      expect(mapping.storeId, '');
    });

    test('toJson produces correct output', () {
      final mapping = ThawaniCategoryMapping(
        id: '10',
        storeId: '5',
        categoryId: 'c-1',
        thawaniCategoryId: '55',
        syncStatus: 'pending',
        syncDirection: 'pull',
        syncError: 'timeout',
        lastSyncedAt: DateTime.utc(2025, 6, 1, 12, 0),
      );

      final json = mapping.toJson();

      expect(json['id'], '10');
      expect(json['store_id'], '5');
      expect(json['category_id'], 'c-1');
      expect(json['thawani_category_id'], '55');
      expect(json['sync_status'], 'pending');
      expect(json['sync_direction'], 'pull');
      expect(json['sync_error'], 'timeout');
      expect(json['last_synced_at'], '2025-06-01T12:00:00.000Z');
    });

    test('toJson round-trips correctly', () {
      const original = ThawaniCategoryMapping(
        id: '1',
        storeId: '2',
        categoryId: 'c-3',
        thawaniCategoryId: '4',
        syncStatus: 'synced',
        syncDirection: 'push',
      );

      final roundTripped = ThawaniCategoryMapping.fromJson(original.toJson());

      expect(roundTripped.id, original.id);
      expect(roundTripped.storeId, original.storeId);
      expect(roundTripped.categoryId, original.categoryId);
      expect(roundTripped.thawaniCategoryId, original.thawaniCategoryId);
      expect(roundTripped.syncStatus, original.syncStatus);
    });
  });

  // ════════════════════════════════════════════════════════
  // MODEL: ThawaniSyncLog
  // ════════════════════════════════════════════════════════

  group('ThawaniSyncLog', () {
    test('fromJson parses complete data', () {
      final json = {
        'id': 100,
        'store_id': 'store-uuid',
        'entity_type': 'product',
        'entity_id': 'prod-1',
        'action': 'create',
        'direction': 'push',
        'status': 'success',
        'request_data': {'name': 'Test'},
        'response_data': {'synced': 1},
        'error_message': null,
        'http_status_code': 200,
        'completed_at': '2025-01-15T10:30:00.000Z',
        'created_at': '2025-01-15T10:29:00.000Z',
      };

      final log = ThawaniSyncLog.fromJson(json);

      expect(log.id, '100');
      expect(log.storeId, 'store-uuid');
      expect(log.entityType, 'product');
      expect(log.entityId, 'prod-1');
      expect(log.action, 'create');
      expect(log.direction, 'push');
      expect(log.status, 'success');
      expect(log.requestData?['name'], 'Test');
      expect(log.responseData?['synced'], 1);
      expect(log.errorMessage, isNull);
      expect(log.httpStatusCode, 200);
      expect(log.completedAt, isA<DateTime>());
      expect(log.createdAt, isA<DateTime>());
    });

    test('fromJson handles minimal data', () {
      final json = {
        'id': 1,
        'store_id': 's1',
        'entity_type': 'category',
        'action': 'sync',
        'direction': 'pull',
        'status': 'failed',
        'created_at': '2025-06-01T00:00:00.000Z',
      };

      final log = ThawaniSyncLog.fromJson(json);

      expect(log.entityId, isNull);
      expect(log.requestData, isNull);
      expect(log.responseData, isNull);
      expect(log.errorMessage, isNull);
      expect(log.httpStatusCode, isNull);
      expect(log.completedAt, isNull);
    });

    test('isSuccess returns true for success status', () {
      final log = ThawaniSyncLog.fromJson({
        'id': 1,
        'store_id': 's',
        'entity_type': 'product',
        'action': 'push',
        'direction': 'outgoing',
        'status': 'success',
        'created_at': '2025-01-01T00:00:00Z',
      });
      expect(log.isSuccess, true);
      expect(log.isFailed, false);
    });

    test('isFailed returns true for failed status', () {
      final log = ThawaniSyncLog.fromJson({
        'id': 2,
        'store_id': 's',
        'entity_type': 'category',
        'action': 'pull',
        'direction': 'incoming',
        'status': 'failed',
        'created_at': '2025-01-01T00:00:00Z',
      });
      expect(log.isFailed, true);
      expect(log.isSuccess, false);
    });

    test('isSuccess and isFailed both false for pending', () {
      final log = ThawaniSyncLog.fromJson({
        'id': 3,
        'store_id': 's',
        'entity_type': 'store',
        'action': 'connect',
        'direction': 'incoming',
        'status': 'pending',
        'created_at': '2025-01-01T00:00:00Z',
      });
      expect(log.isSuccess, false);
      expect(log.isFailed, false);
    });
  });

  // ════════════════════════════════════════════════════════
  // MODEL: ThawaniColumnMapping
  // ════════════════════════════════════════════════════════

  group('ThawaniColumnMapping', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 5,
        'entity_type': 'product',
        'thawani_field': 'price',
        'wameed_field': 'sell_price',
        'transform_type': 'direct',
        'transform_config': {'multiplier': 1.0},
        'is_active': true,
      };

      final mapping = ThawaniColumnMapping.fromJson(json);

      expect(mapping.id, '5');
      expect(mapping.entityType, 'product');
      expect(mapping.thawaniField, 'price');
      expect(mapping.wameedField, 'sell_price');
      expect(mapping.transformType, 'direct');
      expect(mapping.transformConfig?['multiplier'], 1.0);
      expect(mapping.isActive, true);
    });

    test('fromJson defaults for missing fields', () {
      final json = <String, dynamic>{};
      final mapping = ThawaniColumnMapping.fromJson(json);

      expect(mapping.id, '');
      expect(mapping.entityType, '');
      expect(mapping.thawaniField, '');
      expect(mapping.wameedField, '');
      expect(mapping.transformType, 'direct');
      expect(mapping.transformConfig, isNull);
      expect(mapping.isActive, true);
    });

    test('fromJson handles false is_active', () {
      final json = {
        'id': 1,
        'entity_type': 'category',
        'thawani_field': 'name',
        'wameed_field': 'title',
        'transform_type': 'map',
        'is_active': false,
      };

      final mapping = ThawaniColumnMapping.fromJson(json);
      expect(mapping.isActive, false);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE: ThawaniStatsState (new fields)
  // ════════════════════════════════════════════════════════

  group('ThawaniStatsState (extended)', () {
    test('ThawaniStatsLoaded includes new sync fields', () {
      const state = ThawaniStatsLoaded(
        isConnected: true,
        thawaniStoreId: 'T-42',
        totalOrders: 100,
        totalProductsMapped: 50,
        totalCategoriesMapped: 10,
        totalSettlements: 20,
        pendingOrders: 5,
        pendingSyncItems: 3,
        syncLogsToday: 15,
        failedSyncsToday: 2,
      );

      expect(state.totalCategoriesMapped, 10);
      expect(state.pendingSyncItems, 3);
      expect(state.syncLogsToday, 15);
      expect(state.failedSyncsToday, 2);
    });

    test('ThawaniStatsLoaded disconnected state', () {
      const state = ThawaniStatsLoaded(
        isConnected: false,
        totalOrders: 0,
        totalProductsMapped: 0,
        totalCategoriesMapped: 0,
        totalSettlements: 0,
        pendingOrders: 0,
        pendingSyncItems: 0,
        syncLogsToday: 0,
        failedSyncsToday: 0,
      );

      expect(state.isConnected, false);
      expect(state.thawaniStoreId, isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE: ThawaniSyncState
  // ════════════════════════════════════════════════════════

  group('ThawaniSyncState', () {
    test('ThawaniSyncInitial is a ThawaniSyncState', () {
      expect(const ThawaniSyncInitial(), isA<ThawaniSyncState>());
    });

    test('ThawaniSyncLoading holds operation name', () {
      const state = ThawaniSyncLoading('pushProducts');
      expect(state.operation, 'pushProducts');
    });

    test('ThawaniSyncSuccess holds message and optional data', () {
      const state = ThawaniSyncSuccess('Synced 5 products', data: {'synced': 5, 'failed': 0});
      expect(state.message, 'Synced 5 products');
      expect(state.data?['synced'], 5);
    });

    test('ThawaniSyncSuccess works without data', () {
      const state = ThawaniSyncSuccess('Connected');
      expect(state.data, isNull);
    });

    test('ThawaniSyncError holds error message', () {
      const state = ThawaniSyncError('Connection refused');
      expect(state.message, 'Connection refused');
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE: ThawaniCategoryMappingsState
  // ════════════════════════════════════════════════════════

  group('ThawaniCategoryMappingsState', () {
    test('all subclasses are ThawaniCategoryMappingsState', () {
      expect(const ThawaniCategoryMappingsInitial(), isA<ThawaniCategoryMappingsState>());
      expect(const ThawaniCategoryMappingsLoading(), isA<ThawaniCategoryMappingsState>());
      expect(const ThawaniCategoryMappingsLoaded([]), isA<ThawaniCategoryMappingsState>());
      expect(const ThawaniCategoryMappingsError('err'), isA<ThawaniCategoryMappingsState>());
    });

    test('ThawaniCategoryMappingsLoaded holds list', () {
      const state = ThawaniCategoryMappingsLoaded([
        {'id': 1, 'name': 'Food'},
        {'id': 2, 'name': 'Drinks'},
      ]);
      expect(state.mappings.length, 2);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE: ThawaniSyncLogsState
  // ════════════════════════════════════════════════════════

  group('ThawaniSyncLogsState', () {
    test('all subclasses are ThawaniSyncLogsState', () {
      expect(const ThawaniSyncLogsInitial(), isA<ThawaniSyncLogsState>());
      expect(const ThawaniSyncLogsLoading(), isA<ThawaniSyncLogsState>());
      expect(const ThawaniSyncLogsLoaded([]), isA<ThawaniSyncLogsState>());
      expect(const ThawaniSyncLogsError('fail'), isA<ThawaniSyncLogsState>());
    });

    test('ThawaniSyncLogsLoaded holds logs and optional pagination', () {
      const state = ThawaniSyncLogsLoaded(
        [
          {'id': 1},
        ],
        pagination: {'current_page': 1, 'last_page': 3},
      );

      expect(state.logs.length, 1);
      expect(state.pagination?['last_page'], 3);
    });

    test('ThawaniSyncLogsLoaded pagination defaults to null', () {
      const state = ThawaniSyncLogsLoaded([]);
      expect(state.pagination, isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE: ThawaniQueueStatsState
  // ════════════════════════════════════════════════════════

  group('ThawaniQueueStatsState', () {
    test('all subclasses are ThawaniQueueStatsState', () {
      expect(const ThawaniQueueStatsInitial(), isA<ThawaniQueueStatsState>());
      expect(const ThawaniQueueStatsLoading(), isA<ThawaniQueueStatsState>());
      expect(const ThawaniQueueStatsLoaded(pending: 0, processing: 0, completed: 0, failed: 0), isA<ThawaniQueueStatsState>());
      expect(const ThawaniQueueStatsError('err'), isA<ThawaniQueueStatsState>());
    });

    test('ThawaniQueueStatsLoaded holds all counters', () {
      const state = ThawaniQueueStatsLoaded(pending: 10, processing: 2, completed: 50, failed: 3);

      expect(state.pending, 10);
      expect(state.processing, 2);
      expect(state.completed, 50);
      expect(state.failed, 3);
    });
  });
}
