import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/predefined_catalog/models/predefined_product.dart';
import 'package:wameedpos/features/predefined_catalog/providers/predefined_catalog_providers.dart';
import 'package:wameedpos/features/predefined_catalog/providers/predefined_catalog_state.dart';

class PredefinedProductsPage extends ConsumerStatefulWidget {
  final String? businessTypeId;
  final String? categoryId;
  final String? categoryName;

  const PredefinedProductsPage({super.key, this.businessTypeId, this.categoryId, this.categoryName});

  @override
  ConsumerState<PredefinedProductsPage> createState() => _PredefinedProductsPageState();
}

class _PredefinedProductsPageState extends ConsumerState<PredefinedProductsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(predefinedProductsProvider.notifier);
      if (widget.categoryId != null) {
        notifier.filterByCategory(widget.categoryId);
      }
      notifier.load(businessTypeId: widget.businessTypeId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleCloneProduct(PredefinedProduct product) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.pcCloneProduct,
      message:
          'Clone "${product.name}" to your store?'
          '${product.nameAr != null ? '\n${product.nameAr}' : ''}'
          '\nPrice: ${product.sellPrice.toStringAsFixed(2)}',
      confirmLabel: l10n.pcClone,
      cancelLabel: l10n.commonCancel,
    );

    if (confirmed == true && mounted) {
      await ref.read(cloneProvider.notifier).cloneProduct(product.id);
      final cloneState = ref.read(cloneProvider);
      if (mounted) {
        if (cloneState is CloneSuccess) {
          showPosSuccessSnackbar(context, AppLocalizations.of(context)!.productClonedToStore(product.name));
        } else if (cloneState is CloneError) {
          showPosErrorSnackbar(context, cloneState.message);
        }
        ref.read(cloneProvider.notifier).reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productsState = ref.watch(predefinedProductsProvider);
    final cloneState = ref.watch(cloneProvider);
    final isCloning = cloneState is CloneInProgress;

    return PosListPage(
      title: widget.categoryName ?? 'Predefined Products',
      searchController: _searchController,
      onSearchChanged: (value) {
        if (value.isEmpty) {
          ref.read(predefinedProductsProvider.notifier).search(null);
        } else {
          ref.read(predefinedProductsProvider.notifier).search(value);
        }
      },
      child: Column(
        children: [
          if (isCloning) const LinearProgressIndicator(),
          Expanded(child: _buildBody(productsState)),
        ],
      ),
    );
  }

  Widget _buildBody(PredefinedProductsState state) {
    if (state is PredefinedProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PredefinedProductsError) {
      return PosErrorState(
        message: state.message,
        onRetry: () => ref.read(predefinedProductsProvider.notifier).load(businessTypeId: widget.businessTypeId),
      );
    }

    if (state is PredefinedProductsLoaded) {
      if (state.products.isEmpty) {
        return PosEmptyState(
          icon: Icons.inventory_2_outlined,
          title: l10n.pcNoPredefinedProducts,
          subtitle: state.searchQuery != null ? 'Try a different search term.' : 'No products available in this category.',
        );
      }

      return Column(
        children: [
          // Product count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Text(
                  '${state.total} products',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Product list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return _ProductCard(product: product, onClone: () => _handleCloneProduct(product));
              },
            ),
          ),

          // Pagination
          if (state.lastPage > 1)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: state.currentPage > 1 ? () => ref.read(predefinedProductsProvider.notifier).previousPage() : null,
                  ),
                  Text(l10n.pcPageOfLast(state.currentPage.toString(), state.lastPage.toString())),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: state.hasMore ? () => ref.read(predefinedProductsProvider.notifier).nextPage() : null,
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

// ─── Product Card Widget ───────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final PredefinedProduct product;
  final VoidCallback onClone;

  const _ProductCard({required this.product, required this.onClone});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PosCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: AppRadius.borderMd,
              child: SizedBox(
                width: 64,
                height: 64,
                child: product.imageUrl != null
                    ? Image.network(product.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderIcon(theme))
                    : _placeholderIcon(theme),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.nameAr != null)
                    Text(
                      product.nameAr!,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (product.sku != null) ...[
                        Text('SKU: ${product.sku}', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight)),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      if (product.unit != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderXs),
                          child: Text(product.unit!.value, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${product.sellPrice.toStringAsFixed(2)} \u0081',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                if (product.costPrice != null)
                  Text(
                    'Cost: ${product.costPrice!.toStringAsFixed(2)} \u0081',
                    style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),

            // Clone button
            PosButton(
              label: l10n.pcClone,
              icon: Icons.content_copy,
              size: PosButtonSize.sm,
              variant: PosButtonVariant.outline,
              onPressed: onClone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.inventory_2, size: 28, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}
