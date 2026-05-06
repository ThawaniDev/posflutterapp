import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/orders/enums/cancellation_reason_category.dart';

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

const _cancelledSubscriptionPayload = {
  'id': 'sub-uuid-1',
  'organization_id': 'org-uuid-1',
  'subscription_plan_id': 'plan-uuid-1',
  'status': 'cancelled',
  'billing_cycle': 'monthly',
  'current_period_start': '2025-01-01T00:00:00.000Z',
  'current_period_end': '2025-02-01T00:00:00.000Z',
  'trial_ends_at': null,
  'cancelled_at': '2025-01-15T12:00:00.000Z',
  'grace_period_ends_at': null,
  'payment_method': 'card',
  'is_softpos_free': false,
  'softpos_transaction_count': 0,
  'created_at': '2025-01-01T00:00:00.000Z',
  'updated_at': '2025-01-15T12:00:00.000Z',
};

void main() {
  // ═══════════════════════════════════════════════════════════
  // CancellationReasonCategory enum — value contracts
  // ═══════════════════════════════════════════════════════════

  group('CancellationReasonCategory enum values match Laravel backend', () {
    test('price value matches Laravel CATEGORIES', () {
      expect(CancellationReasonCategory.price.value, equals('price'));
    });

    test('features value matches Laravel CATEGORIES', () {
      expect(CancellationReasonCategory.features.value, equals('features'));
    });

    test('competitor value matches Laravel CATEGORIES', () {
      expect(CancellationReasonCategory.competitor.value, equals('competitor'));
    });

    test('support value matches Laravel CATEGORIES', () {
      expect(CancellationReasonCategory.support.value, equals('support'));
    });

    test('other value matches Laravel CATEGORIES', () {
      expect(CancellationReasonCategory.other.value, equals('other'));
    });

    test('has exactly 5 categories matching Laravel', () {
      expect(CancellationReasonCategory.values.length, equals(5));
    });

    test('fromValue parses all valid Laravel category strings', () {
      final categories = ['price', 'features', 'competitor', 'support', 'other'];
      for (final category in categories) {
        expect(
          () => CancellationReasonCategory.fromValue(category),
          returnsNormally,
          reason: 'Expected "$category" to be a valid category',
        );
      }
    });

    test('fromValue throws on invalid category', () {
      expect(() => CancellationReasonCategory.fromValue('invalid_category'), throwsArgumentError);
    });

    test('tryFromValue returns null for null input', () {
      expect(CancellationReasonCategory.tryFromValue(null), isNull);
    });

    test('tryFromValue returns null for unknown value', () {
      expect(CancellationReasonCategory.tryFromValue('unknown'), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Cancellation API — request shape validation
  // ═══════════════════════════════════════════════════════════

  group('cancelSubscription request body contracts', () {
    test('sends reason_category as string value not enum name', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _cancelledSubscriptionPayload});
      });

      await svc.cancelSubscription(reasonCategory: CancellationReasonCategory.price.value);

      final body = captured!.data as Map<String, dynamic>;
      // Must be the string 'price', not 'CancellationReasonCategory.price'
      expect(body['reason_category'], equals('price'));
    });

    test('sends both reason and reason_category when both provided', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _cancelledSubscriptionPayload});
      });

      await svc.cancelSubscription(
        reason: 'The pricing model does not fit our budget.',
        reasonCategory: CancellationReasonCategory.price.value,
      );

      final body = captured!.data as Map<String, dynamic>;
      expect(body['reason'], equals('The pricing model does not fit our budget.'));
      expect(body['reason_category'], equals('price'));
    });

    test('sends only reason_category when reason is null', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _cancelledSubscriptionPayload});
      });

      await svc.cancelSubscription(reasonCategory: CancellationReasonCategory.features.value);

      final body = captured!.data as Map<String, dynamic>;
      expect(body.containsKey('reason'), isFalse);
      expect(body['reason_category'], equals('features'));
    });

    test('sends only reason when reason_category is null', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _cancelledSubscriptionPayload});
      });

      await svc.cancelSubscription(reason: 'Switching to a competitor solution.');

      final body = captured!.data as Map<String, dynamic>;
      expect(body['reason'], equals('Switching to a competitor solution.'));
      expect(body.containsKey('reason_category'), isFalse);
    });

    test('empty body when neither reason nor reason_category provided', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _cancelledSubscriptionPayload});
      });

      await svc.cancelSubscription();

      final body = captured!.data as Map<String, dynamic>;
      expect(body.isEmpty, isTrue);
    });

    for (final category in CancellationReasonCategory.values) {
      test('correctly sends category: ${category.value}', () async {
        RequestOptions? captured;
        final svc = _makeService((opts) async {
          captured = opts;
          return _json({'success': true, 'data': _cancelledSubscriptionPayload});
        });

        await svc.cancelSubscription(reasonCategory: category.value);

        final body = captured!.data as Map<String, dynamic>;
        expect(body['reason_category'], equals(category.value));
      });
    }
  });

  // ═══════════════════════════════════════════════════════════
  // Cancellation API — response parsing
  // ═══════════════════════════════════════════════════════════

  group('cancelSubscription response parsing', () {
    test('returns StoreSubscription with cancelled status', () async {
      final svc = _makeService((_) async => _json({'success': true, 'data': _cancelledSubscriptionPayload}));

      final result = await svc.cancelSubscription(reasonCategory: 'price');

      expect(result, isA<StoreSubscription>());
      expect(result.status.name, equals('cancelled'));
    });

    test('cancelled_at is populated in response', () async {
      final svc = _makeService((_) async => _json({'success': true, 'data': _cancelledSubscriptionPayload}));

      final result = await svc.cancelSubscription(reasonCategory: 'other');

      expect(result.cancelledAt, isNotNull);
    });

    test('subscription still has billing info after cancellation', () async {
      final svc = _makeService((_) async => _json({'success': true, 'data': _cancelledSubscriptionPayload}));

      final result = await svc.cancelSubscription(reasonCategory: 'price');

      // After cancellation, billing info should still be present
      expect(result.currentPeriodEnd, isNotNull);
      expect(result.organizationId, isNotEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Cancel request URL endpoint
  // ═══════════════════════════════════════════════════════════

  group('cancelSubscription endpoint', () {
    test('calls POST to subscription cancel endpoint', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({'success': true, 'data': _cancelledSubscriptionPayload});
      });

      await svc.cancelSubscription(reasonCategory: 'price');

      expect(captured!.method, equals('POST'));
      expect(captured!.path, contains('cancel'));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Resume after cancellation
  // ═══════════════════════════════════════════════════════════

  group('resumeSubscription', () {
    test('returns active subscription after resume', () async {
      final resumedPayload = Map<String, dynamic>.from(_cancelledSubscriptionPayload)
        ..['status'] = 'active'
        ..['cancelled_at'] = null;

      final svc = _makeService((_) async => _json({'success': true, 'data': resumedPayload}));

      final result = await svc.resumeSubscription();

      expect(result.status.name, equals('active'));
      expect(result.cancelledAt, isNull);
    });

    test('calls POST to subscription resume endpoint', () async {
      RequestOptions? captured;
      final svc = _makeService((opts) async {
        captured = opts;
        return _json({
          'success': true,
          'data': Map<String, dynamic>.from(_cancelledSubscriptionPayload)..addAll({'status': 'active'}),
        });
      });

      await svc.resumeSubscription();

      expect(captured!.method, equals('POST'));
      expect(captured!.path, contains('resume'));
    });
  });
}
