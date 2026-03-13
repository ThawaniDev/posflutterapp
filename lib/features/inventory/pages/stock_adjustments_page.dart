import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/inventory/enums/stock_adjustment_type.dart';
import 'package:thawani_pos/features/inventory/models/stock_adjustment.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_providers.dart';
import 'package:thawani_pos/features/inventory/providers/inventory_state.dart';

class StockAdjustmentsPage extends ConsumerStatefulWidget {
  const StockAdjustmentsPage({super.key});

  @override
  ConsumerState<StockAdjustmentsPage> createState() => _StockAdjustmentsPageState();
}

class _StockAdjustmentsPageState extends ConsumerState<StockAdjustmentsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(stockAdjustmentsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockAdjustmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Adjustments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(stockAdjustmentsProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'New Adjustment', icon: Icons.add, onPressed: () => _showAdjustmentDialog()),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(StockAdjustmentsState state) {
    if (state is StockAdjustmentsLoading || state is StockAdjustmentsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is StockAdjustmentsError) {
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
              onPressed: () => ref.read(stockAdjustmentsProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is StockAdjustmentsLoaded) {
      if (state.adjustments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tune_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No stock adjustments yet', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      }

      return SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.md), child: _buildTable(state.adjustments));
    }

    return const SizedBox.shrink();
  }

  Widget _buildTable(List<StockAdjustment> adjustments) {
    return PosDataTable(
      columns: const [
        DataColumn(label: Text('DATE')),
        DataColumn(label: Text('TYPE')),
        DataColumn(label: Text('REASON')),
        DataColumn(label: Text('NOTES')),
      ],
      rows: adjustments.map((adj) {
        final isIncrease = adj.type == StockAdjustmentType.increase;
        return DataRow(
          cells: [
            DataCell(Text(adj.createdAt != null ? '${adj.createdAt!.day}/${adj.createdAt!.month}/${adj.createdAt!.year}' : '-')),
            DataCell(
              PosBadge(
                label: isIncrease ? 'Increase' : 'Decrease',
                variant: isIncrease ? PosBadgeVariant.success : PosBadgeVariant.error,
              ),
            ),
            DataCell(Text(adj.reasonCode)),
            DataCell(Text(adj.notes ?? '-', overflow: TextOverflow.ellipsis)),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _showAdjustmentDialog() async {
    final formKey = GlobalKey<FormState>();
    final productIdController = TextEditingController();
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();
    final notesController = TextEditingController();
    var adjustmentType = StockAdjustmentType.increase;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Stock Adjustment'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentedButton<StockAdjustmentType>(
                    segments: const [
                      ButtonSegment(value: StockAdjustmentType.increase, label: Text('Increase')),
                      ButtonSegment(value: StockAdjustmentType.decrease, label: Text('Decrease')),
                    ],
                    selected: {adjustmentType},
                    onSelectionChanged: (value) {
                      setDialogState(() => adjustmentType = value.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: reasonController,
                    decoration: const InputDecoration(labelText: 'Reason Code'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
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
                    'type': adjustmentType.value,
                    'reason_code': reasonController.text,
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
      ),
    );

    productIdController.dispose();
    quantityController.dispose();
    reasonController.dispose();
    notesController.dispose();

    if (result != null && mounted) {
      try {
        await ref.read(stockAdjustmentsProvider.notifier).createAdjustment(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock adjustment created.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }
}
