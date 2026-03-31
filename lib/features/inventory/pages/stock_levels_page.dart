import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final reorderController = TextEditingController(text: level.reorderPoint?.toStringAsFixed(2) ?? '');
    final maxController = TextEditingController(text: level.maxStockLevel?.toStringAsFixed(2) ?? '');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.inventorySetReorderPoint),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.inventoryProduct}: ${level.productName ?? level.productId}'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: reorderController,
              decoration: InputDecoration(labelText: l10n.inventoryReorderPoint, hintText: 'e.g. 10'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: maxController,
              decoration: InputDecoration(labelText: l10n.inventoryMaxStockLevelOptional, hintText: 'e.g. 100'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSave)),
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.inventoryReorderPointSaved)));
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(stockLevelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryStockLevels),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
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
                    hint: l10n.inventorySearchByProduct,
                    prefixIcon: Icons.search,
                    onSubmitted: (value) => ref.read(stockLevelsProvider.notifier).search(value),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                FilterChip(
                  label: Text(l10n.inventoryLowStock),
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
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is StockLevelsLoading || state is StockLevelsInitial;
    final error = state is StockLevelsError ? state.message : null;
    final levels = state is StockLevelsLoaded ? state.levels : <StockLevel>[];
    final loaded = state is StockLevelsLoaded ? state : null;

    return PosDataTable<StockLevel>(
      columns: [
        PosTableColumn(title: l10n.inventoryProduct),
        PosTableColumn(title: l10n.inventoryQuantity, numeric: true),
        PosTableColumn(title: l10n.inventoryReserved, numeric: true),
        PosTableColumn(title: l10n.inventoryAvgCost, numeric: true),
        PosTableColumn(title: l10n.inventoryReorderPt, numeric: true),
        PosTableColumn(title: l10n.commonStatus),
      ],
      items: levels,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stockLevelsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.inventory_2_outlined,
        title: l10n.inventoryNoStockLevels,
        subtitle: loaded?.lowStockOnly == true
            ? 'No products are below reorder point.'
            : 'Stock levels will appear once products receive inventory.',
      ),
      actions: [
        PosTableRowAction<StockLevel>(
          label: l10n.inventorySetReorderPoint,
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
                ? PosBadge(label: l10n.inventoryLowStock, variant: PosBadgeVariant.warning)
                : PosBadge(label: l10n.commonOk, variant: PosBadgeVariant.success);
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
