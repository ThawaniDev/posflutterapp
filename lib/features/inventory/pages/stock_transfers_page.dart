import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/inventory/enums/stock_transfer_status.dart';
import 'package:thawani_pos/features/inventory/models/stock_transfer.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';

class StockTransfersPage extends ConsumerStatefulWidget {
  const StockTransfersPage({super.key});

  @override
  ConsumerState<StockTransfersPage> createState() => _StockTransfersPageState();
}

class _StockTransfersPageState extends ConsumerState<StockTransfersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(stockTransfersProvider.notifier).load());
  }

  PosBadgeVariant _statusVariant(StockTransferStatus? status) {
    switch (status) {
      case StockTransferStatus.pending:
        return PosBadgeVariant.warning;
      case StockTransferStatus.inTransit:
        return PosBadgeVariant.info;
      case StockTransferStatus.completed:
        return PosBadgeVariant.success;
      case StockTransferStatus.cancelled:
        return PosBadgeVariant.error;
      case null:
        return PosBadgeVariant.neutral;
    }
  }

  Future<void> _handleAction(StockTransfer transfer, String action) async {
    final msg = action == 'approve'
        ? 'Approve this transfer? This will deduct stock from the source store.'
        : action == 'receive'
        ? 'Mark this transfer as received? Stock will be added to the destination store.'
        : 'Cancel this transfer?';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${action[0].toUpperCase()}${action.substring(1)} Transfer'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(action[0].toUpperCase() + action.substring(1))),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final notifier = ref.read(stockTransfersProvider.notifier);
      if (action == 'approve') {
        await notifier.approveTransfer(transfer.id);
      } else if (action == 'receive') {
        await notifier.receiveTransfer(transfer.id);
      } else if (action == 'cancel') {
        await notifier.cancelTransfer(transfer.id);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transfer ${action}d successfully.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockTransfersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Transfers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(stockTransfersProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'New Transfer', icon: Icons.add, onPressed: () => _showCreateTransferDialog()),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(StockTransfersState state) {
    if (state is StockTransfersLoading || state is StockTransfersInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is StockTransfersError) {
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
              onPressed: () => ref.read(stockTransfersProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is StockTransfersLoaded) {
      if (state.transfers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swap_horiz_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No stock transfers yet', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      }

      return SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.md), child: _buildTable(state.transfers));
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<StockTransfer> transfers) {
    return PosDataTable(
      columns: const [
        DataColumn(label: Text('REF')),
        DataColumn(label: Text('FROM')),
        DataColumn(label: Text('TO')),
        DataColumn(label: Text('STATUS')),
        DataColumn(label: Text('CREATED')),
        DataColumn(label: Text('ACTIONS')),
      ],
      rows: transfers.map((t) {
        return DataRow(
          cells: [
            DataCell(Text(t.referenceNumber ?? t.id.substring(0, 8))),
            DataCell(Text(t.fromStoreId.substring(0, 8))),
            DataCell(Text(t.toStoreId.substring(0, 8))),
            DataCell(PosBadge(label: t.status?.value ?? 'pending', variant: _statusVariant(t.status))),
            DataCell(Text(t.createdAt != null ? '${t.createdAt!.day}/${t.createdAt!.month}/${t.createdAt!.year}' : '-')),
            DataCell(_buildActionButtons(t)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(StockTransfer transfer) {
    final actions = <Widget>[];

    if (transfer.status == StockTransferStatus.pending) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.check_circle_outline, size: 20, color: AppColors.success),
          tooltip: 'Approve',
          onPressed: () => _handleAction(transfer, 'approve'),
        ),
      );
      actions.add(
        IconButton(
          icon: const Icon(Icons.cancel_outlined, size: 20, color: AppColors.error),
          tooltip: 'Cancel',
          onPressed: () => _handleAction(transfer, 'cancel'),
        ),
      );
    } else if (transfer.status == StockTransferStatus.inTransit) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.archive_outlined, size: 20, color: AppColors.info),
          tooltip: 'Receive',
          onPressed: () => _handleAction(transfer, 'receive'),
        ),
      );
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(mainAxisSize: MainAxisSize.min, children: actions);
  }

  Future<void> _showCreateTransferDialog() async {
    final formKey = GlobalKey<FormState>();
    final fromStoreController = TextEditingController();
    final toStoreController = TextEditingController();
    final notesController = TextEditingController();
    final productIdController = TextEditingController();
    final quantityController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Stock Transfer'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fromStoreController,
                  decoration: const InputDecoration(labelText: 'From Store ID'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: toStoreController,
                  decoration: const InputDecoration(labelText: 'To Store ID'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: productIdController,
                  decoration: const InputDecoration(labelText: 'Product ID'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (double.tryParse(v) == null) return 'Invalid';
                    return null;
                  },
                ),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, {
                  'from_store_id': fromStoreController.text,
                  'to_store_id': toStoreController.text,
                  'notes': notesController.text.isNotEmpty ? notesController.text : null,
                  'items': [
                    {'product_id': productIdController.text, 'quantity': double.parse(quantityController.text)},
                  ],
                });
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    fromStoreController.dispose();
    toStoreController.dispose();
    notesController.dispose();
    productIdController.dispose();
    quantityController.dispose();

    if (result != null && mounted) {
      try {
        await ref.read(stockTransfersProvider.notifier).createTransfer(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transfer created.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }
}
