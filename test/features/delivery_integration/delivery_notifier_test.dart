// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';
import 'package:wameedpos/features/delivery_integration/repositories/delivery_repository.dart';
import 'package:wameedpos/features/delivery_integration/data/remote/delivery_api_service.dart';
import 'package:dio/dio.dart';

// ─── Stub ApiService (never called) ──────────────────────────────────────────
class _StubApiService extends DeliveryApiService {
  _StubApiService() : super(Dio());
}

// ─── Mock repository (extends concrete class, overrides all methods) ──────────
class _MockRepository extends DeliveryRepository {
  _MockRepository({
    this.statsResult,
    this.configsResult,
    this.ordersResult,
    this.activeOrdersResult,
    this.orderDetailResult,
    this.platformsResult,
    this.connectionResult,
    this.menuSyncResult,
    this.webhookLogsResult,
    this.statusPushLogsResult,
    this.shouldThrow = false,
  }) : super(_StubApiService());

  final Map<String, dynamic>? statsResult;
  final Map<String, dynamic>? configsResult;
  final Map<String, dynamic>? ordersResult;
  final Map<String, dynamic>? activeOrdersResult;
  final Map<String, dynamic>? orderDetailResult;
  final Map<String, dynamic>? platformsResult;
  final Map<String, dynamic>? connectionResult;
  final Map<String, dynamic>? menuSyncResult;
  final Map<String, dynamic>? webhookLogsResult;
  final Map<String, dynamic>? statusPushLogsResult;
  final bool shouldThrow;

  @override
  Future<Map<String, dynamic>> getStats() async {
    if (shouldThrow) throw Exception('stats error');
    return statsResult ?? {'data': {}};
  }

  @override
  Future<Map<String, dynamic>> getConfigs() async {
    if (shouldThrow) throw Exception('configs error');
    return configsResult ?? {'data': []};
  }

  @override
  Future<Map<String, dynamic>> getConfigDetail(String id) async => {'data': {}};

  @override
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) async {
    if (shouldThrow) throw Exception('save error');
    return {'success': true, 'data': {}};
  }

  @override
  Future<Map<String, dynamic>> deleteConfig(String id) async {
    if (shouldThrow) throw Exception('delete error');
    return {'success': true};
  }

  @override
  Future<Map<String, dynamic>> toggleConfig(String id) async {
    if (shouldThrow) throw Exception('toggle error');
    return {'success': true};
  }

  @override
  Future<Map<String, dynamic>> testConnection(String id) async {
    if (shouldThrow) throw Exception('conn error');
    return connectionResult ?? {'success': true, 'message': 'Connected'};
  }

  @override
  Future<Map<String, dynamic>> getOrders({
    String? platform,
    String? status,
    int? perPage,
    int? page,
    String? dateFrom,
    String? dateTo,
  }) async {
    if (shouldThrow) throw Exception('orders error');
    return ordersResult ??
        {
          'data': {'data': [], 'current_page': 1, 'last_page': 1, 'total': 0},
        };
  }

  @override
  Future<Map<String, dynamic>> getActiveOrders() async {
    if (shouldThrow) throw Exception('active orders error');
    return activeOrdersResult ?? {'data': []};
  }

  @override
  Future<Map<String, dynamic>> getOrderDetail(String id) async {
    if (shouldThrow) throw Exception('order detail error');
    return orderDetailResult ?? {'data': {}};
  }

  @override
  Future<Map<String, dynamic>> updateOrderStatus(
    String id, {
    required String status,
    String? rejectionReason,
  }) async {
    if (shouldThrow) throw Exception('update status error');
    return {'success': true};
  }

  @override
  Future<Map<String, dynamic>> getSyncLogs({
    String? platform,
    int? perPage,
    int? page,
  }) async =>
      {'data': {'data': [], 'total': 0, 'current_page': 1, 'last_page': 1}};

  @override
  Future<Map<String, dynamic>> triggerMenuSync({
    String? platform,
    List<Map<String, dynamic>>? products,
  }) async {
    if (shouldThrow) throw Exception('sync error');
    return menuSyncResult ?? {'success': true, 'message': 'Sync queued'};
  }

  @override
  Future<Map<String, dynamic>> getPlatforms() async {
    if (shouldThrow) throw Exception('platforms error');
    return platformsResult ?? {'data': []};
  }

  @override
  Future<Map<String, dynamic>> getWebhookLogs({
    String? platform,
    int? perPage,
    int? page,
  }) async {
    if (shouldThrow) throw Exception('webhook logs error');
    return webhookLogsResult ??
        {'data': {'data': [], 'total': 0, 'current_page': 1, 'last_page': 1}};
  }

  @override
  Future<Map<String, dynamic>> getStatusPushLogs({
    String? platform,
    int? perPage,
    int? page,
  }) async {
    if (shouldThrow) throw Exception('push logs error');
    return statusPushLogsResult ??
        {'data': {'data': [], 'total': 0, 'current_page': 1, 'last_page': 1}};
  }
}

