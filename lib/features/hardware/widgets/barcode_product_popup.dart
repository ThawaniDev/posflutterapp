import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/utils/formatters.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Shows a detailed product popup when a barcode is scanned.
/// If [product] is non-null, shows full product details.
/// If [product] is null, shows "Product not found" with option to add.
Future<BarcodePopupAction?> showBarcodeProductPopup(BuildContext context, {required String barcode, Product? product}) {
  if (context.isPhone) {
    return showModalBottomSheet<BarcodePopupAction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: product != null ? 0.65 : 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, controller) => _BarcodeProductContent(barcode: barcode, product: product, scrollController: controller),
      ),
    );
  }

  return showDialog<BarcodePopupAction>(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
        child: _BarcodeProductContent(barcode: barcode, product: product),
      ),
    ),
  );
}

/// Actions that can be taken from the barcode product popup.
enum BarcodePopupAction { addToCart, viewDetails, editProduct, addNewProduct }

class _BarcodeProductContent extends StatelessWidget {
  const _BarcodeProductContent({required this.barcode, this.product, this.scrollController});

  final String barcode;
  final Product? product;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: AppRadius.borderXl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        body: product != null ? _buildProductFound(context, product!, isDark) : _buildProductNotFound(context, isDark),
      ),
    );
  }

  Widget _buildProductFound(BuildContext context, Product product, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final hasOffer =
        product.offerPrice != null &&
        product.offerPrice! > 0 &&
        (product.offerEnd == null || product.offerEnd!.isAfter(DateTime.now()));

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      children: [
        // Handle bar (mobile)
        if (scrollController != null) ...[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.textMutedLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          AppSpacing.gapH12,
        ],

        // Header: icon + name + status
        Row(
          children: [
            // Product image or icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: AppRadius.borderMd,
                image: product.imageUrl != null
                    ? DecorationImage(image: NetworkImage(product.imageUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: product.imageUrl == null ? const Icon(Icons.inventory_2_rounded, size: 28, color: AppColors.primary) : null,
            ),
            AppSpacing.gapW16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTypography.headlineSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (product.nameAr != null && product.nameAr!.isNotEmpty) ...[
                    AppSpacing.gapH2,
                    Text(product.nameAr!, style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight)),
                  ],
                  AppSpacing.gapH4,
                  Row(
                    children: [
                      _statusChip(
                        product.isActive == true ? 'Active' : 'Inactive',
                        product.isActive == true ? AppColors.success : AppColors.error,
                      ),
                      if (product.isWeighable == true) ...[const SizedBox(width: 6), _statusChip('Weighable', AppColors.info)],
                      if (product.isCombo == true) ...[const SizedBox(width: 6), _statusChip('Combo', AppColors.purple)],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        AppSpacing.gapH20,

        // Barcode badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
            borderRadius: AppRadius.borderSm,
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.qr_code_scanner_rounded, size: 18, color: AppColors.primary),
              AppSpacing.gapW8,
              Expanded(
                child: Text(barcode, style: AppTypography.bodySmall.copyWith(fontFamily: 'monospace')),
              ),
              if (product.sku != null) ...[
                Container(width: 1, height: 16, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                AppSpacing.gapW8,
                Text('SKU: ${product.sku}', style: AppTypography.micro),
              ],
            ],
          ),
        ),

        AppSpacing.gapH16,

        // Pricing section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.04),
            borderRadius: AppRadius.borderMd,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.sellPrice, style: AppTypography.labelMedium),
                  Text(
                    Formatters.currency(product.sellPrice),
                    style: AppTypography.headlineSmall.copyWith(
                      color: hasOffer ? AppColors.textMutedLight : AppColors.primary,
                      decoration: hasOffer ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
              if (hasOffer) ...[
                AppSpacing.gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_offer_rounded, size: 16, color: AppColors.success),
                        AppSpacing.gapW4,
                        Text(l10n.offerPrice, style: AppTypography.labelMedium.copyWith(color: AppColors.success)),
                      ],
                    ),
                    Text(
                      Formatters.currency(product.offerPrice!),
                      style: AppTypography.headlineSmall.copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ],
              if (product.costPrice != null) ...[
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.costPrice, style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight)),
                    Text(Formatters.currency(product.costPrice!), style: AppTypography.bodySmall),
                  ],
                ),
                if (product.costPrice! > 0) ...[
                  AppSpacing.gapH4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.wameedAIBillingMargin, style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight)),
                      Text(
                        '${(((product.sellPrice - product.costPrice!) / product.sellPrice) * 100).toStringAsFixed(1)}%',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),

        AppSpacing.gapH16,

        // Detail rows
        _detailGrid(context, isDark, [
          if (product.unit != null) _DetailItem('Unit', product.unit!.value),
          if (product.taxRate != null) _DetailItem('Tax Rate', '${product.taxRate}%'),
          if (product.categoryId != null) _DetailItem('Category', product.categoryId!),
          if (product.minOrderQty != null) _DetailItem('Min Qty', '${product.minOrderQty}'),
          if (product.maxOrderQty != null) _DetailItem('Max Qty', '${product.maxOrderQty}'),
          if (product.ageRestricted == true) _DetailItem('Age Restricted', 'Yes'),
        ]),

        if (product.description != null && product.description!.isNotEmpty) ...[
          AppSpacing.gapH16,
          Text(l10n.description, style: AppTypography.labelMedium),
          AppSpacing.gapH4,
          Text(product.description!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
        ],

        AppSpacing.gapH24,

        // Actions
        Row(
          children: [
            Expanded(
              child: PosButton(
                label: 'View / Edit',
                icon: Icons.edit_rounded,
                variant: PosButtonVariant.outline,
                onPressed: () => Navigator.pop(context, BarcodePopupAction.viewDetails),
              ),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: PosButton(
                label: 'Add to Cart',
                icon: Icons.add_shopping_cart_rounded,
                onPressed: () => Navigator.pop(context, BarcodePopupAction.addToCart),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductNotFound(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      shrinkWrap: true,
      children: [
        // Handle bar (mobile)
        if (scrollController != null) ...[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.textMutedLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          AppSpacing.gapH16,
        ],

        // Icon
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.search_off_rounded, size: 36, color: AppColors.warning),
          ),
        ),
        AppSpacing.gapH16,

        Text(l10n.productNotFound, style: AppTypography.headlineSmall, textAlign: TextAlign.center),
        AppSpacing.gapH8,
        Text(
          'No product matches barcode:',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapH8,

        // Barcode display
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              borderRadius: AppRadius.borderSm,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code_rounded, size: 18, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(
                  barcode,
                  style: AppTypography.bodyMedium.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),

        AppSpacing.gapH24,

        PosButton(
          label: 'Add New Product',
          icon: Icons.add_rounded,
          isFullWidth: true,
          onPressed: () => Navigator.pop(context, BarcodePopupAction.addNewProduct),
        ),
        AppSpacing.gapH8,
        PosButton(
          label: l10n.wameedAIDismiss,
          variant: PosButtonVariant.outline,
          isFullWidth: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderLg),
      child: Text(
        label,
        style: AppTypography.micro.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _detailGrid(BuildContext context, bool isDark, List<_DetailItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
            borderRadius: AppRadius.borderSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.label, style: AppTypography.micro.copyWith(color: AppColors.textMutedLight)),
              AppSpacing.gapH2,
              Text(item.value, style: AppTypography.labelSmall),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;
  const _DetailItem(this.label, this.value);
}
