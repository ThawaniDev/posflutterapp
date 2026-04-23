import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/utils/locale_helpers.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  bool _isGridView = false;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productsProvider.notifier).load();
      ref.read(categoriesProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete(Product product) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.catalogDeleteProductTitle,
      message:
          'Are you sure you want to delete "${localizedName(context, name: product.name, nameAr: product.nameAr)}"?\n'
          'This action will soft-delete the product.',
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(productsProvider.notifier).deleteProduct(product.id);
        if (mounted) {
          showPosSuccessSnackbar(
            context,
            AppLocalizations.of(context)!.productDeleted(localizedName(context, name: product.name, nameAr: product.nameAr)),
          );
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  Future<void> _handleDuplicate(Product product) async {
    try {
      await ref.read(productsProvider.notifier).duplicateProduct(product.id);
      if (mounted) {
        showPosSuccessSnackbar(
          context,
          AppLocalizations.of(context)!.productDuplicated(localizedName(context, name: product.name, nameAr: product.nameAr)),
        );
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    }
  }

  Future<void> _handleBulkAction(String action) async {
    try {
      await ref.read(productsProvider.notifier).bulkAction(action);
      if (mounted) {
        showPosSuccessSnackbar(context, AppLocalizations.of(context)!.bulkActionCompleted(action));
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final categoriesState = ref.watch(categoriesProvider);
    final categories = categoriesState is CategoriesLoaded ? categoriesState.categories : <Category>[];
    final isMobile = context.isPhone;

    return PosListPage(
      title: l10n.products,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
          onPressed: () => showProductListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: _showFilters ? Icons.filter_list_off : Icons.filter_list,
          tooltip: _showFilters ? 'Hide filters' : 'Show filters',
          onPressed: () => setState(() => _showFilters = !_showFilters),
          variant: PosButtonVariant.ghost,
        ),
        if (!isMobile)
          PosButton.icon(
            icon: _isGridView ? Icons.view_list : Icons.grid_view,
            tooltip: _isGridView ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _isGridView = !_isGridView),
            variant: PosButtonVariant.ghost,
          ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(productsProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.upload_file,
          tooltip: l10n.catalogBulkImportTitle,
          onPressed: () => context.push(Routes.productsImport),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.catalogAddProduct, icon: Icons.add, onPressed: () => context.push(Routes.productsAdd)),
      ],
      child: isMobile
          ? _buildMobileBody(productsState, categories)
          : Row(
              children: [
                // ─── Category sidebar ─────────────────────────────────
                _CategorySidebar(
                  categories: categories,
                  selectedCategoryId: productsState is ProductsLoaded ? productsState.selectedCategoryId : null,
                  onCategorySelected: (id) => ref.read(productsProvider.notifier).filterByCategory(id),
                ),

                // Divider
                const VerticalDivider(width: 1, thickness: 1),

                // ─── Main content ─────────────────────────────────────
                Expanded(
                  child: Column(
                    children: [
                      // Search + bulk bar
                      _buildToolbar(productsState),

                      // Filters panel
                      if (_showFilters) _buildFilterPanel(categories, productsState),

                      // Content
                      Expanded(child: _buildBody(productsState, categories)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Mobile Body
  // ═══════════════════════════════════════════════════════════════

  Widget _buildMobileBody(ProductsState productsState, List<Category> categories) {
    final selectedCategoryId = productsState is ProductsLoaded ? productsState.selectedCategoryId : null;

    return Column(
      children: [
        // Search bar
        MobileToolbar(
          searchController: _searchController,
          searchHint: l10n.catalogSearchProductsShort,
          onSearch: (value) => ref.read(productsProvider.notifier).search(value),
          onSearchChanged: (value) {
            if (value.isEmpty) ref.read(productsProvider.notifier).search(null);
          },
        ),

        // Category chips (horizontal scroll)
        if (categories.isNotEmpty)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip('All', null, selectedCategoryId == null),
                ...categories
                    .where((c) => c.parentId == null)
                    .map(
                      (c) => _buildCategoryChip(
                        localizedName(context, name: c.name, nameAr: c.nameAr),
                        c.id,
                        selectedCategoryId == c.id,
                      ),
                    ),
              ],
            ),
          ),

        // Filters panel
        if (_showFilters) _buildMobileFilterPanel(categories, productsState),

        // Product list
        Expanded(child: _buildMobileProductList(productsState, categories)),
      ],
    );
  }

  Widget _buildCategoryChip(String label, String? id, bool selected) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => ref.read(productsProvider.notifier).filterByCategory(id),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildMobileFilterPanel(List<Category> categories, ProductsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          if (state is ProductsLoaded)
            Text(
              '${state.total} products',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
            ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view, size: 16),
            label: Text(_isGridView ? 'List' : 'Grid', style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileProductList(ProductsState state, List<Category> categories) {
    final isLoading = state is ProductsLoading || state is ProductsInitial;
    final error = state is ProductsError ? state.message : null;
    final loaded = state is ProductsLoaded ? state : null;
    final products = loaded?.products ?? <Product>[];

    if (isLoading) return const PosLoading();

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH12,
            Text(error, textAlign: TextAlign.center),
            AppSpacing.gapH16,
            PosButton(
              onPressed: () => ref.read(productsProvider.notifier).load(),
              variant: PosButtonVariant.soft,
              label: l10n.retry,
            ),
          ],
        ),
      );
    }

    if (loaded != null && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 56, color: Theme.of(context).hintColor),
            AppSpacing.gapH12,
            Text(l10n.posNoProducts),
          ],
        ),
      );
    }

    if (loaded == null) return const SizedBox.shrink();

    if (_isGridView) {
      return Column(
        children: [
          Expanded(child: _buildGrid(products)),
          _MobilePaginationBar(
            currentPage: loaded.currentPage,
            totalPages: loaded.lastPage,
            totalItems: loaded.total,
            onPrevious: () => ref.read(productsProvider.notifier).previousPage(),
            onNext: () => ref.read(productsProvider.notifier).nextPage(),
          ),
        ],
      );
    }

    String categoryName(String? catId) {
      if (catId == null) return '';
      final cat = categories.where((c) => c.id == catId).firstOrNull;
      if (cat == null) return '';
      return localizedName(context, name: cat.name, nameAr: cat.nameAr);
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.read(productsProvider.notifier).load(),
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return MobileListCard(
                  onTap: () => context.push('${Routes.products}/${product.id}'),
                  leading: ClipRRect(
                    borderRadius: AppRadius.borderMd,
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _mobileProductPlaceholder(),
                          )
                        : _mobileProductPlaceholder(),
                  ),
                  title: Text(
                    localizedName(context, name: product.name, nameAr: product.nameAr),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    [
                      if (product.sku != null) 'SKU: ${product.sku}',
                      if (product.barcode != null) product.barcode,
                      categoryName(product.categoryId),
                    ].where((s) => s != null && s.isNotEmpty).join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${product.sellPrice.toStringAsFixed(2)} ﷼',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      if (product.offerPrice != null)
                        Text(
                          '${product.offerPrice!.toStringAsFixed(2)} ﷼',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                        ),
                      AppSpacing.gapH4,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: product.isActive == true
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: AppRadius.borderXs,
                        ),
                        child: Text(
                          product.isActive == true ? l10n.active : l10n.inactive,
                          style: TextStyle(
                            fontSize: 10,
                            color: product.isActive == true ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        _MobilePaginationBar(
          currentPage: loaded.currentPage,
          totalPages: loaded.lastPage,
          totalItems: loaded.total,
          onPrevious: () => ref.read(productsProvider.notifier).previousPage(),
          onNext: () => ref.read(productsProvider.notifier).nextPage(),
        ),
      ],
    );
  }

  Widget _mobileProductPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderMd),
      child: const Icon(Icons.inventory_2_outlined, size: 24, color: AppColors.primary),
    );
  }

  Widget _buildToolbar(ProductsState state) {
    final hasSelection = state is ProductsLoaded && state.hasSelection;
    final selectedCount = state is ProductsLoaded ? state.selectedIds.length : 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Search
          Expanded(
            child: PosTextField(
              controller: _searchController,
              hint: l10n.catalogSearchProductsFull,
              prefixIcon: Icons.search,
              suffixIcon: Icons.clear,
              onSubmitted: (value) => ref.read(productsProvider.notifier).search(value),
              onChanged: (value) {
                if (value.isEmpty) {
                  ref.read(productsProvider.notifier).search(null);
                }
              },
            ),
          ),

          // Bulk action bar (appears when items selected)
          if (hasSelection) ...[
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderMd),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$selectedCount selected',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  PosButton(
                    label: l10n.activate,
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.soft,
                    icon: Icons.check_circle_outline,
                    onPressed: () => _handleBulkAction('activate'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  PosButton(
                    label: l10n.posDeactivate,
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.outline,
                    icon: Icons.block,
                    onPressed: () => _handleBulkAction('deactivate'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  PosButton(
                    label: l10n.delete,
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.danger,
                    icon: Icons.delete_outline,
                    onPressed: () => _handleBulkAction('delete'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: l10n.catalogClearSelection,
                    onPressed: () => ref.read(productsProvider.notifier).clearSelection(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterPanel(List<Category> categories, ProductsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.mutedFor(context)),
          const SizedBox(width: AppSpacing.sm),
          // Category filter
          SizedBox(
            width: 220,
            child: PosSearchableDropdown<String>(
              selectedValue: state is ProductsLoaded ? state.selectedCategoryId : null,
              items: categories
                  .map(
                    (c) => PosDropdownItem(
                      value: c.id,
                      label: localizedName(context, name: c.name, nameAr: c.nameAr),
                    ),
                  )
                  .toList(),
              onChanged: (id) => ref.read(productsProvider.notifier).filterByCategory(id),
              hint: l10n.catalogAllCategories,
              clearable: true,
            ),
          ),
          const Spacer(),
          if (state is ProductsLoaded) ...[
            Text(
              '${state.total} products',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(ProductsState state, List<Category> categories) {
    final isLoading = state is ProductsLoading || state is ProductsInitial;
    final error = state is ProductsError ? state.message : null;
    final loaded = state is ProductsLoaded ? state : null;
    final products = loaded?.products ?? <Product>[];

    if (isLoading) {
      return const PosLoading();
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(error, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: l10n.retry,
              onPressed: () => ref.read(productsProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (loaded != null && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.posNoProducts, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              loaded.searchQuery != null ? 'Try a different search term.' : 'Start by adding your first product.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (loaded == null) return const SizedBox.shrink();

    if (_isGridView) {
      return Column(
        children: [
          Expanded(child: _buildGrid(products)),
          PosTablePagination(
            currentPage: loaded.currentPage,
            totalPages: loaded.lastPage,
            totalItems: loaded.total,
            itemsPerPage: loaded.perPage,
            onPrevious: () => ref.read(productsProvider.notifier).previousPage(),
            onNext: () => ref.read(productsProvider.notifier).nextPage(),
          ),
        ],
      );
    }

    String categoryName(String? catId) {
      if (catId == null) return '—';
      final cat = categories.where((c) => c.id == catId).firstOrNull;
      if (cat == null) return '—';
      return localizedName(context, name: cat.name, nameAr: cat.nameAr);
    }

    return PosDataTable<Product>(
      columns: [
        PosTableColumn(title: l10n.name),
        PosTableColumn(title: l10n.catalogSku),
        PosTableColumn(title: l10n.category),
        PosTableColumn(title: l10n.cost, numeric: true),
        PosTableColumn(title: l10n.wameedAIPrice, numeric: true),
        PosTableColumn(title: l10n.status),
      ],
      items: products,
      selectable: true,
      selectedItems: loaded.selectedIds,
      itemId: (p) => p.id,
      onSelectItem: (p, selected) => ref.read(productsProvider.notifier).toggleSelection(p.id),
      onSelectAll: (_) => ref.read(productsProvider.notifier).selectAll(),
      actions: [
        PosTableRowAction<Product>(
          label: l10n.edit,
          icon: Icons.edit_outlined,
          onTap: (p) => context.push('${Routes.products}/${p.id}'),
        ),
        PosTableRowAction<Product>(label: l10n.labelDuplicate, icon: Icons.copy_outlined, onTap: (p) => _handleDuplicate(p)),
        PosTableRowAction<Product>(
          label: l10n.delete,
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: (p) => _handleDelete(p),
        ),
      ],
      cellBuilder: (product, colIndex, col) {
        switch (colIndex) {
          case 0: // Name
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (product.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: AppRadius.borderSm,
                    child: Image.network(
                      product.imageUrl!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _productPlaceholder(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ] else ...[
                  _productPlaceholder(),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizedName(context, name: product.name, nameAr: product.nameAr),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (product.barcode != null)
                        Text(
                          product.barcode!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedFor(context)),
                        ),
                    ],
                  ),
                ),
              ],
            );
          case 1: // SKU
            return Text(product.sku ?? '—');
          case 2: // Category
            return Text(categoryName(product.categoryId));
          case 3: // Cost
            return Text(product.costPrice != null ? '${product.costPrice!.toStringAsFixed(2)} \u0081' : '—');
          case 4: // Price
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${product.sellPrice.toStringAsFixed(2)} \u0081'),
                if (product.offerPrice != null)
                  Text(
                    '${product.offerPrice!.toStringAsFixed(2)} \u0081',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                  ),
              ],
            );
          case 5: // Status
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: product.isActive == true
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppRadius.borderXs,
              ),
              child: Text(
                product.isActive == true ? l10n.active : l10n.inactive,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: product.isActive == true ? AppColors.success : AppColors.error),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded.currentPage,
      totalPages: loaded.lastPage,
      totalItems: loaded.total,
      itemsPerPage: loaded.perPage,
      onPreviousPage: () => ref.read(productsProvider.notifier).previousPage(),
      onNextPage: () => ref.read(productsProvider.notifier).nextPage(),
    );
  }

  Widget _buildGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductGridCard(
          product: product,
          onTap: () => context.push('${Routes.products}/${product.id}'),
          onDelete: () => _handleDelete(product),
        );
      },
    );
  }

  Widget _productPlaceholder() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderSm),
      child: const Icon(Icons.inventory_2_outlined, size: 18, color: AppColors.primary),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Category Sidebar
// ═══════════════════════════════════════════════════════════════

class _CategorySidebar extends StatelessWidget {

  const _CategorySidebar({required this.categories, required this.selectedCategoryId, required this.onCategorySelected});
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (categories.isEmpty) return const SizedBox.shrink();

    final roots = categories.where((c) => c.parentId == null).toList()
      ..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));

    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(l10n.categories, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          ),
          // All categories option
          _SidebarItem(
            label: AppLocalizations.of(context)!.catalogAllProducts,
            icon: Icons.inventory_2_outlined,
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              children: _buildNodes(context, roots, 0),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNodes(BuildContext context, List<Category> nodes, int depth) {
    final widgets = <Widget>[];
    for (final cat in nodes) {
      widgets.add(
        _SidebarItem(
          label: localizedName(context, name: cat.name, nameAr: cat.nameAr),
          icon: Icons.category_outlined,
          isSelected: selectedCategoryId == cat.id,
          depth: depth,
          onTap: () => onCategorySelected(cat.id),
        ),
      );
      final children = categories.where((c) => c.parentId == cat.id).toList()
        ..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
      if (children.isNotEmpty) {
        widgets.addAll(_buildNodes(context, children, depth + 1));
      }
    }
    return widgets;
  }
}

class _SidebarItem extends StatelessWidget {

  const _SidebarItem({required this.label, required this.icon, this.isSelected = false, this.depth = 0, this.onTap});
  final String label;
  final IconData icon;
  final bool isSelected;
  final int depth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary10 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md + (depth * 16.0),
            right: AppSpacing.sm,
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: isSelected ? AppColors.primary : AppColors.mutedFor(context)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.primary : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Product Grid Card (unchanged)
// ═══════════════════════════════════════════════════════════════

class _ProductGridCard extends StatelessWidget {

  const _ProductGridCard({required this.product, required this.onTap, required this.onDelete});
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,

      border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Center(child: Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.primary)),
                        ),
                      )
                    : const Center(child: Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.primary)),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedName(context, name: product.name, nameAr: product.nameAr),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapH2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.sellPrice.toStringAsFixed(2)} \u0081',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: product.isActive == true ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Mobile Pagination Bar (local to this file)
// ═══════════════════════════════════════════════════════════════

class _MobilePaginationBar extends StatelessWidget {
  const _MobilePaginationBar({
    required this.currentPage,
    required this.totalPages,
    this.totalItems,
    this.onPrevious,
    this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final int? totalItems;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          if (totalItems != null)
            Text('$totalItems items', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: currentPage > 1 ? onPrevious : null,
            visualDensity: VisualDensity.compact,
          ),
          Text('$currentPage / $totalPages', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: currentPage < totalPages ? onNext : null,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
