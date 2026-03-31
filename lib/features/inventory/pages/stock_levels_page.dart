import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/inventory/models/stock_level.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';

class StockLevelsPage extends ConsumerStatefulWidget {
  const StockLevelsPage({super.key});

  @override
  ConsumerState<StockLevelsPage> createState() => _StockLevelsPageState();
}

class _StockLevelsPageState extends ConsumerState<StockLevelsPage> {
  final _searchController = TextEditingController();
  bool _lowStockOnly = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(stockLevelsProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showReorderPointDialog(StockLevel level) async {
    final reorderController = TextEditingController(text: level.reorderPoint?.toStringAsFixed(2) ?? '');
    final maxController = TextEditingController(text: level.maxStockLevel?.toStringAsFixed(2) ?? '');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Reorder Point'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Product: ${level.productName ?? level.productId}'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: reorderController,
              decoration: const InputDecoration(labelText: 'Reorder Point', hintText: 'e.g. 10'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: maxController,
              decoration: const InputDecoration(labelText: 'Max Stock Level (optional)', hintText: 'e.g. 100'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final reorderPoint = double.tryParse(reorderController.text);
      final maxLevel = double.tryParse(maxController.text);
      if (reorderPoint != null) {
        try {
          await ref
              .read(stockLevelsProvider.notifier)
              .setReorderPoint(level.id, reorderPoint: reorderPoint, maxStockLevel: maxLevel);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reorder point updated.')));
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
          }
        }
      }
    }
    reorderController.dispose();
    maxController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockLevelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Levels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(stockLevelsProvider.notifier).load(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search + low stock filter
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _searchController,
                    hint: 'Search by product name...',
                    prefixIcon: Icons.search,
                    onSubmitted: (value) => ref.read(stockLevelsProvider.notifier).search(value),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                FilterChip(
                  label: const Text('Low Stock'),
                  selected: _lowStockOnly,
                  selectedColor: AppColors.warning,
                  onSelected: (value) {
                    setState(() => _lowStockOnly = value);
                    ref.read(stockLevelsProvider.notifier).toggleLowStockFilter(value);
                  },
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(StockLevelsState state) {
    final isLoading = state is StockLevelsLoading || state is StockLevelsInitial;
    final error = state is StockLevelsError ? state.message : null;
    final levels = state is StockLevelsLoaded ? state.levels : <StockLevel>[];
    final loaded = state is StockLevelsLoaded ? state : null;

    return PosDataTable<StockLevel>(
      columns: const [
        PosTableColumn(title: 'Product'),
        PosTableColumn(title: 'Quantity', numeric: true),
        PosTableColumn(title: 'Reserved', numeric: true),
        PosTableColumn(title: 'Avg Cost', numeric: true),
        PosTableColumn(title: 'Reorder Pt', numeric: true),
        PosTableColumn(title: 'Status'),
      ],
      items: levels,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stockLevelsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.inventory_2_outlined,
        title: 'No stock levels found',
        subtitle: loaded?.lowStockOnly == true
            ? 'No products are below reorder point.'
            : 'Stock levels will appear once products receive inventory.',
      ),
      actions: [
        PosTableRowAction<StockLevel>(
          label: 'Set reorder point',
          icon: Icons.edit_outlined,
          onTap: (level) => _showReorderPointDialog(level),
        ),
      ],
      cellBuilder: (level, colIndex, col) {
        final isLow = level.reorderPoint != null && level.quantity <= level.reorderPoint!;
        switch (colIndex) {
          case 0:
            return Text(level.productName ?? level.productId, overflow: TextOverflow.ellipsis);
          case 1:
            return Text(level.quantity.toStringAsFixed(2));
          case 2:
            return Text(level.reservedQuantity?.toStringAsFixed(2) ?? '0.00');
          case 3:
            return Text(level.averageCost?.toStringAsFixed(2) ?? '-');
          case 4:
            return Text(level.reorderPoint?.toStringAsFixed(2) ?? '-');
          case 5:
            return isLow
                ? const PosBadge(label: 'Low Stock', variant: PosBadgeVariant.warning)
                : const PosBadge(label: 'OK', variant: PosBadgeVariant.success);
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: 25,
      onPreviousPage: loaded != null ? () => ref.read(stockLevelsProvider.notifier).previousPage() : null,
      onNextPage: loaded != null ? () => ref.read(stockLevelsProvider.notifier).nextPage() : null,
    );
  }
}
