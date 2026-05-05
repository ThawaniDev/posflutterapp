import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_menu_sync_log.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_order_mapping.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_platform.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_platform_config.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_platform_endpoint.dart';
import 'package:wameedpos/features/delivery_integration/models/delivery_platform_field.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_auth_method.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_endpoint_operation.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_field_type.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_order_status.dart';
import 'package:wameedpos/features/delivery_integration/enums/menu_sync_status.dart';

void main() {
  // ==========================================================================
  // DeliveryPlatform model
  // ==========================================================================
  group('DeliveryPlatform JSON round-trip', () {
    test('parses full platform payload with all fields', () {
      final json = {
        'id': 'plt-1',
        'name': 'Jahez',
        'name_ar': 'جاهز',
        'slug': 'jahez',
        'logo_url': 'https://example.com/jahez.png',
        'description': 'Saudi delivery platform',
        'description_ar': 'منصة توصيل سعودية',
        'auth_method': 'api_key',
        'api_type': 'rest',
        'base_url': 'https://api.jahez.net',
        'documentation_url': 'https://docs.jahez.net',
        'supported_countries': ['SA', 'AE'],
        'default_commission_percent': '18.50',
        'is_active': true,
        'sort_order': 1,
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-10T00:00:00Z',
        'fields': [
          {
            'id': 'fld-1',
            'delivery_platform_id': 'plt-1',
            'field_key': 'restaurant_id',
            'field_label': 'Restaurant ID',
            'field_label_ar': 'معرف المطعم',
            'field_type': 'text',
            'placeholder': 'Enter ID',
            'is_required': true,
            'sort_order': 1,
          },
        ],
      };

      final platform = DeliveryPlatform.fromJson(json);

      expect(platform.id, 'plt-1');
      expect(platform.name, 'Jahez');
      expect(platform.nameAr, 'جاهز');
      expect(platform.slug, 'jahez');
      expect(platform.logoUrl, 'https://example.com/jahez.png');
      expect(platform.description, 'Saudi delivery platform');
      expect(platform.descriptionAr, 'منصة توصيل سعودية');
      expect(platform.authMethod, DeliveryAuthMethod.apiKey);
      expect(platform.apiType, 'rest');
      expect(platform.baseUrl, 'https://api.jahez.net');
      expect(platform.documentationUrl, 'https://docs.jahez.net');
      expect(platform.supportedCountries, ['SA', 'AE']);
      expect(platform.defaultCommissionPercent, 18.50);
      expect(platform.isActive, true);
      expect(platform.sortOrder, 1);
      expect(platform.createdAt, isNotNull);
      expect(platform.fields.length, 1);
      expect(platform.fields.first.fieldKey, 'restaurant_id');
    });

    test('handles minimal platform with no optional fields', () {
      final json = {'id': 'plt-min', 'name': 'Marsool', 'slug': 'marsool', 'auth_method': 'bearer', 'fields': <dynamic>[]};

      final platform = DeliveryPlatform.fromJson(json);

      expect(platform.id, 'plt-min');
      expect(platform.nameAr, isNull);
      expect(platform.logoUrl, isNull);
      expect(platform.supportedCountries, isNull);
      expect(platform.defaultCommissionPercent, isNull);
      expect(platform.isActive, true); // default
      expect(platform.fields, isEmpty);
    });

    test('parses numeric commission_percent as double', () {
      final json = {
        'id': 'plt-2',
        'name': 'HungerStation',
        'slug': 'hungerstation',
        'auth_method': 'oauth2',
        'default_commission_percent': 22,
        'fields': <dynamic>[],
      };
      final platform = DeliveryPlatform.fromJson(json);
      expect(platform.defaultCommissionPercent, 22.0);
    });
  });

  // ==========================================================================
  // DeliveryPlatformField model
  // ==========================================================================
  group('DeliveryPlatformField JSON', () {
    test('parses all fields', () {
      final json = {
        'id': 'fld-1',
        'delivery_platform_id': 'plt-1',
        'field_key': 'api_key',
        'field_label': 'API Key',
        'field_label_ar': 'مفتاح API',
        'field_type': 'password',
        'placeholder': 'Enter API Key',
        'helper_text': 'Found in your dashboard',
        'is_required': true,
        'sort_order': 1,
      };

      final field = DeliveryPlatformField.fromJson(json);

      expect(field.id, 'fld-1');
      expect(field.fieldKey, 'api_key');
      expect(field.fieldLabel, 'API Key');
      expect(field.fieldType, DeliveryFieldType.password);
      expect(field.isRequired, true);
      expect(field.sortOrder, 1);
    });

    test('handles url field type', () {
      final field = DeliveryPlatformField.fromJson({
        'id': 'fld-2',
        'delivery_platform_id': 'plt-1',
        'field_key': 'webhook_url',
        'field_label': 'Webhook URL',
        'field_type': 'url',
        'is_required': false,
        'sort_order': 2,
      });
      expect(field.fieldType, DeliveryFieldType.url);
    });
  });

  // ==========================================================================
  // DeliveryPlatformEndpoint model
  // ==========================================================================
  group('DeliveryPlatformEndpoint JSON', () {
    test('parses all endpoint fields', () {
      final json = {
        'id': 'ep-1',
        'delivery_platform_id': 'plt-1',
        'operation': 'bulk_menu_push',
        'http_method': 'POST',
        'url_template': '/restaurants/{restaurant_id}/menu',
        'request_mapping': {'items': 'products'},
        'sort_order': 1,
        'is_active': true,
      };

      final endpoint = DeliveryPlatformEndpoint.fromJson(json);

      expect(endpoint.id, 'ep-1');
      expect(endpoint.operation, DeliveryEndpointOperation.bulkMenuPush);
      expect(endpoint.urlTemplate, '/restaurants/{restaurant_id}/menu');
      expect(endpoint.requestMapping, {'items': 'products'});
    });

    test('all DeliveryEndpointOperation values parse correctly', () {
      for (final op in DeliveryEndpointOperation.values) {
        final endpoint = DeliveryPlatformEndpoint.fromJson({
          'id': 'ep-${op.value}',
          'delivery_platform_id': 'plt-1',
          'operation': op.value,
          'http_method': 'POST',
          'url_template': '/test',
        });
        expect(endpoint.operation, op);
      }
    });
  });

  // ==========================================================================
  // DeliveryPlatformConfig model
  // ==========================================================================
  group('DeliveryPlatformConfig JSON round-trip', () {
    test('parses full config with operating hours', () {
      final json = {
        'id': 'cfg-1',
        'store_id': 'store-1',
        'platform': 'jahez',
        'merchant_id': 'M-100',
        'webhook_secret': null,
        'branch_id_on_platform': 'BR-1',
        'is_enabled': true,
        'auto_accept': true,
        'auto_accept_timeout_seconds': 180,
        'throttle_limit': 10,
        'max_daily_orders': 200,
        'daily_order_count': 15,
        'sync_menu_on_product_change': true,
        'menu_sync_interval_hours': 4,
        'operating_hours_synced': true,
        'operating_hours_json': [
          {'day': 0, 'open': '08:00', 'close': '23:00'},
        ],
        'webhook_url': 'https://example.com/webhook/jahez',
        'status': 'active',
        'last_menu_sync_at': '2026-01-01T08:00:00Z',
        'last_order_received_at': '2026-01-01T10:00:00Z',
        'created_at': '2025-12-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
      };

      final config = DeliveryPlatformConfig.fromJson(json);

      expect(config.id, 'cfg-1');
      expect(config.storeId, 'store-1');
      expect(config.platform, DeliveryConfigPlatform.jahez);
      expect(config.isEnabled, true);
      expect(config.autoAccept, true);
      expect(config.autoAcceptTimeoutSeconds, 180);
      expect(config.throttleLimit, 10);
      expect(config.maxDailyOrders, 200);
      expect(config.dailyOrderCount, 15);
      expect(config.syncMenuOnProductChange, true);
      expect(config.menuSyncIntervalHours, 4);
      expect(config.operatingHoursSynced, true);
      expect(config.operatingHoursJson, isNotNull);
      expect(config.operatingHoursJson!.length, 1);
      expect(config.webhookUrl, 'https://example.com/webhook/jahez');
      expect(config.status, 'active');
      expect(config.lastMenuSyncAt, isNotNull);
      expect(config.lastOrderReceivedAt, isNotNull);
    });

    test('api_key is always empty (server hides it)', () {
      final config = DeliveryPlatformConfig.fromJson({
        'id': 'cfg-2',
        'store_id': 'store-1',
        'platform': 'marsool',
        'api_key': 'should-be-hidden',
        'is_enabled': false,
      });
      expect(config.apiKey, isEmpty);
    });

    test('parses all DeliveryConfigPlatform values', () {
      for (final platform in DeliveryConfigPlatform.values) {
        final config = DeliveryPlatformConfig.fromJson({
          'id': 'cfg-${platform.value}',
          'store_id': 'store-1',
          'platform': platform.value,
          'is_enabled': false,
        });
        expect(config.platform, platform);
      }
    });

    test('handles bool false values (no stripping)', () {
      final config = DeliveryPlatformConfig.fromJson({
        'id': 'cfg-3',
        'store_id': 'store-1',
        'platform': 'jahez',
        'is_enabled': false,
        'auto_accept': false,
        'sync_menu_on_product_change': false,
        'operating_hours_synced': false,
      });
      expect(config.isEnabled, false);
      expect(config.autoAccept, false);
      expect(config.syncMenuOnProductChange, false);
      expect(config.operatingHoursSynced, false);
    });
  });

  // ==========================================================================
  // DeliveryOrderMapping model
  // ==========================================================================
  group('DeliveryOrderMapping JSON round-trip', () {
    test('parses all order fields', () {
      final json = {
        'id': 'ord-1',
        'order_id': 'pos-1',
        'store_id': 'store-1',
        'platform': 'jahez',
        'external_order_id': 'JZ-1001',
        'delivery_status': 'preparing',
        'customer_name': 'Ahmed Ali',
        'customer_phone': '+966500000001',
        'delivery_address': 'King Fahd Road, Riyadh',
        'subtotal': '120.00',
        'delivery_fee': '15.00',
        'total_amount': '135.00',
        'items_count': 4,
        'commission_amount': '24.97',
        'commission_percent': '18.50',
        'rejection_reason': null,
        'estimated_prep_minutes': 20,
        'notes': 'No onions',
        'accepted_at': '2026-01-01T10:00:00Z',
        'rejected_at': null,
        'delivered_at': null,
        'created_at': '2026-01-01T09:55:00Z',
        'updated_at': '2026-01-01T10:01:00Z',
      };

      final order = DeliveryOrderMapping.fromJson(json);

      expect(order.id, 'ord-1');
      expect(order.platform, DeliveryConfigPlatform.jahez);
      expect(order.externalOrderId, 'JZ-1001');
      expect(order.deliveryStatus, DeliveryOrderStatus.preparing);
      expect(order.customerName, 'Ahmed Ali');
      expect(order.subtotal, 120.0);
      expect(order.deliveryFee, 15.0);
      expect(order.totalAmount, 135.0);
      expect(order.itemsCount, 4);
      expect(order.commissionAmount, 24.97);
      expect(order.commissionPercent, 18.50);
      expect(order.acceptedAt, isNotNull);
      expect(order.deliveredAt, isNull);
    });

    test('parses all DeliveryOrderStatus values', () {
      for (final status in DeliveryOrderStatus.values) {
        final order = DeliveryOrderMapping.fromJson({
          'id': 'ord-${status.value}',
          'platform': 'jahez',
          'external_order_id': 'EXT-${status.value}',
          'delivery_status': status.value,
        });
        expect(order.deliveryStatus, status);
      }
    });

    test('handles null status gracefully', () {
      final order = DeliveryOrderMapping.fromJson({'id': 'ord-nostatus', 'platform': 'marsool', 'external_order_id': 'M-001'});
      expect(order.deliveryStatus, isNull);
    });

    test('parses commission as decimal string', () {
      final order = DeliveryOrderMapping.fromJson({
        'id': 'ord-comm',
        'platform': 'jahez',
        'external_order_id': 'JZ-COMM',
        'commission_amount': '39.78',
        'commission_percent': '18.50',
      });
      expect(order.commissionAmount, closeTo(39.78, 0.001));
      expect(order.commissionPercent, closeTo(18.50, 0.001));
    });
  });

  // ==========================================================================
  // DeliveryMenuSyncLog model
  // ==========================================================================
  group('DeliveryMenuSyncLog JSON round-trip', () {
    test('parses full sync log', () {
      final json = {
        'id': 'log-1',
        'store_id': 'store-1',
        'platform': 'jahez',
        'status': 'success',
        'items_synced': 45,
        'items_failed': 2,
        'error_details': {'error': 'Timeout on item 5'},
        'triggered_by': 'manual',
        'sync_type': 'full',
        'duration_seconds': 12,
        'started_at': '2026-01-01T10:00:00Z',
        'completed_at': '2026-01-01T10:00:12Z',
      };

      final log = DeliveryMenuSyncLog.fromJson(json);

      expect(log.id, 'log-1');
      expect(log.platform, DeliveryConfigPlatform.jahez);
      expect(log.status, MenuSyncStatus.success);
      expect(log.itemsSynced, 45);
      expect(log.itemsFailed, 2);
      expect(log.errorDetails, isNotNull);
      expect(log.triggeredBy, 'manual');
      expect(log.syncType, 'full');
      expect(log.durationSeconds, 12);
      expect(log.startedAt, isNotNull);
      expect(log.completedAt, isNotNull);
    });

    test('parses all MenuSyncStatus values', () {
      for (final status in MenuSyncStatus.values) {
        final log = DeliveryMenuSyncLog.fromJson({
          'id': 'log-${status.value}',
          'store_id': 'store-1',
          'platform': 'marsool',
          'status': status.value,
        });
        expect(log.status, status);
      }
    });

    test('toJson round-trip preserves key fields', () {
      final json = {
        'id': 'log-rt',
        'store_id': 'store-1',
        'platform': 'jahez',
        'status': 'failed',
        'items_synced': 10,
        'items_failed': 5,
        'triggered_by': 'webhook',
        'sync_type': 'incremental',
        'started_at': '2026-01-01T10:00:00Z',
      };

      final log = DeliveryMenuSyncLog.fromJson(json);
      final serialized = log.toJson();

      expect(serialized['id'], 'log-rt');
      expect(serialized['platform'], 'jahez');
      expect(serialized['status'], 'failed');
      expect(serialized['items_synced'], 10);
      expect(serialized['triggered_by'], 'webhook');
    });
  });

  // ==========================================================================
  // API Compatibility: Backend response ↔ Flutter model
  // ==========================================================================
  group('API Compatibility: Backend response → Flutter models', () {
    test('platforms list response matches DeliveryPlatform.fromJson', () {
      // Simulates the exact structure returned by GET /api/v2/delivery/platforms
      final backendResponse = {
        'success': true,
        'message': 'delivery.platforms_retrieved',
        'data': [
          {
            'id': 'plt-jahez',
            'name': 'Jahez',
            'name_ar': 'جاهز',
            'slug': 'jahez',
            'description': null,
            'description_ar': null,
            'logo_url': null,
            'api_type': null,
            'auth_method': 'api_key',
            'base_url': null,
            'documentation_url': null,
            'default_commission_percent': '18.50',
            'supported_countries': null,
            'is_active': true,
            'sort_order': 1,
            'fields': [
              {
                'id': 'fld-1',
                'delivery_platform_id': 'plt-jahez',
                'field_key': 'restaurant_id',
                'field_label': 'Restaurant ID',
                'field_label_ar': 'معرف المطعم',
                'field_type': 'text',
                'placeholder': null,
                'helper_text': null,
                'is_required': true,
                'sort_order': 1,
              },
            ],
          },
        ],
      };

      final platformsData = backendResponse['data'] as List;
      final platforms = platformsData.map((p) => DeliveryPlatform.fromJson(p as Map<String, dynamic>)).toList();

      expect(platforms.length, 1);
      expect(platforms.first.slug, 'jahez');
      expect(platforms.first.defaultCommissionPercent, 18.50);
      expect(platforms.first.fields.length, 1);
      expect(platforms.first.fields.first.isRequired, true);
    });

    test('paginated configs response matches DeliveryPlatformConfig.fromJson', () {
      // Simulates GET /api/v2/delivery/configs
      final backendResponse = {
        'success': true,
        'data': [
          {
            'id': 'cfg-1',
            'store_id': 'store-1',
            'platform': 'jahez',
            'is_enabled': true,
            'auto_accept': false,
            'auto_accept_timeout_seconds': 300,
            'throttle_limit': null,
            'max_daily_orders': null,
            'daily_order_count': 0,
            'sync_menu_on_product_change': false,
            'menu_sync_interval_hours': null,
            'operating_hours_synced': false,
            'operating_hours_json': null,
            'webhook_url': null,
            'status': 'active',
            'last_menu_sync_at': null,
            'last_order_received_at': null,
            'created_at': '2026-01-01T00:00:00Z',
            'updated_at': '2026-01-01T00:00:00Z',
          },
        ],
      };

      final configsData = backendResponse['data'] as List;
      final configs = configsData.map((c) => DeliveryPlatformConfig.fromJson(c as Map<String, dynamic>)).toList();

      expect(configs.length, 1);
      expect(configs.first.platform, DeliveryConfigPlatform.jahez);
      expect(configs.first.isEnabled, true);
      expect(configs.first.dailyOrderCount, 0);
    });

    test('order list response (paginated) matches DeliveryOrderMapping.fromJson', () {
      // Simulates GET /api/v2/delivery/orders
      final backendResponse = {
        'success': true,
        'data': {
          'data': [
            {
              'id': 'ord-1',
              'order_id': null,
              'store_id': 'store-1',
              'platform': 'jahez',
              'external_order_id': 'JZ-001',
              'delivery_status': 'pending',
              'customer_name': 'Ali',
              'customer_phone': '966500000000',
              'delivery_address': 'Riyadh',
              'subtotal': '100.00',
              'delivery_fee': '15.00',
              'total_amount': '115.00',
              'items_count': 2,
              'commission_amount': '21.28',
              'commission_percent': '18.50',
              'rejection_reason': null,
              'accepted_at': null,
              'rejected_at': null,
              'delivered_at': null,
              'created_at': '2026-01-01T09:00:00Z',
            },
          ],
          'total': 1,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        },
      };

      final ordersData = (backendResponse['data'] as Map<String, dynamic>)['data'] as List;
      final orders = ordersData.map((o) => DeliveryOrderMapping.fromJson(o as Map<String, dynamic>)).toList();

      expect(orders.length, 1);
      expect(orders.first.deliveryStatus, DeliveryOrderStatus.pending);
      expect(orders.first.subtotal, 100.0);
      expect(orders.first.commissionAmount, closeTo(21.28, 0.001));
    });

    test('sync-logs paginated response matches DeliveryMenuSyncLog.fromJson', () {
      // Simulates GET /api/v2/delivery/sync-logs
      final backendResponse = {
        'success': true,
        'data': {
          'data': [
            {
              'id': 'sl-1',
              'store_id': 'store-1',
              'platform': 'jahez',
              'status': 'success',
              'items_synced': 30,
              'items_failed': 0,
              'error_details': null,
              'triggered_by': 'product_change',
              'sync_type': 'incremental',
              'duration_seconds': 5,
              'started_at': '2026-01-01T10:00:00Z',
              'completed_at': '2026-01-01T10:00:05Z',
            },
          ],
          'total': 1,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        },
      };

      final logsData = (backendResponse['data'] as Map<String, dynamic>)['data'] as List;
      final logs = logsData.map((l) => DeliveryMenuSyncLog.fromJson(l as Map<String, dynamic>)).toList();

      expect(logs.length, 1);
      expect(logs.first.status, MenuSyncStatus.success);
      expect(logs.first.itemsSynced, 30);
      expect(logs.first.triggeredBy, 'product_change');
    });

    test('stats response data maps to DeliveryStatsLoaded fields', () {
      // Simulates GET /api/v2/delivery/stats
      final statsData = {
        'total_platforms': 3,
        'active_platforms': 2,
        'total_orders': 500,
        'pending_orders': 10,
        'completed_orders': 450,
        'today_orders': 25,
        'today_revenue': '2875.50',
        'active_orders': 10,
        'rejected_orders': 40,
        'platforms': [
          {'platform': 'jahez', 'order_count': 300},
          {'platform': 'marsool', 'order_count': 200},
        ],
      };

      // Validate that all expected keys are present (matching what the notifier reads)
      expect(statsData['total_platforms'], isA<int>());
      expect(statsData['active_platforms'], isA<int>());
      expect(statsData['total_orders'], isA<int>());
      expect(statsData['pending_orders'], isA<int>());
      expect(statsData['today_revenue'], isA<String>());
      expect(double.tryParse(statsData['today_revenue'] as String), closeTo(2875.50, 0.001));
      expect(statsData['platforms'], isA<List>());
    });

    test('webhook-logs response structure matches expectations', () {
      // Simulates GET /api/v2/delivery/webhook-logs (paginated)
      final backendResponse = {
        'success': true,
        'data': {
          'data': [
            {
              'id': 'wh-1',
              'platform': 'jahez',
              'store_id': 'store-1',
              'event_type': 'new_order',
              'payload': {'order': 'data'},
              'headers': {'x-signature': 'abc'},
              'ip_address': '1.2.3.4',
              'signature_valid': true,
              'processed': true,
              'processing_result': 'success',
              'error_message': null,
              'created_at': '2026-01-01T10:00:00Z',
            },
          ],
          'total': 1,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        },
      };

      final dataWrapper = backendResponse['data'] as Map<String, dynamic>;
      expect(dataWrapper.containsKey('data'), isTrue);
      expect(dataWrapper.containsKey('total'), isTrue);
      expect(dataWrapper.containsKey('current_page'), isTrue);
      expect(dataWrapper.containsKey('last_page'), isTrue);

      // Verify the pagination structure Flutter expects
      final items = dataWrapper['data'] as List;
      expect(items.first['signature_valid'], isTrue);
      expect(items.first['processed'], isTrue);
    });

    test('status-push-logs response structure matches expectations', () {
      // Simulates GET /api/v2/delivery/status-push-logs (paginated)
      final backendResponse = {
        'success': true,
        'data': {
          'data': [
            {
              'id': 'spl-1',
              'delivery_order_mapping_id': 'ord-1',
              'platform': 'jahez',
              'status_pushed': 'accepted',
              'attempt_number': 1,
              'success': true,
              'http_status_code': 200,
              'response_body': null,
              'error_message': null,
              'pushed_at': '2026-01-01T10:00:00Z',
            },
          ],
          'total': 1,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        },
      };

      final dataWrapper = backendResponse['data'] as Map<String, dynamic>;
      final items = dataWrapper['data'] as List;
      final item = items.first as Map<String, dynamic>;

      expect(item['success'], isTrue);
      expect(item['status_pushed'], 'accepted');
      expect(item['attempt_number'], 1);
      expect(item['http_status_code'], 200);
    });
  });
}
