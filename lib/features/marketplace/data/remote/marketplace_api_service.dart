import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/marketplace/models/marketplace_category.dart';
import 'package:wameedpos/features/marketplace/models/marketplace_invoice.dart';
import 'package:wameedpos/features/marketplace/models/marketplace_listing.dart';
import 'package:wameedpos/features/marketplace/models/template_purchase.dart';
import 'package:wameedpos/features/marketplace/models/template_review.dart';

final marketplaceApiServiceProvider = Provider<MarketplaceApiService>((ref) {
  return MarketplaceApiService(ref.watch(dioClientProvider));
});

class MarketplaceApiService {
  final Dio _dio;

  MarketplaceApiService(this._dio);

  // ── Browse Listings ───────────────────────────────────────

  Future<List<MarketplaceListing>> listListings({
    String? search,
    String? categoryId,
    String? pricingType,
    String? sortBy,
    int? page,
    int? perPage,
  }) async {
    final queryParams = <String, dynamic>{};
    if (search != null) queryParams['search'] = search;
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (pricingType != null) queryParams['pricing_type'] = pricingType;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;
    final response = await _dio.get(ApiEndpoints.marketplaceListings, queryParameters: queryParams);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => MarketplaceListing.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<MarketplaceListing> getListing(String id) async {
    final response = await _dio.get(ApiEndpoints.marketplaceListingById(id));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return MarketplaceListing.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ── Categories ────────────────────────────────────────────

  Future<List<MarketplaceCategory>> listCategories() async {
    final response = await _dio.get(ApiEndpoints.marketplaceCategories);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => MarketplaceCategory.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<MarketplaceCategory> getCategory(String id) async {
    final response = await _dio.get(ApiEndpoints.marketplaceCategoryById(id));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return MarketplaceCategory.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ── Purchase ──────────────────────────────────────────────

  Future<TemplatePurchase> purchase(String listingId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.marketplacePurchase(listingId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TemplatePurchase.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<TemplatePurchase>> myPurchases() async {
    final response = await _dio.get(ApiEndpoints.marketplaceMyPurchases);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => TemplatePurchase.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<bool> checkAccess(String listingId) async {
    final response = await _dio.get(ApiEndpoints.marketplaceCheckAccess(listingId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return (apiResponse.data as Map<String, dynamic>)['has_access'] as bool? ?? false;
  }

  Future<void> cancelPurchase(String purchaseId) async {
    await _dio.post(ApiEndpoints.marketplaceCancelPurchase(purchaseId));
  }

  // ── Invoices ──────────────────────────────────────────────

  Future<List<MarketplaceInvoice>> myInvoices() async {
    final response = await _dio.get(ApiEndpoints.marketplaceMyInvoices);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => MarketplaceInvoice.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<MarketplaceInvoice> getInvoice(String id) async {
    final response = await _dio.get(ApiEndpoints.marketplaceInvoiceById(id));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return MarketplaceInvoice.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ── Reviews ───────────────────────────────────────────────

  Future<List<TemplateReview>> listReviews({required String listingId}) async {
    final response = await _dio.get(ApiEndpoints.marketplaceListingReviews(listingId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => TemplateReview.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<TemplateReview> createReview(String listingId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.marketplaceListingReviews(listingId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TemplateReview.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<TemplateReview> updateReview(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.marketplaceReviewById(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TemplateReview.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteReview(String id) async {
    await _dio.delete(ApiEndpoints.marketplaceReviewById(id));
  }
}
