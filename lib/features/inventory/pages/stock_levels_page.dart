import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
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
            Text('Product: ${level.productId}'),
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
    if (state is StockLevelsLoading || state is StockLevelsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is StockLevelsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: 'Retry',
              onPressed: () => ref.read(stockLevelsProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is StockLevelsLoaded) {
      if (state.levels.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No stock levels found', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                state.lowStockOnly
                    ? 'No products are below reorder point.'
                    : 'Stock levels will appear once products receive inventory.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(child: _buildTable(state.levels)),
          PosTablePagination(
            currentPage: state.currentPage,
            totalPages: state.lastPage,
            totalItems: state.total,
            itemsPerPage: 25,
            onPrevious: () => ref.read(stockLevelsProvider.notifier).previousPage(),
            onNext: () => ref.read(stockLevelsProvider.notifier).nextPage(),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<StockLevel> levels) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PosDataTable(
        columns: const [
          DataColumn(label: Text('PRODUCT')),
          DataColumn(label: Text('QUANTITY'), numeric: true),
          DataColumn(label: Text('RESERVED'), numeric: true),
          DataColumn(label: Text('AVG COST'), numeric: true),
          DataColumn(label: Text('REORDER PT'), numeric: true),
          DataColumn(label: Text('STATUS')),
          DataColumn(label: Text('ACTIONS')),
        ],
        rows: levels.map((level) {
          final isLow = level.reorderPoint != null && level.quantity <= level.reorderPoint!;
          return DataRow(
            cells: [
              DataCell(Text(level.productId, overflow: TextOverflow.ellipsis)),
              DataCell(Text(level.quantity.toStringAsFixed(2))),
              DataCell(Text(level.reservedQuantity?.toStringAsFixed(2) ?? '0.00')),
              DataCell(Text(level.averageCost?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(level.reorderPoint?.toStringAsFixed(2) ?? '-')),
              DataCell(
                isLow
                    ? const PosBadge(label: 'Low Stock', variant: PosBadgeVariant.warning)
                    : const PosBadge(label: 'OK', variant: PosBadgeVariant.success),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Set reorder point',
                  onPressed: () => _showReorderPointDialog(level),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
