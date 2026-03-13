import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/promotions/models/coupon_code.dart';
import 'package:thawani_pos/features/promotions/models/promotion.dart';

final promotionApiServiceProvider = Provider<PromotionApiService>((ref) {
  return PromotionApiService(ref.watch(dioClientProvider));
});

class PromotionApiService {
  final Dio _dio;

  PromotionApiService(this._dio);

  // ─── Promotions CRUD ──────────────────────────────────────────

  Future<PaginatedResult<Promotion>> listPromotions({
    int page = 1,
    int perPage = 20,
    String? search,
    bool? isActive,
    String? type,
    bool? isCoupon,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.promotions,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (isActive != null) 'is_active': isActive.toString(),
        if (type != null) 'type': type,
        if (isCoupon != null) 'is_coupon': isCoupon.toString(),
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Promotion.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<Promotion> getPromotion(String promotionId) async {
    final response = await _dio.get(ApiEndpoints.promotionById(promotionId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Promotion.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Promotion> createPromotion(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.promotions, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Promotion.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Promotion> updatePromotion(String promotionId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.promotionById(promotionId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Promotion.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deletePromotion(String promotionId) async {
    await _dio.delete(ApiEndpoints.promotionById(promotionId));
  }

  Future<Promotion> togglePromotion(String promotionId) async {
    final response = await _dio.post(ApiEndpoints.promotionToggle(promotionId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Promotion.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Coupon Operations ────────────────────────────────────────

  Future<Map<String, dynamic>> validateCoupon({required String code, String? customerId, double? orderTotal}) async {
    final response = await _dio.post(
      ApiEndpoints.couponValidate,
      data: {'code': code, if (customerId != null) 'customer_id': customerId, if (orderTotal != null) 'order_total': orderTotal},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> redeemCoupon({
    required String couponCodeId,
    required String orderId,
    String? customerId,
    required double discountAmount,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.couponRedeem,
      data: {
        'coupon_code_id': couponCodeId,
        'order_id': orderId,
        if (customerId != null) 'customer_id': customerId,
        'discount_amount': discountAmount,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<List<CouponCode>> generateCoupons(String promotionId, {required int count, int? maxUses, String? prefix}) async {
    final response = await _dio.post(
      ApiEndpoints.promotionGenerateCoupons(promotionId),
      data: {'count': count, if (maxUses != null) 'max_uses': maxUses, if (prefix != null) 'prefix': prefix},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List;
    return list.map((j) => CouponCode.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> getPromotionAnalytics(String promotionId) async {
    final response = await _dio.get(ApiEndpoints.promotionAnalytics(promotionId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }
}
