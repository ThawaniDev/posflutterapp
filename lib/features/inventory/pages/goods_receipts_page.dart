import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/inventory/models/goods_receipt.dart';
import 'package:thawani_pos/features/inventory/enums/goods_receipt_status.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';

class GoodsReceiptsPage extends ConsumerStatefulWidget {
  const GoodsReceiptsPage({super.key});

  @override
  ConsumerState<GoodsReceiptsPage> createState() => _GoodsReceiptsPageState();
}

class _GoodsReceiptsPageState extends ConsumerState<GoodsReceiptsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(goodsReceiptsProvider.notifier).load());
  }

  Future<void> _handleConfirm(GoodsReceipt receipt) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Receipt'),
        content: Text(
          'Are you sure you want to confirm receipt "${receipt.referenceNumber ?? receipt.id}"?\n\n'
          'This will update stock levels and cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(goodsReceiptsProvider.notifier).confirmReceipt(receipt.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Goods receipt confirmed. Stock updated.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goodsReceiptsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goods Receipts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(goodsReceiptsProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(
        label: 'New Receipt',
        icon: Icons.add,
        onPressed: () => context.push(Routes.goodsReceiptsAdd),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(GoodsReceiptsState state) {
    final isLoading = state is GoodsReceiptsLoading || state is GoodsReceiptsInitial;
    final error = state is GoodsReceiptsError ? state.message : null;
    final receipts = state is GoodsReceiptsLoaded ? state.receipts : <GoodsReceipt>[];
    final loaded = state is GoodsReceiptsLoaded ? state : null;

    return PosDataTable<GoodsReceipt>(
      columns: const [
        PosTableColumn(title: 'Reference'),
        PosTableColumn(title: 'Supplier'),
        PosTableColumn(title: 'Status'),
        PosTableColumn(title: 'Total Cost', numeric: true),
        PosTableColumn(title: 'Received'),
      ],
      items: receipts,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(goodsReceiptsProvider.notifier).load(),
      emptyConfig: const PosTableEmptyConfig(
        icon: Icons.receipt_long_outlined,
        title: 'No goods receipts yet',
        subtitle: 'Create a receipt when you receive goods from suppliers.',
      ),
      actions: [
        PosTableRowAction<GoodsReceipt>(
          label: 'Confirm',
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          isVisible: (r) => r.status == GoodsReceiptStatus.draft,
          onTap: (r) => _handleConfirm(r),
        ),
      ],
      cellBuilder: (receipt, colIndex, col) {
        final isDraft = receipt.status == GoodsReceiptStatus.draft;
        switch (colIndex) {
          case 0:
            return Text(receipt.referenceNumber ?? receipt.id.substring(0, 8));
          case 1:
            return Text(receipt.supplierName ?? receipt.supplierId ?? '-');
          case 2:
            return PosBadge(
              label: receipt.status?.value ?? 'draft',
              variant: isDraft ? PosBadgeVariant.warning : PosBadgeVariant.success,
            );
          case 3:
            return Text(receipt.totalCost?.toStringAsFixed(2) ?? '-');
          case 4:
            return Text(
              receipt.receivedAt != null
                  ? '${receipt.receivedAt!.day}/${receipt.receivedAt!.month}/${receipt.receivedAt!.year}'
                  : '-',
            );
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: 25,
    );
  }
}
