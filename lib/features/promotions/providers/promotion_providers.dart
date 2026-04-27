import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/promotions/providers/promotion_state.dart';
import 'package:wameedpos/features/promotions/repositories/promotion_repository.dart';

// ─── Promotions List Provider ───────────────────────────────────

final promotionsProvider = StateNotifierProvider<PromotionsNotifier, PromotionsState>((ref) {
  return PromotionsNotifier(ref.watch(promotionRepositoryProvider));
});

class PromotionsNotifier extends StateNotifier<PromotionsState> {
  PromotionsNotifier(this._repo) : super(const PromotionsInitial());
  final PromotionRepository _repo;

  Future<void> load({int page = 1, String? search, bool? isActive, String? type, bool? isCoupon}) async {
    if (state is! PromotionsLoaded) state = const PromotionsLoading();
    try {
      final result = await _repo.listPromotions(page: page, search: search, isActive: isActive, type: type, isCoupon: isCoupon);
      state = PromotionsLoaded(
        promotions: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        searchQuery: search,
        activeFilter: isActive,
        typeFilter: type,
        couponFilter: isCoupon,
      );
    } on DioException catch (e) {
      if (state is! PromotionsLoaded) state = PromotionsError(message: _extractError(e));
    } catch (e) {
      if (state is! PromotionsLoaded) state = PromotionsError(message: e.toString());
    }
  }

  Future<void> togglePromotion(String id) async {
    try {
      await _repo.togglePromotion(id);
      if (state is PromotionsLoaded) {
        final s = state as PromotionsLoaded;
        await load(
          page: s.currentPage,
          search: s.searchQuery,
          isActive: s.activeFilter,
          type: s.typeFilter,
          isCoupon: s.couponFilter,
        );
      }
    } on DioException catch (e) {
      state = PromotionsError(message: _extractError(e));
    }
  }

  Future<void> deletePromotion(String id) async {
    try {
      await _repo.deletePromotion(id);
      await load();
    } on DioException catch (e) {
      state = PromotionsError(message: _extractError(e));
    }
  }
}

// ─── Promotion Detail Provider ──────────────────────────────────

final promotionDetailProvider = StateNotifierProvider.family<PromotionDetailNotifier, PromotionDetailState, String?>((
  ref,
  promotionId,
) {
  return PromotionDetailNotifier(ref.watch(promotionRepositoryProvider), promotionId);
});

class PromotionDetailNotifier extends StateNotifier<PromotionDetailState> {
  PromotionDetailNotifier(this._repo, this._promotionId) : super(const PromotionDetailInitial());
  final PromotionRepository _repo;
  final String? _promotionId;

  Future<void> load() async {
    if (_promotionId == null) return;
    if (state is! PromotionDetailLoaded) state = const PromotionDetailLoading();
    try {
      final promotion = await _repo.getPromotion(_promotionId);
      state = PromotionDetailLoaded(promotion: promotion);
    } on DioException catch (e) {
      if (state is! PromotionDetailLoaded) state = PromotionDetailError(message: _extractError(e));
    } catch (e) {
      if (state is! PromotionDetailLoaded) state = PromotionDetailError(message: e.toString());
    }
  }

  Future<void> save(Map<String, dynamic> data) async {
    try {
      if (_promotionId != null) {
        final updated = await _repo.updatePromotion(_promotionId, data);
        state = PromotionDetailLoaded(promotion: updated);
      } else {
        final created = await _repo.createPromotion(data);
        state = PromotionDetailLoaded(promotion: created);
      }
    } on DioException catch (e) {
      state = PromotionDetailError(message: _extractError(e));
    }
  }
}

// ─── Coupon Validation Provider ─────────────────────────────────

final couponValidationProvider = StateNotifierProvider<CouponValidationNotifier, CouponValidationState>((ref) {
  return CouponValidationNotifier(ref.watch(promotionRepositoryProvider));
});

class CouponValidationNotifier extends StateNotifier<CouponValidationState> {
  CouponValidationNotifier(this._repo) : super(const CouponValidationInitial());
  final PromotionRepository _repo;