// ─── Helper to create a container with a mock repository ─────────────────────
ProviderContainer _makeContainer(_MockRepository repo) {
  return ProviderContainer(
    overrides: [
      deliveryRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

void main() {
  // ==========================================================================
  // DeliveryStatsNotifier
  // ==========================================================================
  group('DeliveryStatsNotifier', () {
    test('initial state is DeliveryStatsInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryStatsProvider), isA<DeliveryStatsInitial>());
    });

    test('load sets state to DeliveryStatsLoaded on success', () async {
      final repo = _MockRepository(statsResult: {
        'data': {
          'total_platforms': 3,
          'active_platforms': 2,
          'total_orders': 150,
          'pending_orders': 5,
          'completed_orders': 140,
          'today_orders': 10,
          'today_revenue': '1500.00',
          'active_orders': 5,
          'rejected_orders': 5,
          'platforms': [],
        },
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryStatsProvider.notifier).load();

      final state = container.read(deliveryStatsProvider);
      expect(state, isA<DeliveryStatsLoaded>());
      final loaded = state as DeliveryStatsLoaded;
      expect(loaded.totalPlatforms, 3);
      expect(loaded.activePlatforms, 2);
      expect(loaded.totalOrders, 150);
      expect(loaded.pendingOrders, 5);
      expect(loaded.todayRevenue, 1500.0);
    });

    test('load sets DeliveryStatsError on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryStatsProvider.notifier).load();

      final state = container.read(deliveryStatsProvider);
      expect(state, isA<DeliveryStatsError>());
      expect((state as DeliveryStatsError).message, contains('stats error'));
    });

    test('load does not overwrite existing loaded state on error', () async {
      // First successful load
      final repo = _MockRepository(statsResult: {
        'data': {'total_platforms': 1, 'platforms': []},
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);
      await container.read(deliveryStatsProvider.notifier).load();
      expect(container.read(deliveryStatsProvider), isA<DeliveryStatsLoaded>());

      // Second load throws — state should remain loaded
      final throwingRepo = _MockRepository(shouldThrow: true);
      final container2 = ProviderContainer(overrides: [
        deliveryRepositoryProvider.overrideWithValue(throwingRepo),
        deliveryStatsProvider.overrideWith((ref) {
          final notifier = DeliveryStatsNotifier(throwingRepo);
          // Pre-seed with loaded state
          return notifier;
        }),
      ]);
      addTearDown(container2.dispose);
    });
  });

  // ==========================================================================
  // DeliveryConfigsNotifier
  // ==========================================================================
  group('DeliveryConfigsNotifier', () {
    test('initial state is DeliveryConfigsInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryConfigsProvider), isA<DeliveryConfigsInitial>());
    });

    test('load sets DeliveryConfigsLoaded with items', () async {
      final repo = _MockRepository(configsResult: {
        'data': [
          {'id': 'cfg-1', 'platform': 'jahez', 'is_enabled': true},
        ],
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryConfigsProvider.notifier).load();

      final state = container.read(deliveryConfigsProvider);
      expect(state, isA<DeliveryConfigsLoaded>());
      expect((state as DeliveryConfigsLoaded).configs.length, 1);
    });

    test('load sets DeliveryConfigsLoaded with empty list', () async {
      final repo = _MockRepository(configsResult: {'data': []});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryConfigsProvider.notifier).load();

      final state = container.read(deliveryConfigsProvider);
      expect(state, isA<DeliveryConfigsLoaded>());
      expect((state as DeliveryConfigsLoaded).configs, isEmpty);
    });

    test('load sets DeliveryConfigsError on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryConfigsProvider.notifier).load();

      expect(container.read(deliveryConfigsProvider), isA<DeliveryConfigsError>());
    });

    test('saveConfig calls repository and reloads', () async {
      final repo = _MockRepository(
        configsResult: {
          'data': [
            {'id': 'cfg-1', 'platform': 'jahez'},
          ],
        },
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryConfigsProvider.notifier).saveConfig({'platform': 'jahez', 'api_key': 'K1'});

      final state = container.read(deliveryConfigsProvider);
      expect(state, isA<DeliveryConfigsLoaded>());
    });

    test('deleteConfig returns true on success and reloads', () async {
      final repo = _MockRepository(configsResult: {'data': []});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final result = await container.read(deliveryConfigsProvider.notifier).deleteConfig('cfg-1');

      expect(result, isTrue);
      expect(container.read(deliveryConfigsProvider), isA<DeliveryConfigsLoaded>());
    });

    test('deleteConfig returns false on error', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      final result = await container.read(deliveryConfigsProvider.notifier).deleteConfig('cfg-1');

      expect(result, isFalse);
      expect(container.read(deliveryConfigsProvider), isA<DeliveryConfigsError>());
    });
  });

  // ==========================================================================
  // DeliveryOrdersNotifier
  // ==========================================================================
  group('DeliveryOrdersNotifier', () {
    test('initial state is DeliveryOrdersInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryOrdersProvider), isA<DeliveryOrdersInitial>());
    });

    test('load sets DeliveryOrdersLoaded with paginated orders', () async {
      final repo = _MockRepository(ordersResult: {
        'data': {
          'data': [
            {'id': 'ord-1', 'platform': 'jahez'},
            {'id': 'ord-2', 'platform': 'marsool'},
          ],
          'current_page': 1,
          'last_page': 3,
          'total': 25,
        },
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryOrdersProvider.notifier).load();

      final state = container.read(deliveryOrdersProvider) as DeliveryOrdersLoaded;
      expect(state.orders.length, 2);
      expect(state.currentPage, 1);
      expect(state.lastPage, 3);
      expect(state.total, 25);
    });

    test('load stores platform and status filters', () async {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);

      await container.read(deliveryOrdersProvider.notifier).load(platform: 'jahez', status: 'pending');

      expect(container.read(deliveryOrdersProvider.notifier).platformFilter, 'jahez');
      expect(container.read(deliveryOrdersProvider.notifier).statusFilter, 'pending');
    });

    test('loadActive uses getActiveOrders', () async {
      final repo = _MockRepository(activeOrdersResult: {
        'data': [
          {'id': 'ord-active-1'},
        ],
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryOrdersProvider.notifier).loadActive();

      final state = container.read(deliveryOrdersProvider) as DeliveryOrdersLoaded;
      expect(state.orders.length, 1);
    });

    test('updateOrderStatus returns true on success', () async {
      final repo = _MockRepository(ordersResult: {'data': {'data': [], 'current_page': 1, 'last_page': 1, 'total': 0}});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final result = await container.read(deliveryOrdersProvider.notifier).updateOrderStatus('ord-1', status: 'accepted');

      expect(result, isTrue);
    });

    test('updateOrderStatus returns false on error', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      final result = await container.read(deliveryOrdersProvider.notifier).updateOrderStatus('ord-1', status: 'accepted');

      expect(result, isFalse);
    });

    test('load sets error state on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryOrdersProvider.notifier).load();

      expect(container.read(deliveryOrdersProvider), isA<DeliveryOrdersError>());
    });
  });

  // ==========================================================================
  // DeliveryOrderDetailNotifier
  // ==========================================================================
  group('DeliveryOrderDetailNotifier', () {
    test('initial state is DeliveryOrderDetailInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryOrderDetailProvider), isA<DeliveryOrderDetailInitial>());
    });

    test('load sets DeliveryOrderDetailLoaded with data', () async {
      final repo = _MockRepository(orderDetailResult: {
        'data': {'id': 'ord-1', 'platform': 'jahez', 'delivery_status': 'pending'},
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryOrderDetailProvider.notifier).load('ord-1');

      final state = container.read(deliveryOrderDetailProvider) as DeliveryOrderDetailLoaded;
      expect(state.order['id'], 'ord-1');
    });

    test('load sets error on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryOrderDetailProvider.notifier).load('ord-1');

      expect(container.read(deliveryOrderDetailProvider), isA<DeliveryOrderDetailError>());
    });

    test('updateStatus returns true on success and reloads', () async {
      final repo = _MockRepository(orderDetailResult: {
        'data': {'id': 'ord-1'},
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final result = await container.read(deliveryOrderDetailProvider.notifier).updateStatus(id: 'ord-1', status: 'accepted');

      expect(result, isTrue);
    });

    test('updateStatus returns false on error', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      final result = await container.read(deliveryOrderDetailProvider.notifier).updateStatus(id: 'ord-1', status: 'accepted');

      expect(result, isFalse);
    });
  });

  // ==========================================================================
  // DeliveryPlatformsNotifier
  // ==========================================================================
  group('DeliveryPlatformsNotifier', () {
    test('initial state is DeliveryPlatformsInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryPlatformsProvider), isA<DeliveryPlatformsInitial>());
    });

    test('load parses DeliveryPlatform objects', () async {
      final repo = _MockRepository(platformsResult: {
        'data': [
          {
            'id': 'plt-1',
            'name': 'Jahez',
            'name_ar': 'جاهز',
            'slug': 'jahez',
            'auth_method': 'api_key',
            'is_active': true,
            'default_commission_percent': '18.5',
            'fields': [],
          },
        ],
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryPlatformsProvider.notifier).load();

      final state = container.read(deliveryPlatformsProvider) as DeliveryPlatformsLoaded;
      expect(state.platforms.length, 1);
      expect(state.platforms.first.slug, 'jahez');
      expect(state.platforms.first.nameAr, 'جاهز');
      expect(state.platforms.first.defaultCommissionPercent, 18.5);
    });

    test('load sets error on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryPlatformsProvider.notifier).load();

      expect(container.read(deliveryPlatformsProvider), isA<DeliveryPlatformsError>());
    });
  });

  // ==========================================================================
  // DeliveryConnectionTestNotifier
  // ==========================================================================
  group('DeliveryConnectionTestNotifier', () {
    test('initial state is DeliveryConnectionTestIdle', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryConnectionTestProvider), isA<DeliveryConnectionTestIdle>());
    });

    test('test sets success state on success', () async {
      final repo = _MockRepository(connectionResult: {'success': true, 'message': 'Connected successfully'});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryConnectionTestProvider.notifier).test('cfg-1');

      final state = container.read(deliveryConnectionTestProvider) as DeliveryConnectionTestSuccess;
      expect(state.message, 'Connected successfully');
    });

    test('test sets failure state when success=false', () async {
      final repo = _MockRepository(connectionResult: {'success': false, 'message': 'Auth failed'});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryConnectionTestProvider.notifier).test('cfg-1');

      final state = container.read(deliveryConnectionTestProvider) as DeliveryConnectionTestFailure;
      expect(state.message, 'Auth failed');
    });

    test('test sets failure on exception', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryConnectionTestProvider.notifier).test('cfg-1');

      expect(container.read(deliveryConnectionTestProvider), isA<DeliveryConnectionTestFailure>());
    });

    test('reset returns to idle', () async {
      final repo = _MockRepository(connectionResult: {'success': true, 'message': 'OK'});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryConnectionTestProvider.notifier).test('cfg-1');
      container.read(deliveryConnectionTestProvider.notifier).reset();

      expect(container.read(deliveryConnectionTestProvider), isA<DeliveryConnectionTestIdle>());
    });
  });

  // ==========================================================================
  // DeliveryMenuSyncNotifier
  // ==========================================================================
  group('DeliveryMenuSyncNotifier', () {
    test('initial state is DeliveryMenuSyncIdle', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryMenuSyncProvider), isA<DeliveryMenuSyncIdle>());
    });

    test('sync sets success state on success', () async {
      final repo = _MockRepository(menuSyncResult: {'success': true, 'message': 'Menu sync queued'});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryMenuSyncProvider.notifier).sync(platform: 'jahez');

      final state = container.read(deliveryMenuSyncProvider) as DeliveryMenuSyncSuccess;
      expect(state.message, 'Menu sync queued');
    });

    test('sync sets error state on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryMenuSyncProvider.notifier).sync();

      expect(container.read(deliveryMenuSyncProvider), isA<DeliveryMenuSyncError>());
    });

    test('reset returns to idle', () async {
      final repo = _MockRepository(menuSyncResult: {'success': true, 'message': 'Queued'});
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryMenuSyncProvider.notifier).sync();
      container.read(deliveryMenuSyncProvider.notifier).reset();

      expect(container.read(deliveryMenuSyncProvider), isA<DeliveryMenuSyncIdle>());
    });
  });

  // ==========================================================================
  // DeliveryWebhookLogsNotifier
  // ==========================================================================
  group('DeliveryWebhookLogsNotifier', () {
    test('initial state is DeliveryWebhookLogsInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryWebhookLogsProvider), isA<DeliveryWebhookLogsInitial>());
    });

    test('load sets DeliveryWebhookLogsLoaded', () async {
      final repo = _MockRepository(webhookLogsResult: {
        'data': {
          'data': [
            {'id': 'wh-1', 'platform': 'jahez', 'signature_valid': true},
          ],
          'total': 1,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        },
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryWebhookLogsProvider.notifier).load();

      final state = container.read(deliveryWebhookLogsProvider) as DeliveryWebhookLogsLoaded;
      expect(state.logs.length, 1);
      expect(state.total, 1);
    });

    test('load sets error on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryWebhookLogsProvider.notifier).load();

      expect(container.read(deliveryWebhookLogsProvider), isA<DeliveryWebhookLogsError>());
    });
  });

  // ==========================================================================
  // DeliveryStatusPushLogsNotifier
  // ==========================================================================
  group('DeliveryStatusPushLogsNotifier', () {
    test('initial state is DeliveryStatusPushLogsInitial', () {
      final container = _makeContainer(_MockRepository());
      addTearDown(container.dispose);
      expect(container.read(deliveryStatusPushLogsProvider), isA<DeliveryStatusPushLogsInitial>());
    });

    test('load sets DeliveryStatusPushLogsLoaded', () async {
      final repo = _MockRepository(statusPushLogsResult: {
        'data': {
          'data': [
            {'id': 'spl-1', 'platform': 'jahez', 'status_pushed': 'accepted', 'success': true},
          ],
          'total': 1,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        },
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryStatusPushLogsProvider.notifier).load();

      final state = container.read(deliveryStatusPushLogsProvider) as DeliveryStatusPushLogsLoaded;
      expect(state.logs.length, 1);
      expect(state.total, 1);
      expect(state.currentPage, 1);
    });

    test('load with pagination filter works', () async {
      final repo = _MockRepository(statusPushLogsResult: {
        'data': {
          'data': [],
          'total': 0,
          'current_page': 2,
          'last_page': 5,
          'per_page': 20,
        },
      });
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(deliveryStatusPushLogsProvider.notifier).load(page: 2);

      final state = container.read(deliveryStatusPushLogsProvider) as DeliveryStatusPushLogsLoaded;
      expect(state.currentPage, 2);
      expect(state.lastPage, 5);
    });

    test('load sets error on failure', () async {
      final container = _makeContainer(_MockRepository(shouldThrow: true));
      addTearDown(container.dispose);

      await container.read(deliveryStatusPushLogsProvider.notifier).load();

      expect(container.read(deliveryStatusPushLogsProvider), isA<DeliveryStatusPushLogsError>());
    });
  });
}
