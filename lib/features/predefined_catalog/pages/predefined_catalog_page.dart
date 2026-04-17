import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/predefined_catalog/models/predefined_category.dart';
import 'package:wameedpos/features/predefined_catalog/providers/predefined_catalog_providers.dart';
import 'package:wameedpos/features/predefined_catalog/providers/predefined_catalog_state.dart';

class PredefinedCatalogPage extends ConsumerStatefulWidget {
  const PredefinedCatalogPage({super.key});

  @override
  ConsumerState<PredefinedCatalogPage> createState() => _PredefinedCatalogPageState();
}

class _PredefinedCatalogPageState extends ConsumerState<PredefinedCatalogPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
      showPosWarningSnackbar(context, AppLocalizations.of(context)!.selectBusinessTypeFirst);
      return;
    }

    final confirmed = await showPosConfirmDialog(
      context,
      title: 'Clone All Products',
      message:
          'This will clone all predefined categories and products for the '
          'selected business type to your store. Continue?',
      confirmLabel: 'Clone All',
      cancelLabel: 'Cancel',
    );

    if (confirmed == true && mounted) {
      await ref.read(cloneProvider.notifier).cloneAll(_selectedBusinessTypeId!);
      final cloneState = ref.read(cloneProvider);
      if (mounted) {
        if (cloneState is CloneSuccess) {
          final cats = cloneState.result['categories_cloned'] ?? 0;
          final prods = cloneState.result['products_cloned'] ?? 0;
          showPosSuccessSnackbar(context, AppLocalizations.of(context)!.clonedCategoriesAndProducts(cats, prods));
        } else if (cloneState is CloneError) {
          showPosErrorSnackbar(context, cloneState.message);
        }
        ref.read(cloneProvider.notifier).reset();
      }
    }
  }

  Future<void> _handleCloneCategory(PredefinedCategory category) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: 'Clone Category',
      message: 'Clone "${category.name}" and all its products to your store?',
      confirmLabel: 'Clone',
      cancelLabel: 'Cancel',
    );

    if (confirmed == true && mounted) {
      await ref.read(cloneProvider.notifier).cloneCategory(category.id);
      final cloneState = ref.read(cloneProvider);
      if (mounted) {
        if (cloneState is CloneSuccess) {
          showPosSuccessSnackbar(context, AppLocalizations.of(context)!.categoryClonedSuccessfully(category.name));
        } else if (cloneState is CloneError) {
          showPosErrorSnackbar(context, cloneState.message);
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

    return PosListPage(
      title: l10n.sidebarPredefinedCatalog,
      showSearch: false,
      actions: [
        if (_selectedBusinessTypeId != null)
          PosButton(
            label: 'Clone All',
            icon: Icons.copy_all,
            onPressed: isCloning ? null : _handleCloneAll,
            variant: PosButtonVariant.soft,
            size: PosButtonSize.sm,
          ),
      ],
      child: Column(
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

    return PosCard(
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
