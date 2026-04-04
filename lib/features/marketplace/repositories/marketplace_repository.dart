import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/marketplace/data/remote/marketplace_api_service.dart';
import 'package:thawani_pos/features/marketplace/models/marketplace_category.dart';
import 'package:thawani_pos/features/marketplace/models/marketplace_invoice.dart';
import 'package:thawani_pos/features/marketplace/models/marketplace_listing.dart';
import 'package:thawani_pos/features/marketplace/models/template_purchase.dart';
import 'package:thawani_pos/features/marketplace/models/template_review.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository(apiService: ref.watch(marketplaceApiServiceProvider));
});

class MarketplaceRepository {
  final MarketplaceApiService _apiService;

  MarketplaceRepository({required MarketplaceApiService apiService}) : _apiService = apiService;

  Future<List<MarketplaceListing>> listListings({
    String? search,
    String? categoryId,
    String? pricingType,
    String? sortBy,
    int? page,
    int? perPage,
  }) => _apiService.listListings(
    search: search,
    categoryId: categoryId,
    pricingType: pricingType,
    sortBy: sortBy,
    page: page,
    perPage: perPage,
  );

  Future<MarketplaceListing> getListing(String id) => _apiService.getListing(id);
  Future<List<MarketplaceCategory>> listCategories() => _apiService.listCategories();
  Future<MarketplaceCategory> getCategory(String id) => _apiService.getCategory(id);
  Future<TemplatePurchase> purchase(String listingId, Map<String, dynamic> data) => _apiService.purchase(listingId, data);
  Future<List<TemplatePurchase>> myPurchases() => _apiService.myPurchases();
  Future<bool> checkAccess(String listingId) => _apiService.checkAccess(listingId);
  Future<void> cancelPurchase(String purchaseId) => _apiService.cancelPurchase(purchaseId);
  Future<List<MarketplaceInvoice>> myInvoices() => _apiService.myInvoices();
  Future<MarketplaceInvoice> getInvoice(String id) => _apiService.getInvoice(id);
  Future<List<TemplateReview>> listReviews({required String listingId}) => _apiService.listReviews(listingId: listingId);
  Future<TemplateReview> createReview(String listingId, Map<String, dynamic> data) => _apiService.createReview(listingId, data);
  Future<TemplateReview> updateReview(String id, Map<String, dynamic> data) => _apiService.updateReview(id, data);
  Future<void> deleteReview(String id) => _apiService.deleteReview(id);
}