  Future<void> validate({required String code, String? customerId, double? orderTotal}) async {
    state = const CouponValidationLoading();
    try {
      final result = await _repo.validateCoupon(code: code, customerId: customerId, orderTotal: orderTotal);
      if (result['valid'] == true) {
        state = CouponValidationValid(
          promotionId: result['promotion_id'] as String,
          couponCodeId: result['coupon_code_id'] as String,
          promotionName: result['promotion_name'] as String,
          type: result['type'] as String,
          discountAmount: double.tryParse(result['discount_amount'].toString()) ?? 0.0,
        );
      } else {
        state = CouponValidationInvalid(
          error: result['error'] as String? ?? 'unknown',
          message: result['message'] as String? ?? 'Invalid coupon',
        );
      }
    } on DioException catch (e) {
      // Error responses with validation result in errors field
      final data = e.response?.data;
      if (data is Map && data['errors'] is Map) {
        final errors = data['errors'] as Map<String, dynamic>;
        state = CouponValidationInvalid(
          error: errors['error'] as String? ?? 'unknown',
          message: data['message'] as String? ?? 'Invalid coupon',
        );
      } else {
        state = CouponValidationError(message: _extractError(e));
      }
    } catch (e) {
      state = CouponValidationError(message: e.toString());
    }
  }

  void reset() {
    state = const CouponValidationInitial();
  }
}

// ─── Promotion Analytics Provider ───────────────────────────────

final promotionAnalyticsProvider = StateNotifierProvider.family<PromotionAnalyticsNotifier, PromotionAnalyticsState, String>((
  ref,
  promotionId,
) {
  return PromotionAnalyticsNotifier(ref.watch(promotionRepositoryProvider), promotionId);
});

class PromotionAnalyticsNotifier extends StateNotifier<PromotionAnalyticsState> {
  PromotionAnalyticsNotifier(this._repo, this._promotionId) : super(const PromotionAnalyticsInitial());
  final PromotionRepository _repo;
  final String _promotionId;

  Future<void> load() async {
    if (state is! PromotionAnalyticsLoaded) state = const PromotionAnalyticsLoading();
    try {
      final data = await _repo.getPromotionAnalytics(_promotionId);
      state = PromotionAnalyticsLoaded(analytics: data);
    } on DioException catch (e) {
      if (state is! PromotionAnalyticsLoaded) state = PromotionAnalyticsError(message: _extractError(e));
    } catch (e) {
      if (state is! PromotionAnalyticsLoaded) state = PromotionAnalyticsError(message: e.toString());
    }
  }
}

// ─── Helper ─────────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map && data['message'] != null) return data['message'] as String;
  return e.message ?? 'An unexpected error occurred';
}

// ─── Promotion Usage Log Provider ───────────────────────────────

final promotionUsageLogProvider = StateNotifierProvider.family<PromotionUsageLogNotifier, PromotionUsageLogState, String>((
  ref,
  promotionId,
) {
  return PromotionUsageLogNotifier(ref.watch(promotionRepositoryProvider), promotionId);
});

class PromotionUsageLogNotifier extends StateNotifier<PromotionUsageLogState> {
  PromotionUsageLogNotifier(this._repo, this._promotionId) : super(const PromotionUsageLogInitial());
  final PromotionRepository _repo;
  final String _promotionId;

  String? _dateFrom;
  String? _dateTo;

  Future<void> load({int page = 1, String? dateFrom, String? dateTo}) async {
    _dateFrom = dateFrom;
    _dateTo = dateTo;
    if (state is! PromotionUsageLogLoaded) state = const PromotionUsageLogLoading();
    try {
      final result = await _repo.getPromotionUsageLog(_promotionId, page: page, dateFrom: dateFrom, dateTo: dateTo);
      state = PromotionUsageLogLoaded(
        items: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    } on DioException catch (e) {
      if (state is! PromotionUsageLogLoaded) state = PromotionUsageLogError(message: _extractError(e));
    } catch (e) {
      if (state is! PromotionUsageLogLoaded) state = PromotionUsageLogError(message: e.toString());
    }
  }

  Future<void> loadMore() async {
    final s = state;
    if (s is! PromotionUsageLogLoaded || !s.hasMore) return;
    try {
      final result = await _repo.getPromotionUsageLog(
        _promotionId,
        page: s.currentPage + 1,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      );
      state = s.copyWith(items: [...s.items, ...result.items], currentPage: result.currentPage, lastPage: result.lastPage);
    } on DioException catch (e) {
      // silently fail on pagination, keep existing items
      state = PromotionUsageLogError(message: _extractError(e));
    }
  }
}
