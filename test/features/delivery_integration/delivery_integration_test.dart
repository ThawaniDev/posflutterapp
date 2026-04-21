import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_order_status.dart';
import 'package:wameedpos/features/delivery_integration/enums/menu_sync_status.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_sync_status.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_webhook_log.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_status_push_log.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';

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
      expect(() => DeliveryConfigPlatform.fromValue('uber_eats'), throwsA(isA<ArgumentError>()));
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
      expect(() => DeliveryOrderStatus.fromValue('unknown'), throwsA(isA<ArgumentError>()));
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
      const state = DeliveryOrderDetailLoaded({'id': '42', 'status': 'accepted', 'customer_name': 'Test User'});
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

  // ════════════════════════════════════════════════════════
  // MODELS
  // ════════════════════════════════════════════════════════

  group('DeliveryWebhookLog', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'whl-uuid-1',
        'platform': 'jahez',
        'store_id': 'store-uuid-1',
        'event_type': 'order.created',
        'external_order_id': 'EXT-12345',
        'payload': {'order_id': '123', 'total': 50.0},
        'headers': {'X-Signature': 'abc123', 'Content-Type': 'application/json'},
        'signature_valid': true,
        'processed': true,
        'processing_result': 'Order created successfully',
        'error_message': null,
        'ip_address': '192.168.1.100',
        'received_at': '2024-06-20T14:30:00.000Z',
      };

      final log = DeliveryWebhookLog.fromJson(json);
      expect(log.id, 'whl-uuid-1');
      expect(log.platform, 'jahez');
      expect(log.storeId, 'store-uuid-1');
      expect(log.eventType, 'order.created');
      expect(log.externalOrderId, 'EXT-12345');
      expect(log.payload, isNotNull);
      expect(log.payload!['order_id'], '123');
      expect(log.headers, isNotNull);
      expect(log.headers!['X-Signature'], 'abc123');
      expect(log.signatureValid, true);
      expect(log.processed, true);
      expect(log.processingResult, 'Order created successfully');
      expect(log.errorMessage, isNull);
      expect(log.ipAddress, '192.168.1.100');
      expect(log.receivedAt, isNotNull);
      expect(log.receivedAt!.year, 2024);
    });

    test('fromJson handles minimal fields', () {
      final json = {'id': 'whl-uuid-2', 'platform': 'hungerstation', 'event_type': 'order.updated'};

      final log = DeliveryWebhookLog.fromJson(json);
      expect(log.id, 'whl-uuid-2');
      expect(log.platform, 'hungerstation');
      expect(log.eventType, 'order.updated');
      expect(log.storeId, isNull);
      expect(log.externalOrderId, isNull);
      expect(log.payload, isNull);
      expect(log.headers, isNull);
      expect(log.signatureValid, isNull);
      expect(log.processed, false);
      expect(log.processingResult, isNull);
      expect(log.errorMessage, isNull);
      expect(log.ipAddress, isNull);
      expect(log.receivedAt, isNull);
    });

    test('toJson produces correct map', () {
      const log = DeliveryWebhookLog(
        id: 'whl-uuid-1',
        platform: 'marsool',
        eventType: 'order.cancelled',
        externalOrderId: 'EXT-999',
        processed: true,
        ipAddress: '10.0.0.1',
      );

      final json = log.toJson();
      expect(json['id'], 'whl-uuid-1');
      expect(json['platform'], 'marsool');
      expect(json['event_type'], 'order.cancelled');
      expect(json['external_order_id'], 'EXT-999');
      expect(json['processed'], true);
      expect(json['ip_address'], '10.0.0.1');
      expect(json['store_id'], isNull);
      expect(json['payload'], isNull);
    });

    test('fromJson → toJson round-trip', () {
      final original = {
        'id': 'whl-round',
        'platform': 'keeta',
        'store_id': 'store-1',
        'event_type': 'order.ready',
        'external_order_id': 'EXT-RT',
        'payload': {'status': 'ready'},
        'headers': {'Authorization': 'Bearer token'},
        'signature_valid': true,
        'processed': true,
        'processing_result': 'OK',
        'error_message': null,
        'ip_address': '127.0.0.1',
        'received_at': '2024-06-20T14:30:00.000Z',
      };

      final log = DeliveryWebhookLog.fromJson(original);
      final result = log.toJson();

      expect(result['id'], original['id']);
      expect(result['platform'], original['platform']);
      expect(result['event_type'], original['event_type']);
      expect(result['processed'], original['processed']);
      expect(result['signature_valid'], original['signature_valid']);
    });

    test('fromJson with error message', () {
      final json = {
        'id': 'whl-err',
        'platform': 'talabat',
        'event_type': 'order.created',
        'processed': false,
        'error_message': 'Invalid signature',
        'signature_valid': false,
      };

      final log = DeliveryWebhookLog.fromJson(json);
      expect(log.processed, false);
      expect(log.errorMessage, 'Invalid signature');
      expect(log.signatureValid, false);
    });
  });

  group('DeliveryStatusPushLog', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'spl-uuid-1',
        'delivery_order_mapping_id': 'dom-uuid-1',
        'status_pushed': 'accepted',
        'platform': 'jahez',
        'http_status_code': 200,
        'request_payload': {'order_id': '123', 'status': 'accepted'},
        'response_payload': {'success': true, 'message': 'OK'},
        'success': true,
        'attempt_number': 1,
        'error_message': null,
        'pushed_at': '2024-06-20T15:00:00.000Z',
      };

      final log = DeliveryStatusPushLog.fromJson(json);
      expect(log.id, 'spl-uuid-1');
      expect(log.deliveryOrderMappingId, 'dom-uuid-1');
      expect(log.statusPushed, 'accepted');
      expect(log.platform, 'jahez');
      expect(log.httpStatusCode, 200);
      expect(log.requestPayload, isNotNull);
      expect(log.requestPayload!['status'], 'accepted');
      expect(log.responsePayload, isNotNull);
      expect(log.responsePayload!['success'], true);
      expect(log.success, true);
      expect(log.attemptNumber, 1);
      expect(log.errorMessage, isNull);
      expect(log.pushedAt, isNotNull);
      expect(log.pushedAt!.year, 2024);
    });

    test('fromJson handles minimal fields', () {
      final json = {
        'id': 'spl-uuid-2',
        'delivery_order_mapping_id': 'dom-uuid-2',
        'status_pushed': 'preparing',
        'platform': 'hungerstation',
      };

      final log = DeliveryStatusPushLog.fromJson(json);
      expect(log.id, 'spl-uuid-2');
      expect(log.statusPushed, 'preparing');
      expect(log.platform, 'hungerstation');
      expect(log.httpStatusCode, isNull);
      expect(log.requestPayload, isNull);
      expect(log.responsePayload, isNull);
      expect(log.success, false);
      expect(log.attemptNumber, 1);
      expect(log.errorMessage, isNull);
      expect(log.pushedAt, isNull);
    });

    test('toJson produces correct map', () {
      const log = DeliveryStatusPushLog(
        id: 'spl-uuid-1',
        deliveryOrderMappingId: 'dom-uuid-1',
        statusPushed: 'ready',
        platform: 'marsool',
        httpStatusCode: 200,
        success: true,
        attemptNumber: 2,
      );

      final json = log.toJson();
      expect(json['id'], 'spl-uuid-1');
      expect(json['delivery_order_mapping_id'], 'dom-uuid-1');
      expect(json['status_pushed'], 'ready');
      expect(json['platform'], 'marsool');
      expect(json['http_status_code'], 200);
      expect(json['success'], true);
      expect(json['attempt_number'], 2);
      expect(json['request_payload'], isNull);
    });

    test('fromJson → toJson round-trip', () {
      final original = {
        'id': 'spl-round',
        'delivery_order_mapping_id': 'dom-rt',
        'status_pushed': 'dispatched',
        'platform': 'noonFood',
        'http_status_code': 201,
        'request_payload': {'order': '42'},
        'response_payload': {'ack': true},
        'success': true,
        'attempt_number': 3,
        'error_message': null,
        'pushed_at': '2024-06-20T18:00:00.000Z',
      };

      final log = DeliveryStatusPushLog.fromJson(original);
      final result = log.toJson();

      expect(result['id'], original['id']);
      expect(result['platform'], original['platform']);
      expect(result['status_pushed'], original['status_pushed']);
      expect(result['http_status_code'], original['http_status_code']);
      expect(result['success'], original['success']);
      expect(result['attempt_number'], original['attempt_number']);
    });

    test('fromJson with failed push', () {
      final json = {
        'id': 'spl-fail',
        'delivery_order_mapping_id': 'dom-fail',
        'status_pushed': 'delivered',
        'platform': 'toyou',
        'http_status_code': 500,
        'success': false,
        'attempt_number': 3,
        'error_message': 'Internal server error',
      };

      final log = DeliveryStatusPushLog.fromJson(json);
      expect(log.success, false);
      expect(log.httpStatusCode, 500);
      expect(log.attemptNumber, 3);
      expect(log.errorMessage, 'Internal server error');
    });

    test('fromJson handles numeric types correctly', () {
      final json = {
        'id': 'spl-num',
        'delivery_order_mapping_id': 'dom-num',
        'status_pushed': 'accepted',
        'platform': 'carriage',
        'http_status_code': 200.0,
        'attempt_number': 1.0,
      };

      final log = DeliveryStatusPushLog.fromJson(json);
      expect(log.httpStatusCode, 200);
      expect(log.attemptNumber, 1);
    });
  });

  // ════════════════════════════════════════════════════════
  // NEW STATE CLASSES
  // ════════════════════════════════════════════════════════

  group('DeliveryWebhookLogsState', () {
    test('all states extend DeliveryWebhookLogsState', () {
      expect(const DeliveryWebhookLogsInitial(), isA<DeliveryWebhookLogsState>());
      expect(const DeliveryWebhookLogsLoading(), isA<DeliveryWebhookLogsState>());
      expect(const DeliveryWebhookLogsLoaded([], currentPage: 1, lastPage: 1, total: 0), isA<DeliveryWebhookLogsState>());
      expect(const DeliveryWebhookLogsError('err'), isA<DeliveryWebhookLogsState>());
    });

    test('DeliveryWebhookLogsLoaded holds data', () {
      final logs = <Map<String, dynamic>>[
        {'id': 'whl-1', 'platform': 'jahez', 'event_type': 'order.created'},
        {'id': 'whl-2', 'platform': 'marsool', 'event_type': 'order.updated'},
      ];

      final state = DeliveryWebhookLogsLoaded(logs, currentPage: 1, lastPage: 3, total: 50);
      expect(state.logs.length, 2);
      expect(state.currentPage, 1);
      expect(state.lastPage, 3);
      expect(state.total, 50);
    });

    test('DeliveryWebhookLogsError holds message', () {
      const state = DeliveryWebhookLogsError('Network timeout');
      expect(state.message, 'Network timeout');
    });

    test('sealed class exhaustive switch', () {
      const DeliveryWebhookLogsState state = DeliveryWebhookLogsLoading();
      final result = switch (state) {
        DeliveryWebhookLogsInitial() => 'initial',
        DeliveryWebhookLogsLoading() => 'loading',
        DeliveryWebhookLogsLoaded() => 'loaded',
        DeliveryWebhookLogsError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  group('DeliveryStatusPushLogsState', () {
    test('all states extend DeliveryStatusPushLogsState', () {
      expect(const DeliveryStatusPushLogsInitial(), isA<DeliveryStatusPushLogsState>());
      expect(const DeliveryStatusPushLogsLoading(), isA<DeliveryStatusPushLogsState>());
      expect(const DeliveryStatusPushLogsLoaded([], currentPage: 1, lastPage: 1, total: 0), isA<DeliveryStatusPushLogsState>());
      expect(const DeliveryStatusPushLogsError('err'), isA<DeliveryStatusPushLogsState>());
    });

    test('DeliveryStatusPushLogsLoaded holds data', () {
      final logs = <Map<String, dynamic>>[
        {'id': 'spl-1', 'delivery_order_mapping_id': 'dom-1', 'status_pushed': 'accepted', 'platform': 'jahez'},
      ];

      final state = DeliveryStatusPushLogsLoaded(logs, currentPage: 2, lastPage: 5, total: 100);
      expect(state.logs.length, 1);
      expect(state.currentPage, 2);
      expect(state.lastPage, 5);
      expect(state.total, 100);
    });

    test('DeliveryStatusPushLogsError holds message', () {
      const state = DeliveryStatusPushLogsError('Auth expired');
      expect(state.message, 'Auth expired');
    });

    test('sealed class exhaustive switch', () {
      const DeliveryStatusPushLogsState state = DeliveryStatusPushLogsInitial();
      final result = switch (state) {
        DeliveryStatusPushLogsInitial() => 'initial',
        DeliveryStatusPushLogsLoading() => 'loading',
        DeliveryStatusPushLogsLoaded() => 'loaded',
        DeliveryStatusPushLogsError(:final message) => 'error:$message',
      };
      expect(result, 'initial');
    });
  });
}
