import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/core/widgets/pos_loading_skeleton.dart';
import 'package:thawani_pos/features/marketplace/models/template_review.dart';
import 'package:thawani_pos/features/marketplace/providers/marketplace_providers.dart';
import 'package:thawani_pos/features/marketplace/providers/marketplace_state.dart';

class MarketplaceListingDetailPage extends ConsumerStatefulWidget {
  const MarketplaceListingDetailPage({super.key, required this.listingId});

  final String listingId;

  @override
  ConsumerState<MarketplaceListingDetailPage> createState() => _MarketplaceListingDetailPageState();
}

class _MarketplaceListingDetailPageState extends ConsumerState<MarketplaceListingDetailPage> {
  int _selectedScreenshot = 0;
  final _reviewController = TextEditingController();
  int _reviewRating = 5;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marketplaceDetailProvider(widget.listingId).notifier).load());
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceDetailProvider(widget.listingId));
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(state is MarketplaceDetailLoaded ? state.listing.name : l10n.marketplaceListingDetail)),
      body: switch (state) {
        MarketplaceDetailInitial() || MarketplaceDetailLoading() => PosLoadingSkeleton.list(),
        MarketplaceDetailPurchasing() => const Center(child: CircularProgressIndicator()),
        MarketplaceDetailError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(marketplaceDetailProvider(widget.listingId).notifier).load(),
        ),
        MarketplaceDetailLoaded(:final listing, :final reviews, :final hasAccess) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Screenshots + description
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Screenshot gallery
                    if (listing.screenshotUrls.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: AppRadius.borderMd,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(listing.screenshotUrls[_selectedScreenshot], fit: BoxFit.cover),
                        ),
                      ),
                      AppSpacing.gapH8,
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: listing.screenshotUrls.length,
                          separatorBuilder: (_, __) => AppSpacing.gapW8,
                          itemBuilder: (context, index) {
                            final isActive = index == _selectedScreenshot;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedScreenshot = index),
                              child: Container(
                                width: 96,
                                decoration: BoxDecoration(
                                  borderRadius: AppRadius.borderSm,
                                  border: Border.all(
                                    color: isActive ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                    width: isActive ? 2 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: AppRadius.borderSm,
                                  child: Image.network(listing.screenshotUrls[index], fit: BoxFit.cover),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      AppSpacing.gapH16,
                    ],
                    // Description
                    Text(l10n.marketplaceDescription, style: AppTypography.titleSmall),
                    AppSpacing.gapH8,
                    Text(
                      listing.description ?? '',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    AppSpacing.gapH24,
                    // Reviews section
                    _buildReviewsSection(reviews, l10n, isDark),
                  ],
                ),
              ),
              AppSpacing.gapW24,
              // Right: Purchase card + stats
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildPurchaseCard(listing, hasAccess, l10n, isDark),
                    AppSpacing.gapH16,
                    _buildStatsCard(listing, l10n, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      },
    );
  }

  Widget _buildPurchaseCard(dynamic listing, bool hasAccess, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price display
          if (listing.isFree)
            Text(l10n.marketplaceFree, style: AppTypography.headlineSmall.copyWith(color: AppColors.success))
          else if (listing.isSubscription)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${listing.subscriptionPrice}', style: AppTypography.headlineSmall.copyWith(color: AppColors.primary)),
                Text(
                  '/ ${listing.subscriptionInterval}',
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            )
          else
            Text(
              '${listing.price} ${l10n.marketplaceCurrency}',
              style: AppTypography.headlineSmall.copyWith(color: AppColors.primary),
            ),
          AppSpacing.gapH16,
          // Access status + purchase button
          if (hasAccess)
            Column(
              children: [
                PosBadge(label: l10n.marketplaceOwned, variant: PosBadgeVariant.success),
                AppSpacing.gapH8,
                PosButton(
                  label: l10n.marketplaceInstall,
                  icon: Icons.download_rounded,
                  isFullWidth: true,
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.marketplaceInstallSuccess), backgroundColor: AppColors.success));
                  },
                ),
              ],
            )
          else
            PosButton(
              label: l10n.marketplacePurchase,
              icon: Icons.shopping_cart_rounded,
              isFullWidth: true,
              onPressed: () => _showPurchaseConfirmation(listing, l10n),
            ),
          AppSpacing.gapH12,
          // Published by
          Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              AppSpacing.gapW4,
              Expanded(
                child: Text(
                  listing.publishedBy ?? l10n.marketplaceUnknownPublisher,
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(dynamic listing, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _statRow(
            Icons.star_rounded,
            Colors.amber,
            l10n.marketplaceRating,
            '${listing.averageRating.toStringAsFixed(1)} (${listing.reviewCount})',
            isDark,
          ),
          AppSpacing.gapH12,
          _statRow(Icons.download_rounded, AppColors.primary, l10n.marketplaceDownloads, '${listing.downloadCount}', isDark),
          if (listing.categoryName != null) ...[
            AppSpacing.gapH12,
            _statRow(Icons.category_rounded, AppColors.info, l10n.marketplaceCategory, listing.categoryName!, isDark),
          ],
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, Color iconColor, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        AppSpacing.gapW8,
        Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
        const Spacer(),
        Text(value, style: AppTypography.labelSmall),
      ],
    );
  }

  // ─── Reviews ──────────────────────────────────────────────────

  Widget _buildReviewsSection(List<TemplateReview> reviews, AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.marketplaceReviews, style: AppTypography.titleSmall),
            AppSpacing.gapW8,
            PosBadge(label: '${reviews.length}', variant: PosBadgeVariant.neutral),
          ],
        ),
        AppSpacing.gapH12,
        // Submit review form
        PosCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.marketplaceWriteReview, style: AppTypography.labelSmall),
              AppSpacing.gapH8,
              // Star rating selector
              Row(
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => _reviewRating = i + 1),
                    child: Icon(
                      i < _reviewRating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 28,
                    ),
                  );
                }),
              ),
              AppSpacing.gapH8,
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(hintText: l10n.marketplaceReviewHint, border: const OutlineInputBorder()),
              ),
              AppSpacing.gapH8,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: PosButton(
                  label: l10n.marketplaceSubmitReview,
                  size: PosButtonSize.sm,
                  onPressed: () {
                    if (_reviewController.text.trim().isEmpty) return;
                    ref.read(marketplaceDetailProvider(widget.listingId).notifier).submitReview({
                      'rating': _reviewRating,
                      'comment': _reviewController.text.trim(),
                    });
                    _reviewController.clear();
                    setState(() => _reviewRating = 5);
                  },
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapH16,
        // Existing reviews
        ...reviews.map(
          (review) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PosCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(review.reviewerName ?? l10n.marketplaceAnonymous, style: AppTypography.labelSmall),
                      const Spacer(),
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  if (review.comment != null && review.comment!.isNotEmpty) ...[
                    AppSpacing.gapH4,
                    Text(
                      review.comment!,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Purchase Confirmation ────────────────────────────────────

  void _showPurchaseConfirmation(dynamic listing, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.marketplacePurchaseConfirm),
        content: Text(
          listing.isFree
              ? l10n.marketplacePurchaseFreeConfirm
              : '${l10n.marketplacePurchaseChargeConfirm} ${listing.price ?? listing.subscriptionPrice}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.layoutCancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(marketplaceDetailProvider(widget.listingId).notifier).purchase({'listing_id': widget.listingId});
            },
            child: Text(l10n.marketplaceConfirm),
          ),
        ],
      ),
    );
  }
}
