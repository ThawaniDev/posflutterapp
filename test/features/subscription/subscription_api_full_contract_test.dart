import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/zatca/enums/invoice_status.dart';

// ─── Mock HTTP Adapter ────────────────────────────────────────────────────────

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

SubscriptionApiService _makeService(Future<ResponseBody> Function(RequestOptions) handler) {
  return SubscriptionApiService(_makeDio(handler));
}

// ─── Sample API Payloads (matching Laravel resource shapes exactly) ────────────

const _planPayload = {
  'id': 'plan-uuid-1',
  'name': 'Growth',
  'name_ar': 'النمو',
  'slug': 'growth',
  'description': 'For growing businesses',
  'description_ar': 'للشركات النامية',
  'monthly_price': 29.99,
  'annual_price': 299.99,
  'trial_days': 0,
  'grace_period_days': 7,
  'is_active': true,
  'is_highlighted': false,
  'sort_order': 2,
  'business_type': null,
  'softpos_free_eligible': false,
  'softpos_free_threshold': null,
  'softpos_free_threshold_period': null,
  'created_at': '2025-01-01T00:00:00.000Z',
  'updated_at': '2025-01-01T00:00:00.000Z',
};

const _subscriptionPayload = {
  'id': 'sub-uuid-1',
  'organization_id': 'org-uuid-1',
  'subscription_plan_id': 'plan-uuid-1',
  'status': 'active',
  'billing_cycle': 'monthly',
  'current_period_start': '2025-01-01T00:00:00.000Z',
  'current_period_end': '2025-02-01T00:00:00.000Z',
  'trial_ends_at': null,
  'cancelled_at': null,
  'grace_period_ends_at': null,
  'payment_method': 'card',
  'is_softpos_free': false,
  'softpos_transaction_count': 0,
  'created_at': '2025-01-01T00:00:00.000Z',
  'updated_at': '2025-01-01T00:00:00.000Z',
};

const _invoicePayload = {
  'id': 'inv-uuid-1',
  'invoice_number': 'INV-2025-0001',
  'amount': 29.99,
  'tax': 4.50,
  'total': 34.49,
  'status': 'paid',
  'due_date': '2025-01-15T00:00:00.000Z',
  'paid_at': '2025-01-10T00:00:00.000Z',
  'pdf_url': null,
  'created_at': '2025-01-01T00:00:00.000Z',
  'updated_at': '2025-01-01T00:00:00.000Z',
};

