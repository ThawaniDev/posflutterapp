import 'package:thawani_pos/features/marketplace/models/marketplace_category.dart';
import 'package:thawani_pos/features/marketplace/models/marketplace_invoice.dart';
import 'package:thawani_pos/features/marketplace/models/marketplace_listing.dart';
import 'package:thawani_pos/features/marketplace/models/template_purchase.dart';
import 'package:thawani_pos/features/marketplace/models/template_review.dart';

// ─── Marketplace Listings State ────────────────────────────

sealed class MarketplaceListingsState {
  const MarketplaceListingsState();
}

class MarketplaceListingsInitial extends MarketplaceListingsState {
  const MarketplaceListingsInitial();
}

class MarketplaceListingsLoading extends MarketplaceListingsState {
  const MarketplaceListingsLoading();
}

class MarketplaceListingsLoaded extends MarketplaceListingsState {
  final List<MarketplaceListing> listings;
  final List<MarketplaceCategory> categories;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final String? searchQuery;
  final String? categoryId;
  final String? pricingType;

  const MarketplaceListingsLoaded({
    required this.listings,
    this.categories = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.perPage = 15,
    this.searchQuery,
    this.categoryId,
    this.pricingType,
  });

  MarketplaceListingsLoaded copyWith({
    List<MarketplaceListing>? listings,
    List<MarketplaceCategory>? categories,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? perPage,
    String? searchQuery,
    String? categoryId,
    String? pricingType,
  }) {
    return MarketplaceListingsLoaded(
      listings: listings ?? this.listings,
      categories: categories ?? this.categories,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      pricingType: pricingType ?? this.pricingType,
    );
  }
}

class MarketplaceListingsError extends MarketplaceListingsState {
  final String message;
  const MarketplaceListingsError({required this.message});
}

// ─── Marketplace Detail State ──────────────────────────────

sealed class MarketplaceDetailState {
  const MarketplaceDetailState();
}

class MarketplaceDetailInitial extends MarketplaceDetailState {
  const MarketplaceDetailInitial();
}

class MarketplaceDetailLoading extends MarketplaceDetailState {
  const MarketplaceDetailLoading();
}

class MarketplaceDetailLoaded extends MarketplaceDetailState {
  final MarketplaceListing listing;
  final List<TemplateReview> reviews;
  final bool hasAccess;

  const MarketplaceDetailLoaded({required this.listing, this.reviews = const [], this.hasAccess = false});

  MarketplaceDetailLoaded copyWith({MarketplaceListing? listing, List<TemplateReview>? reviews, bool? hasAccess}) {
    return MarketplaceDetailLoaded(
      listing: listing ?? this.listing,
      reviews: reviews ?? this.reviews,
      hasAccess: hasAccess ?? this.hasAccess,
    );
  }
}

class MarketplaceDetailPurchasing extends MarketplaceDetailState {
  const MarketplaceDetailPurchasing();
}

class MarketplaceDetailError extends MarketplaceDetailState {
  final String message;
  const MarketplaceDetailError({required this.message});
}

// ─── My Purchases State ────────────────────────────────────

sealed class MyPurchasesState {
  const MyPurchasesState();
}

class MyPurchasesInitial extends MyPurchasesState {
  const MyPurchasesInitial();
}

class MyPurchasesLoading extends MyPurchasesState {
  const MyPurchasesLoading();
}

class MyPurchasesLoaded extends MyPurchasesState {
  final List<TemplatePurchase> purchases;
  final List<MarketplaceInvoice> invoices;

  const MyPurchasesLoaded({required this.purchases, this.invoices = const []});

  MyPurchasesLoaded copyWith({List<TemplatePurchase>? purchases, List<MarketplaceInvoice>? invoices}) {
    return MyPurchasesLoaded(purchases: purchases ?? this.purchases, invoices: invoices ?? this.invoices);
  }
}

class MyPurchasesError extends MyPurchasesState {
  final String message;
  const MyPurchasesError({required this.message});
}
