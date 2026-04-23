import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';
import 'package:wameedpos/features/promotions/services/promotion_evaluator.dart';

void main() {
  late PosOfflineDatabase db;
  late PromotionEvaluator evaluator;

  setUp(() {
    db = PosOfflineDatabase.forTesting(NativeDatabase.memory());
    evaluator = PromotionEvaluator(db);
  });

  tearDown(() async {
    await db.close();
  });

  LocalPromotionsCompanion basePromo({
    required String id,
    required String type,
    double? discountValue,
    double? bundlePrice,
    int? buyQty,
    int? getQty,
    double? getPct,
    double? minOrderTotal,
    bool isStackable = true,
    bool isCoupon = false,
    List<String> productIds = const [],
    List<String> categoryIds = const [],
    List<Map<String, dynamic>> bundleProducts = const [],
  }) {
    return LocalPromotionsCompanion(
      id: Value(id),
      name: Value('Promo $id'),
      type: Value(type),
      discountValue: Value(discountValue),
      buyQuantity: Value(buyQty),
      getQuantity: Value(getQty),
      getDiscountPercent: Value(getPct),
      bundlePrice: Value(bundlePrice),
      minOrderTotal: Value(minOrderTotal),
      activeDaysJson: const Value('[]'),
      productIdsJson: Value(jsonEncode(productIds)),
      categoryIdsJson: Value(jsonEncode(categoryIds)),
      customerGroupIdsJson: const Value('[]'),
      bundleProductsJson: Value(jsonEncode(bundleProducts)),
      isStackable: Value(isStackable),
      isActive: const Value(true),
      isCoupon: Value(isCoupon),
      usageCount: const Value(0),
      updatedAt: Value(DateTime.now()),
    );
  }

  test('percentage discount on qualifying items', () async {
    await db.upsertPromotions([basePromo(id: 'p1', type: 'percentage', discountValue: 10)]);

    final res = await evaluator.evaluate(items: [const EvalCartItem(productId: 'prod-1', unitPrice: 50, quantity: 2)]);

    expect(res.subtotal, 100);
    expect(res.totalDiscount, 10);
    expect(res.totalAfter, 90);
    expect(res.applied.length, 1);
  });

  test('fixed amount discount capped to qualifying total', () async {
    await db.upsertPromotions([basePromo(id: 'p2', type: 'fixed_amount', discountValue: 500)]);

    final res = await evaluator.evaluate(items: [const EvalCartItem(productId: 'prod-1', unitPrice: 10, quantity: 1)]);

    expect(res.totalDiscount, 10);
  });

  test('bogo discounts cheapest qualifying units', () async {
    await db.upsertPromotions([
      basePromo(id: 'p3', type: 'bogo', buyQty: 1, getQty: 1, getPct: 100, productIds: ['prod-a', 'prod-b']),
    ]);

    final res = await evaluator.evaluate(
      items: [
        const EvalCartItem(productId: 'prod-a', unitPrice: 10, quantity: 1),
        const EvalCartItem(productId: 'prod-b', unitPrice: 20, quantity: 1),
      ],
    );

    expect(res.totalDiscount, 10);
  });

  test('bundle discount when all parts present', () async {
    await db.upsertPromotions([
      basePromo(
        id: 'p4',
        type: 'bundle',
        bundlePrice: 30,
        bundleProducts: [
          {'product_id': 'prod-a', 'quantity': 1},
          {'product_id': 'prod-b', 'quantity': 1},
        ],
      ),
    ]);

    final res = await evaluator.evaluate(
      items: [
        const EvalCartItem(productId: 'prod-a', unitPrice: 15, quantity: 1),
        const EvalCartItem(productId: 'prod-b', unitPrice: 25, quantity: 1),
      ],
    );

    // saving per bundle = 40 - 30 = 10, x 1 bundle possible
    expect(res.totalDiscount, 10);
  });

  test('bundle no discount when incomplete', () async {
    await db.upsertPromotions([
      basePromo(
        id: 'p5',
        type: 'bundle',
        bundlePrice: 30,
        bundleProducts: [
          {'product_id': 'prod-a', 'quantity': 1},
          {'product_id': 'prod-b', 'quantity': 1},
        ],
      ),
    ]);

    final res = await evaluator.evaluate(items: [const EvalCartItem(productId: 'prod-a', unitPrice: 15, quantity: 1)]);
    expect(res.totalDiscount, 0);
  });

  test('min_order_total blocks evaluation', () async {
    await db.upsertPromotions([basePromo(id: 'p6', type: 'percentage', discountValue: 20, minOrderTotal: 100)]);
    final res = await evaluator.evaluate(items: [const EvalCartItem(productId: 'prod-a', unitPrice: 10, quantity: 2)]);
    expect(res.totalDiscount, 0);
    expect(res.applied, isEmpty);
  });

  test('non-stackable returns only one promotion', () async {
    await db.upsertPromotions([
      basePromo(id: 'p7', type: 'percentage', discountValue: 10, isStackable: false),
      basePromo(id: 'p8', type: 'fixed_amount', discountValue: 5, isStackable: false),
    ]);
    final res = await evaluator.evaluate(items: [const EvalCartItem(productId: 'prod-a', unitPrice: 100, quantity: 1)]);
    expect(res.applied.length, 1);
  });

  test('stackable promotions combine', () async {
    await db.upsertPromotions([
      basePromo(id: 'p9', type: 'percentage', discountValue: 10),
      basePromo(id: 'pa', type: 'fixed_amount', discountValue: 5),
    ]);
    final res = await evaluator.evaluate(items: [const EvalCartItem(productId: 'prod-a', unitPrice: 100, quantity: 1)]);
    expect(res.applied.length, 2);
    expect(res.totalDiscount, 15);
  });

  test('coupon code resolves to promotion', () async {
    await db.upsertPromotions([basePromo(id: 'pc', type: 'percentage', discountValue: 25, isCoupon: true)]);
    await db.upsertCouponCodes([
      LocalCouponCodesCompanion.insert(id: 'cc1', promotionId: 'pc', code: 'SAVE25', isActive: const Value(true)),
    ]);

    final res = await evaluator.evaluate(
      items: [const EvalCartItem(productId: 'prod-a', unitPrice: 40, quantity: 1)],
      couponCode: 'SAVE25',
    );

    expect(res.totalDiscount, 10);
    expect(res.applied.first.couponCode, 'SAVE25');
  });

  test('unknown coupon is ignored', () async {
    final res = await evaluator.evaluate(
      items: [const EvalCartItem(productId: 'prod-a', unitPrice: 40, quantity: 1)],
      couponCode: 'BOGUS',
    );
    expect(res.totalDiscount, 0);
  });

  test('empty cart returns zero', () async {
    final res = await evaluator.evaluate(items: const []);
    expect(res.subtotal, 0);
    expect(res.totalDiscount, 0);
  });

  test('discount cannot exceed subtotal', () async {
    await db.upsertPromotions([basePromo(id: 'pd', type: 'fixed_amount', discountValue: 9999)]);
    final res = await evaluator.evaluate(items: [const EvalCartItem(productId: 'prod-a', unitPrice: 10, quantity: 1)]);
    expect(res.totalDiscount, lessThanOrEqualTo(res.subtotal));
  });
}
