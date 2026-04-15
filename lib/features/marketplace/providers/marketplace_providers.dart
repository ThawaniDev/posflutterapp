import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/marketplace/models/marketplace_category.dart';
import 'package:wameedpos/features/marketplace/models/marketplace_listing.dart';
import 'package:wameedpos/features/marketplace/providers/marketplace_state.dart';
import 'package:wameedpos/features/marketplace/repositories/marketplace_repository.dart';

// ─── Marketplace Listings Provider ─────────────────────────

final marketplaceListingsProvider = StateNotifierProvider<MarketplaceListingsNotifier, MarketplaceListingsState>((ref) {
  return MarketplaceListingsNotifier(ref.watch(marketplaceRepositoryProvider));
});

class MarketplaceListingsNotifier extends StateNotifier<MarketplaceListingsState> {
  final MarketplaceRepository _repo;

  MarketplaceListingsNotifier(this._repo) : super(const MarketplaceListingsInitial());

  Future<void> load({
    String? search,
    String? categoryId,
    String? pricingType,
    String? sortBy,
    int page = 1,
    int perPage = 15,
  }) async {
    state = const MarketplaceListingsLoading();
    try {
      final results = await Future.wait([
        _repo.listListings(
          search: search,
          categoryId: categoryId,
          pricingType: pricingType,
          sortBy: sortBy,
          page: page,
          perPage: perPage,
        ),
        _repo.listCategories(),
      ]);
      final listings = results[0] as List<MarketplaceListing>;
      final categories = results[1] as List<MarketplaceCategory>;

      state = MarketplaceListingsLoaded(
        listings: listings,
        categories: categories,
        currentPage: page,
        totalPages: 1,
        totalItems: listings.length,
        perPage: perPage,
        searchQuery: search,
        categoryId: categoryId,
        pricingType: pricingType,
      );
    } on DioException catch (e) {
      state = MarketplaceListingsError(message: _extractError(e));
    } catch (e) {
      state = MarketplaceListingsError(message: e.toString());
    }
  }

  Future<void> nextPage() async {
    if (state is! MarketplaceListingsLoaded) return;
    final current = state as MarketplaceListingsLoaded;
    if (current.currentPage >= current.totalPages) return;
    await load(
      search: current.searchQuery,
      categoryId: current.categoryId,
      pricingType: current.pricingType,
      page: current.currentPage + 1,
      perPage: current.perPage,
    );
  }

  Future<void> previousPage() async {
    if (state is! MarketplaceListingsLoaded) return;
    final current = state as MarketplaceListingsLoaded;
    if (current.currentPage <= 1) return;
    await load(
      search: current.searchQuery,
      categoryId: current.categoryId,
      pricingType: current.pricingType,
      page: current.currentPage - 1,
      perPage: current.perPage,
    );
  }
}

// ─── Marketplace Detail Provider ───────────────────────────

final marketplaceDetailProvider = StateNotifierProvider.family<MarketplaceDetailNotifier, MarketplaceDetailState, String>((
  ref,
  listingId,
) {
  return MarketplaceDetailNotifier(ref.watch(marketplaceRepositoryProvider), listingId);
});

class MarketplaceDetailNotifier extends StateNotifier<MarketplaceDetailState> {
  final MarketplaceRepository _repo;
  final String _listingId;

  MarketplaceDetailNotifier(this._repo, this._listingId) : super(const MarketplaceDetailInitial());

  Future<void> load() async {
    state = const MarketplaceDetailLoading();
    try {
      final results = await Future.wait([
        _repo.getListing(_listingId),
        _repo.listReviews(listingId: _listingId),
        _repo.checkAccess(_listingId),
      ]);
      state = MarketplaceDetailLoaded(
        listing: results[0] as dynamic,
        reviews: results[1] as dynamic,
        hasAccess: results[2] as bool? ?? false,
      );
    } on DioException catch (e) {
      state = MarketplaceDetailError(message: _extractError(e));
    } catch (e) {
      state = MarketplaceDetailError(message: e.toString());
    }
  }

  Future<void> purchase(Map<String, dynamic> data) async {
    state = const MarketplaceDetailPurchasing();
    try {
      final result = await _repo.purchase(_listingId, data);

      // If response contains redirect_url, it's a paid listing needing payment
      if (result.containsKey('redirect_url') && result['redirect_url'] != null) {
        state = MarketplaceDetailPaymentRequired(
          redirectUrl: result['redirect_url'] as String,
          purchaseId: result['purchase_id'] as String? ?? '',
        );
        return;
      }

      // Free listing — purchase completed immediately
      await load();
    } on DioException catch (e) {
      state = MarketplaceDetailError(message: _extractError(e));
    }
  }

  Future<void> submitReview(Map<String, dynamic> data) async {
    if (state is! MarketplaceDetailLoaded) return;
    try {
      await _repo.createReview(_listingId, data);
      final reviews = await _repo.listReviews(listingId: _listingId);
      final current = state as MarketplaceDetailLoaded;
      state = current.copyWith(reviews: reviews);
    } on DioException catch (e) {
      state = MarketplaceDetailError(message: _extractError(e));
    }
  }
}

// ─── My Purchases Provider ─────────────────────────────────

final myPurchasesProvider = StateNotifierProvider<MyPurchasesNotifier, MyPurchasesState>((ref) {
  return MyPurchasesNotifier(ref.watch(marketplaceRepositoryProvider));
});

class MyPurchasesNotifier extends StateNotifier<MyPurchasesState> {
  final MarketplaceRepository _repo;

  MyPurchasesNotifier(this._repo) : super(const MyPurchasesInitial());

  Future<void> load() async {
    state = const MyPurchasesLoading();
    try {
      final results = await Future.wait([_repo.myPurchases(), _repo.myInvoices()]);
      state = MyPurchasesLoaded(purchases: results[0] as dynamic, invoices: results[1] as dynamic);
    } on DioException catch (e) {
      state = MyPurchasesError(message: _extractError(e));
    } catch (e) {
      state = MyPurchasesError(message: e.toString());
    }
  }

  Future<void> cancelPurchase(String listingId) async {
    if (state is! MyPurchasesLoaded) return;
    try {
      await _repo.cancelPurchase(listingId);
      await load();
    } on DioException catch (e) {
      state = MyPurchasesError(message: _extractError(e));
    }
  }
}

// ─── Helper ─────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