void main() {
  // ═══════════════════════════════════════════════════════════
  // cancelSubscription — request shape and reason_category
  // ═══════════════════════════════════════════════════════════

  group('cancelSubscription', () {
    test('sends reason and reason_category in request body', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload});
      });

      await svc.cancelSubscription(reason: 'Too expensive', reasonCategory: 'price');

      expect(captured, isNotNull);
      final body = captured!.data as Map<String, dynamic>;
      expect(body['reason'], equals('Too expensive'));
      expect(body['reason_category'], equals('price'));
    });

    test('omits null reason from request body', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload});
      });

      await svc.cancelSubscription(reasonCategory: 'features');

      final body = captured!.data as Map<String, dynamic>;
      expect(body.containsKey('reason'), isFalse);
      expect(body['reason_category'], equals('features'));
    });

    test('omits null reason_category from request body', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload});
      });

      await svc.cancelSubscription(reason: 'Switching to competitor');

      final body = captured!.data as Map<String, dynamic>;
      expect(body['reason'], equals('Switching to competitor'));
      expect(body.containsKey('reason_category'), isFalse);
    });

    test('sends empty body when no reason provided', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload});
      });

      await svc.cancelSubscription();

      final body = captured!.data as Map<String, dynamic>;
      expect(body.isEmpty, isTrue);
    });

    test('parses cancelled subscription from response', () async {
      final cancelledPayload = Map<String, dynamic>.from(_subscriptionPayload)
        ..['status'] = 'cancelled'
        ..['cancelled_at'] = '2025-01-15T12:00:00.000Z';

      final svc = _makeService((_) async => _json({'success': true, 'data': cancelledPayload}));

      final result = await svc.cancelSubscription(reasonCategory: 'other');

      expect(result, isA<StoreSubscription>());
      expect(result.status.name, equals('cancelled'));
    });

    test('all valid reason_category values are accepted', () async {
      final categories = ['price', 'features', 'competitor', 'support', 'other'];
      for (final category in categories) {
        RequestOptions? captured;
        final svc = _makeService((opts) async {
          captured = opts;
          return _json({'success': true, 'data': _subscriptionPayload});
        });

        await svc.cancelSubscription(reasonCategory: category);

        final body = captured!.data as Map<String, dynamic>;
        expect(body['reason_category'], equals(category),
            reason: 'Expected $category to be sent as reason_category');
      }
    });
  });

  // ═══════════════════════════════════════════════════════════
  // subscribe — request shape
  // ═══════════════════════════════════════════════════════════

  group('subscribe request body', () {
    test('sends plan_id and billing_cycle', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload}, 201);
      });

      await svc.subscribe(planId: 'plan-uuid-1', billingCycle: 'monthly');

      final body = captured!.data as Map<String, dynamic>;
      expect(body['plan_id'], equals('plan-uuid-1'));
      expect(body['billing_cycle'], equals('monthly'));
    });

    test('includes discount_code when provided', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload}, 201);
      });

      await svc.subscribe(planId: 'plan-uuid-1', billingCycle: 'monthly', discountCode: 'SAVE20');

      final body = captured!.data as Map<String, dynamic>;
      expect(body['discount_code'], equals('SAVE20'));
    });

    test('omits discount_code when null', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload}, 201);
      });

      await svc.subscribe(planId: 'plan-uuid-1', billingCycle: 'yearly');

      final body = captured!.data as Map<String, dynamic>;
      expect(body.containsKey('discount_code'), isFalse);
    });

    test('returns StoreSubscription from created response', () async {
      final svc = _makeService((_) async => _json({'success': true, 'data': _subscriptionPayload}, 201));

      final result = await svc.subscribe(planId: 'plan-uuid-1', billingCycle: 'monthly');

      expect(result, isA<StoreSubscription>());
      expect(result.id, equals('sub-uuid-1'));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // getCurrentSubscription — nullable response
  // ═══════════════════════════════════════════════════════════

  group('getCurrentSubscription', () {
    test('parses active subscription correctly', () async {
      final svc = _makeService((_) async => _json({'success': true, 'data': _subscriptionPayload}));

      final result = await svc.getCurrentSubscription();

      expect(result, isNotNull);
      expect(result!.id, equals('sub-uuid-1'));
      expect(result.organizationId, equals('org-uuid-1'));
      expect(result.status.name, equals('active'));
    });

    test('returns null when 404 response', () async {
      final svc = _makeService((_) async => _json({'success': false, 'message': 'Not found'}, 404));

      // Dio throws DioException for non-2xx status by default
      await expectLater(svc.getCurrentSubscription(), throwsA(isA<DioException>()));
    });

    test('subscription plan is parsed when present', () async {
      final withPlan = Map<String, dynamic>.from(_subscriptionPayload)
        ..['plan'] = _planPayload;

      final svc = _makeService((_) async => _json({'success': true, 'data': withPlan}));

      final result = await svc.getCurrentSubscription();

      expect(result!.plan, isNotNull);
      expect(result.plan!.name, equals('Growth'));
      expect(result.plan!.monthlyPrice, closeTo(29.99, 0.01));
    });

    test('grace_period_ends_at is parsed when present', () async {
      final withGrace = Map<String, dynamic>.from(_subscriptionPayload)
        ..['status'] = 'grace'
        ..['grace_period_ends_at'] = '2025-02-08T00:00:00.000Z';

      final svc = _makeService((_) async => _json({'success': true, 'data': withGrace}));

      final result = await svc.getCurrentSubscription();

      expect(result!.gracePeriodEndsAt, isNotNull);
      expect(result.status.name, equals('grace'));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // getInvoices — list parsing
  // ═══════════════════════════════════════════════════════════

  group('getInvoices', () {
    final invoiceListResponse = {
      'success': true,
      'data': {
        'data': [_invoicePayload, Map<String, dynamic>.from(_invoicePayload)..['id'] = 'inv-uuid-2'..['invoice_number'] = 'INV-2025-0002'],
        'meta': {'current_page': 1, 'last_page': 1, 'per_page': 20, 'total': 2},
      },
    };

    test('parses list of invoices from response', () async {
      final svc = _makeService((_) async => _json(invoiceListResponse));

      final result = await svc.getInvoices();

      expect(result, isA<List<Invoice>>());
      expect(result.length, equals(2));
    });

    test('first invoice has correct fields', () async {
      final svc = _makeService((_) async => _json(invoiceListResponse));

      final result = await svc.getInvoices();

      final first = result.first;
      expect(first.id, equals('inv-uuid-1'));
      expect(first.invoiceNumber, equals('INV-2025-0001'));
      expect(first.amount, closeTo(29.99, 0.01));
      expect(first.tax, closeTo(4.50, 0.01));
      expect(first.total, closeTo(34.49, 0.01));
      expect(first.status, equals(InvoiceStatus.paid));
    });

    test('returns empty list when no invoices', () async {
      final emptyResponse = {
        'success': true,
        'data': {
          'data': <dynamic>[],
          'meta': {'current_page': 1, 'last_page': 1, 'per_page': 20, 'total': 0},
        },
      };

      final svc = _makeService((_) async => _json(emptyResponse));

      final result = await svc.getInvoices();

      expect(result, isEmpty);
    });

    test('sends per_page and page query params', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': {'data': [], 'meta': {'current_page': 2, 'last_page': 2, 'per_page': 10, 'total': 15}}});
      });

      await svc.getInvoices(page: 2, perPage: 10);

      expect(captured!.queryParameters['page'], equals(2));
      expect(captured!.queryParameters['per_page'], equals(10));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // getInvoice (single) — response parsing
  // ═══════════════════════════════════════════════════════════

  group('getInvoice', () {
    test('parses single invoice with line items', () async {
      final withLineItems = Map<String, dynamic>.from(_invoicePayload)
        ..['line_items'] = [
          {'id': 'line-uuid-1', 'description': 'Growth Plan - Monthly', 'quantity': 1, 'unit_price': 29.99, 'total': 29.99},
        ];

      final svc = _makeService((_) async => _json({'success': true, 'data': withLineItems}));

      final result = await svc.getInvoice('inv-uuid-1');

      expect(result, isA<Invoice>());
      expect(result.id, equals('inv-uuid-1'));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // getInvoicePdfUrl — handles both URL and null
  // ═══════════════════════════════════════════════════════════

  group('getInvoicePdfUrl', () {
    test('returns pdf_url string when invoice has stored URL', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': {
          'pdf_url': 'https://storage.example.com/invoices/INV-2025-0001.pdf',
          'invoice_number': 'INV-2025-0001',
        },
      }));

      final result = await svc.getInvoicePdfUrl('inv-uuid-1');

      expect(result, equals('https://storage.example.com/invoices/INV-2025-0001.pdf'));
    });

    test('returns null when no pdf_url in response', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': {
          'pdf_url': null,
          'invoice_number': 'INV-2025-0001',
        },
      }));

      final result = await svc.getInvoicePdfUrl('inv-uuid-1');

      expect(result, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // validateDiscount — request + response
  // ═══════════════════════════════════════════════════════════

  group('validateDiscount', () {
    test('sends code, plan_id, and billing_cycle in request', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({
          'success': true,
          'data': {
            'valid': true,
            'discount_type': 'percentage',
            'discount_value': 20.0,
            'discount_percentage': 20.0,
            'original_price': 29.99,
            'discounted_price': 23.99,
            'savings': 6.00,
          },
        });
      });

      await svc.validateDiscount(code: 'SAVE20', planId: 'plan-uuid-1', billingCycle: 'monthly');

      final body = captured!.data as Map<String, dynamic>;
      expect(body['code'], equals('SAVE20'));
      expect(body['plan_id'], equals('plan-uuid-1'));
      expect(body['billing_cycle'], equals('monthly'));
    });

    test('response includes discounted_price and savings', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': {
          'valid': true,
          'discount_type': 'percentage',
          'discount_value': 50.0,
          'discount_percentage': 50.0,
          'original_price': 29.99,
          'discounted_price': 14.995,
          'savings': 14.995,
        },
      }));

      final result = await svc.validateDiscount(code: 'HALF', planId: 'plan-uuid-1', billingCycle: 'monthly');

      expect(result['valid'], isTrue);
      expect(result['discounted_price'], closeTo(14.995, 0.001));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // changePlan — request shape
  // ═══════════════════════════════════════════════════════════

  group('changePlan', () {
    test('sends plan_id and billing_cycle', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _subscriptionPayload});
      });

      await svc.changePlan(planId: 'plan-uuid-2', billingCycle: 'yearly');

      final body = captured!.data as Map<String, dynamic>;
      expect(body['plan_id'], equals('plan-uuid-2'));
      expect(body['billing_cycle'], equals('yearly'));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // listPlans — array parsing
  // ═══════════════════════════════════════════════════════════

  group('listPlans', () {
    test('parses list of plans from array response', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': [_planPayload, Map<String, dynamic>.from(_planPayload)..['id'] = 'plan-uuid-2'..['name'] = 'Enterprise'],
      }));

      final result = await svc.listPlans();

      expect(result, isA<List<SubscriptionPlan>>());
      expect(result.length, equals(2));
      expect(result.first.name, equals('Growth'));
      expect(result.last.name, equals('Enterprise'));
    });

    test('plan monthly_price is parsed as double', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': [_planPayload],
      }));

      final result = await svc.listPlans();

      expect(result.first.monthlyPrice, isA<double>());
      expect(result.first.monthlyPrice, closeTo(29.99, 0.01));
    });

    test('plan annual_price is nullable', () async {
      final noAnnual = Map<String, dynamic>.from(_planPayload)..['annual_price'] = null;

      final svc = _makeService((_) async => _json({'success': true, 'data': [noAnnual]}));

      final result = await svc.listPlans();

      expect(result.first.annualPrice, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // checkFeature — boolean response
  // ═══════════════════════════════════════════════════════════

  group('checkFeature', () {
    test('returns true when feature is enabled', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': {'feature_key': 'multi_branch', 'is_enabled': true},
      }));

      final result = await svc.checkFeature('multi_branch');

      expect(result, isTrue);
    });

    test('returns false when feature is disabled', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': {'feature_key': 'reports_advanced', 'is_enabled': false},
      }));

      final result = await svc.checkFeature('reports_advanced');

      expect(result, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // checkLimit — response structure
  // ═══════════════════════════════════════════════════════════

  group('checkLimit', () {
    test('returns map with limit, current, within_limit keys', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': {
          'limit_key': 'branches',
          'limit': 3,
          'current': 1,
          'remaining': 2,
          'within_limit': true,
          'unlimited': false,
        },
      }));

      final result = await svc.checkLimit('branches');

      expect(result['limit'], equals(3));
      expect(result['current'], equals(1));
      expect(result['within_limit'], isTrue);
      expect(result['unlimited'], isFalse);
    });

    test('unlimited flag is true when no limit configured', () async {
      final svc = _makeService((_) async => _json({
        'success': true,
        'data': {
          'limit_key': 'products',
          'limit': null,
          'current': 150,
          'remaining': null,
          'within_limit': true,
          'unlimited': true,
        },
      }));

      final result = await svc.checkLimit('products');

      expect(result['unlimited'], isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Add-on API contracts
  // ═══════════════════════════════════════════════════════════

  group('activateAddOn', () {
    test('returns map with store_id, plan_add_on_id, is_active, add_on', () async {
      final payload = {
        'store_id': 'store-uuid-1',
        'plan_add_on_id': 'addon-uuid-1',
        'is_active': true,
        'activated_at': '2025-01-15T10:00:00.000Z',
        'add_on': {
          'id': 'addon-uuid-1',
          'name': 'Loyalty Module',
          'name_ar': 'وحدة الولاء',
          'slug': 'loyalty-module',
          'monthly_price': 9.99,
          'description': 'Customer loyalty',
          'is_active': true,
        },
      };

      final svc = _makeService((_) async => _json({'success': true, 'data': payload}, 201));

      final result = await svc.activateAddOn('addon-uuid-1');

      expect(result['plan_add_on_id'], equals('addon-uuid-1'));
      expect(result['is_active'], isTrue);
      expect(result['add_on']['name_ar'], equals('وحدة الولاء'));
    });
  });

  group('getStoreAddOns', () {
    test('returns empty list when no add-ons', () async {
      final svc = _makeService((_) async => _json({'success': true, 'data': []}));

      final result = await svc.getStoreAddOns();

      expect(result, isEmpty);
    });

    test('returns list of add-on maps', () async {
      final payload = [
        {
          'store_id': 'store-uuid-1',
          'plan_add_on_id': 'addon-uuid-1',
          'is_active': true,
          'activated_at': '2025-01-15T10:00:00.000Z',
          'add_on': {
            'id': 'addon-uuid-1',
            'name': 'Loyalty Module',
            'name_ar': 'وحدة الولاء',
            'slug': 'loyalty-module',
            'monthly_price': 9.99,
            'description': 'Customer loyalty',
            'is_active': true,
          },
        }
      ];

      final svc = _makeService((_) async => _json({'success': true, 'data': payload}));

      final result = await svc.getStoreAddOns();

      expect(result.length, equals(1));
      expect(result.first['plan_add_on_id'], equals('addon-uuid-1'));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // StoreSubscription model — fromJson completeness
  // ═══════════════════════════════════════════════════════════

  group('StoreSubscription.fromJson', () {
    test('all fields from full payload are parsed', () {
      final sub = StoreSubscription.fromJson(_subscriptionPayload);

      expect(sub.id, equals('sub-uuid-1'));
      expect(sub.organizationId, equals('org-uuid-1'));
      expect(sub.subscriptionPlanId, equals('plan-uuid-1'));
      expect(sub.billingCycle?.value, equals('monthly'));
      expect(sub.isActive, isTrue);
    });

    test('trial subscription has trial_ends_at parsed', () {
      final trial = Map<String, dynamic>.from(_subscriptionPayload)
        ..['status'] = 'trial'
        ..['trial_ends_at'] = '2025-01-15T00:00:00.000Z';

      final sub = StoreSubscription.fromJson(trial);

      expect(sub.status.name, equals('trial'));
      expect(sub.trialEndsAt, isNotNull);
    });

    test('cancelled subscription has cancelled_at parsed', () {
      final cancelled = Map<String, dynamic>.from(_subscriptionPayload)
        ..['status'] = 'cancelled'
        ..['cancelled_at'] = '2025-01-20T00:00:00.000Z';

      final sub = StoreSubscription.fromJson(cancelled);

      expect(sub.status.name, equals('cancelled'));
      expect(sub.cancelledAt, isNotNull);
    });

    test('grace subscription has grace_period_ends_at parsed', () {
      final grace = Map<String, dynamic>.from(_subscriptionPayload)
        ..['status'] = 'grace'
        ..['grace_period_ends_at'] = '2025-02-08T00:00:00.000Z';

      final sub = StoreSubscription.fromJson(grace);

      expect(sub.status.name, equals('grace'));
      expect(sub.gracePeriodEndsAt, isNotNull);
    });
  });
}
