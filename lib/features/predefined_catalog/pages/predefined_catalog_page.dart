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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(predefinedCategoriesProvider.notifier).load();
    });
  }

  Future<void> _handleCloneAll() async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.pcCloneAllProducts,
      message:
          'This will clone all predefined categories and products for your '
          'business type to your store. Continue?',
      confirmLabel: l10n.pcCloneAll,
      cancelLabel: l10n.commonCancel,
    );

    if (confirmed == true && mounted) {
      await ref.read(cloneProvider.notifier).cloneAll();
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
      title: l10n.pcCloneCategory,
      message: l10n.pcCloneCategoryConfirm(category.name),
      confirmLabel: l10n.pcClone,
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
    final l10n = AppLocalizations.of(context)!;
    final categoriesState = ref.watch(predefinedCategoriesProvider);
    final cloneState = ref.watch(cloneProvider);
    final isCloning = cloneState is CloneInProgress;

    return PosListPage(
      title: l10n.sidebarPredefinedCatalog,
      showSearch: false,
      actions: [
        PosButton(
          label: l10n.pcCloneAll,
          icon: Icons.copy_all,
          onPressed: isCloning ? null : _handleCloneAll,
          variant: PosButtonVariant.soft,
          size: PosButtonSize.sm,
        ),
      ],
      child: Column(
        children: [
          // Loading overlay for cloning
          if (isCloning) const LinearProgressIndicator(),

          // Category grid
          Expanded(child: _buildBody(categoriesState)),
        ],
      ),
    );
  }

  Widget _buildBody(PredefinedCategoriesState state) {
    if (state is PredefinedCategoriesLoading) {
      return const PosLoading();
    }

    if (state is PredefinedCategoriesError) {
      return PosErrorState(message: state.message, onRetry: () => ref.read(predefinedCategoriesProvider.notifier).load());
    }

    if (state is PredefinedCategoriesLoaded) {
      if (state.categories.isEmpty) {
        return PosEmptyState(
          icon: Icons.category_outlined,
          title: l10n.pcNoPredefinedCategories,
          subtitle: 'No predefined categories available for your business type.',
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
                  Text(l10n.pcPageOfLast(state.currentPage.toString(), state.lastPage.toString())),
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
    final l10n = AppLocalizations.of(context)!;
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
                          Flexible(
                            child: Text(
                              '${category.productsCount} products',
                              style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.content_copy, size: 16),
                          tooltip: l10n.pcCloneToMyStore,
                          onPressed: onClone,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                          style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
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
