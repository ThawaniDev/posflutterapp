import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_empty_state.dart';
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/features/predefined_catalog/models/predefined_category.dart';
import 'package:thawani_pos/features/predefined_catalog/providers/predefined_catalog_providers.dart';
import 'package:thawani_pos/features/predefined_catalog/providers/predefined_catalog_state.dart';

class PredefinedCatalogPage extends ConsumerStatefulWidget {
  const PredefinedCatalogPage({super.key});

  @override
  ConsumerState<PredefinedCatalogPage> createState() => _PredefinedCatalogPageState();
}

class _PredefinedCatalogPageState extends ConsumerState<PredefinedCatalogPage> {
  String? _selectedBusinessTypeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(predefinedCategoriesProvider.notifier).load();
    });
  }

  void _onBusinessTypeChanged(String? businessTypeId) {
    setState(() => _selectedBusinessTypeId = businessTypeId);
    ref.read(predefinedCategoriesProvider.notifier).filterByBusinessType(businessTypeId);
    if (businessTypeId != null) {
      ref.read(predefinedCategoryTreeProvider.notifier).load(businessTypeId);
    }
  }

  Future<void> _handleCloneAll() async {
    if (_selectedBusinessTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a business type first.')));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clone All Products'),
        content: const Text(
          'This will clone all predefined categories and products for the '
          'selected business type to your store. Continue?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clone All')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(cloneProvider.notifier).cloneAll(_selectedBusinessTypeId!);
      final cloneState = ref.read(cloneProvider);
      if (mounted) {
        if (cloneState is CloneSuccess) {
          final cats = cloneState.result['categories_cloned'] ?? 0;
          final prods = cloneState.result['products_cloned'] ?? 0;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Cloned $cats categories and $prods products to your store.')));
        } else if (cloneState is CloneError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(cloneState.message), backgroundColor: AppColors.error));
        }
        ref.read(cloneProvider.notifier).reset();
      }
    }
  }

  Future<void> _handleCloneCategory(PredefinedCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clone Category'),
        content: Text('Clone "${category.name}" and all its products to your store?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clone')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(cloneProvider.notifier).cloneCategory(category.id);
      final cloneState = ref.read(cloneProvider);
      if (mounted) {
        if (cloneState is CloneSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category "${category.name}" cloned successfully.')));
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
    final categoriesState = ref.watch(predefinedCategoriesProvider);
    final cloneState = ref.watch(cloneProvider);
    final isCloning = cloneState is CloneInProgress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Predefined Catalog'),
        actions: [
          if (_selectedBusinessTypeId != null)
            PosButton(
              label: 'Clone All',
              icon: Icons.copy_all,
              onPressed: isCloning ? null : _handleCloneAll,
              variant: PosButtonVariant.soft,
              size: PosButtonSize.sm,
            ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(predefinedCategoriesProvider.notifier).load(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Business type filter
          _buildBusinessTypeFilter(),

          // Loading overlay for cloning
          if (isCloning) const LinearProgressIndicator(),

          // Category grid
          Expanded(child: _buildBody(categoriesState)),
        ],
      ),
    );
  }

  Widget _buildBusinessTypeFilter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(Icons.business, size: 20, color: AppColors.textMutedLight),
          const SizedBox(width: AppSpacing.sm),
          const Text('Business Type:'),
          const SizedBox(width: AppSpacing.sm),
          ..._businessTypeChips(),
        ],
      ),
    );
  }

  List<Widget> _businessTypeChips() {
    const businessTypes = [
      {'id': 'grocery', 'label': 'Grocery', 'icon': Icons.local_grocery_store},
      {'id': 'pharmacy', 'label': 'Pharmacy', 'icon': Icons.local_pharmacy},
      {'id': 'electronics', 'label': 'Electronics', 'icon': Icons.devices},
      {'id': 'bakery', 'label': 'Bakery', 'icon': Icons.bakery_dining},
      {'id': 'restaurant', 'label': 'Restaurant', 'icon': Icons.restaurant},
      {'id': 'florist', 'label': 'Florist', 'icon': Icons.local_florist},
      {'id': 'jewelry', 'label': 'Jewelry', 'icon': Icons.diamond},
      {'id': 'fashion', 'label': 'Fashion', 'icon': Icons.checkroom},
    ];

    return businessTypes.map((bt) {
      final isSelected = _selectedBusinessTypeId == bt['id'];
      return Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xs),
        child: FilterChip(
          selected: isSelected,
          label: Text(bt['label'] as String),
          avatar: Icon(bt['icon'] as IconData, size: 16),
          onSelected: (selected) {
            _onBusinessTypeChanged(selected ? bt['id'] as String : null);
          },
        ),
      );
    }).toList();
  }

  Widget _buildBody(PredefinedCategoriesState state) {
    if (state is PredefinedCategoriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PredefinedCategoriesError) {
      return PosErrorState(message: state.message, onRetry: () => ref.read(predefinedCategoriesProvider.notifier).load());
    }

    if (state is PredefinedCategoriesLoaded) {
      if (state.categories.isEmpty) {
        return PosEmptyState(
          icon: Icons.category_outlined,
          title: 'No predefined categories found',
          subtitle: _selectedBusinessTypeId != null
              ? 'No categories available for this business type.'
              : 'Select a business type to browse predefined categories.',
        );
      }

      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 0.85,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return _CategoryCard(
                  category: category,
                  onTap: () => context.push(
                    Routes.predefinedCatalogProducts,
                    extra: {'businessTypeId': category.businessTypeId, 'categoryId': category.id, 'categoryName': category.name},
                  ),
                  onClone: () => _handleCloneCategory(category),
                );
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
                    onPressed: state.currentPage > 1
                        ? () => ref.read(predefinedCategoriesProvider.notifier).previousPage()
                        : null,
                  ),
                  Text('Page ${state.currentPage} of ${state.lastPage}'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: state.hasMore ? () => ref.read(predefinedCategoriesProvider.notifier).nextPage() : null,
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

// ─── Category Card Widget ──────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final PredefinedCategory category;
  final VoidCallback onTap;
  final VoidCallback onClone;

  const _CategoryCard({required this.category, required this.onTap, required this.onClone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: category.imageUrl != null
                  ? Image.network(category.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderIcon(theme))
                  : _placeholderIcon(theme),
            ),

            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.nameAr != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        category.nameAr!,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (category.productsCount != null)
                          Text(
                            '${category.productsCount} products',
                            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight),
                          ),
                        IconButton(
                          icon: const Icon(Icons.content_copy, size: 18),
                          tooltip: 'Clone to my store',
                          onPressed: onClone,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.category, size: 48, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}
