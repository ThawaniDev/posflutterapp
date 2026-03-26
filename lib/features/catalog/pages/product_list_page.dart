import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productsProvider.notifier).load());
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product "${product.name}" deleted.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
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
      floatingActionButton: PosButton(
        label: 'Add Product',
        icon: Icons.add,
        onPressed: () => context.push(Routes.productsAdd),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
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

          // Content
          Expanded(child: _buildBody(productsState)),
        ],
      ),
    );
  }

  Widget _buildBody(ProductsState state) {
    if (state is ProductsLoading || state is ProductsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
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

    if (state is ProductsLoaded) {
      if (state.products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No products yet', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Start by adding your first product.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: _isGridView ? _buildGrid(state.products) : _buildTable(state.products),
          ),
          PosTablePagination(
            currentPage: state.currentPage,
            totalPages: state.lastPage,
            totalItems: state.total,
            itemsPerPage: state.perPage,
            onPrevious: () => ref.read(productsProvider.notifier).previousPage(),
            onNext: () => ref.read(productsProvider.notifier).nextPage(),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<Product> products) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PosDataTable(
        columns: const [
          DataColumn(label: Text('NAME')),
          DataColumn(label: Text('SKU')),
          DataColumn(label: Text('PRICE'), numeric: true),
          DataColumn(label: Text('STATUS')),
          DataColumn(label: Text('ACTIONS')),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (product.imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(product.imageUrl!, width: 36, height: 36, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _productPlaceholder()),
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
                          Text(product.name, overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                          if (product.barcode != null)
                            Text(product.barcode!,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(product.sku ?? '—')),
              DataCell(Text('${product.sellPrice.toStringAsFixed(3)} SAR')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: product.isActive == true ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.isActive == true ? 'Active' : 'Inactive',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: product.isActive == true ? AppColors.success : AppColors.error,
                        ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit',
                      onPressed: () => context.push('${Routes.products}/${product.id}'),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                      tooltip: 'Delete',
                      onPressed: () => _handleDelete(product),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
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
      decoration: BoxDecoration(
        color: AppColors.primary10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Icons.inventory_2_outlined, size: 18, color: AppColors.primary),
    );
  }
}

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
                        child: Image.network(product.imageUrl!, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                                  child: Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.primary),
                                )),
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
                        '${product.sellPrice.toStringAsFixed(3)} SAR',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
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
