import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_empty_state.dart';
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/core/widgets/pos_loading_skeleton.dart';
import 'package:thawani_pos/features/marketplace/models/marketplace_listing.dart';
import 'package:thawani_pos/features/marketplace/providers/marketplace_providers.dart';
import 'package:thawani_pos/features/marketplace/providers/marketplace_state.dart';
import 'package:thawani_pos/core/router/route_names.dart';

class MarketplaceBrowsePage extends ConsumerStatefulWidget {
  const MarketplaceBrowsePage({super.key});

  @override
  ConsumerState<MarketplaceBrowsePage> createState() => _MarketplaceBrowsePageState();
}

class _MarketplaceBrowsePageState extends ConsumerState<MarketplaceBrowsePage> {
  final _searchController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedPricingType;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marketplaceListingsProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref
        .read(marketplaceListingsProvider.notifier)
        .load(
          search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
          categoryId: _selectedCategoryId,
          pricingType: _selectedPricingType,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceListingsProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.marketplaceTitle),
        actions: [
          PosButton(
            label: l10n.marketplaceMyPurchases,
            icon: Icons.shopping_bag_outlined,
            size: PosButtonSize.sm,
            variant: PosButtonVariant.outline,
            onPressed: () => context.push(Routes.myPurchases),
          ),
          AppSpacing.gapW16,
        ],
      ),
      body: Column(
        children: [
          // Search & filter bar
          _buildFilterBar(state, l10n, isDark),
          // Listings grid
          Expanded(
            child: switch (state) {
              MarketplaceListingsInitial() || MarketplaceListingsLoading() => PosLoadingSkeleton.list(),
              MarketplaceListingsError(:final message) => PosErrorState(
                message: message,
                onRetry: () => ref.read(marketplaceListingsProvider.notifier).load(),
              ),
              MarketplaceListingsLoaded(:final listings) when listings.isEmpty => PosEmptyState(
                icon: Icons.storefront_outlined,
                title: l10n.marketplaceNoListings,
                subtitle: l10n.marketplaceNoListingsSubtitle,
              ),
              MarketplaceListingsLoaded(:final listings, :final currentPage, :final totalPages) => _buildListingsContent(
                listings,
                currentPage,
                totalPages,
                l10n,
                isDark,
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(MarketplaceListingsState state, AppLocalizations l10n, bool isDark) {
    // Extract categories from loaded state
    final categories = state is MarketplaceListingsLoaded ? state.categories : <dynamic>[];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Column(
        children: [
          // Search row
          Row(
            children: [
              Expanded(
                child: PosSearchField(
                  controller: _searchController,
                  hint: l10n.marketplaceSearch,
                  onChanged: (_) => _applyFilters(),
                ),
              ),
            ],
          ),
          AppSpacing.gapH8,
          // Filter pills row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Pricing type filters
                PosButton.pill(
                  label: l10n.marketplaceAll,
                  isSelected: _selectedPricingType == null,
                  onPressed: () {
                    setState(() => _selectedPricingType = null);
                    _applyFilters();
                  },
                ),
                AppSpacing.gapW8,
                PosButton.pill(
                  label: l10n.marketplaceFree,
                  isSelected: _selectedPricingType == 'free',
                  onPressed: () {
                    setState(() => _selectedPricingType = 'free');
                    _applyFilters();
                  },
                ),
                AppSpacing.gapW8,
                PosButton.pill(
                  label: l10n.marketplaceOneTime,
                  isSelected: _selectedPricingType == 'one-time',
                  onPressed: () {
                    setState(() => _selectedPricingType = 'one-time');
                    _applyFilters();
                  },
                ),
                AppSpacing.gapW8,
                PosButton.pill(
                  label: l10n.marketplaceSubscription,
                  isSelected: _selectedPricingType == 'subscription',
                  onPressed: () {
                    setState(() => _selectedPricingType = 'subscription');
                    _applyFilters();
                  },
                ),
                if (categories.isNotEmpty) ...[
                  AppSpacing.gapW16,
                  Container(width: 1, height: 24, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  AppSpacing.gapW16,
                  // Category filters
                  ...categories.map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PosButton.pill(
                        label: cat.name,
                        isSelected: _selectedCategoryId == cat.id,
                        onPressed: () {
                          setState(() {
                            _selectedCategoryId = _selectedCategoryId == cat.id ? null : cat.id;
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingsContent(
    List<MarketplaceListing> listings,
    int currentPage,
    int totalPages,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: listings.length,
            itemBuilder: (context, index) => _buildListingCard(listings[index], l10n, isDark),
          ),
        ),
        // Pagination
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PosButton.icon(
                  icon: Icons.chevron_left_rounded,
                  onPressed: currentPage > 1 ? () => ref.read(marketplaceListingsProvider.notifier).previousPage() : null,
                ),
                AppSpacing.gapW16,
                Text('${l10n.marketplacePage} $currentPage / $totalPages', style: AppTypography.labelSmall),
                AppSpacing.gapW16,
                PosButton.icon(
                  icon: Icons.chevron_right_rounded,
                  onPressed: currentPage < totalPages ? () => ref.read(marketplaceListingsProvider.notifier).nextPage() : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildListingCard(MarketplaceListing listing, AppLocalizations l10n, bool isDark) {
    return GestureDetector(
      onTap: () => context.push('${Routes.marketplace}/${listing.id}'),
      child: PosCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: listing.previewImageUrl != null
                    ? Image.network(listing.previewImageUrl!, fit: BoxFit.cover)
                    : Container(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        child: Icon(Icons.storefront_rounded, size: 40, color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(listing.title, style: AppTypography.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    AppSpacing.gapH4,
                    // Category
                    if (listing.categoryName != null)
                      Text(
                        listing.categoryName!,
                        style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      ),
                    const Spacer(),
                    // Rating + downloads
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                        AppSpacing.gapW4,
                        Text(
                          listing.averageRating.toStringAsFixed(1),
                          style: AppTypography.micro.copyWith(fontWeight: FontWeight.w600),
                        ),
                        AppSpacing.gapW8,
                        Icon(
                          Icons.download_rounded,
                          size: 14,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        AppSpacing.gapW4,
                        Text(
                          '${listing.downloadCount}',
                          style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                        ),
                      ],
                    ),
                    AppSpacing.gapH8,
                    // Price badge
                    _pricingBadge(listing, l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pricingBadge(MarketplaceListing listing, AppLocalizations l10n) {
    if (listing.isFree) {
      return PosBadge(label: l10n.marketplaceFree, variant: PosBadgeVariant.success);
    }
    if (listing.isSubscription) {
      return PosBadge(label: '${listing.priceAmount}/${listing.subscriptionInterval}', variant: PosBadgeVariant.info);
    }
    return PosBadge(label: '${listing.priceAmount} ${l10n.marketplaceCurrency}', variant: PosBadgeVariant.primary);
  }
}
