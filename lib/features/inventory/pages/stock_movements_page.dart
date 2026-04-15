import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';
import 'package:wameedpos/features/inventory/models/stock_movement.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(stockMovementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryStockMovements),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(stockMovementsProvider.notifier).load(productId: widget.productId),
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(StockMovementsState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is StockMovementsLoading || state is StockMovementsInitial;
    final error = state is StockMovementsError ? state.message : null;
    final movements = state is StockMovementsLoaded ? state.movements : <StockMovement>[];
    final loaded = state is StockMovementsLoaded ? state : null;

    return PosDataTable<StockMovement>(
      columns: [
        PosTableColumn(title: l10n.commonDate),
        PosTableColumn(title: l10n.commonType),
        PosTableColumn(title: l10n.inventoryProduct),
        PosTableColumn(title: l10n.inventoryQuantity, numeric: true),
        PosTableColumn(title: l10n.inventoryUnitCostLabel, numeric: true),
        PosTableColumn(title: l10n.reason),
      ],
      items: movements,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stockMovementsProvider.notifier).load(productId: widget.productId),
      emptyConfig: PosTableEmptyConfig(icon: Icons.history_outlined, title: l10n.inventoryNoMovements),
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
