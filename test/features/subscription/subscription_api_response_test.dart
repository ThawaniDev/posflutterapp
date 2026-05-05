import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/subscription/enums/subscription_status.dart';
import 'package:wameedpos/features/subscription/enums/billing_cycle.dart';

// ─── Shared mock HTTP adapter (same pattern as delivery_api_repository_test) ──

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

ResponseBody _json(Object body, [int status = 200]) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

SubscriptionApiService _makeService(Future<ResponseBody> Function(RequestOptions) handler) {
  return SubscriptionApiService(_makeDio(handler));
}

void main() {
  // ══════════════════════════════════════════════════════════
  // syncEntitlements() — response structure & parsing
  // ══════════════════════════════════════════════════════════

  group('syncEntitlements response', () {
    final fullEntitlementsPayload = {
      'success': true,
      'message': 'OK',
      'data': {
        'has_subscription': true,
        'status': 'active',
        'billing_cycle': 'monthly',
        'current_period_end': '2025-12-31T23:59:59.000Z',
        'plan_id': 'plan-uuid-1',
        'plan_name': 'Growth',
        'tier': 'growth',
        'features': {'pos': true, 'inventory': true, 'analytics': false, 'multi_branch': false},
        'limits': {'products': 500, 'staff': 10, 'branches': 1},
        'softpos': {'enabled': true, 'is_free': false, 'percentage': 45.5, 'free_threshold': 5, 'threshold_period': 'monthly'},
        'feature_route_mapping': {
          'pos': ['pos.sale', 'pos.checkout'],
          'inventory': ['inventory.list', 'inventory.edit'],
        },
        'synced_at': '2025-01-15T08:00:00.000Z',
      },
    };

    test('returns map with all required top-level keys', () async {
      final svc = _makeService((_) async => _json(fullEntitlementsPayload));

      final result = await svc.syncEntitlements();

      expect(result.containsKey('has_subscription'), isTrue);
      expect(result.containsKey('status'), isTrue);
      expect(result.containsKey('features'), isTrue);
      expect(result.containsKey('limits'), isTrue);
      expect(result.containsKey('softpos'), isTrue);
      expect(result.containsKey('feature_route_mapping'), isTrue);
      expect(result.containsKey('synced_at'), isTrue);
    });

    test('features map is key→bool', () async {
      final svc = _makeService((_) async => _json(fullEntitlementsPayload));

      final result = await svc.syncEntitlements();
      final features = result['features'] as Map<String, dynamic>;

      expect(features['pos'], isA<bool>());
      expect(features['inventory'], isA<bool>());
      expect(features['pos'], isTrue);
      expect(features['analytics'], isFalse);
    });

    test('limits map is key→int', () async {
      final svc = _makeService((_) async => _json(fullEntitlementsPayload));

      final result = await svc.syncEntitlements();
      final limits = result['limits'] as Map<String, dynamic>;

      expect(limits['products'], isA<int>());
      expect(limits['products'], 500);
      expect(limits['staff'], 10);
    });

    test('softpos block has required sub-keys', () async {
      final svc = _makeService((_) async => _json(fullEntitlementsPayload));

      final result = await svc.syncEntitlements();
      final softpos = result['softpos'] as Map<String, dynamic>;

      expect(softpos.containsKey('enabled'), isTrue);
      expect(softpos.containsKey('is_free'), isTrue);
      expect(softpos.containsKey('percentage'), isTrue);
    });

    test('feature_route_mapping maps feature_key to list of routes', () async {
      final svc = _makeService((_) async => _json(fullEntitlementsPayload));

      final result = await svc.syncEntitlements();
      final mapping = result['feature_route_mapping'] as Map<String, dynamic>;

      expect(mapping, isNotEmpty);
      final posRoutes = mapping['pos'] as List;
      expect(posRoutes, contains('pos.sale'));
    });

    test('returns empty map when data is null', () async {
      final svc = _makeService((_) async => _json({'success': true, 'message': 'OK', 'data': null}));

      final result = await svc.syncEntitlements();
      expect(result, isEmpty);
    });

    test('has_subscription is false when no active subscription', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'has_subscription': false,
            'status': null,
            'features': <String, bool>{},
            'limits': <String, int>{},
            'softpos': {'enabled': false, 'is_free': false, 'percentage': 0},
            'feature_route_mapping': <String, dynamic>{},
            'synced_at': '2025-01-01T00:00:00.000Z',
          },
        }),
      );

      final result = await svc.syncEntitlements();
      expect(result['has_subscription'], isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════
  // activateAddOn() — response parsing
  // ══════════════════════════════════════════════════════════

  group('activateAddOn response', () {
    test('returns map with store_add_on and plan_add_on', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'Add-on activated successfully',
          'data': {
            'store_add_on': {
              'organization_id': 'org-uuid-1',
              'plan_add_on_id': 'addon-uuid-1',
              'activated_at': '2025-01-15T10:00:00.000Z',
              'is_active': true,
            },
            'plan_add_on': {
              'id': 'addon-uuid-1',
              'name': 'SoftPOS',
              'name_ar': 'سوفت بوس',
              'slug': 'softpos',
              'monthly_price': 49.99,
            },
          },
        }),
      );

      final result = await svc.activateAddOn('addon-uuid-1');

      expect(result.containsKey('store_add_on'), isTrue);
      expect(result.containsKey('plan_add_on'), isTrue);

      final storeAddOn = result['store_add_on'] as Map<String, dynamic>;
      expect(storeAddOn['is_active'], true);
      expect(storeAddOn['organization_id'], 'org-uuid-1');
    });

    test('activated store_add_on has activated_at timestamp', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'store_add_on': {
              'organization_id': 'org-1',
              'plan_add_on_id': 'addon-1',
              'activated_at': '2025-06-01T12:00:00.000Z',
              'is_active': true,
            },
            'plan_add_on': {'id': 'addon-1', 'name': 'Test', 'name_ar': 'اختبار', 'slug': 'test', 'monthly_price': 0},
          },
        }),
      );

      final result = await svc.activateAddOn('addon-1');
      final storeAddOn = result['store_add_on'] as Map<String, dynamic>;
      expect(storeAddOn['activated_at'], isNotNull);
      expect(storeAddOn['is_active'], isTrue);
    });

    test('activateAddOn posts to correct endpoint path', () async {
      String? capturedPath;
      final svc = _makeService((_req) async {
        capturedPath = _req.path;
        return _json({
          'success': true,
          'message': 'OK',
          'data': {
            'store_add_on': {'organization_id': 'o', 'plan_add_on_id': 'a', 'is_active': true},
            'plan_add_on': {'id': 'a', 'name': 'T', 'name_ar': 'ت', 'slug': 't', 'monthly_price': 0},
          },
        });
      });

      await svc.activateAddOn('my-addon-id');
      expect(capturedPath, contains('my-addon-id'));
      expect(capturedPath, contains('activate'));
    });
  });

  // ══════════════════════════════════════════════════════════
  // getStoreAddOns() — response parsing
  // ══════════════════════════════════════════════════════════

  group('getStoreAddOns response', () {
    test('returns list of store add-on maps', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {
              'organization_id': 'org-1',
              'plan_add_on_id': 'addon-1',
              'is_active': true,
              'activated_at': '2025-01-01T00:00:00.000Z',
            },
            {'organization_id': 'org-1', 'plan_add_on_id': 'addon-2', 'is_active': false, 'activated_at': null},
          ],
        }),
      );

      final result = await svc.getStoreAddOns();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 2);
      expect(result[0]['plan_add_on_id'], 'addon-1');
      expect(result[0]['is_active'], true);
      expect(result[1]['is_active'], false);
    });

    test('returns empty list when no add-ons', () async {
      final svc = _makeService((_) async => _json({'success': true, 'message': 'OK', 'data': []}));

      final result = await svc.getStoreAddOns();
      expect(result, isEmpty);
    });

    test('returns empty list when data is null', () async {
      final svc = _makeService((_) async => _json({'success': true, 'message': 'OK', 'data': null}));

      final result = await svc.getStoreAddOns();
      expect(result, isEmpty);
    });

    test('each add-on map has plan_add_on_id key', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {'organization_id': 'org-1', 'plan_add_on_id': 'addon-1', 'is_active': true},
          ],
        }),
      );

      final result = await svc.getStoreAddOns();
      expect(result[0].containsKey('plan_add_on_id'), isTrue);
    });

    test('supports nested add_on payload contract from backend', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {
              'store_id': 'store-1',
              'plan_add_on_id': 'addon-1',
              'is_active': true,
              'add_on': {'id': 'addon-1', 'name': 'SoftPOS', 'name_ar': 'سوفت بوس', 'monthly_price': 49.99},
            },
          ],
        }),
      );

      final result = await svc.getStoreAddOns();

      expect(result.first['add_on'], isA<Map<String, dynamic>>());
      expect(result.first['add_on']['name_ar'], 'سوفت بوس');
    });
  });

  // ══════════════════════════════════════════════════════════
  // getUsageSummary() — response parsing
  // ══════════════════════════════════════════════════════════

  group('getUsageSummary response', () {
    test('returns list of usage snapshot maps', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {'resource_type': 'products', 'current_count': 45, 'plan_limit': 100},
            {'resource_type': 'staff', 'current_count': 3, 'plan_limit': 5},
            {'resource_type': 'branches', 'current_count': 1, 'plan_limit': 1},
          ],
        }),
      );

      final result = await svc.getUsageSummary();

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 3);
      expect(result[0]['resource_type'], 'products');
      expect(result[0]['current_count'], 45);
      expect(result[0]['plan_limit'], 100);
    });

    test('returns empty list when no usage data', () async {
      final svc = _makeService((_) async => _json({'success': true, 'message': 'OK', 'data': null}));

      final result = await svc.getUsageSummary();
      expect(result, isEmpty);
    });

    test('usage snapshot has resource_type, current_count, plan_limit', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {'resource_type': 'products', 'current_count': 10, 'plan_limit': 50},
          ],
        }),
      );

      final result = await svc.getUsageSummary();
      final snapshot = result[0];

      expect(snapshot.containsKey('resource_type'), isTrue);
      expect(snapshot.containsKey('current_count'), isTrue);
      expect(snapshot.containsKey('plan_limit'), isTrue);
    });

    test('supports limit_key/current/limit format used by subscription status UI', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {'limit_key': 'products', 'current': 25, 'limit': 100, 'percentage': 25.0},
          ],
        }),
      );

      final result = await svc.getUsageSummary();
      expect(result.first['limit_key'], 'products');
      expect(result.first['current'], 25);
      expect(result.first['limit'], 100);
    });
  });

  // ══════════════════════════════════════════════════════════
  // checkFeature() — boolean parsing
  // ══════════════════════════════════════════════════════════

  group('checkFeature response', () {
    test('returns true when feature is enabled', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {'feature_key': 'pos', 'is_enabled': true},
        }),
      );

      final result = await svc.checkFeature('pos');
      expect(result, isTrue);
    });

    test('returns false when feature is disabled', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {'feature_key': 'analytics', 'is_enabled': false},
        }),
      );

      final result = await svc.checkFeature('analytics');
      expect(result, isFalse);
    });

    test('checkFeature uses correct endpoint path', () async {
      String? capturedPath;
      final svc = _makeService((_req) async {
        capturedPath = _req.path;
        return _json({
          'success': true,
          'message': 'OK',
          'data': {'feature_key': 'inventory', 'is_enabled': true},
        });
      });

      await svc.checkFeature('inventory');
      expect(capturedPath, contains('check-feature'));
      expect(capturedPath, contains('inventory'));
    });
  });

  // ══════════════════════════════════════════════════════════
  // validateDiscount() — response parsing
  // ══════════════════════════════════════════════════════════

  group('validateDiscount response', () {
    test('returns discount map with all required fields', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'Discount is valid',
          'data': {
            'code': 'SAVE20',
            'type': 'percentage',
            'value': 20.0,
            'original_price': 29.99,
            'discount_amount': 5.998,
            'final_price': 23.992,
            'currency': 'SAR',
            'billing_cycle': 'monthly',
          },
        }),
      );

      final result = await svc.validateDiscount(code: 'SAVE20', planId: 'plan-1');

      expect(result['code'], 'SAVE20');
      expect(result['type'], 'percentage');
      expect(result['value'], 20.0);
      expect(result['currency'], 'SAR');
      expect(result['billing_cycle'], 'monthly');
      expect(result.containsKey('original_price'), isTrue);
      expect(result.containsKey('discount_amount'), isTrue);
      expect(result.containsKey('final_price'), isTrue);
    });

    test('yearly billing returns annual original_price', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'code': 'YEAR15',
            'type': 'percentage',
            'value': 15.0,
            'original_price': 299.99,
            'discount_amount': 45.0,
            'final_price': 254.99,
            'currency': 'SAR',
            'billing_cycle': 'yearly',
          },
        }),
      );

      final result = await svc.validateDiscount(code: 'YEAR15', planId: 'plan-1', billingCycle: 'yearly');

      expect(result['billing_cycle'], 'yearly');
      expect((result['original_price'] as num).toDouble(), closeTo(299.99, 0.01));
    });

    test('fixed discount type returned correctly', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'code': 'FIXED50',
            'type': 'fixed',
            'value': 50.0,
            'original_price': 299.99,
            'discount_amount': 50.0,
            'final_price': 249.99,
            'currency': 'SAR',
            'billing_cycle': 'yearly',
          },
        }),
      );

      final result = await svc.validateDiscount(code: 'FIXED50', planId: 'plan-1');
      expect(result['type'], 'fixed');
    });
  });

  // ══════════════════════════════════════════════════════════
  // listPlans() — response parsing
  // ══════════════════════════════════════════════════════════

  group('listPlans response', () {
    test('returns parsed list of SubscriptionPlan', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {
              'id': 'plan-1',
              'name': 'Starter',
              'name_ar': 'مبتدئ',
              'slug': 'starter',
              'monthly_price': 0.0,
              'annual_price': 0.0,
              'is_active': true,
            },
            {
              'id': 'plan-2',
              'name': 'Growth',
              'name_ar': 'نمو',
              'slug': 'growth',
              'monthly_price': 29.99,
              'annual_price': 299.99,
              'is_active': true,
            },
          ],
        }),
      );

      final plans = await svc.listPlans();

      expect(plans, isA<List<SubscriptionPlan>>());
      expect(plans.length, 2);
      expect(plans[0].id, 'plan-1');
      expect(plans[0].name, 'Starter');
      expect(plans[1].monthlyPrice, 29.99);
    });

    test('returns empty list when no plans', () async {
      final svc = _makeService((_) async => _json({'success': true, 'message': 'OK', 'data': []}));

      final plans = await svc.listPlans();
      expect(plans, isEmpty);
    });

    test('handles paginated response format', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'data': [
              {'id': 'plan-1', 'name': 'Starter', 'monthly_price': 0.0, 'is_active': true},
            ],
            'current_page': 1,
            'total': 1,
          },
        }),
      );

      final plans = await svc.listPlans();
      expect(plans.length, 1);
      expect(plans[0].id, 'plan-1');
    });
  });

  // ══════════════════════════════════════════════════════════
  // getCurrentSubscription() — response parsing
  // ══════════════════════════════════════════════════════════

  group('getCurrentSubscription response', () {
    test('returns StoreSubscription when active subscription exists', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'id': 'sub-uuid-1',
            'organization_id': 'org-uuid-1',
            'subscription_plan_id': 'plan-uuid-1',
            'status': 'active',
            'billing_cycle': 'monthly',
            'current_period_start': '2025-01-01T00:00:00.000Z',
            'current_period_end': '2025-02-01T00:00:00.000Z',
            'plan': {'id': 'plan-uuid-1', 'name': 'Growth', 'monthly_price': 29.99, 'annual_price': 299.99},
          },
        }),
      );

      final sub = await svc.getCurrentSubscription();

      expect(sub, isNotNull);
      expect(sub!.id, 'sub-uuid-1');
      expect(sub.status, SubscriptionStatus.active);
      expect(sub.billingCycle, BillingCycle.monthly);
      expect(sub.plan, isNotNull);
      expect(sub.plan!.name, 'Growth');
    });

    test('returns null when no subscription', () async {
      final svc = _makeService((_) async => _json({'success': true, 'message': 'No subscription', 'data': null}));

      final sub = await svc.getCurrentSubscription();
      expect(sub, isNull);
    });

    test('parses trial subscription correctly', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'id': 'sub-trial-1',
            'organization_id': 'org-1',
            'subscription_plan_id': 'plan-1',
            'status': 'trial',
            'billing_cycle': 'monthly',
            'trial_ends_at': '2025-02-15T00:00:00.000Z',
          },
        }),
      );

      final sub = await svc.getCurrentSubscription();

      expect(sub!.status, SubscriptionStatus.trial);
      expect(sub.trialEndsAt, isNotNull);
    });

    test('parses grace period subscription', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'id': 'sub-grace-1',
            'organization_id': 'org-1',
            'subscription_plan_id': 'plan-1',
            'status': 'grace',
            'billing_cycle': 'monthly',
            'grace_period_ends_at': '2025-02-10T00:00:00.000Z',
          },
        }),
      );

      final sub = await svc.getCurrentSubscription();

      expect(sub!.status, SubscriptionStatus.grace);
      expect(sub.gracePeriodEndsAt, isNotNull);
    });
  });

  // ══════════════════════════════════════════════════════════
  // getInvoices() — response parsing
  // ══════════════════════════════════════════════════════════

  group('getInvoices response', () {
    test('returns list of invoices from paginated response', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {
            'data': [
              {
                'id': 'inv-1',
                'invoice_number': 'INV-2025-001',
                'amount': 29.99,
                'total': 34.49,
                'status': 'paid',
                'paid_at': '2025-01-10T00:00:00.000Z',
              },
              {'id': 'inv-2', 'invoice_number': 'INV-2025-002', 'amount': 29.99, 'total': 34.49, 'status': 'pending'},
            ],
            'current_page': 1,
            'total': 2,
          },
        }),
      );

      final invoices = await svc.getInvoices();

      expect(invoices, isA<List<Invoice>>());
      expect(invoices.length, 2);
      expect(invoices[0].id, 'inv-1');
      expect(invoices[0].invoiceNumber, 'INV-2025-001');
      expect(invoices[1].id, 'inv-2');
    });

    test('returns empty list when no invoices', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': {'data': [], 'current_page': 1, 'total': 0},
        }),
      );

      final invoices = await svc.getInvoices();
      expect(invoices, isEmpty);
    });
  });

  // ══════════════════════════════════════════════════════════
  // listAddOns() — plan add-ons public endpoint
  // ══════════════════════════════════════════════════════════

  group('listAddOns response', () {
    test('returns list of plan add-on maps', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'OK',
          'data': [
            {
              'id': 'addon-1',
              'name': 'SoftPOS',
              'name_ar': 'سوفت بوس',
              'slug': 'softpos',
              'monthly_price': 49.99,
              'is_active': true,
            },
            {
              'id': 'addon-2',
              'name': 'Loyalty',
              'name_ar': 'الولاء',
              'slug': 'loyalty',
              'monthly_price': 29.99,
              'is_active': true,
            },
          ],
        }),
      );

      final addons = await svc.listAddOns();

      expect(addons, isA<List<Map<String, dynamic>>>());
      expect(addons.length, 2);
      expect(addons[0]['id'], 'addon-1');
      expect(addons[1]['slug'], 'loyalty');
    });

    test('returns empty list when no add-ons available', () async {
      final svc = _makeService((_) async => _json({'success': true, 'message': 'OK', 'data': null}));

      final addons = await svc.listAddOns();
      expect(addons, isEmpty);
    });
  });

  // ══════════════════════════════════════════════════════════
  // subscribe() — lifecycle response parsing
  // ══════════════════════════════════════════════════════════

  group('subscribe response', () {
    test('returns new StoreSubscription after subscribing', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'Subscribed successfully',
          'data': {
            'id': 'sub-new-1',
            'organization_id': 'org-1',
            'subscription_plan_id': 'plan-growth',
            'status': 'active',
            'billing_cycle': 'monthly',
            'current_period_start': '2025-01-01T00:00:00.000Z',
            'current_period_end': '2025-02-01T00:00:00.000Z',
          },
        }, 201),
      );

      final sub = await svc.subscribe(planId: 'plan-growth');

      expect(sub, isA<StoreSubscription>());
      expect(sub.id, 'sub-new-1');
      expect(sub.status, SubscriptionStatus.active);
      expect(sub.billingCycle, BillingCycle.monthly);
    });

    test('returns trial subscription when plan has trial days', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'Trial started',
          'data': {
            'id': 'sub-trial-2',
            'organization_id': 'org-1',
            'subscription_plan_id': 'plan-starter',
            'status': 'trial',
            'billing_cycle': 'monthly',
            'trial_ends_at': '2025-01-15T00:00:00.000Z',
          },
        }, 201),
      );

      final sub = await svc.subscribe(planId: 'plan-starter');

      expect(sub.status, SubscriptionStatus.trial);
      expect(sub.trialEndsAt, isNotNull);
    });
  });

  // ══════════════════════════════════════════════════════════
  // cancelSubscription() — response parsing
  // ══════════════════════════════════════════════════════════

  group('cancelSubscription response', () {
    test('returns cancelled or grace subscription', () async {
      final svc = _makeService(
        (_) async => _json({
          'success': true,
          'message': 'Subscription cancelled',
          'data': {
            'id': 'sub-1',
            'organization_id': 'org-1',
            'subscription_plan_id': 'plan-1',
            'status': 'grace',
            'billing_cycle': 'monthly',
            'grace_period_ends_at': '2025-01-17T00:00:00.000Z',
            'cancelled_at': '2025-01-10T00:00:00.000Z',
          },
        }),
      );

      final sub = await svc.cancelSubscription();

      expect(sub.status, SubscriptionStatus.grace);
      expect(sub.cancelledAt, isNotNull);
      expect(sub.gracePeriodEndsAt, isNotNull);
    });
  });
}
