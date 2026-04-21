import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/promotions/enums/promotion_type.dart';
import 'package:wameedpos/features/promotions/models/promotion.dart';
import 'package:wameedpos/features/promotions/models/coupon_code.dart';
import 'package:wameedpos/features/promotions/providers/promotion_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // PromotionType Enum Tests
  // ═══════════════════════════════════════════════════════════════

  group('PromotionType', () {
    test('has correct values', () {
      expect(PromotionType.percentage.value, 'percentage');
      expect(PromotionType.fixedAmount.value, 'fixed_amount');
      expect(PromotionType.bogo.value, 'bogo');
      expect(PromotionType.bundle.value, 'bundle');
      expect(PromotionType.happyHour.value, 'happy_hour');
    });

    test('has human-readable labels', () {
      expect(PromotionType.percentage.label, 'Percentage');
      expect(PromotionType.fixedAmount.label, 'Fixed Amount');
      expect(PromotionType.bogo.label, 'Buy One Get One');
      expect(PromotionType.bundle.label, 'Bundle');
      expect(PromotionType.happyHour.label, 'Happy Hour');
    });

    test('fromValue parses correctly', () {
      expect(PromotionType.fromValue('percentage'), PromotionType.percentage);
      expect(PromotionType.fromValue('fixed_amount'), PromotionType.fixedAmount);
      expect(PromotionType.fromValue('bogo'), PromotionType.bogo);
      expect(PromotionType.fromValue('bundle'), PromotionType.bundle);
      expect(PromotionType.fromValue('happy_hour'), PromotionType.happyHour);
    });

    test('fromValue throws on invalid', () {
      expect(() => PromotionType.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns null on invalid', () {
      expect(PromotionType.tryFromValue('invalid'), isNull);
      expect(PromotionType.tryFromValue(null), isNull);
    });

    test('tryFromValue parses valid', () {
      expect(PromotionType.tryFromValue('bogo'), PromotionType.bogo);
    });

    test('values has 5 entries', () {
      expect(PromotionType.values.length, 5);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Promotion Model Tests
  // ═══════════════════════════════════════════════════════════════

  group('Promotion', () {
    final baseJson = {
      'id': 'promo-1',
      'organization_id': 'org-1',
      'name': 'Summer Sale',
      'description': '20% off everything',
      'type': 'percentage',
      'discount_value': 20.0,
      'is_active': true,
      'is_coupon': false,
      'is_stackable': false,
      'max_uses': 100,
      'max_uses_per_customer': 1,
      'min_order_total': 10.0,
      'usage_count': 5,
      'sync_version': 1,
      'valid_from': '2024-01-01T00:00:00.000Z',
      'valid_to': '2024-12-31T23:59:59.000Z',
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-02T00:00:00.000Z',
    };

    test('fromJson parses percentage promotion', () {
      final promo = Promotion.fromJson(baseJson);
      expect(promo.id, 'promo-1');
      expect(promo.organizationId, 'org-1');
      expect(promo.name, 'Summer Sale');
      expect(promo.description, '20% off everything');
      expect(promo.type, PromotionType.percentage);
      expect(promo.discountValue, 20.0);
      expect(promo.isActive, true);
      expect(promo.isCoupon, false);
      expect(promo.maxUses, 100);
      expect(promo.maxUsesPerCustomer, 1);
      expect(promo.minOrderTotal, 10.0);
      expect(promo.usageCount, 5);
      expect(promo.validFrom, isA<DateTime>());
      expect(promo.validTo, isA<DateTime>());
    });

    test('fromJson parses BOGO promotion', () {
      final json = {
        ...baseJson,
        'type': 'bogo',
        'buy_quantity': 2,
        'get_quantity': 1,
        'get_discount_percent': 100.0,
        'discount_value': null,
      };
      final promo = Promotion.fromJson(json);
      expect(promo.type, PromotionType.bogo);
      expect(promo.buyQuantity, 2);
      expect(promo.getQuantity, 1);
      expect(promo.getDiscountPercent, 100.0);
    });

    test('fromJson parses bundle promotion', () {
      final json = {...baseJson, 'type': 'bundle', 'bundle_price': 49.99, 'discount_value': null};
      final promo = Promotion.fromJson(json);
      expect(promo.type, PromotionType.bundle);
      expect(promo.bundlePrice, 49.99);
    });

    test('fromJson handles null optional fields', () {
      final json = {'id': 'promo-2', 'organization_id': 'org-1', 'name': 'Basic', 'type': 'percentage'};
      final promo = Promotion.fromJson(json);
      expect(promo.description, isNull);
      expect(promo.discountValue, isNull);
      expect(promo.validFrom, isNull);
      expect(promo.validTo, isNull);
      expect(promo.isActive, isNull);
      expect(promo.isCoupon, isNull);
    });

    test('toJson round-trips correctly', () {
      final promo = Promotion.fromJson(baseJson);
      final json = promo.toJson();
      expect(json['id'], 'promo-1');
      expect(json['name'], 'Summer Sale');
      expect(json['type'], 'percentage');
      expect(json['discount_value'], 20.0);
      expect(json['is_active'], true);
    });

    test('fromJson with active_days', () {
      final json = {
        ...baseJson,
        'type': 'happy_hour',
        'active_days': ['monday', 'tuesday'],
        'active_time_from': '14:00',
        'active_time_to': '18:00',
      };
      final promo = Promotion.fromJson(json);
      expect(promo.type, PromotionType.happyHour);
      expect(promo.activeDays, isA<List<String>>());
      expect(promo.activeDays.contains('monday'), true);
      expect(promo.activeTimeFrom, '14:00');
      expect(promo.activeTimeTo, '18:00');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CouponCode Model Tests
  // ═══════════════════════════════════════════════════════════════

  group('CouponCode', () {
    final baseJson = {
      'id': 'coupon-1',
      'promotion_id': 'promo-1',
      'code': 'SUMMER20',
      'max_uses': 50,
      'usage_count': 3,
      'is_active': true,
      'created_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson parses correctly', () {
      final coupon = CouponCode.fromJson(baseJson);
      expect(coupon.id, 'coupon-1');
      expect(coupon.promotionId, 'promo-1');
      expect(coupon.code, 'SUMMER20');
      expect(coupon.maxUses, 50);
      expect(coupon.usageCount, 3);
      expect(coupon.isActive, true);
    });

    test('toJson round-trips', () {
      final coupon = CouponCode.fromJson(baseJson);
      final json = coupon.toJson();
      expect(json['code'], 'SUMMER20');
      expect(json['max_uses'], 50);
    });

    test('copyWith replaces fields', () {
      final coupon = CouponCode.fromJson(baseJson);
      final updated = coupon.copyWith(usageCount: 10, isActive: false);
      expect(updated.usageCount, 10);
      expect(updated.isActive, false);
      expect(updated.code, 'SUMMER20'); // unchanged
    });

    test('equality is based on id', () {
      final c1 = CouponCode.fromJson(baseJson);
      final c2 = CouponCode.fromJson({...baseJson, 'usage_count': 999});
      expect(c1, equals(c2));
    });

    test('handles null optional fields', () {
      final coupon = CouponCode.fromJson({'id': 'c2', 'promotion_id': 'p1', 'code': 'TEST'});
      expect(coupon.maxUses, isNull);
      expect(coupon.usageCount, isNull);
      expect(coupon.isActive, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // PromotionsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('PromotionsState', () {
    test('PromotionsInitial is default', () {
      const state = PromotionsInitial();
      expect(state, isA<PromotionsState>());
    });

    test('PromotionsLoading indicates loading', () {
      const state = PromotionsLoading();
      expect(state, isA<PromotionsState>());
    });

    test('PromotionsLoaded holds data and pagination', () {
      final promos = [const Promotion(id: 'p1', organizationId: 'o1', name: 'Sale', type: PromotionType.percentage)];
      final state = PromotionsLoaded(promotions: promos, total: 10, currentPage: 1, lastPage: 2, perPage: 20);
      expect(state.promotions, hasLength(1));
      expect(state.total, 10);
      expect(state.hasMore, true);
    });

    test('PromotionsLoaded hasMore false on last page', () {
      const state = PromotionsLoaded(promotions: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20);
      expect(state.hasMore, false);
    });

    test('PromotionsLoaded copyWith', () {
      const state = PromotionsLoaded(promotions: [], total: 100, currentPage: 1, lastPage: 5, perPage: 20, searchQuery: 'test');
      final updated = state.copyWith(currentPage: 3, total: 50);
      expect(updated.currentPage, 3);
      expect(updated.total, 50);
      expect(updated.searchQuery, 'test');
    });

    test('PromotionsError holds message', () {
      const state = PromotionsError(message: 'Network error');
      expect(state.message, 'Network error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // PromotionDetailState Tests
  // ═══════════════════════════════════════════════════════════════

  group('PromotionDetailState', () {
    test('initial state', () {
      const state = PromotionDetailInitial();
      expect(state, isA<PromotionDetailState>());
    });

    test('loading state', () {
      const state = PromotionDetailLoading();
      expect(state, isA<PromotionDetailState>());
    });

    test('loaded state holds promotion', () {
      const promo = Promotion(id: 'p1', organizationId: 'o1', name: 'Deal', type: PromotionType.bogo);
      const state = PromotionDetailLoaded(promotion: promo);
      expect(state.promotion.name, 'Deal');
      expect(state.promotion.type, PromotionType.bogo);
    });

    test('error state holds message', () {
      const state = PromotionDetailError(message: 'Not found');
      expect(state.message, 'Not found');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CouponValidationState Tests
  // ═══════════════════════════════════════════════════════════════

  group('CouponValidationState', () {
    test('initial state', () {
      const state = CouponValidationInitial();
      expect(state, isA<CouponValidationState>());
    });

    test('loading state', () {
      const state = CouponValidationLoading();
      expect(state, isA<CouponValidationState>());
    });

    test('valid state holds coupon details', () {
      const state = CouponValidationValid(
        promotionId: 'p1',
        couponCodeId: 'cc1',
        promotionName: 'Summer Sale',
        type: 'percentage',
        discountAmount: 15.50,
      );
      expect(state.promotionId, 'p1');
      expect(state.couponCodeId, 'cc1');
      expect(state.promotionName, 'Summer Sale');
      expect(state.discountAmount, 15.50);
    });

    test('invalid state holds error detail', () {
      const state = CouponValidationInvalid(error: 'expired', message: 'Promotion has expired');
      expect(state.error, 'expired');
      expect(state.message, 'Promotion has expired');
    });

    test('error state holds message', () {
      const state = CouponValidationError(message: 'Server error');
      expect(state.message, 'Server error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // PromotionAnalyticsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('PromotionAnalyticsState', () {
    test('initial state', () {
      const state = PromotionAnalyticsInitial();
      expect(state, isA<PromotionAnalyticsState>());
    });

    test('loading state', () {
      const state = PromotionAnalyticsLoading();
      expect(state, isA<PromotionAnalyticsState>());
    });

    test('loaded state holds analytics data', () {
      const state = PromotionAnalyticsLoaded(
        analytics: {
          'usage_count': 42,
          'total_discount_given': 1050.0,
          'unique_customers': 30,
          'active_coupons': 8,
          'total_coupons': 20,
        },
      );
      expect(state.analytics['usage_count'], 42);
      expect(state.analytics['total_discount_given'], 1050.0);
    });

    test('error state holds message', () {
      const state = PromotionAnalyticsError(message: 'Unauthorized');
      expect(state.message, 'Unauthorized');
    });
  });
}
