import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:wameedpos/features/delivery_integration/data/remote/delivery_api_service.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_order_status.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_menu_sync_log.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_order_mapping.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_platform_config.dart';
import 'package:wameedpos/features/delivery_integration/repositories/delivery_repository.dart';

class _MockAdapter implements HttpClientAdapter {
  _MockAdapter(this.handler);
  final Future<ResponseBody> Function(RequestOptions options) handler;
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream, Future<void>? cancelFuture) {
    return handler(options);
  }
}

Dio _makeDio(Future<ResponseBody> Function(RequestOptions) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test', responseType: ResponseType.json, contentType: 'application/json'));
  dio.httpClientAdapter = _MockAdapter(handler);
  return dio;
}

ResponseBody _json(String body, [int status = 200]) {
  return ResponseBody.fromString(
    body,
    status,
    headers: {Headers.contentTypeHeader: ['application/json']},
  );
}

void main() {
  // ════════════════════════════════════════════════════
  // MODEL JSON ROUND-TRIPS (extends existing coverage)
  // ════════════════════════════════════════════════════
  group('DeliveryOrderMapping JSON', () {
    test('parses full payload with commission and timestamps', () {
      final json = {
        'id': 'ord-1',
        'order_id': 'pos-1',
        'store_id': 'store-1',
        'platform': 'jahez',
        'external_order_id': 'JZ-100',
        'delivery_status': 'accepted',
        'customer_name': 'Ali',
        'customer_phone': '966500000000',
        'delivery_address': 'Riyadh',
        'subtotal': '100.00',
        'delivery_fee': '15.50',
        'total_amount': '115.50',
        'items_count': 3,
        'commission_amount': '21.37',
        'commission_percent': '18.50',
        'accepted_at': '2026-01-01T10:00:00Z',
        'created_at': '2026-01-01T09:55:00Z',
      };
      final m = DeliveryOrderMapping.fromJson(json);
      expect(m.id, 'ord-1');
      expect(m.platform, DeliveryConfigPlatform.jahez);
      expect(m.deliveryStatus, DeliveryOrderStatus.accepted);
      expect(m.subtotal, 100.00);
      expect(m.totalAmount, 115.50);
      expect(m.commissionAmount, 21.37);
      expect(m.commissionPercent, 18.50);
      expect(m.itemsCount, 3);
      expect(m.acceptedAt, isNotNull);
    });

    test('handles missing optional fields gracefully', () {
      final m = DeliveryOrderMapping.fromJson({
        'id': 'x',
        'order_id': 'y',
        'platform': 'marsool',
        'external_order_id': 'M-1',
      });
      expect(m.platform, DeliveryConfigPlatform.marsool);
      expect(m.deliveryStatus, isNull);
      expect(m.commissionAmount, isNull);
      expect(m.acceptedAt, isNull);
    });
  });

  group('DeliveryPlatformConfig JSON', () {
    test('parses full config payload', () {
      final c = DeliveryPlatformConfig.fromJson({
        'id': 'cfg-1',
        'store_id': 'store-1',
        'platform': 'hungerstation',
        'api_key': 'KEY',
        'merchant_id': 'M-100',
        'is_enabled': true,
        'auto_accept': true,
        'max_daily_orders': 200,
        'daily_order_count': 7,
        'sync_menu_on_product_change': true,
        'menu_sync_interval_hours': 6,
        'status': 'active',
      });
      expect(c.platform, DeliveryConfigPlatform.hungerstation);
      expect(c.isEnabled, isTrue);
      expect(c.autoAccept, isTrue);
      expect(c.maxDailyOrders, 200);
      expect(c.dailyOrderCount, 7);
      expect(c.menuSyncIntervalHours, 6);
      expect(c.status, 'active');
    });

    test('defaults sensibly when fields missing', () {
      final c = DeliveryPlatformConfig.fromJson({
        'id': 'cfg-2',
        'store_id': 'store-1',
        'platform': 'jahez',
      });
      expect(c.apiKey, '');
      expect(c.isEnabled, isFalse);
      expect(c.autoAccept, isFalse);
      expect(c.dailyOrderCount, 0);
      expect(c.status, 'pending');
    });
  });

  group('DeliveryMenuSyncLog JSON', () {
    test('parses minimal sync log', () {
      final log = DeliveryMenuSyncLog.fromJson({
        'id': 'log-1',
        'store_id': 'store-1',
        'platform': 'jahez',
        'status': 'success',
        'items_synced': 25,
        'items_failed': 2,
        'triggered_by': 'manual',
        'sync_type': 'full',
      });
      expect(log.id, 'log-1');
      expect(log.itemsSynced, 25);
      expect(log.itemsFailed, 2);
    });
  });

  // ════════════════════════════════════════════════════
  // API ENDPOINTS — verify URLs and methods
  // ════════════════════════════════════════════════════
  group('DeliveryApiService endpoint contracts', () {
    test('getStats hits /delivery/stats', () async {
      String? hitPath;
      String? hitMethod;
      final dio = _makeDio((opts) async {
        hitPath = opts.path;
        hitMethod = opts.method;
        return _json('{"success":true,"data":{}}');
      });
      await DeliveryApiService(dio).getStats();
      expect(hitPath, '/delivery/stats');
      expect(hitMethod, 'GET');
    });

    test('saveConfig POSTs to /delivery/configs with body', () async {
      String? hitPath;
      String? hitMethod;
      Object? hitBody;
      final dio = _makeDio((opts) async {
        hitPath = opts.path;
        hitMethod = opts.method;
        hitBody = opts.data;
        return _json('{"success":true,"data":{}}');
      });
      await DeliveryApiService(dio).saveConfig({'platform': 'jahez', 'is_enabled': true});
      expect(hitPath, '/delivery/configs');
      expect(hitMethod, 'POST');
      expect(hitBody, isA<Map>());
      expect((hitBody! as Map)['platform'], 'jahez');
    });

    test('toggleConfig PUTs to /delivery/configs/{id}/toggle', () async {
      String? hitPath;
      String? hitMethod;
      final dio = _makeDio((opts) async {
        hitPath = opts.path;
        hitMethod = opts.method;
        return _json('{"success":true,"data":{}}');
      });
      await DeliveryApiService(dio).toggleConfig('abc-123');
      expect(hitPath, '/delivery/configs/abc-123/toggle');
      expect(hitMethod, 'PUT');
    });

    test('testConnection POSTs to /delivery/configs/{id}/test-connection', () async {
      String? hitPath;
      String? hitMethod;
      final dio = _makeDio((opts) async {
        hitPath = opts.path;
        hitMethod = opts.method;
        return _json('{"success":true,"data":{"success":true}}');
      });
      await DeliveryApiService(dio).testConnection('cfg-1');
      expect(hitPath, '/delivery/configs/cfg-1/test-connection');
      expect(hitMethod, 'POST');
    });

    test('getOrders sends filters as query params', () async {
      Map<String, dynamic>? params;
      final dio = _makeDio((opts) async {
        params = opts.queryParameters;
        return _json('{"success":true,"data":{"data":[]}}');
      });
      await DeliveryApiService(dio).getOrders(
        platform: 'jahez',
        status: 'accepted',
        perPage: 25,
        page: 2,
        dateFrom: '2026-01-01',
        dateTo: '2026-01-31',
      );
      expect(params, isNotNull);
      expect(params!['platform'], 'jahez');
      expect(params!['status'], 'accepted');
      expect(params!['per_page'], 25);
      expect(params!['page'], 2);
      expect(params!['date_from'], '2026-01-01');
      expect(params!['date_to'], '2026-01-31');
    });

    test('updateOrderStatus PUTs status payload', () async {
      String? hitPath;
      String? hitMethod;
      Object? hitBody;
      final dio = _makeDio((opts) async {
        hitPath = opts.path;
        hitMethod = opts.method;
        hitBody = opts.data;
        return _json('{"success":true,"data":{}}');
      });
      await DeliveryApiService(dio).updateOrderStatus('ord-1', status: 'rejected', rejectionReason: 'closed');
      expect(hitPath, '/delivery/orders/ord-1/status');
      expect(hitMethod, 'PUT');
      expect((hitBody! as Map)['status'], 'rejected');
      expect((hitBody! as Map)['rejection_reason'], 'closed');
    });

    test('triggerMenuSync POSTs products list', () async {
      Object? hitBody;
      final dio = _makeDio((opts) async {
        hitBody = opts.data;
        return _json('{"success":true,"data":null}');
      });
      await DeliveryApiService(dio).triggerMenuSync(
        platform: 'jahez',
        products: [
          {'id': 'p-1', 'name': 'Pizza', 'price': 25.0},
        ],
      );
      final body = hitBody! as Map;
      expect(body['platform'], 'jahez');
      expect((body['products'] as List).length, 1);
    });
  });

  // ════════════════════════════════════════════════════
  // REPOSITORY — verifies thin pass-through
  // ════════════════════════════════════════════════════
  group('DeliveryRepository forwards to API service', () {
    test('getStats / getConfigs / getPlatforms reach correct endpoints', () async {
      final hits = <String>[];
      final dio = _makeDio((opts) async {
        hits.add(opts.path);
        return _json('{"success":true,"data":{}}');
      });
      final repo = DeliveryRepository(DeliveryApiService(dio));
      await repo.getStats();
      await repo.getConfigs();
      await repo.getPlatforms();
      await repo.getActiveOrders();
      await repo.getWebhookLogs();
      await repo.getStatusPushLogs();
      await repo.getSyncLogs();

      expect(hits, [
        '/delivery/stats',
        '/delivery/configs',
        '/delivery/platforms',
        '/delivery/orders/active',
        '/delivery/webhook-logs',
        '/delivery/status-push-logs',
        '/delivery/sync-logs',
      ]);
    });

    test('deleteConfig sends DELETE', () async {
      String? method;
      String? path;
      final dio = _makeDio((opts) async {
        method = opts.method;
        path = opts.path;
        return _json('{"success":true}');
      });
      await DeliveryRepository(DeliveryApiService(dio)).deleteConfig('cfg-9');
      expect(method, 'DELETE');
      expect(path, '/delivery/configs/cfg-9');
    });
  });

  // ════════════════════════════════════════════════════
  // ORDER STATUS TRANSITIONS
  // ════════════════════════════════════════════════════
  group('DeliveryOrderStatus business rules', () {
    test('terminal statuses cannot transition further', () {
      for (final s in [DeliveryOrderStatus.delivered, DeliveryOrderStatus.cancelled, DeliveryOrderStatus.rejected]) {
        expect(s.isTerminal, isTrue);
      }
    });

    test('pending → accepted/rejected only', () {
      final transitions = DeliveryOrderStatus.pending.allowedTransitions;
      expect(transitions.contains(DeliveryOrderStatus.accepted), isTrue);
      expect(transitions.contains(DeliveryOrderStatus.rejected), isTrue);
      expect(transitions.contains(DeliveryOrderStatus.delivered), isFalse);
    });
  });
}
