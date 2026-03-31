import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/catalog/models/category.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.name}"?\n'
          'This action will soft-delete the product.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(productsProvider.notifier).deleteProduct(product.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product "${product.name}" deleted.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  Future<void> _handleDuplicate(Product product) async {
    try {
      await ref.read(productsProvider.notifier).duplicateProduct(product.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product "${product.name}" duplicated.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _handleBulkAction(String action) async {
    try {
      await ref.read(productsProvider.notifier).bulkAction(action);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bulk $action completed.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final categoriesState = ref.watch(categoriesProvider);
    final categories = categoriesState is CategoriesLoaded ? categoriesState.categories : <Category>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            tooltip: _showFilters ? 'Hide filters' : 'Show filters',
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(productsProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'Add Product', icon: Icons.add, onPressed: () => context.push(Routes.productsAdd)),
      body: Row(
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
              hint: 'Search products by name, SKU or barcode...',
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
              decoration: BoxDecoration(color: AppColors.primary10, borderRadius: BorderRadius.circular(8)),
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
                    label: 'Activate',
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.soft,
                    icon: Icons.check_circle_outline,
                    onPressed: () => _handleBulkAction('activate'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  PosButton(
                    label: 'Deactivate',
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.outline,
                    icon: Icons.block,
                    onPressed: () => _handleBulkAction('deactivate'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  PosButton(
                    label: 'Delete',
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.danger,
                    icon: Icons.delete_outline,
                    onPressed: () => _handleBulkAction('delete'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: 'Clear selection',
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
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.textMutedLight),
          const SizedBox(width: AppSpacing.sm),
          // Category filter
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: state is ProductsLoaded ? state.selectedCategoryId : null,
              decoration: InputDecoration(
                hintText: 'All categories',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              ),
              items: [
                const DropdownMenuItem<String>(value: null, child: Text('All categories')),
                ...categories.map((c) => DropdownMenuItem<String>(value: c.id, child: Text(c.name))),
              ],
              onChanged: (id) => ref.read(productsProvider.notifier).filterByCategory(id),
            ),
          ),
          const Spacer(),
          if (state is ProductsLoaded) ...[
            Text(
              '${state.total} products',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(error, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: 'Retry',
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
            Text('No products found', style: Theme.of(context).textTheme.titleMedium),
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
      return categories.where((c) => c.id == catId).firstOrNull?.name ?? '—';
    }

    return PosDataTable<Product>(
      columns: const [
        PosTableColumn(title: 'Name'),
        PosTableColumn(title: 'SKU'),
        PosTableColumn(title: 'Category'),
        PosTableColumn(title: 'Cost', numeric: true),
        PosTableColumn(title: 'Price', numeric: true),
        PosTableColumn(title: 'Status'),
      ],
      items: products,
      selectable: true,
      selectedItems: loaded.selectedIds,
      itemId: (p) => p.id,
      onSelectItem: (p, selected) => ref.read(productsProvider.notifier).toggleSelection(p.id),
      onSelectAll: (_) => ref.read(productsProvider.notifier).selectAll(),
      actions: [
        PosTableRowAction<Product>(
          label: 'Edit',
          icon: Icons.edit_outlined,
          onTap: (p) => context.push('${Routes.products}/${p.id}'),
        ),
        PosTableRowAction<Product>(label: 'Duplicate', icon: Icons.copy_outlined, onTap: (p) => _handleDuplicate(p)),
        PosTableRowAction<Product>(
          label: 'Delete',
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
                    borderRadius: BorderRadius.circular(6),
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
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (product.barcode != null)
                        Text(
                          product.barcode!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight),
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
            return Text(product.costPrice != null ? '${product.costPrice!.toStringAsFixed(2)} SAR' : '—');
          case 4: // Price
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${product.sellPrice.toStringAsFixed(2)} SAR'),
                if (product.offerPrice != null)
                  Text(
                    '${product.offerPrice!.toStringAsFixed(2)} SAR',
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
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.isActive == true ? 'Active' : 'Inactive',
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
      decoration: BoxDecoration(color: AppColors.primary10, borderRadius: BorderRadius.circular(6)),
      child: Icon(Icons.inventory_2_outlined, size: 18, color: AppColors.primary),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Category Sidebar
// ═══════════════════════════════════════════════════════════════

class _CategorySidebar extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const _CategorySidebar({required this.categories, required this.selectedCategoryId, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
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
            child: Text('Categories', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
          ),
          // All categories option
          _SidebarItem(
            label: 'All Products',
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
          label: cat.name,
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
  final String label;
  final IconData icon;
  final bool isSelected;
  final int depth;
  final VoidCallback? onTap;

  const _SidebarItem({required this.label, required this.icon, this.isSelected = false, this.depth = 0, this.onTap});

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
              Icon(icon, size: 16, color: isSelected ? AppColors.primary : AppColors.textMutedLight),
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
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProductGridCard({required this.product, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                              Center(child: Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.primary)),
                        ),
                      )
                    : Center(child: Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.primary)),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.sellPrice.toStringAsFixed(2)} SAR',
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
