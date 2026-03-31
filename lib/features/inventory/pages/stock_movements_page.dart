import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
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
    final isLoading = state is StockMovementsLoading || state is StockMovementsInitial;
    final error = state is StockMovementsError ? state.message : null;
    final movements = state is StockMovementsLoaded ? state.movements : <StockMovement>[];
    final loaded = state is StockMovementsLoaded ? state : null;

    return PosDataTable<StockMovement>(
      columns: const [
        PosTableColumn(title: 'Date'),
        PosTableColumn(title: 'Type'),
        PosTableColumn(title: 'Product'),
        PosTableColumn(title: 'Quantity', numeric: true),
        PosTableColumn(title: 'Unit Cost', numeric: true),
        PosTableColumn(title: 'Reason'),
      ],
      items: movements,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stockMovementsProvider.notifier).load(productId: widget.productId),
      emptyConfig: const PosTableEmptyConfig(icon: Icons.history_outlined, title: 'No stock movements yet'),
      cellBuilder: (m, colIndex, col) {
        final typeLabel = m.type.value;
        switch (colIndex) {
          case 0:
            return Text(m.createdAt != null ? '${m.createdAt!.day}/${m.createdAt!.month}/${m.createdAt!.year}' : '-');
          case 1:
            return PosBadge(label: typeLabel, variant: _badgeVariant(typeLabel));
          case 2:
            return Text(m.productId, overflow: TextOverflow.ellipsis);
          case 3:
            return Text(m.quantity.toStringAsFixed(2));
          case 4:
            return Text(m.unitCost?.toStringAsFixed(2) ?? '-');
          case 5:
            return Text(m.reason ?? '-', overflow: TextOverflow.ellipsis);
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: 25,
      onPreviousPage: loaded != null ? () => ref.read(stockMovementsProvider.notifier).previousPage() : null,
      onNextPage: loaded != null ? () => ref.read(stockMovementsProvider.notifier).nextPage() : null,
    );
  }
}
