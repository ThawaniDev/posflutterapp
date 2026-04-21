import 'package:wameedpos/features/promotions/models/promotion.dart';

// ─── Promotions List State ──────────────────────────────────────

sealed class PromotionsState {
  const PromotionsState();
}

class PromotionsInitial extends PromotionsState {
  const PromotionsInitial();
}

class PromotionsLoading extends PromotionsState {
  const PromotionsLoading();
}

class PromotionsLoaded extends PromotionsState {

  const PromotionsLoaded({
    required this.promotions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.searchQuery,
    this.activeFilter,
    this.typeFilter,
    this.couponFilter,
  });
  final List<Promotion> promotions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? searchQuery;
  final bool? activeFilter;
  final String? typeFilter;
  final bool? couponFilter;

  bool get hasMore => currentPage < lastPage;

  PromotionsLoaded copyWith({
    List<Promotion>? promotions,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? searchQuery,
    bool? activeFilter,
    String? typeFilter,
    bool? couponFilter,
  }) => PromotionsLoaded(
    promotions: promotions ?? this.promotions,
    total: total ?? this.total,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
    searchQuery: searchQuery ?? this.searchQuery,
    activeFilter: activeFilter ?? this.activeFilter,
    typeFilter: typeFilter ?? this.typeFilter,
    couponFilter: couponFilter ?? this.couponFilter,
  );
}

class PromotionsError extends PromotionsState {
  const PromotionsError({required this.message});
  final String message;
}

// ─── Promotion Detail State ─────────────────────────────────────

sealed class PromotionDetailState {
  const PromotionDetailState();
}

class PromotionDetailInitial extends PromotionDetailState {
  const PromotionDetailInitial();
}

class PromotionDetailLoading extends PromotionDetailState {
  const PromotionDetailLoading();
}

class PromotionDetailLoaded extends PromotionDetailState {
  const PromotionDetailLoaded({required this.promotion});
  final Promotion promotion;
}

class PromotionDetailError extends PromotionDetailState {
  const PromotionDetailError({required this.message});
  final String message;
}

// ─── Coupon Validation State ────────────────────────────────────

sealed class CouponValidationState {
  const CouponValidationState();
}

class CouponValidationInitial extends CouponValidationState {
  const CouponValidationInitial();
}

class CouponValidationLoading extends CouponValidationState {
  const CouponValidationLoading();
}

class CouponValidationValid extends CouponValidationState {

  const CouponValidationValid({
    required this.promotionId,
    required this.couponCodeId,
    required this.promotionName,
    required this.type,
    required this.discountAmount,
  });
  final String promotionId;
  final String couponCodeId;
  final String promotionName;
  final String type;
  final double discountAmount;
}

class CouponValidationInvalid extends CouponValidationState {
  const CouponValidationInvalid({required this.error, required this.message});
  final String error;
  final String message;
}

class CouponValidationError extends CouponValidationState {
  const CouponValidationError({required this.message});
  final String message;
}

// ─── Promotion Analytics State ──────────────────────────────────

sealed class PromotionAnalyticsState {
  const PromotionAnalyticsState();
}

class PromotionAnalyticsInitial extends PromotionAnalyticsState {
  const PromotionAnalyticsInitial();
}

class PromotionAnalyticsLoading extends PromotionAnalyticsState {
  const PromotionAnalyticsLoading();
}

class PromotionAnalyticsLoaded extends PromotionAnalyticsState {
  const PromotionAnalyticsLoaded({required this.analytics});
  final Map<String, dynamic> analytics;
}

class PromotionAnalyticsError extends PromotionAnalyticsState {
  const PromotionAnalyticsError({required this.message});
  final String message;
}
