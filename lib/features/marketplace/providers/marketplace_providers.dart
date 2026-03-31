import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/marketplace/providers/marketplace_state.dart';
import 'package:thawani_pos/features/marketplace/repositories/marketplace_repository.dart';

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
      final listingsResponse = results[0] as Map<String, dynamic>;
      final categories = results[1];
      final data = listingsResponse['data'] as List? ?? [];
      final meta = listingsResponse['meta'] as Map<String, dynamic>? ?? {};

      state = MarketplaceListingsLoaded(
        listings: data as dynamic,
        categories: categories as dynamic,
        currentPage: meta['current_page'] as int? ?? page,
        totalPages: meta['last_page'] as int? ?? 1,
        totalItems: meta['total'] as int? ?? 0,
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
        hasAccess: (results[2] as Map<String, dynamic>?)?['has_access'] as bool? ?? false,
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
      await _repo.purchase(data);
      await load();
    } on DioException catch (e) {
      state = MarketplaceDetailError(message: _extractError(e));
    }
  }

  Future<void> submitReview(Map<String, dynamic> data) async {
    if (state is! MarketplaceDetailLoaded) return;
    try {
      await _repo.createReview(data);
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
