import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/features/industry_bakery/enums/production_schedule_status.dart';
import 'package:thawani_pos/features/industry_bakery/enums/custom_cake_order_status.dart';
import 'package:thawani_pos/features/industry_bakery/models/bakery_recipe.dart';
import 'package:thawani_pos/features/industry_bakery/models/production_schedule.dart';
import 'package:thawani_pos/features/industry_bakery/models/custom_cake_order.dart';
import 'package:thawani_pos/features/industry_bakery/providers/bakery_state.dart';

void main() {
  // ═══════════════ Enums ═══════════════
  group('ProductionScheduleStatus', () {
    test('all values', () {
      expect(ProductionScheduleStatus.values, hasLength(3));
      expect(ProductionScheduleStatus.planned.value, 'planned');
      expect(ProductionScheduleStatus.inProgress.value, 'in_progress');
      expect(ProductionScheduleStatus.completed.value, 'completed');
    });

    test('fromValue round-trip', () {
      for (final e in ProductionScheduleStatus.values) {
        expect(ProductionScheduleStatus.fromValue(e.value), e);
      }
    });
  });

  group('CustomCakeOrderStatus', () {
    test('all values', () {
      expect(CustomCakeOrderStatus.values, hasLength(4));
      expect(CustomCakeOrderStatus.ordered.value, 'ordered');
      expect(CustomCakeOrderStatus.inProduction.value, 'in_production');
      expect(CustomCakeOrderStatus.ready.value, 'ready');
      expect(CustomCakeOrderStatus.delivered.value, 'delivered');
    });

    test('fromValue round-trip', () {
      for (final e in CustomCakeOrderStatus.values) {
        expect(CustomCakeOrderStatus.fromValue(e.value), e);
      }
    });
  });

  // ═══════════════ BakeryRecipe Model ═══════════════
  group('BakeryRecipe', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'product_id': 'p1',
      'name': 'Croissant',
      'expected_yield': 24,
      'prep_time_minutes': 30,
      'bake_time_minutes': 18,
      'bake_temperature_c': 200,
      'instructions': 'Roll the dough...',
    };

    test('fromJson', () {
      final r = BakeryRecipe.fromJson(json);
      expect(r.name, 'Croissant');
      expect(r.expectedYield, 24);
      expect(r.prepTimeMinutes, 30);
      expect(r.bakeTemperatureC, 200);
    });

    test('toJson round-trip', () {
      final r = BakeryRecipe.fromJson(json);
      final out = r.toJson();
      expect(out['name'], 'Croissant');
      expect(out['expected_yield'], 24);
    });
  });

  // ═══════════════ ProductionSchedule Model ═══════════════
  group('ProductionSchedule', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'recipe_id': 'r1',
      'schedule_date': '2025-06-15',
      'planned_batches': 5,
      'actual_batches': 4,
      'planned_yield': 120,
      'actual_yield': 96,
      'status': 'in_progress',
      'notes': 'Morning run',
    };

    test('fromJson', () {
      final s = ProductionSchedule.fromJson(json);
      expect(s.plannedBatches, 5);
      expect(s.actualBatches, 4);
      expect(s.status, ProductionScheduleStatus.inProgress);
    });

    test('toJson round-trip', () {
      final s = ProductionSchedule.fromJson(json);
      final out = s.toJson();
      expect(out['planned_batches'], 5);
      expect(out['status'], 'in_progress');
    });
  });

  // ═══════════════ CustomCakeOrder Model ═══════════════
  group('CustomCakeOrder', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'customer_id': 'c1',
      'order_id': 'o1',
      'description': 'Birthday cake',
      'size': '10 inch',
      'flavor': 'Chocolate',
      'decoration_notes': 'Blue frosting',
      'delivery_date': '2025-06-20',
      'delivery_time': '14:00',
      'price': 35.0,
      'deposit_paid': 15.0,
      'status': 'ordered',
    };

    test('fromJson', () {
      final c = CustomCakeOrder.fromJson(json);
      expect(c.description, 'Birthday cake');
      expect(c.size, '10 inch');
      expect(c.flavor, 'Chocolate');
      expect(c.price, 35.0);
      expect(c.status, CustomCakeOrderStatus.ordered);
    });

    test('toJson round-trip', () {
      final c = CustomCakeOrder.fromJson(json);
      final out = c.toJson();
      expect(out['description'], 'Birthday cake');
      expect(out['price'], 35.0);
    });
  });

  // ═══════════════ BakeryState ═══════════════
  group('BakeryState', () {
    test('initial', () {
      const s = BakeryInitial();
      expect(s, isA<BakeryState>());
    });

    test('loading', () {
      const s = BakeryLoading();
      expect(s, isA<BakeryState>());
    });

    test('loaded', () {
      const s = BakeryLoaded(recipes: [], productionSchedules: [], cakeOrders: []);
      expect(s.recipes, isEmpty);
      expect(s.productionSchedules, isEmpty);
      expect(s.cakeOrders, isEmpty);
    });

    test('loaded copyWith', () {
      const s = BakeryLoaded(recipes: [], productionSchedules: [], cakeOrders: []);
      final s2 = s.copyWith(recipes: []);
      expect(s2.recipes, isEmpty);
    });

    test('error', () {
      const s = BakeryError(message: 'fail');
      expect(s.message, 'fail');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('Bakery endpoints', () {
    test('recipes', () {
      expect(ApiEndpoints.bakeryRecipes, '/industry/bakery/recipes');
    });

    test('production schedules', () {
      expect(ApiEndpoints.bakeryProductionSchedules, '/industry/bakery/production-schedules');
    });

    test('cake orders', () {
      expect(ApiEndpoints.bakeryCakeOrders, '/industry/bakery/cake-orders');
    });
  });

  // ═══════════════ Route ═══════════════
  group('Bakery route', () {
    test('route constant', () {
      expect(Routes.industryBakery, '/industry/bakery');
    });
  });
}
