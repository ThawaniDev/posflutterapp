import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';
import 'package:wameedpos/features/promotions/repositories/promotion_repository.dart';

/// Pulls `/pos/promotions/sync?since=<ts>` on demand and upserts the result
/// into the Drift offline mirror so the terminal can evaluate promotions when
/// the network is unavailable.
class PromotionSyncService {
  PromotionSyncService({required PromotionRepository repository, required PosOfflineDatabase db})
    : _repository = repository,
      _db = db;

  final PromotionRepository _repository;
  final PosOfflineDatabase _db;

  static const _lastSyncedKey = 'promotion_sync.last_synced_at';

  Future<DateTime?> _readLastSynced() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastSyncedKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> _writeLastSynced(DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncedKey, value.toIso8601String());
  }

  Future<PromotionSyncResult> syncFromServer({bool fullResync = false}) async {
    final since = fullResync ? null : await _readLastSynced();
    final response = await _repository.posSync(since: since);

    final promotions = (response['promotions'] as List? ?? []).cast<Map<String, dynamic>>();
    final serverTime = response['server_time'] as String?;

    if (promotions.isNotEmpty) {
      final promoRows = <LocalPromotionsCompanion>[];
      for (final p in promotions) {
        promoRows.add(_toPromotionCompanion(p));
      }
      await _db.upsertPromotions(promoRows);

      // Replace coupons per promotion to keep offline state in sync
      for (final p in promotions) {
        final coupons = (p['coupon_codes'] as List? ?? []).cast<Map<String, dynamic>>();
        final couponRows = coupons.map(_toCouponCompanion).toList();
        await _db.replacePromotionCoupons(p['id'] as String, couponRows);
      }
    }

    final nextCursor = serverTime != null ? DateTime.tryParse(serverTime) : DateTime.now();
    if (nextCursor != null) await _writeLastSynced(nextCursor);

    return PromotionSyncResult(syncedCount: promotions.length, serverTime: nextCursor);
  }

  LocalPromotionsCompanion _toPromotionCompanion(Map<String, dynamic> p) {
    return LocalPromotionsCompanion(
      id: Value(p['id'] as String),
      name: Value(p['name'] as String? ?? ''),
      type: Value(p['type'] as String? ?? 'percentage'),
      discountValue: Value(_asDouble(p['discount_value'])),
      buyQuantity: Value(_asInt(p['buy_quantity'])),
      getQuantity: Value(_asInt(p['get_quantity'])),
      getDiscountPercent: Value(_asDouble(p['get_discount_percent'])),
      bundlePrice: Value(_asDouble(p['bundle_price'])),
      minOrderTotal: Value(_asDouble(p['min_order_total'])),
      minItemQuantity: Value(_asInt(p['min_item_quantity'])),
      validFrom: Value(_asDate(p['valid_from'])),
      validTo: Value(_asDate(p['valid_to'])),
      activeDaysJson: Value(jsonEncode(p['active_days'] ?? const [])),
      activeTimeFrom: Value(p['active_time_from'] as String?),
      activeTimeTo: Value(p['active_time_to'] as String?),
      maxUses: Value(_asInt(p['max_uses'])),
      maxUsesPerCustomer: Value(_asInt(p['max_uses_per_customer'])),
      usageCount: Value(_asInt(p['usage_count']) ?? 0),
      isStackable: Value((p['is_stackable'] as bool?) ?? false),
      isActive: Value((p['is_active'] as bool?) ?? true),
      isCoupon: Value((p['is_coupon'] as bool?) ?? false),
      productIdsJson: Value(jsonEncode(p['product_ids'] ?? const [])),
      categoryIdsJson: Value(jsonEncode(p['category_ids'] ?? const [])),
      customerGroupIdsJson: Value(jsonEncode(p['customer_group_ids'] ?? const [])),
      bundleProductsJson: Value(jsonEncode(p['bundle_products'] ?? const [])),
      updatedAt: Value(_asDate(p['updated_at']) ?? DateTime.now()),
    );
  }

  LocalCouponCodesCompanion _toCouponCompanion(Map<String, dynamic> c) {
    return LocalCouponCodesCompanion(
      id: Value(c['id'] as String),
      promotionId: Value(c['promotion_id'] as String),
      code: Value((c['code'] as String? ?? '').toUpperCase()),
      maxUses: Value(_asInt(c['max_uses'])),
      usageCount: Value(_asInt(c['usage_count']) ?? 0),
      isActive: Value((c['is_active'] as bool?) ?? true),
    );
  }

  double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  DateTime? _asDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}

class PromotionSyncResult {
  const PromotionSyncResult({required this.syncedCount, required this.serverTime});
  final int syncedCount;
  final DateTime? serverTime;
}

final promotionSyncServiceProvider = Provider<PromotionSyncService>((ref) {
  return PromotionSyncService(repository: ref.watch(promotionRepositoryProvider), db: ref.watch(posOfflineDatabaseProvider));
});
