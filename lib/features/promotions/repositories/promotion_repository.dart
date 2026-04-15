import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/promotions/data/remote/promotion_api_service.dart';
import 'package:wameedpos/features/promotions/models/coupon_code.dart';
import 'package:wameedpos/features/promotions/models/promotion.dart';

final promotionRepositoryProvider = Provider<PromotionRepository>((ref) {
  return PromotionRepository(apiService: ref.watch(promotionApiServiceProvider));
});

class PromotionRepository {
  final PromotionApiService _apiService;

  PromotionRepository({required PromotionApiService apiService}) : _apiService = apiService;

  // Promotions
  Future<PaginatedResult<Promotion>> listPromotions({
    int page = 1,
    int perPage = 20,
    String? search,
    bool? isActive,
    String? type,
    bool? isCoupon,
  }) => _apiService.listPromotions(
    page: page,
    perPage: perPage,
    search: search,
    isActive: isActive,
    type: type,
    isCoupon: isCoupon,
  );

  Future<Promotion> getPromotion(String id) => _apiService.getPromotion(id);
  Future<Promotion> createPromotion(Map<String, dynamic> data) => _apiService.createPromotion(data);
  Future<Promotion> updatePromotion(String id, Map<String, dynamic> data) => _apiService.updatePromotion(id, data);
  Future<void> deletePromotion(String id) => _apiService.deletePromotion(id);
  Future<Promotion> togglePromotion(String id) => _apiService.togglePromotion(id);

  // Coupons
  Future<Map<String, dynamic>> validateCoupon({required String code, String? customerId, double? orderTotal}) =>
      _apiService.validateCoupon(code: code, customerId: customerId, orderTotal: orderTotal);
  Future<Map<String, dynamic>> redeemCoupon({
    required String couponCodeId,
    required String orderId,
    String? customerId,
    required double discountAmount,
  }) => _apiService.redeemCoupon(
    couponCodeId: couponCodeId,
    orderId: orderId,
    customerId: customerId,
    discountAmount: discountAmount,
  );
  Future<List<CouponCode>> generateCoupons(String promotionId, {required int count, int? maxUses, String? prefix}) =>
      _apiService.generateCoupons(promotionId, count: count, maxUses: maxUses, prefix: prefix);
  Future<Map<String, dynamic>> getPromotionAnalytics(String id) => _apiService.getPromotionAnalytics(id);
}
