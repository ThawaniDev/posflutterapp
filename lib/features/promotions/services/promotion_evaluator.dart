import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';

/// A single cart line passed into the offline evaluator.
class EvalCartItem {
  const EvalCartItem({
    required this.productId,
    this.categoryId,
    required this.unitPrice,
    required this.quantity,
  });
  final String? productId;
  final String? categoryId;
  final double unitPrice;
  final int quantity;

  Map<String, dynamic> toApiJson() => {
        'product_id': productId,
        'category_id': categoryId,
        'unit_price': unitPrice,
        'quantity': quantity,
      };
}

class AppliedPromotion {
  const AppliedPromotion({
    required this.promotionId,
    required this.promotionName,
    required this.type,
    required this.discount,
    required this.isStackable,
    this.couponCode,
  });
  final String promotionId;
  final String promotionName;
  final String type;
  final double discount;
  final bool isStackable;
  final String? couponCode;
}

class EvaluationResult {
  const EvaluationResult({
    required this.subtotal,
    required this.totalDiscount,
    required this.totalAfter,
    required this.applied,
  });
  final double subtotal;
  final double totalDiscount;
  final double totalAfter;
  final List<AppliedPromotion> applied;

  static const empty = EvaluationResult(
    subtotal: 0, totalDiscount: 0, totalAfter: 0, applied: [],
  );
}

/// Offline mirror of the backend PromotionService::evaluateCart engine.
/// Reads from the Drift offline mirror that PromotionSyncService populates.
class PromotionEvaluator {
  PromotionEvaluator(this._db);
  final PosOfflineDatabase _db;

  Future<EvaluationResult> evaluate({
    required List<EvalCartItem> items,
    String? customerId,
    List<String> customerGroupIds = const [],
    String? couponCode,
    DateTime? now,
  }) async {
    final clock = now ?? DateTime.now();
    final subtotal = items.fold<double>(0, (s, it) => s + it.unitPrice * it.quantity);
    if (items.isEmpty) return EvaluationResult.empty;

    final active = await _db.activePromotions();

    final applied = <AppliedPromotion>[];
    var totalDiscount = 0.0;

    // Auto-apply (non-coupon) promotions first
    for (final p in active) {
      if (p.isCoupon) continue;
      if (!_isEligible(p, items, subtotal, customerGroupIds, clock)) continue;
      final detail = _applyToCart(p, items);
      if (detail.discount > 0) {
        applied.add(detail);
        totalDiscount += detail.discount;
        if (!p.isStackable) break; // non-stackable: single best promo
      }
    }

    // Coupon code on top
    if (couponCode != null && couponCode.trim().isNotEmpty) {
      final coupon = await _db.findCouponByCode(couponCode.trim());
      if (coupon != null && coupon.isActive) {
        final promo = active.firstWhere(
          (p) => p.id == coupon.promotionId,
          orElse: () => LocalPromotion(
            id: '', name: '', type: 'percentage',
            activeDaysJson: '[]', productIdsJson: '[]', categoryIdsJson: '[]',
            customerGroupIdsJson: '[]', bundleProductsJson: '[]',
            usageCount: 0, isStackable: false, isActive: false, isCoupon: false,
            updatedAt: DateTime.now(),
          ),
        );
        if (promo.id.isNotEmpty && promo.isActive &&
            _isEligible(promo, items, subtotal, customerGroupIds, clock)) {
          final detail = _applyToCart(promo, items, couponCode: coupon.code);
          if (detail.discount > 0) {
            applied.add(detail);
            totalDiscount += detail.discount;
          }
        }
      }
    }

    totalDiscount = totalDiscount.clamp(0.0, subtotal);
    return EvaluationResult(
      subtotal: _round(subtotal),
      totalDiscount: _round(totalDiscount),
      totalAfter: _round((subtotal - totalDiscount).clamp(0.0, double.infinity)),
      applied: applied,
    );
  }

  bool _isEligible(LocalPromotion p, List<EvalCartItem> items, double subtotal,
      List<String> customerGroupIds, DateTime clock) {
    if (p.validFrom != null && clock.isBefore(p.validFrom!)) return false;
    if (p.validTo != null && clock.isAfter(p.validTo!)) return false;
    if (p.maxUses != null && p.usageCount >= p.maxUses!) return false;
    if (p.minOrderTotal != null && subtotal < p.minOrderTotal!) return false;
    final totalQty = items.fold<int>(0, (s, it) => s + it.quantity);
    if (p.minItemQuantity != null && totalQty < p.minItemQuantity!) return false;

    final days = _decodeStringList(p.activeDaysJson);
    if (days.isNotEmpty) {
      const weekdayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
      final today = weekdayNames[(clock.weekday - 1).clamp(0, 6)];
      if (!days.map((s) => s.toLowerCase()).contains(today)) return false;
    }

    if (p.activeTimeFrom != null && p.activeTimeTo != null) {
      final nowT = _formatHm(clock);
      if (!(nowT.compareTo(p.activeTimeFrom!) >= 0 && nowT.compareTo(p.activeTimeTo!) <= 0)) {
        return false;
      }
    }

    final requiredGroups = _decodeStringList(p.customerGroupIdsJson);
    if (requiredGroups.isNotEmpty) {
      if (!requiredGroups.any(customerGroupIds.contains)) return false;
    }

    final productIds = _decodeStringList(p.productIdsJson);
    final catIds = _decodeStringList(p.categoryIdsJson);
    if (productIds.isNotEmpty || catIds.isNotEmpty) {
      final hasMatch = items.any((it) =>
          (it.productId != null && productIds.contains(it.productId)) ||
          (it.categoryId != null && catIds.contains(it.categoryId)));
      if (!hasMatch) return false;
    }

    return true;
  }

