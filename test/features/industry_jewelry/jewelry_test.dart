import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/features/industry_jewelry/enums/metal_type.dart';
import 'package:thawani_pos/features/industry_jewelry/enums/making_charges_type.dart';
import 'package:thawani_pos/features/industry_jewelry/enums/buyback_payment_method.dart';
import 'package:thawani_pos/features/industry_jewelry/models/daily_metal_rate.dart';
import 'package:thawani_pos/features/industry_jewelry/models/jewelry_product_detail.dart';
import 'package:thawani_pos/features/industry_jewelry/models/buyback_transaction.dart';
import 'package:thawani_pos/features/industry_jewelry/providers/jewelry_state.dart';

void main() {
  // ═══════════════ Enums ═══════════════
  group('MetalType', () {
    test('all values', () {
      expect(MetalType.values, hasLength(3));
      expect(MetalType.gold.value, 'gold');
      expect(MetalType.silver.value, 'silver');
      expect(MetalType.platinum.value, 'platinum');
    });

    test('fromValue round-trip', () {
      for (final e in MetalType.values) {
        expect(MetalType.fromValue(e.value), e);
      }
    });
  });

  group('MakingChargesType', () {
    test('all values', () {
      expect(MakingChargesType.values, hasLength(3));
      expect(MakingChargesType.flat.value, 'flat');
      expect(MakingChargesType.percentage.value, 'percentage');
      expect(MakingChargesType.perGram.value, 'per_gram');
    });
  });

  group('BuybackPaymentMethod', () {
    test('all values', () {
      expect(BuybackPaymentMethod.values, hasLength(3));
      expect(BuybackPaymentMethod.cash.value, 'cash');
      expect(BuybackPaymentMethod.bankTransfer.value, 'bank_transfer');
      expect(BuybackPaymentMethod.creditNote.value, 'credit_note');
    });
  });

  // ═══════════════ DailyMetalRate Model ═══════════════
  group('DailyMetalRate', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'metal_type': 'gold',
      'karat': '24K',
      'rate_per_gram': 22.5,
      'buyback_rate_per_gram': 21.0,
      'effective_date': '2025-06-01',
    };

    test('fromJson', () {
      final r = DailyMetalRate.fromJson(json);
      expect(r.metalType, MetalType.gold);
      expect(r.karat, '24K');
      expect(r.ratePerGram, 22.5);
      expect(r.buybackRatePerGram, 21.0);
    });

    test('toJson round-trip', () {
      final r = DailyMetalRate.fromJson(json);
      final out = r.toJson();
      expect(out['metal_type'], 'gold');
      expect(out['rate_per_gram'], 22.5);
    });
  });

  // ═══════════════ JewelryProductDetail Model ═══════════════
  group('JewelryProductDetail', () {
    final json = {
      'id': '1',
      'product_id': 'p1',
      'metal_type': 'gold',
      'karat': '22K',
      'gross_weight_g': 15.5,
      'net_weight_g': 14.0,
      'making_charges_type': 'flat',
      'making_charges_value': 50.0,
      'stone_type': 'Diamond',
      'stone_weight_carat': 0.5,
      'stone_count': 3,
      'certificate_number': 'CERT-001',
    };

    test('fromJson', () {
      final d = JewelryProductDetail.fromJson(json);
      expect(d.metalType, MetalType.gold);
      expect(d.grossWeightG, 15.5);
      expect(d.netWeightG, 14.0);
      expect(d.makingChargesType, MakingChargesType.flat);
      expect(d.stoneCount, 3);
    });

    test('toJson round-trip', () {
      final d = JewelryProductDetail.fromJson(json);
      final out = d.toJson();
      expect(out['gross_weight_g'], 15.5);
      expect(out['certificate_number'], 'CERT-001');
    });
  });

  // ═══════════════ BuybackTransaction Model ═══════════════
  group('BuybackTransaction', () {
    final json = {
      'id': '1',
      'store_id': 's1',
      'customer_id': 'c1',
      'metal_type': 'silver',
      'karat': '925',
      'weight_g': 100.0,
      'rate_per_gram': 0.85,
      'total_amount': 85.0,
      'payment_method': 'cash',
      'staff_user_id': 'u1',
      'notes': 'Buyback',
    };

    test('fromJson', () {
      final b = BuybackTransaction.fromJson(json);
      expect(b.metalType, MetalType.silver);
      expect(b.paymentMethod, BuybackPaymentMethod.cash);
      expect(b.totalAmount, 85.0);
      expect(b.weightG, 100.0);
    });

    test('toJson round-trip', () {
      final b = BuybackTransaction.fromJson(json);
      final out = b.toJson();
      expect(out['payment_method'], 'cash');
      expect(out['total_amount'], 85.0);
    });
  });

  // ═══════════════ JewelryState ═══════════════
  group('JewelryState', () {
    test('initial', () {
      const s = JewelryInitial();
      expect(s, isA<JewelryState>());
    });

    test('loading', () {
      const s = JewelryLoading();
      expect(s, isA<JewelryState>());
    });

    test('loaded', () {
      const s = JewelryLoaded(metalRates: [], productDetails: [], buybacks: []);
      expect(s.metalRates, isEmpty);
      expect(s.productDetails, isEmpty);
      expect(s.buybacks, isEmpty);
    });

    test('loaded copyWith', () {
      const s = JewelryLoaded(metalRates: [], productDetails: [], buybacks: []);
      final s2 = s.copyWith(metalRates: []);
      expect(s2.metalRates, isEmpty);
    });

    test('error', () {
      const s = JewelryError(message: 'fail');
      expect(s.message, 'fail');
    });
  });

  // ═══════════════ API Endpoints ═══════════════
  group('Jewelry endpoints', () {
    test('metal rates', () {
      expect(ApiEndpoints.jewelryMetalRates, '/industry/jewelry/metal-rates');
    });

    test('product details', () {
      expect(ApiEndpoints.jewelryProductDetails, '/industry/jewelry/product-details');
    });

    test('buybacks', () {
      expect(ApiEndpoints.jewelryBuybacks, '/industry/jewelry/buybacks');
    });
  });

  // ═══════════════ Route ═══════════════
  group('Jewelry route', () {
    test('route constant', () {
      expect(Routes.industryJewelry, '/industry/jewelry');
    });
  });
}
