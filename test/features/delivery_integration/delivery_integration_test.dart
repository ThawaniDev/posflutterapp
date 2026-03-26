import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_order_status.dart';
import 'package:thawani_pos/features/delivery_integration/enums/menu_sync_status.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_sync_status.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ENUMS
  // ════════════════════════════════════════════════════════

  group('DeliveryConfigPlatform', () {
    test('has 10 values', () {
      expect(DeliveryConfigPlatform.values.length, 10);
    });

    test('has correct string values', () {
      expect(DeliveryConfigPlatform.hungerstation.value, 'hungerstation');
      expect(DeliveryConfigPlatform.jahez.value, 'jahez');
      expect(DeliveryConfigPlatform.marsool.value, 'marsool');
      expect(DeliveryConfigPlatform.keeta.value, 'keeta');
      expect(DeliveryConfigPlatform.noonFood.value, 'noon_food');
      expect(DeliveryConfigPlatform.ninja.value, 'ninja');
      expect(DeliveryConfigPlatform.theChefz.value, 'the_chefz');
      expect(DeliveryConfigPlatform.talabat.value, 'talabat');
      expect(DeliveryConfigPlatform.toyou.value, 'toyou');
      expect(DeliveryConfigPlatform.carriage.value, 'carriage');
    });

    test('each value has a non-empty label', () {
      for (final p in DeliveryConfigPlatform.values) {
        expect(p.label, isNotEmpty);
      }
    });

    test('each value has a color', () {
      for (final p in DeliveryConfigPlatform.values) {
        expect(p.color, isA<Color>());
      }
    });

    test('each value has an icon', () {
      for (final p in DeliveryConfigPlatform.values) {
        expect(p.icon, isA<IconData>());
      }
    });

    test('fromValue works for all values', () {
      for (final p in DeliveryConfigPlatform.values) {
        expect(DeliveryConfigPlatform.fromValue(p.value), p);
      }
    });

    test('fromValue throws for invalid', () {
      expect(
        () => DeliveryConfigPlatform.fromValue('uber_eats'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('tryFromValue returns null for invalid', () {
      expect(DeliveryConfigPlatform.tryFromValue('uber_eats'), isNull);
      expect(DeliveryConfigPlatform.tryFromValue(null), isNull);
    });
  });

  group('DeliveryOrderStatus', () {
    test('has 9 values', () {
      expect(DeliveryOrderStatus.values.length, 9);
    });

    test('has correct string values', () {
      expect(DeliveryOrderStatus.pending.value, 'pending');
      expect(DeliveryOrderStatus.accepted.value, 'accepted');
      expect(DeliveryOrderStatus.preparing.value, 'preparing');
      expect(DeliveryOrderStatus.ready.value, 'ready');
      expect(DeliveryOrderStatus.dispatched.value, 'dispatched');
      expect(DeliveryOrderStatus.delivered.value, 'delivered');
      expect(DeliveryOrderStatus.rejected.value, 'rejected');
      expect(DeliveryOrderStatus.cancelled.value, 'cancelled');
      expect(DeliveryOrderStatus.failed.value, 'failed');
    });

    test('each value has a non-empty label', () {
      for (final s in DeliveryOrderStatus.values) {
        expect(s.label, isNotEmpty);
      }
    });

    test('each value has a color', () {
      for (final s in DeliveryOrderStatus.values) {
        expect(s.color, isA<Color>());
      }
    });

    test('each value has an icon', () {
      for (final s in DeliveryOrderStatus.values) {
        expect(s.icon, isA<IconData>());
      }
    });

    test('terminal statuses are correct', () {
      expect(DeliveryOrderStatus.delivered.isTerminal, isTrue);
      expect(DeliveryOrderStatus.rejected.isTerminal, isTrue);
      expect(DeliveryOrderStatus.cancelled.isTerminal, isTrue);
      expect(DeliveryOrderStatus.failed.isTerminal, isTrue);
      expect(DeliveryOrderStatus.pending.isTerminal, isFalse);
      expect(DeliveryOrderStatus.accepted.isTerminal, isFalse);
      expect(DeliveryOrderStatus.preparing.isTerminal, isFalse);
    });

    test('actionable statuses are correct', () {
      expect(DeliveryOrderStatus.pending.isActionable, isTrue);
      expect(DeliveryOrderStatus.accepted.isActionable, isTrue);
      expect(DeliveryOrderStatus.preparing.isActionable, isTrue);
      expect(DeliveryOrderStatus.ready.isActionable, isTrue);
      expect(DeliveryOrderStatus.delivered.isActionable, isFalse);
      expect(DeliveryOrderStatus.rejected.isActionable, isFalse);
    });

    test('pending has correct transitions', () {
      final transitions = DeliveryOrderStatus.pending.allowedTransitions;
      expect(transitions, contains(DeliveryOrderStatus.accepted));
      expect(transitions, contains(DeliveryOrderStatus.rejected));
    });

    test('terminal statuses have no transitions', () {
      expect(DeliveryOrderStatus.delivered.allowedTransitions, isEmpty);
      expect(DeliveryOrderStatus.rejected.allowedTransitions, isEmpty);
      expect(DeliveryOrderStatus.cancelled.allowedTransitions, isEmpty);
      expect(DeliveryOrderStatus.failed.allowedTransitions, isEmpty);
    });

    test('fromValue works for all values', () {
      for (final s in DeliveryOrderStatus.values) {
        expect(DeliveryOrderStatus.fromValue(s.value), s);
      }
    });

    test('fromValue throws for invalid', () {
      expect(
        () => DeliveryOrderStatus.fromValue('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('tryFromValue returns null for invalid', () {
      expect(DeliveryOrderStatus.tryFromValue('unknown'), isNull);
      expect(DeliveryOrderStatus.tryFromValue(null), isNull);
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

    test('DeliveryStatsLoading is a DeliveryStatsState', () {
      expect(const DeliveryStatsLoading(), isA<DeliveryStatsState>());
    });

    test('DeliveryStatsLoaded holds all data fields', () {
      const state = DeliveryStatsLoaded(
        totalPlatforms: 3,
        activePlatforms: 2,
        totalOrders: 100,
        pendingOrders: 5,
        completedOrders: 90,
        todayOrders: 12,
        todayRevenue: 450.50,
        activeOrders: 3,
        rejectedOrders: 2,
        platformBreakdown: [
          {'platform': 'jahez', 'count': 50},
          {'platform': 'hungerstation', 'count': 50},
        ],
      );
      expect(state.totalPlatforms, 3);
      expect(state.activePlatforms, 2);
      expect(state.totalOrders, 100);
      expect(state.pendingOrders, 5);
      expect(state.completedOrders, 90);
      expect(state.todayOrders, 12);
      expect(state.todayRevenue, 450.50);
      expect(state.activeOrders, 3);
      expect(state.rejectedOrders, 2);
      expect(state.platformBreakdown.length, 2);
    });

    test('DeliveryStatsLoaded defaults for optional fields', () {
      const state = DeliveryStatsLoaded(
        totalPlatforms: 1,
        activePlatforms: 1,
        totalOrders: 0,
        pendingOrders: 0,
        completedOrders: 0,
      );
      expect(state.todayOrders, 0);
      expect(state.todayRevenue, 0.0);
      expect(state.activeOrders, 0);
      expect(state.rejectedOrders, 0);
      expect(state.platformBreakdown, isEmpty);
    });

    test('DeliveryStatsError holds message', () {
      const state = DeliveryStatsError('Connection failed');
      expect(state.message, 'Connection failed');
    });
  });

  group('DeliveryConfigsState', () {
    test('all states extend DeliveryConfigsState', () {
      expect(const DeliveryConfigsInitial(), isA<DeliveryConfigsState>());
      expect(const DeliveryConfigsLoading(), isA<DeliveryConfigsState>());
      expect(const DeliveryConfigsLoaded([]), isA<DeliveryConfigsState>());
      expect(const DeliveryConfigsError('err'), isA<DeliveryConfigsState>());
    });

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
    test('all states extend DeliveryOrdersState', () {
      expect(const DeliveryOrdersInitial(), isA<DeliveryOrdersState>());
      expect(const DeliveryOrdersLoading(), isA<DeliveryOrdersState>());
      expect(const DeliveryOrdersLoaded([]), isA<DeliveryOrdersState>());
      expect(const DeliveryOrdersError('err'), isA<DeliveryOrdersState>());
    });

    test('DeliveryOrdersLoaded holds orders', () {
      const state = DeliveryOrdersLoaded([
        {'id': '1', 'status': 'pending'},
      ]);
      expect(state.orders.length, 1);
    });
  });

  group('DeliveryOrderDetailState', () {
    test('all states extend DeliveryOrderDetailState', () {
      expect(const DeliveryOrderDetailInitial(), isA<DeliveryOrderDetailState>());
      expect(const DeliveryOrderDetailLoading(), isA<DeliveryOrderDetailState>());
      expect(const DeliveryOrderDetailLoaded({}), isA<DeliveryOrderDetailState>());
      expect(const DeliveryOrderDetailError('err'), isA<DeliveryOrderDetailState>());
    });

    test('DeliveryOrderDetailLoaded holds order data', () {
      const state = DeliveryOrderDetailLoaded({
        'id': '42',
        'status': 'accepted',
        'customer_name': 'Test User',
      });
      expect(state.order['id'], '42');
      expect(state.order['status'], 'accepted');
      expect(state.order['customer_name'], 'Test User');
    });
  });

  group('DeliveryPlatformsState', () {
    test('all states extend DeliveryPlatformsState', () {
      expect(const DeliveryPlatformsInitial(), isA<DeliveryPlatformsState>());
      expect(const DeliveryPlatformsLoading(), isA<DeliveryPlatformsState>());
      expect(const DeliveryPlatformsLoaded([]), isA<DeliveryPlatformsState>());
      expect(const DeliveryPlatformsError('err'), isA<DeliveryPlatformsState>());
    });

    test('DeliveryPlatformsLoaded holds platforms', () {
      const state = DeliveryPlatformsLoaded([
        {'slug': 'jahez', 'name': 'Jahez'},
        {'slug': 'hungerstation', 'name': 'HungerStation'},
      ]);
      expect(state.platforms.length, 2);
    });
  });

  group('DeliveryConnectionTestState', () {
    test('all states extend DeliveryConnectionTestState', () {
      expect(const DeliveryConnectionTestIdle(), isA<DeliveryConnectionTestState>());
      expect(const DeliveryConnectionTestLoading(), isA<DeliveryConnectionTestState>());
      expect(const DeliveryConnectionTestSuccess('OK'), isA<DeliveryConnectionTestState>());
      expect(const DeliveryConnectionTestFailure('Fail'), isA<DeliveryConnectionTestState>());
    });

    test('Success holds message', () {
      const state = DeliveryConnectionTestSuccess('Connected successfully');
      expect(state.message, 'Connected successfully');
    });

    test('Failure holds message', () {
      const state = DeliveryConnectionTestFailure('Auth failed');
      expect(state.message, 'Auth failed');
    });
  });

  group('DeliveryMenuSyncState', () {
    test('all states extend DeliveryMenuSyncState', () {
      expect(const DeliveryMenuSyncIdle(), isA<DeliveryMenuSyncState>());
      expect(const DeliveryMenuSyncLoading(), isA<DeliveryMenuSyncState>());
      expect(const DeliveryMenuSyncSuccess('Synced'), isA<DeliveryMenuSyncState>());
      expect(const DeliveryMenuSyncError('err'), isA<DeliveryMenuSyncState>());
    });

    test('Success holds message', () {
      const state = DeliveryMenuSyncSuccess('25 products synced successfully');
      expect(state.message, '25 products synced successfully');
    });

    test('Error holds message', () {
      const state = DeliveryMenuSyncError('Sync timed out');
      expect(state.message, 'Sync timed out');
    });
  });
}
