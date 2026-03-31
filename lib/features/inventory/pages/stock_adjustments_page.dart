import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(stockAdjustmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryStockAdjustments),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(stockAdjustmentsProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(
        label: l10n.inventoryNewAdjustment,
        icon: Icons.add,
        onPressed: () => _showAdjustmentDialog(),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(StockAdjustmentsState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is StockAdjustmentsLoading || state is StockAdjustmentsInitial;
    final error = state is StockAdjustmentsError ? state.message : null;
    final adjustments = state is StockAdjustmentsLoaded ? state.adjustments : <StockAdjustment>[];

    return PosDataTable<StockAdjustment>(
      columns: [
        PosTableColumn(title: l10n.commonDate),
        PosTableColumn(title: l10n.commonType),
        PosTableColumn(title: l10n.reason),
        PosTableColumn(title: l10n.commonNotes),
      ],
      items: adjustments,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stockAdjustmentsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(icon: Icons.tune_outlined, title: l10n.inventoryNoAdjustments),
      cellBuilder: (adj, colIndex, col) {
        final isIncrease = adj.type == StockAdjustmentType.increase;
        switch (colIndex) {
          case 0:
            return Text(adj.createdAt != null ? '${adj.createdAt!.day}/${adj.createdAt!.month}/${adj.createdAt!.year}' : '-');
          case 1:
            return PosBadge(
              label: isIncrease ? l10n.inventoryIncrease : l10n.inventoryDecrease,
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
          final l10n = AppLocalizations.of(ctx)!;
          final products = ref.read(productsProvider);
          final productList = products is ProductsLoaded ? products.products : <Product>[];

          return AlertDialog(
            title: Text(l10n.inventoryNewStockAdjustment),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SegmentedButton<StockAdjustmentType>(
                        segments: [
                          ButtonSegment(value: StockAdjustmentType.increase, label: Text(l10n.inventoryIncrease)),
                          ButtonSegment(value: StockAdjustmentType.decrease, label: Text(l10n.inventoryDecrease)),
                          ButtonSegment(value: StockAdjustmentType.damage, label: Text(l10n.inventoryDamage)),
                        ],
                        selected: {adjustmentType},
                        onSelectionChanged: (value) {
                          setDialogState(() => adjustmentType = value.first);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        value: selectedProductId,
                        decoration: InputDecoration(labelText: l10n.inventoryProduct),
                        isExpanded: true,
                        items: productList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: quantityController,
                        decoration: InputDecoration(labelText: l10n.inventoryQuantity),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.commonRequired;
                          if (double.tryParse(v) == null) return l10n.inventoryInvalidNumber;
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<String>(
                        value: selectedReason,
                        decoration: InputDecoration(labelText: l10n.reason),
                        isExpanded: true,
                        items: reasonOptions
                            .map((r) => DropdownMenuItem(value: r, child: Text(r[0].toUpperCase() + r.substring(1))))
                            .toList(),
                        onChanged: (v) => setDialogState(() => selectedReason = v),
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: notesController,
                        decoration: InputDecoration(labelText: l10n.commonNotesOptional),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
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
                child: Text(l10n.create),
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.inventoryAdjustmentCreated)));
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
