import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/inventory/models/stock_movement.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';

class StockMovementsPage extends ConsumerStatefulWidget {
  final String? productId;

  const StockMovementsPage({super.key, this.productId});

  @override
  ConsumerState<StockMovementsPage> createState() => _StockMovementsPageState();
}

class _StockMovementsPageState extends ConsumerState<StockMovementsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(stockMovementsProvider.notifier).load(productId: widget.productId));
  }

  PosBadgeVariant _badgeVariant(String type) {
    if (type.contains('in') || type == 'receipt') return PosBadgeVariant.success;
    if (type.contains('out') || type == 'sale' || type == 'waste') return PosBadgeVariant.error;
    return PosBadgeVariant.info;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockMovementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Movements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(stockMovementsProvider.notifier).load(productId: widget.productId),
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(StockMovementsState state) {
    if (state is StockMovementsLoading || state is StockMovementsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is StockMovementsError) {
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
              onPressed: () => ref.read(stockMovementsProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is StockMovementsLoaded) {
      if (state.movements.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No stock movements yet', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(child: _buildTable(state.movements)),
          PosTablePagination(
            currentPage: state.currentPage,
            totalPages: state.lastPage,
            totalItems: state.total,
            itemsPerPage: 25,
            onPrevious: () => ref.read(stockMovementsProvider.notifier).previousPage(),
            onNext: () => ref.read(stockMovementsProvider.notifier).nextPage(),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<StockMovement> movements) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PosDataTable(
        columns: const [
          DataColumn(label: Text('DATE')),
          DataColumn(label: Text('TYPE')),
          DataColumn(label: Text('PRODUCT')),
          DataColumn(label: Text('QUANTITY'), numeric: true),
          DataColumn(label: Text('UNIT COST'), numeric: true),
          DataColumn(label: Text('REASON')),
        ],
        rows: movements.map((m) {
          final typeLabel = m.type.value;
          return DataRow(
            cells: [
              DataCell(Text(m.createdAt != null ? '${m.createdAt!.day}/${m.createdAt!.month}/${m.createdAt!.year}' : '-')),
              DataCell(PosBadge(label: typeLabel, variant: _badgeVariant(typeLabel))),
              DataCell(Text(m.productId, overflow: TextOverflow.ellipsis)),
              DataCell(Text(m.quantity.toStringAsFixed(2))),
              DataCell(Text(m.unitCost?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(m.reason ?? '-', overflow: TextOverflow.ellipsis)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