  AppliedPromotion _applyToCart(LocalPromotion p, List<EvalCartItem> items, {String? couponCode}) {
    final productIds = _decodeStringList(p.productIdsJson);
    final catIds = _decodeStringList(p.categoryIdsJson);

    bool qualifies(EvalCartItem it) {
      if (productIds.isEmpty && catIds.isEmpty) return true;
      if (it.productId != null && productIds.contains(it.productId)) return true;
      if (it.categoryId != null && catIds.contains(it.categoryId)) return true;
      return false;
    }

    final qualifying = items.where(qualifies).toList();
    final qualifyingTotal = qualifying.fold<double>(0, (s, it) => s + it.unitPrice * it.quantity);

    var discount = 0.0;
    switch (p.type) {
      case 'percentage':
        discount = _round(qualifyingTotal * (p.discountValue ?? 0) / 100);
        break;
      case 'fixed_amount':
        discount = (p.discountValue ?? 0).clamp(0, qualifyingTotal).toDouble();
        break;
      case 'happy_hour':
        discount = _round(qualifyingTotal * (p.discountValue ?? 0) / 100);
        break;
      case 'bogo':
        final buy = p.buyQuantity ?? 0;
        final get = p.getQuantity ?? 0;
        final pct = p.getDiscountPercent ?? 100;
        if (buy > 0 && get > 0 && qualifying.isNotEmpty) {
          final units = <double>[];
          for (final it in qualifying) {
            for (var i = 0; i < it.quantity; i++) units.add(it.unitPrice);
          }
          units.sort();
          final groupSize = buy + get;
          final groupCount = units.length ~/ groupSize;
          for (var g = 0; g < groupCount; g++) {
            for (var j = 0; j < get; j++) {
              discount += units[g * groupSize + j] * pct / 100;
            }
          }
          discount = _round(discount);
        }
        break;
      case 'bundle':
        final bundleRows = _decodeBundleList(p.bundleProductsJson);
        if (bundleRows.isNotEmpty && (p.bundlePrice ?? 0) > 0) {
          final qtyByProduct = <String, int>{};
          final priceByProduct = <String, double>{};
          for (final it in items) {
            if (it.productId == null) continue;
            qtyByProduct[it.productId!] = (qtyByProduct[it.productId!] ?? 0) + it.quantity;
            priceByProduct[it.productId!] ??= it.unitPrice;
          }
          var bundlesPossible = 1 << 30;
          var regularPrice = 0.0;
          for (final row in bundleRows) {
            final pid = row['product_id'] as String?;
            final qty = (row['quantity'] as num?)?.toInt() ?? 1;
            if (pid == null) { bundlesPossible = 0; break; }
            final have = qtyByProduct[pid] ?? 0;
            bundlesPossible = bundlesPossible < (have ~/ qty) ? bundlesPossible : (have ~/ qty);
            regularPrice += (priceByProduct[pid] ?? 0) * qty;
          }
          if (bundlesPossible > 0 && bundlesPossible < (1 << 30)) {
            final saving = regularPrice - (p.bundlePrice ?? 0);
            if (saving > 0) discount = _round(saving * bundlesPossible);
          }
        }
        break;
    }

    discount = discount.clamp(0.0, qualifyingTotal).toDouble();

    return AppliedPromotion(
      promotionId: p.id,
      promotionName: p.name,
      type: p.type,
      discount: _round(discount),
      isStackable: p.isStackable,
      couponCode: couponCode,
    );
  }

  List<String> _decodeStringList(String raw) {
    if (raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
    } catch (_) {}
    return const [];
  }

  List<Map<String, dynamic>> _decodeBundleList(String raw) {
    if (raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<Map>().map((m) => m.cast<String, dynamic>()).toList();
      }
    } catch (_) {}
    return const [];
  }

  String _formatHm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  double _round(double v) => (v * 100).roundToDouble() / 100;
}

final promotionEvaluatorProvider = Provider<PromotionEvaluator>((ref) {
  return PromotionEvaluator(ref.watch(posOfflineDatabaseProvider));
});
