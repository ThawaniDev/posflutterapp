import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';
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
    final isLoading = state is StockAdjustmentsLoading || state is StockAdjustmentsInitial;
    final error = state is StockAdjustmentsError ? state.message : null;
    final adjustments = state is StockAdjustmentsLoaded ? state.adjustments : <StockAdjustment>[];

    return PosDataTable<StockAdjustment>(
      columns: const [
        PosTableColumn(title: 'Date'),
        PosTableColumn(title: 'Type'),
        PosTableColumn(title: 'Reason'),
        PosTableColumn(title: 'Notes'),
      ],
      items: adjustments,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stockAdjustmentsProvider.notifier).load(),
      emptyConfig: const PosTableEmptyConfig(icon: Icons.tune_outlined, title: 'No stock adjustments yet'),
      cellBuilder: (adj, colIndex, col) {
        final isIncrease = adj.type == StockAdjustmentType.increase;
        switch (colIndex) {
          case 0:
            return Text(adj.createdAt != null ? '${adj.createdAt!.day}/${adj.createdAt!.month}/${adj.createdAt!.year}' : '-');
          case 1:
            return PosBadge(
              label: isIncrease ? 'Increase' : 'Decrease',
              variant: isIncrease ? PosBadgeVariant.success : PosBadgeVariant.error,
            );
          case 2:
            return Text(adj.reasonCode);
          case 3:
            return Text(adj.notes ?? '-', overflow: TextOverflow.ellipsis);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _showAdjustmentDialog() async {
    // Ensure products are loaded for the dropdown
    final productsState = ref.read(productsProvider);
    if (productsState is! ProductsLoaded) {
      await ref.read(productsProvider.notifier).load();
    }

    final formKey = GlobalKey<FormState>();
    final quantityController = TextEditingController();
    final notesController = TextEditingController();
    var adjustmentType = StockAdjustmentType.increase;
    String? selectedProductId;
    String? selectedReason;

    const reasonOptions = ['damaged', 'expired', 'lost', 'correction', 'returned', 'miscounted', 'theft', 'other'];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final products = ref.read(productsProvider);
          final productList = products is ProductsLoaded ? products.products : <Product>[];

          return AlertDialog(
            title: const Text('New Stock Adjustment'),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SegmentedButton<StockAdjustmentType>(
                        segments: const [
                          ButtonSegment(value: StockAdjustmentType.increase, label: Text('Increase')),
                          ButtonSegment(value: StockAdjustmentType.decrease, label: Text('Decrease')),
                          ButtonSegment(value: StockAdjustmentType.damage, label: Text('Damage')),
                        ],
                        selected: {adjustmentType},
                        onSelectionChanged: (value) {
                          setDialogState(() => adjustmentType = value.first);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        value: selectedProductId,
                        decoration: const InputDecoration(labelText: 'Product'),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
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
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<String>(
                        value: selectedReason,
                        decoration: const InputDecoration(labelText: 'Reason'),
                        isExpanded: true,
                        items: reasonOptions
                            .map((r) => DropdownMenuItem(value: r, child: Text(r[0].toUpperCase() + r.substring(1))))
                            .toList(),
                        onChanged: (v) => setDialogState(() => selectedReason = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(labelText: 'Notes (optional)'),
                      ),
                    ],
                  ),
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
                      'reason_code': selectedReason,
                      'notes': notesController.text.isNotEmpty ? notesController.text : null,
                      'items': [
                        {'product_id': selectedProductId, 'quantity': double.parse(quantityController.text)},
                      ],
                    });
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );

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

    quantityController.dispose();
    notesController.dispose();
  }
}
