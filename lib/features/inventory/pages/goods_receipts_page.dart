import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
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
    if (state is GoodsReceiptsLoading || state is GoodsReceiptsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GoodsReceiptsError) {
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
              onPressed: () => ref.read(goodsReceiptsProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is GoodsReceiptsLoaded) {
      if (state.receipts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No goods receipts yet', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Create a receipt when you receive goods from suppliers.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(child: _buildTable(state.receipts)),
          PosTablePagination(
            currentPage: state.currentPage,
            totalPages: state.lastPage,
            totalItems: state.total,
            itemsPerPage: 25,
            onPrevious: () {},
            onNext: () {},
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<GoodsReceipt> receipts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PosDataTable(
        columns: const [
          DataColumn(label: Text('REFERENCE')),
          DataColumn(label: Text('SUPPLIER')),
          DataColumn(label: Text('STATUS')),
          DataColumn(label: Text('TOTAL COST'), numeric: true),
          DataColumn(label: Text('RECEIVED')),
          DataColumn(label: Text('ACTIONS')),
        ],
        rows: receipts.map((receipt) {
          final isDraft = receipt.status == GoodsReceiptStatus.draft;
          return DataRow(
            cells: [
              DataCell(Text(receipt.referenceNumber ?? receipt.id.substring(0, 8))),
              DataCell(Text(receipt.supplierId ?? '-')),
              DataCell(
                PosBadge(
                  label: receipt.status?.value ?? 'draft',
                  variant: isDraft ? PosBadgeVariant.warning : PosBadgeVariant.success,
                ),
              ),
              DataCell(Text(receipt.totalCost?.toStringAsFixed(2) ?? '-')),
              DataCell(
                Text(
                  receipt.receivedAt != null
                      ? '${receipt.receivedAt!.day}/${receipt.receivedAt!.month}/${receipt.receivedAt!.year}'
                      : '-',
                ),
              ),
              DataCell(
                isDraft
                    ? PosButton(
                        label: 'Confirm',
                        variant: PosButtonVariant.outline,
                        size: PosButtonSize.sm,
                        onPressed: () => _handleConfirm(receipt),
                      )
                    : const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
