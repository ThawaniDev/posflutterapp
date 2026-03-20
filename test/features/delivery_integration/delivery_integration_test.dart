import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:thawani_pos/features/delivery_integration/enums/menu_sync_status.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_sync_status.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ENUMS
  // ════════════════════════════════════════════════════════

  group('DeliveryConfigPlatform', () {
    test('has correct values', () {
      expect(DeliveryConfigPlatform.hungerstation.value, 'hungerstation');
      expect(DeliveryConfigPlatform.jahez.value, 'jahez');
      expect(DeliveryConfigPlatform.marsool.value, 'marsool');
    });

    test('has 3 values', () {
      expect(DeliveryConfigPlatform.values.length, 3);
    });

    test('fromValue works for all values', () {
      for (final p in DeliveryConfigPlatform.values) {
        expect(DeliveryConfigPlatform.fromValue(p.value), p);
      }
    });

    test('fromValue throws for invalid', () {
      expect(() => DeliveryConfigPlatform.fromValue('talabat'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(DeliveryConfigPlatform.tryFromValue('uber_eats'), isNull);
      expect(DeliveryConfigPlatform.tryFromValue(null), isNull);
    });
  });

  group('MenuSyncStatus', () {
    test('has correct values', () {
      expect(MenuSyncStatus.success.value, 'success');
      expect(MenuSyncStatus.partial.value, 'partial');
      expect(MenuSyncStatus.failed.value, 'failed');
    });

    test('has 3 values', () {
      expect(MenuSyncStatus.values.length, 3);
    });

    test('fromValue works for all values', () {
      for (final s in MenuSyncStatus.values) {
        expect(MenuSyncStatus.fromValue(s.value), s);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(MenuSyncStatus.tryFromValue('pending'), isNull);
    });
  });

  group('DeliverySyncStatus', () {
    test('fromValue works for all values', () {
      for (final s in DeliverySyncStatus.values) {
        expect(DeliverySyncStatus.fromValue(s.value), s);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(DeliverySyncStatus.tryFromValue('unknown'), isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE CLASSES
  // ════════════════════════════════════════════════════════

  group('DeliveryStatsState', () {
    test('DeliveryStatsInitial is a DeliveryStatsState', () {
      expect(const DeliveryStatsInitial(), isA<DeliveryStatsState>());
    });

    test('DeliveryStatsLoaded holds data', () {
      const state = DeliveryStatsLoaded(
        totalPlatforms: 3,
        activePlatforms: 2,
        totalOrders: 100,
        pendingOrders: 5,
        completedOrders: 90,
      );
      expect(state.totalPlatforms, 3);
      expect(state.activePlatforms, 2);
      expect(state.totalOrders, 100);
      expect(state.pendingOrders, 5);
      expect(state.completedOrders, 90);
    });

    test('DeliveryStatsError holds message', () {
      const state = DeliveryStatsError('Connection failed');
      expect(state.message, 'Connection failed');
    });
  });

  group('DeliveryConfigsState', () {
    test('DeliveryConfigsLoaded holds configs', () {
      const state = DeliveryConfigsLoaded([
        {'platform': 'jahez', 'is_enabled': true},
      ]);
      expect(state.configs.length, 1);
      expect(state.configs.first['platform'], 'jahez');
    });

    test('DeliveryConfigsError holds message', () {
      const state = DeliveryConfigsError('Failed');
      expect(state.message, 'Failed');
    });
  });

  group('DeliveryOrdersState', () {
    test('DeliveryOrdersLoaded holds orders', () {
      const state = DeliveryOrdersLoaded([
        {'id': '1', 'status': 'pending'},
      ]);
      expect(state.orders.length, 1);
    });

    test('all states extend DeliveryOrdersState', () {
      expect(const DeliveryOrdersInitial(), isA<DeliveryOrdersState>());
      expect(const DeliveryOrdersLoading(), isA<DeliveryOrdersState>());
      expect(const DeliveryOrdersLoaded([]), isA<DeliveryOrdersState>());
      expect(const DeliveryOrdersError('err'), isA<DeliveryOrdersState>());
    });
  });
}
