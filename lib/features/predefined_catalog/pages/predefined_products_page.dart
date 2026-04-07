import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_empty_state.dart';
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/features/predefined_catalog/models/predefined_product.dart';
import 'package:thawani_pos/features/predefined_catalog/providers/predefined_catalog_providers.dart';
import 'package:thawani_pos/features/predefined_catalog/providers/predefined_catalog_state.dart';

class PredefinedProductsPage extends ConsumerStatefulWidget {
  final String? businessTypeId;
  final String? categoryId;
  final String? categoryName;

  const PredefinedProductsPage({super.key, this.businessTypeId, this.categoryId, this.categoryName});

  @override
  ConsumerState<PredefinedProductsPage> createState() => _PredefinedProductsPageState();
}

class _PredefinedProductsPageState extends ConsumerState<PredefinedProductsPage> {
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clone Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clone "${product.name}" to your store?'),
            const SizedBox(height: AppSpacing.sm),
            if (product.nameAr != null)
              Text(
                product.nameAr!,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: AppSpacing.xs),
            Text('Price: ${product.sellPrice.toStringAsFixed(2)} \u0081', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clone')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(cloneProvider.notifier).cloneProduct(product.id);
      final cloneState = ref.read(cloneProvider);
      if (mounted) {
        if (cloneState is CloneSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product "${product.name}" cloned to your store.')));
        } else if (cloneState is CloneError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(cloneState.message), backgroundColor: AppColors.error));
        }
        ref.read(cloneProvider.notifier).reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(predefinedProductsProvider);
    final cloneState = ref.watch(cloneProvider);
    final isCloning = cloneState is CloneInProgress;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? 'Predefined Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(predefinedProductsProvider.notifier).load(businessTypeId: widget.businessTypeId),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PosTextField(
              controller: _searchController,
              hint: 'Search products...',
              prefixIcon: Icons.search,
              suffixIcon: Icons.clear,
              onSubmitted: (value) => ref.read(predefinedProductsProvider.notifier).search(value),
              onChanged: (value) {
                if (value.isEmpty) {
                  ref.read(predefinedProductsProvider.notifier).search(null);
                }
              },
            ),
          ),

          if (isCloning) const LinearProgressIndicator(),

          // Content
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
          title: 'No predefined products found',
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
                  Text('Page ${state.currentPage} of ${state.lastPage}'),
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
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
                          decoration: BoxDecoration(color: AppColors.primary10, borderRadius: BorderRadius.circular(4)),
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
              label: 'Clone',
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
