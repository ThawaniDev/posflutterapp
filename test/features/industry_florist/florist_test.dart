import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/industry_florist/enums/flower_freshness_status.dart';
import 'package:wameedpos/features/industry_florist/enums/flower_subscription_frequency.dart';
import 'package:wameedpos/features/industry_florist/models/flower_arrangement.dart';
import 'package:wameedpos/features/industry_florist/models/flower_freshness_log.dart';
import 'package:wameedpos/features/industry_florist/models/flower_subscription.dart';
import 'package:wameedpos/features/industry_florist/providers/florist_state.dart';

void main() {
  // ═══════════════ Enums ═══════════════
  group('FlowerFreshnessStatus', () {
    test('all values', () {
      expect(FlowerFreshnessStatus.values, hasLength(3));
      expect(FlowerFreshnessStatus.fresh.value, 'fresh');
      expect(FlowerFreshnessStatus.markedDown.value, 'marked_down');
      expect(FlowerFreshnessStatus.disposed.value, 'disposed');
    });

    test('fromValue round-trip', () {
      for (final e in FlowerFreshnessStatus.values) {
        expect(FlowerFreshnessStatus.fromValue(e.value), e);
      }
    });
  });

  group('FlowerSubscriptionFrequency', () {
    test('all values', () {
      expect(FlowerSubscriptionFrequency.values, hasLength(3));
      expect(FlowerSubscriptionFrequency.weekly.value, 'weekly');
      expect(FlowerSubscriptionFrequency.biweekly.value, 'biweekly');
      expect(FlowerSubscriptionFrequency.monthly.value, 'monthly');
    });

    test('fromValue round-trip', () {
      for (final e in FlowerSubscriptionFrequency.values) {
        expect(FlowerSubscriptionFrequency.fromValue(e.value), e);
      }
    });
  });

  // ═══════════════ FlowerArrangement Model ═══════════════
  group('FlowerArrangement', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'name': 'Rose Bouquet',
      'occasion': 'Wedding',
      'items_json': {'roses': 12, 'baby_breath': 6},
      'total_price': 45.0,
      'is_template': true,
    };

    test('fromJson', () {
      final a = FlowerArrangement.fromJson(json);
      expect(a.name, 'Rose Bouquet');
      expect(a.occasion, 'Wedding');
      expect(a.totalPrice, 45.0);
      expect(a.isTemplate, true);
      expect(a.itemsJson, isA<Map<String, dynamic>>());
    });

    test('toJson round-trip', () {
      final a = FlowerArrangement.fromJson(json);
      final out = a.toJson();
      expect(out['name'], 'Rose Bouquet');
      expect(out['total_price'], 45.0);
    });
  });

  // ═══════════════ FlowerFreshnessLog Model ═══════════════
  group('FlowerFreshnessLog', () {
    final json = {
      'id': '1',
      'product_id': 'p1',
      'store_id': 's1',
      'received_date': '2025-06-01',
      'expected_vase_life_days': 7,
      'markdown_date': '2025-06-06',
      'quantity': 50,
      'status': 'fresh',
    };

    test('fromJson', () {
      final l = FlowerFreshnessLog.fromJson(json);
      expect(l.expectedVaseLifeDays, 7);
      expect(l.quantity, 50);
      expect(l.status, FlowerFreshnessStatus.fresh);
    });

    test('toJson round-trip', () {
      final l = FlowerFreshnessLog.fromJson(json);
      final out = l.toJson();
      expect(out['expected_vase_life_days'], 7);
      expect(out['status'], 'fresh');
    });
  });

  // ═══════════════ FlowerSubscription Model ═══════════════
  group('FlowerSubscription', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'customer_id': 'c1',
      'arrangement_template_id': 'tmpl1',
      'frequency': 'weekly',
      'delivery_day': 'Monday',
      'delivery_address': '123 Main St',
      'price_per_delivery': 25.0,
      'is_active': true,
      'next_delivery_date': '2025-06-10',
    };

    test('fromJson', () {
      final s = FlowerSubscription.fromJson(json);
      expect(s.frequency, FlowerSubscriptionFrequency.weekly);
      expect(s.deliveryDay, 'Monday');
      expect(s.pricePerDelivery, 25.0);
      expect(s.isActive, true);
    });

    test('toJson round-trip', () {
      final s = FlowerSubscription.fromJson(json);
      final out = s.toJson();
      expect(out['frequency'], 'weekly');
      expect(out['price_per_delivery'], 25.0);
    });
  });

  // ═══════════════ FloristState ═══════════════
  group('FloristState', () {
    test('initial', () {
      const s = FloristInitial();
      expect(s, isA<FloristState>());
    });

    test('loading', () {
      const s = FloristLoading();
      expect(s, isA<FloristState>());
    });

    test('loaded', () {
      const s = FloristLoaded(arrangements: [], freshnessLogs: [], subscriptions: []);
      expect(s.arrangements, isEmpty);
      expect(s.freshnessLogs, isEmpty);
      expect(s.subscriptions, isEmpty);
    });

    test('loaded copyWith', () {
      const s = FloristLoaded(arrangements: [], freshnessLogs: [], subscriptions: []);
      final s2 = s.copyWith(arrangements: []);
      expect(s2.arrangements, isEmpty);
    });

    test('error', () {
      const s = FloristError(message: 'fail');
      expect(s.message, 'fail');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('Florist endpoints', () {
    test('arrangements', () {
      expect(ApiEndpoints.floristArrangements, '/industry/florist/arrangements');
    });

    test('freshness logs', () {
      expect(ApiEndpoints.floristFreshnessLogs, '/industry/florist/freshness-logs');
    });

    test('subscriptions', () {
      expect(ApiEndpoints.floristSubscriptions, '/industry/florist/subscriptions');
    });
  });

  // ═══════════════ Route ═══════════════
  group('Florist route', () {
    test('route constant', () {
      expect(Routes.industryFlorist, '/industry/florist');
    });
  });
}
