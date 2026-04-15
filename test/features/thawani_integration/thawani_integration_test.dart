import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/thawani_integration/enums/thawani_order_status.dart';
import 'package:wameedpos/features/thawani_integration/enums/thawani_connection_status.dart';
import 'package:wameedpos/features/thawani_integration/enums/sync_status.dart';
import 'package:wameedpos/features/thawani_integration/enums/thawani_delivery_type.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ENUMS
  // ════════════════════════════════════════════════════════

  group('ThawaniOrderStatus', () {
    test('has correct values', () {
      expect(ThawaniOrderStatus.newValue.value, 'new');
      expect(ThawaniOrderStatus.accepted.value, 'accepted');
      expect(ThawaniOrderStatus.preparing.value, 'preparing');
      expect(ThawaniOrderStatus.ready.value, 'ready');
      expect(ThawaniOrderStatus.dispatched.value, 'dispatched');
      expect(ThawaniOrderStatus.completed.value, 'completed');
      expect(ThawaniOrderStatus.rejected.value, 'rejected');
      expect(ThawaniOrderStatus.cancelled.value, 'cancelled');
    });

    test('has 8 values', () {
      expect(ThawaniOrderStatus.values.length, 8);
    });

    test('fromValue works for all values', () {
      for (final s in ThawaniOrderStatus.values) {
        expect(ThawaniOrderStatus.fromValue(s.value), s);
      }
    });

    test('fromValue throws for invalid', () {
      expect(() => ThawaniOrderStatus.fromValue('unknown'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(ThawaniOrderStatus.tryFromValue('invalid'), isNull);
      expect(ThawaniOrderStatus.tryFromValue(null), isNull);
    });
  });

  group('ThawaniConnectionStatus', () {
    test('has correct values', () {
      expect(ThawaniConnectionStatus.connected.value, 'connected');
      expect(ThawaniConnectionStatus.failed.value, 'failed');
      expect(ThawaniConnectionStatus.unknown.value, 'unknown');
    });

    test('has 3 values', () {
      expect(ThawaniConnectionStatus.values.length, 3);
    });

    test('fromValue works for all values', () {
      for (final s in ThawaniConnectionStatus.values) {
        expect(ThawaniConnectionStatus.fromValue(s.value), s);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(ThawaniConnectionStatus.tryFromValue('nope'), isNull);
    });
  });

  group('SyncStatus', () {
    test('has correct values', () {
      expect(SyncStatus.pending.value, 'pending');
      expect(SyncStatus.synced.value, 'synced');
      expect(SyncStatus.failed.value, 'failed');
    });

    test('has 3 values', () {
      expect(SyncStatus.values.length, 3);
    });

    test('fromValue works for all values', () {
      for (final s in SyncStatus.values) {
        expect(SyncStatus.fromValue(s.value), s);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(SyncStatus.tryFromValue('unknown'), isNull);
    });
  });

  group('ThawaniDeliveryType', () {
    test('fromValue works for all values', () {
      for (final t in ThawaniDeliveryType.values) {
        expect(ThawaniDeliveryType.fromValue(t.value), t);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(ThawaniDeliveryType.tryFromValue('drone'), isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE CLASSES
  // ════════════════════════════════════════════════════════

  group('ThawaniStatsState', () {
    test('ThawaniStatsInitial is a ThawaniStatsState', () {
      expect(const ThawaniStatsInitial(), isA<ThawaniStatsState>());
    });

    test('ThawaniStatsLoaded holds data', () {
      const state = ThawaniStatsLoaded(
        isConnected: true,
        thawaniStoreId: 'T-001',
        totalOrders: 50,
        totalProductsMapped: 25,
        totalCategoriesMapped: 8,
        totalSettlements: 10,
        pendingOrders: 3,
        pendingSyncItems: 2,
        syncLogsToday: 12,
        failedSyncsToday: 1,
      );
      expect(state.isConnected, true);
      expect(state.thawaniStoreId, 'T-001');
      expect(state.totalOrders, 50);
      expect(state.totalProductsMapped, 25);
      expect(state.totalCategoriesMapped, 8);
      expect(state.totalSettlements, 10);
      expect(state.pendingOrders, 3);
      expect(state.pendingSyncItems, 2);
      expect(state.syncLogsToday, 12);
      expect(state.failedSyncsToday, 1);
    });

    test('ThawaniStatsError holds message', () {
      const state = ThawaniStatsError('Failed to load stats');
      expect(state.message, 'Failed to load stats');
    });
  });

  group('ThawaniConfigState', () {
    test('ThawaniConfigLoaded holds config', () {
      const state = ThawaniConfigLoaded({'auto_sync_products': true, 'is_connected': false});
      expect(state.config?['auto_sync_products'], true);
      expect(state.config?['is_connected'], false);
    });

    test('ThawaniConfigLoaded allows null config', () {
      const state = ThawaniConfigLoaded(null);
      expect(state.config, isNull);
    });

    test('all states extend ThawaniConfigState', () {
      expect(const ThawaniConfigInitial(), isA<ThawaniConfigState>());
      expect(const ThawaniConfigLoading(), isA<ThawaniConfigState>());
      expect(const ThawaniConfigLoaded(null), isA<ThawaniConfigState>());
      expect(const ThawaniConfigError('err'), isA<ThawaniConfigState>());
    });
  });

  group('ThawaniActionState', () {
    test('ThawaniActionSuccess holds message', () {
      const state = ThawaniActionSuccess('Config saved');
      expect(state.message, 'Config saved');
    });

    test('ThawaniActionError holds message', () {
      const state = ThawaniActionError('Save failed');
      expect(state.message, 'Save failed');
    });

    test('all states extend ThawaniActionState', () {
      expect(const ThawaniActionInitial(), isA<ThawaniActionState>());
      expect(const ThawaniActionLoading(), isA<ThawaniActionState>());
      expect(const ThawaniActionSuccess('ok'), isA<ThawaniActionState>());
      expect(const ThawaniActionError('err'), isA<ThawaniActionState>());
    });
  });
}
