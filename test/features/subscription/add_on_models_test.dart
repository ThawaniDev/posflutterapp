import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/subscription/models/plan_add_on.dart';
import 'package:wameedpos/features/subscription/models/store_add_on.dart';

void main() {
  // ══════════════════════════════════════════════
  // PlanAddOn
  // ══════════════════════════════════════════════

  group('PlanAddOn', () {
    test('fromJson parses full payload', () {
      final json = {
        'id': 'addon-uuid-1',
        'name': 'SoftPOS',
        'name_ar': 'سوفت بوس',
        'slug': 'softpos',
        'monthly_price': 49.99,
        'description': 'Accept card payments from your phone',
        'is_active': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final addon = PlanAddOn.fromJson(json);

      expect(addon.id, 'addon-uuid-1');
      expect(addon.name, 'SoftPOS');
      expect(addon.nameAr, 'سوفت بوس');
      expect(addon.slug, 'softpos');
      expect(addon.monthlyPrice, 49.99);
      expect(addon.description, 'Accept card payments from your phone');
      expect(addon.isActive, true);
      expect(addon.createdAt, isNotNull);
      expect(addon.updatedAt, isNotNull);
    });

    test('fromJson handles integer monthly_price cast to double', () {
      final json = {
        'id': 'addon-1',
        'name': 'Loyalty',
        'name_ar': 'الولاء',
        'slug': 'loyalty',
        'monthly_price': 20, // integer
      };

      final addon = PlanAddOn.fromJson(json);
      expect(addon.monthlyPrice, 20.0);
      expect(addon.monthlyPrice, isA<double>());
    });

    test('fromJson handles zero monthly_price', () {
      final json = {
        'id': 'addon-1',
        'name': 'Free Feature',
        'name_ar': 'ميزة مجانية',
        'slug': 'free-feature',
        'monthly_price': 0,
      };

      final addon = PlanAddOn.fromJson(json);
      expect(addon.monthlyPrice, 0.0);
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'id': 'addon-1',
        'name': 'Basic Add-On',
        'name_ar': 'إضافة أساسية',
        'slug': 'basic-addon',
        'monthly_price': 9.99,
      };

      final addon = PlanAddOn.fromJson(json);
      expect(addon.description, isNull);
      expect(addon.isActive, isNull);
      expect(addon.createdAt, isNull);
      expect(addon.updatedAt, isNull);
    });

    test('fromJson handles string monthly_price (e.g. from DB decimal cast)', () {
      final json = {
        'id': 'addon-1',
        'name': 'Pro Feature',
        'name_ar': 'ميزة برو',
        'slug': 'pro-feature',
        'monthly_price': '29.990', // string from DB decimal:3
      };

      final addon = PlanAddOn.fromJson(json);
      expect(addon.monthlyPrice, closeTo(29.99, 0.001));
    });

    test('fromJson defaults to 0.0 when monthly_price is invalid', () {
      final json = {'id': 'addon-1', 'name': 'Test', 'name_ar': 'اختبار', 'slug': 'test', 'monthly_price': 'invalid_price'};

      final addon = PlanAddOn.fromJson(json);
      expect(addon.monthlyPrice, 0.0);
    });

    test('toJson round-trip preserves all fields', () {
      const original = PlanAddOn(
        id: 'addon-uuid-1',
        name: 'SoftPOS',
        nameAr: 'سوفت بوس',
        slug: 'softpos',
        monthlyPrice: 49.99,
        description: 'Card payment add-on',
        isActive: true,
      );

      final json = original.toJson();
      final restored = PlanAddOn.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.nameAr, original.nameAr);
      expect(restored.slug, original.slug);
      expect(restored.monthlyPrice, original.monthlyPrice);
      expect(restored.description, original.description);
      expect(restored.isActive, original.isActive);
    });

    test('toJson serializes name_ar key correctly', () {
      const addon = PlanAddOn(id: 'addon-1', name: 'Loyalty', nameAr: 'برنامج الولاء', slug: 'loyalty', monthlyPrice: 15.0);

      final json = addon.toJson();
      expect(json['name_ar'], 'برنامج الولاء');
      expect(json.containsKey('name_ar'), isTrue);
    });

    test('copyWith updates only specified fields', () {
      const original = PlanAddOn(
        id: 'addon-1',
        name: 'SoftPOS',
        nameAr: 'سوفت بوس',
        slug: 'softpos',
        monthlyPrice: 49.99,
        isActive: true,
      );

      final updated = original.copyWith(monthlyPrice: 39.99, isActive: false);

      expect(updated.id, original.id);
      expect(updated.name, original.name);
      expect(updated.nameAr, original.nameAr);
      expect(updated.slug, original.slug);
      expect(updated.monthlyPrice, 39.99);
      expect(updated.isActive, false);
    });

    test('equality is id-based', () {
      const a = PlanAddOn(id: 'addon-1', name: 'SoftPOS', nameAr: 'سوفت بوس', slug: 'softpos', monthlyPrice: 49.99);
      const b = PlanAddOn(id: 'addon-1', name: 'Different Name', nameAr: 'اسم مختلف', slug: 'different', monthlyPrice: 99.0);
      const c = PlanAddOn(id: 'addon-2', name: 'SoftPOS', nameAr: 'سوفت بوس', slug: 'softpos', monthlyPrice: 49.99);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('hashCode is id-based', () {
      const a = PlanAddOn(id: 'addon-1', name: 'A', nameAr: 'أ', slug: 'a', monthlyPrice: 1.0);
      const b = PlanAddOn(id: 'addon-1', name: 'B', nameAr: 'ب', slug: 'b', monthlyPrice: 2.0);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString includes key info', () {
      const addon = PlanAddOn(id: 'addon-1', name: 'SoftPOS', nameAr: 'سوفت بوس', slug: 'softpos', monthlyPrice: 49.99);
      final str = addon.toString();
      expect(str, contains('addon-1'));
      expect(str, contains('SoftPOS'));
      expect(str, contains('49.99'));
    });

    test('fromJson parses list of add-ons correctly', () {
      final jsonList = [
        {'id': 'addon-1', 'name': 'SoftPOS', 'name_ar': 'سوفت بوس', 'slug': 'softpos', 'monthly_price': 49.99},
        {'id': 'addon-2', 'name': 'Loyalty', 'name_ar': 'الولاء', 'slug': 'loyalty', 'monthly_price': 29.99},
        {'id': 'addon-3', 'name': 'Analytics Pro', 'name_ar': 'تحليلات متقدمة', 'slug': 'analytics-pro', 'monthly_price': 19.99},
      ];

      final addons = jsonList.map(PlanAddOn.fromJson).toList();

      expect(addons.length, 3);
      expect(addons[0].id, 'addon-1');
      expect(addons[1].slug, 'loyalty');
      expect(addons[2].monthlyPrice, 19.99);
    });
  });

  // ══════════════════════════════════════════════
  // StoreAddOn
  // ══════════════════════════════════════════════

  group('StoreAddOn', () {
    test('fromJson parses full payload with organization_id key', () {
      final json = {
        'organization_id': 'org-uuid-1',
        'plan_add_on_id': 'addon-uuid-1',
        'activated_at': '2024-03-01T08:00:00.000Z',
        'is_active': true,
      };

      final storeAddon = StoreAddOn.fromJson(json);

      expect(storeAddon.organizationId, 'org-uuid-1');
      expect(storeAddon.planAddOnId, 'addon-uuid-1');
      expect(storeAddon.isActive, true);
      expect(storeAddon.activatedAt, isNotNull);
    });

    test('fromJson falls back to store_id key if organization_id is absent', () {
      final json = {'store_id': 'store-uuid-1', 'plan_add_on_id': 'addon-uuid-2', 'is_active': true};

      final storeAddon = StoreAddOn.fromJson(json);

      expect(storeAddon.organizationId, 'store-uuid-1');
      expect(storeAddon.planAddOnId, 'addon-uuid-2');
    });

    test('fromJson prefers organization_id when both keys present', () {
      final json = {
        'organization_id': 'org-uuid-1',
        'store_id': 'store-uuid-1',
        'plan_add_on_id': 'addon-uuid-1',
        'is_active': true,
      };

      final storeAddon = StoreAddOn.fromJson(json);
      expect(storeAddon.organizationId, 'org-uuid-1');
    });

    test('fromJson parses activatedAt datetime correctly', () {
      final json = {
        'organization_id': 'org-1',
        'plan_add_on_id': 'addon-1',
        'activated_at': '2024-06-15T14:30:00.000Z',
        'is_active': true,
      };

      final storeAddon = StoreAddOn.fromJson(json);

      expect(storeAddon.activatedAt, isNotNull);
      expect(storeAddon.activatedAt!.year, 2024);
      expect(storeAddon.activatedAt!.month, 6);
      expect(storeAddon.activatedAt!.day, 15);
    });

    test('fromJson handles null activatedAt', () {
      final json = {'organization_id': 'org-1', 'plan_add_on_id': 'addon-1', 'activated_at': null, 'is_active': true};

      final storeAddon = StoreAddOn.fromJson(json);
      expect(storeAddon.activatedAt, isNull);
    });

    test('fromJson handles missing optional fields', () {
      final json = {'organization_id': 'org-1', 'plan_add_on_id': 'addon-1'};

      final storeAddon = StoreAddOn.fromJson(json);
      expect(storeAddon.activatedAt, isNull);
      expect(storeAddon.isActive, isNull);
    });

    test('fromJson handles is_active false', () {
      final json = {'organization_id': 'org-1', 'plan_add_on_id': 'addon-1', 'is_active': false};

      final storeAddon = StoreAddOn.fromJson(json);
      expect(storeAddon.isActive, false);
    });

    test('toJson serializes organization_id key', () {
      final storeAddon = StoreAddOn(
        organizationId: 'org-1',
        planAddOnId: 'addon-1',
        activatedAt: DateTime(2024, 3, 1),
        isActive: true,
      );

      final json = storeAddon.toJson();
      expect(json['organization_id'], 'org-1');
      expect(json['plan_add_on_id'], 'addon-1');
      expect(json['is_active'], true);
      expect(json['activated_at'], isNotNull);
    });

    test('copyWith updates only specified fields', () {
      final original = StoreAddOn(
        organizationId: 'org-1',
        planAddOnId: 'addon-1',
        isActive: true,
        activatedAt: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(isActive: false);

      expect(updated.organizationId, 'org-1');
      expect(updated.planAddOnId, 'addon-1');
      expect(updated.activatedAt, original.activatedAt);
      expect(updated.isActive, false);
    });

    test('copyWith with new planAddOnId', () {
      final original = StoreAddOn(organizationId: 'org-1', planAddOnId: 'addon-1', isActive: true);

      final updated = original.copyWith(planAddOnId: 'addon-2');

      expect(updated.organizationId, 'org-1');
      expect(updated.planAddOnId, 'addon-2');
      expect(updated.isActive, true);
    });

    test('equality checks all fields', () {
      final now = DateTime(2024, 1, 1);
      final a = StoreAddOn(organizationId: 'org-1', planAddOnId: 'addon-1', activatedAt: now, isActive: true);
      final b = StoreAddOn(organizationId: 'org-1', planAddOnId: 'addon-1', activatedAt: now, isActive: true);
      final c = StoreAddOn(organizationId: 'org-1', planAddOnId: 'addon-2', activatedAt: now, isActive: true);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('toString includes key identifiers', () {
      final storeAddon = StoreAddOn(organizationId: 'org-1', planAddOnId: 'addon-1');
      final str = storeAddon.toString();
      expect(str, contains('org-1'));
      expect(str, contains('addon-1'));
    });

    test('fromJson round-trip preserves all fields', () {
      final original = StoreAddOn(
        organizationId: 'org-uuid-1',
        planAddOnId: 'addon-uuid-1',
        activatedAt: DateTime.utc(2024, 3, 15, 10, 0, 0),
        isActive: true,
      );

      final json = original.toJson();
      // toJson uses organization_id, fromJson reads organization_id
      final restored = StoreAddOn.fromJson(json);

      expect(restored.organizationId, original.organizationId);
      expect(restored.planAddOnId, original.planAddOnId);
      expect(restored.isActive, original.isActive);
    });
  });

  // ══════════════════════════════════════════════
  // validateDiscount response structure
  // ══════════════════════════════════════════════

  group('validateDiscount response structure', () {
    final percentageDiscountResponse = {
      'code': 'SAVE20',
      'type': 'percentage',
      'value': 20.0,
      'original_price': 100.0,
      'discount_amount': 20.0,
      'final_price': 80.0,
      'currency': 'SAR',
      'billing_cycle': 'monthly',
    };

    final fixedDiscountResponse = {
      'code': 'FIXED50',
      'type': 'fixed',
      'value': 50.0,
      'original_price': 299.99,
      'discount_amount': 50.0,
      'final_price': 249.99,
      'currency': 'SAR',
      'billing_cycle': 'yearly',
    };

    test('percentage discount response has all required keys', () {
      expect(percentageDiscountResponse.containsKey('code'), isTrue);
      expect(percentageDiscountResponse.containsKey('type'), isTrue);
      expect(percentageDiscountResponse.containsKey('value'), isTrue);
      expect(percentageDiscountResponse.containsKey('original_price'), isTrue);
      expect(percentageDiscountResponse.containsKey('discount_amount'), isTrue);
      expect(percentageDiscountResponse.containsKey('final_price'), isTrue);
      expect(percentageDiscountResponse.containsKey('currency'), isTrue);
      expect(percentageDiscountResponse.containsKey('billing_cycle'), isTrue);
    });

    test('percentage discount calculates correctly', () {
      final originalPrice = percentageDiscountResponse['original_price'] as double;
      final discountAmount = percentageDiscountResponse['discount_amount'] as double;
      final finalPrice = percentageDiscountResponse['final_price'] as double;
      final value = percentageDiscountResponse['value'] as double;

      expect(percentageDiscountResponse['type'], 'percentage');
      expect(discountAmount, closeTo(originalPrice * value / 100, 0.01));
      expect(finalPrice, closeTo(originalPrice - discountAmount, 0.01));
    });

    test('fixed discount calculates correctly', () {
      final originalPrice = fixedDiscountResponse['original_price'] as double;
      final discountAmount = fixedDiscountResponse['discount_amount'] as double;
      final finalPrice = fixedDiscountResponse['final_price'] as double;
      final value = fixedDiscountResponse['value'] as double;

      expect(fixedDiscountResponse['type'], 'fixed');
      expect(discountAmount, closeTo(value, 0.01));
      expect(finalPrice, closeTo(originalPrice - discountAmount, 0.01));
    });

    test('yearly billing discount reflects annual price', () {
      final yearlyResponse = {
        'code': 'YEAR10',
        'type': 'percentage',
        'value': 10.0,
        'original_price': 1000.0, // annual price
        'discount_amount': 100.0,
        'final_price': 900.0,
        'currency': 'SAR',
        'billing_cycle': 'yearly',
      };

      expect(yearlyResponse['billing_cycle'], 'yearly');
      expect(yearlyResponse['original_price'], 1000.0);
      expect(yearlyResponse['final_price'], 900.0);
    });

    test('discount response currency is string', () {
      expect(percentageDiscountResponse['currency'], isA<String>());
      expect(percentageDiscountResponse['currency'], 'SAR');
    });

    test('discount type is one of expected values', () {
      final validTypes = ['percentage', 'fixed'];
      expect(validTypes, contains(percentageDiscountResponse['type']));
      expect(validTypes, contains(fixedDiscountResponse['type']));
    });
  });
}
