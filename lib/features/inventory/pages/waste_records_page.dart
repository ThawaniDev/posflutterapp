import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/inventory/enums/waste_reason.dart';
import 'package:wameedpos/features/inventory/models/waste_record.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

class WasteRecordsPage extends ConsumerStatefulWidget {
  const WasteRecordsPage({super.key});

  @override
  ConsumerState<WasteRecordsPage> createState() => _WasteRecordsPageState();
}

class _WasteRecordsPageState extends ConsumerState<WasteRecordsPage> {
  String? _selectedReason;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(wasteRecordsProvider.notifier).load());
  }

  PosBadgeVariant _reasonVariant(WasteReason? reason) {
    return switch (reason) {
      WasteReason.expired => PosBadgeVariant.error,
      WasteReason.damaged => PosBadgeVariant.warning,
      WasteReason.spillage => PosBadgeVariant.warning,
      WasteReason.overproduction => PosBadgeVariant.info,
      WasteReason.qualityIssue => PosBadgeVariant.warning,
      WasteReason.other => PosBadgeVariant.neutral,
      null => PosBadgeVariant.neutral,
    };
  }

  String _reasonLabel(WasteReason? reason, AppLocalizations l10n) {
    return switch (reason) {
      WasteReason.expired => l10n.inventoryWasteReasonExpired,
      WasteReason.damaged => l10n.inventoryWasteReasonDamaged,
      WasteReason.spillage => l10n.inventoryWasteReasonSpillage,
      WasteReason.overproduction => l10n.inventoryWasteReasonOverproduction,
      WasteReason.qualityIssue => l10n.inventoryWasteReasonQualityIssue,
      WasteReason.other => l10n.inventoryWasteReasonOther,
      null => '-',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wasteRecordsProvider);
    final loaded = state is WasteRecordsLoaded ? state : null;

    return PosListPage(
      title: l10n.inventoryWasteRecords,
      actions: [
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String?>(
            initialValue: _selectedReason,
            isDense: true,
            decoration: InputDecoration(
              labelText: l10n.inventoryWasteReason,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            ),
            items: [
              DropdownMenuItem<String?>(value: null, child: Text(l10n.inventoryAllReasons)),
              ...WasteReason.values.map(
                (r) => DropdownMenuItem<String?>(value: r.value, child: Text(_reasonLabel(r, l10n))),
              ),
            ],
            onChanged: (v) {
              setState(() => _selectedReason = v);
              ref.read(wasteRecordsProvider.notifier).filterByReason(v);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(wasteRecordsProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(
          label: l10n.inventoryRecordWaste,
          icon: Icons.add,
          onPressed: _showCreateDialog,
        ),
      ],
      child: _buildBody(state, l10n, loaded),
    );
  }

  Widget _buildBody(WasteRecordsState state, AppLocalizations l10n, WasteRecordsLoaded? loaded) {
    final isLoading = state is WasteRecordsLoading || state is WasteRecordsInitial;
    final error = state is WasteRecordsError ? state.message : null;
    final records = loaded?.records ?? <WasteRecord>[];

    return Column(
      children: [
        // Summary row
        if (loaded != null && records.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                _SummaryChip(
                  label: l10n.inventoryTotalRecords,
                  value: '${loaded.total}',
                  icon: Icons.delete_sweep_outlined,
                  color: AppColors.error,
                ),
                const SizedBox(width: AppSpacing.md),
                _SummaryChip(
                  label: l10n.inventoryTotalWasteCost,
                  value: 'SAR ${records.fold(0.0, (s, r) => s + (r.totalCost ?? (r.quantity * (r.unitCost ?? 0)))).toStringAsFixed(3)}',
                  icon: Icons.monetization_on_outlined,
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
        Expanded(
          child: PosDataTable<WasteRecord>(
            columns: [
              PosTableColumn(title: l10n.commonDate),
              PosTableColumn(title: l10n.inventoryProduct),
              PosTableColumn(title: l10n.inventoryQuantity),
              PosTableColumn(title: l10n.inventoryUnitCost),
              PosTableColumn(title: l10n.inventoryTotalCost),
              PosTableColumn(title: l10n.inventoryWasteReason),
              PosTableColumn(title: l10n.inventoryBatchNumber),
              PosTableColumn(title: l10n.commonNotes),
            ],
            items: records,
            isLoading: isLoading,
            error: error,
            onRetry: () => ref.read(wasteRecordsProvider.notifier).load(),
            emptyConfig: PosTableEmptyConfig(
              icon: Icons.delete_sweep_outlined,
              title: l10n.inventoryNoWasteRecords,
              subtitle: l10n.inventoryNoWasteRecordsHint,
            ),
            cellBuilder: (rec, colIndex, col) {
              final l10n = AppLocalizations.of(context)!;
              switch (colIndex) {
                case 0:
                  return Text(rec.createdAt != null
                      ? '${rec.createdAt!.day}/${rec.createdAt!.month}/${rec.createdAt!.year}'
                      : '-');
                case 1:
                  return Text(rec.productName ?? rec.productId.substring(0, 8),
                      style: const TextStyle(fontWeight: FontWeight.w500));
                case 2:
                  return Text(rec.quantity.toStringAsFixed(3));
                case 3:
                  return Text(rec.unitCost != null ? 'SAR ${rec.unitCost!.toStringAsFixed(4)}' : '-');
                case 4:
                  final totalCost = rec.totalCost ?? (rec.quantity * (rec.unitCost ?? 0));
                  return Text(
                    'SAR ${totalCost.toStringAsFixed(3)}',
                    style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
                  );
                case 5:
                  return PosBadge(
                    label: _reasonLabel(rec.reason, l10n),
                    variant: _reasonVariant(rec.reason),
                  );
                case 6:
                  return Text(rec.batchNumber ?? '-');
                case 7:
                  return Text(rec.notes ?? '-', overflow: TextOverflow.ellipsis);
                default:
                  return const SizedBox.shrink();
              }
            },
            currentPage: loaded?.currentPage,
            totalPages: loaded?.lastPage,
            totalItems: loaded?.total,
            itemsPerPage: 25,
            onPreviousPage: loaded != null && loaded.currentPage > 1
                ? () => ref.read(wasteRecordsProvider.notifier).previousPage()
                : null,
            onNextPage: loaded != null && loaded.hasMore
                ? () => ref.read(wasteRecordsProvider.notifier).nextPage()
                : null,
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateDialog() async {
    final l10n = AppLocalizations.of(context)!;

    // Ensure products loaded
    final productsState = ref.read(productsProvider);
    if (productsState is! ProductsLoaded) {
      await ref.read(productsProvider.notifier).load();
    }

    String? selectedProductId;
    WasteReason selectedReason = WasteReason.expired;
    final qtyCtrl = TextEditingController();
    final unitCostCtrl = TextEditingController();
    final batchCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final products = (ref.read(productsProvider) is ProductsLoaded)
              ? (ref.read(productsProvider) as ProductsLoaded).products
              : <Product>[];

          return AlertDialog(
            title: Text(l10n.inventoryRecordWaste),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String?>(
                      initialValue: selectedProductId,
                      decoration: InputDecoration(labelText: l10n.inventoryProduct),
                      items: products
                          .map((p) => DropdownMenuItem<String?>(value: p.id, child: Text(p.name)))
                          .toList(),
                      onChanged: (v) => setDialogState(() => selectedProductId = v),
                    ),
                    AppSpacing.gapH12,
                    DropdownButtonFormField<WasteReason>(
                      initialValue: selectedReason,
                      decoration: InputDecoration(labelText: l10n.inventoryWasteReason),
                      items: WasteReason.values
                          .map((r) => DropdownMenuItem(value: r, child: Text(_reasonLabel(r, l10n))))
                          .toList(),
                      onChanged: (v) => setDialogState(() => selectedReason = v ?? WasteReason.expired),
                    ),
                    AppSpacing.gapH12,
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: qtyCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(labelText: l10n.inventoryQuantity),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextField(
                            controller: unitCostCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(labelText: l10n.inventoryUnitCost),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapH12,
                    TextField(
                      controller: batchCtrl,
                      decoration: InputDecoration(labelText: l10n.inventoryBatchNumber),
                    ),
                    AppSpacing.gapH12,
                    TextField(
                      controller: notesCtrl,
                      decoration: InputDecoration(labelText: l10n.commonNotes),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
              FilledButton(
                onPressed: () async {
                  if (selectedProductId == null || qtyCtrl.text.trim().isEmpty) return;
                  Navigator.pop(ctx);
                  try {
                    final data = {
                      'product_id': selectedProductId,
                      'quantity': double.parse(qtyCtrl.text.trim()),
                      'reason': selectedReason.value,
                      if (unitCostCtrl.text.trim().isNotEmpty)
                        'unit_cost': double.parse(unitCostCtrl.text.trim()),
                      if (batchCtrl.text.trim().isNotEmpty) 'batch_number': batchCtrl.text.trim(),
                      if (notesCtrl.text.trim().isNotEmpty) 'notes': notesCtrl.text.trim(),
                    };
                    await ref.read(wasteRecordsProvider.notifier).createWasteRecord(data);
                    if (mounted) showPosSuccessSnackbar(context, l10n.inventoryWasteRecorded);
                  } catch (e) {
                    if (mounted) showPosErrorSnackbar(context, e.toString());
                  }
                },
                child: Text(l10n.inventoryRecordWaste),
              ),
            ],
          );
        },
      ),
    );

    qtyCtrl.dispose();
    unitCostCtrl.dispose();
    batchCtrl.dispose();
    notesCtrl.dispose();
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
