import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/inventory/enums/stocktake_status.dart';
import 'package:wameedpos/features/inventory/enums/stocktake_type.dart';
import 'package:wameedpos/features/inventory/models/stocktake.dart';
import 'package:wameedpos/features/inventory/models/stocktake_item.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';
import 'package:wameedpos/features/inventory/repositories/inventory_repository.dart';

class StocktakesPage extends ConsumerStatefulWidget {
  const StocktakesPage({super.key, this.initialDetailId});

  final String? initialDetailId;

  @override
  ConsumerState<StocktakesPage> createState() => _StocktakesPageState();
}

class _StocktakesPageState extends ConsumerState<StocktakesPage> {
  String? _selectedStatus;
  Stocktake? _detailStocktake;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(stocktakesProvider.notifier).load();
      if (widget.initialDetailId != null) {
        final state = ref.read(stocktakesProvider);
        if (state is StocktakesLoaded) {
          final match = state.stocktakes
              .where((s) => s.id == widget.initialDetailId)
              .firstOrNull;
          if (match != null && mounted) {
            setState(() => _detailStocktake = match);
          }
        }
      }
    });
  }

  PosBadgeVariant _statusVariant(StocktakeStatus? status) {
    return switch (status) {
      StocktakeStatus.inProgress => PosBadgeVariant.info,
      StocktakeStatus.review => PosBadgeVariant.warning,
      StocktakeStatus.completed => PosBadgeVariant.success,
      StocktakeStatus.cancelled => PosBadgeVariant.error,
      null => PosBadgeVariant.neutral,
    };
  }

  String _statusLabel(StocktakeStatus? status, AppLocalizations l10n) {
    return switch (status) {
      StocktakeStatus.inProgress => l10n.inventoryStocktakeStatusInProgress,
      StocktakeStatus.review => l10n.inventoryStocktakeStatusReview,
      StocktakeStatus.completed => l10n.inventoryStocktakeStatusCompleted,
      StocktakeStatus.cancelled => l10n.inventoryStocktakeStatusCancelled,
      null => '-',
    };
  }

  String _typeLabel(StocktakeType? type, AppLocalizations l10n) {
    return switch (type) {
      StocktakeType.full => l10n.inventoryStocktakeTypeFull,
      StocktakeType.partial => l10n.inventoryStocktakeTypePartial,
      StocktakeType.category => l10n.inventoryStocktakeTypeCategory,
      null => '-',
    };
  }

  Future<void> _handleAction(String action, Stocktake stocktake) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(stocktakesProvider.notifier);
    final label = stocktake.referenceNumber ?? stocktake.id.substring(0, 8);

    if (action == 'viewCounts') {
      final fresh = await ref.read(inventoryRepositoryProvider).getStocktake(stocktake.id);
      if (mounted) setState(() => _detailStocktake = fresh);
      return;
    }

    final isDanger = action == 'cancel';
    final actionLabel = action == 'apply' ? l10n.inventoryApplyStocktake : l10n.inventoryCancelled;
    final confirmed = await showPosConfirmDialog(
      context,
      title: '${actionLabel} "$label"?',
      message: action == 'apply'
          ? l10n.inventoryStocktakeApplyWarning
          : l10n.inventoryStocktakeCancelWarning,
      confirmLabel: actionLabel,
      cancelLabel: l10n.commonCancel,
      isDanger: isDanger,
    );

    if (confirmed != true || !mounted) return;

    try {
      switch (action) {
        case 'apply':
          await notifier.applyStocktake(stocktake.id);
          if (mounted) showPosSuccessSnackbar(context, l10n.inventoryStocktakeApplied);
        case 'cancel':
          await notifier.cancelStocktake(stocktake.id);
          if (mounted) showPosSuccessSnackbar(context, l10n.inventoryStocktakeCancelled);
      }
    } catch (e) {
      if (mounted) showPosErrorSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(stocktakesProvider);

    if (_detailStocktake != null) {
      return _StocktakeDetailView(
        stocktake: _detailStocktake!,
        onBack: () => setState(() => _detailStocktake = null),
        onCountsSaved: (updated) => setState(() => _detailStocktake = updated),
      );
    }

    return PosListPage(
      title: l10n.inventoryStocktakes,
      actions: [
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String?>(
            value: _selectedStatus,
            isDense: true,
            decoration: InputDecoration(
              labelText: l10n.inventoryAllStatuses,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            ),
            items: [
              DropdownMenuItem<String?>(value: null, child: Text(l10n.inventoryAllStatuses)),
              DropdownMenuItem<String?>(value: 'in_progress', child: Text(l10n.inventoryStocktakeStatusInProgress)),
              DropdownMenuItem<String?>(value: 'review', child: Text(l10n.inventoryStocktakeStatusReview)),
              DropdownMenuItem<String?>(value: 'completed', child: Text(l10n.inventoryStocktakeStatusCompleted)),
              DropdownMenuItem<String?>(value: 'cancelled', child: Text(l10n.inventoryStocktakeStatusCancelled)),
            ],
            onChanged: (v) {
              setState(() => _selectedStatus = v);
              ref.read(stocktakesProvider.notifier).filterByStatus(v);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(stocktakesProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(
          label: l10n.inventoryNewStocktake,
          icon: Icons.add,
          onPressed: _showCreateDialog,
        ),
      ],
      child: _buildBody(state),
    );
  }

  Widget _buildBody(StocktakesState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is StocktakesLoading || state is StocktakesInitial;
    final error = state is StocktakesError ? state.message : null;
    final stocktakes = state is StocktakesLoaded ? state.stocktakes : <Stocktake>[];

    return PosDataTable<Stocktake>(
      columns: [
        PosTableColumn(title: l10n.inventoryReferenceNumber),
        PosTableColumn(title: l10n.commonType),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.commonCategory),
        PosTableColumn(title: l10n.inventoryStartedAt),
        PosTableColumn(title: l10n.inventoryItemCount),
        PosTableColumn(title: l10n.commonAction),
      ],
      items: stocktakes,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stocktakesProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.fact_check_outlined,
        title: l10n.inventoryNoStocktakes,
        subtitle: l10n.inventoryNoStocktakesHint,
      ),
      cellBuilder: (st, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(st.referenceNumber ?? st.id.substring(0, 8), style: const TextStyle(fontWeight: FontWeight.w600));
          case 1:
            return Text(_typeLabel(st.type, AppLocalizations.of(context)!));
          case 2:
            return PosBadge(
              label: _statusLabel(st.status, AppLocalizations.of(context)!),
              variant: _statusVariant(st.status),
            );
          case 3:
            return Text(st.categoryName ?? '-');
          case 4:
            return Text(st.startedAt != null
                ? '${st.startedAt!.day}/${st.startedAt!.month}/${st.startedAt!.year}'
                : '-');
          case 5:
            return Text('${st.itemCount}');
          case 6:
            return _buildActions(st);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildActions(Stocktake st) {
    final l10n = AppLocalizations.of(context)!;
    final canApply = st.status == StocktakeStatus.review;
    final canCancel = st.status == StocktakeStatus.inProgress || st.status == StocktakeStatus.review;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosButton.icon(
          icon: Icons.list_alt_outlined,
          tooltip: l10n.inventoryViewCounts,
          onPressed: () => _handleAction('viewCounts', st),
          variant: PosButtonVariant.ghost,
        ),
        if (canApply)
          PosButton.icon(
            icon: Icons.check_circle_outline,
            tooltip: l10n.inventoryApplyStocktake,
            onPressed: () => _handleAction('apply', st),
            variant: PosButtonVariant.ghost,
          ),
        if (canCancel)
          PosButton.icon(
            icon: Icons.cancel_outlined,
            tooltip: l10n.inventoryCancelled,
            onPressed: () => _handleAction('cancel', st),
            variant: PosButtonVariant.ghost,
          ),
      ],
    );
  }

  Future<void> _showCreateDialog() async {
    final l10n = AppLocalizations.of(context)!;
    StocktakeType selectedType = StocktakeType.full;
    final notesCtrl = TextEditingController();
    String? selectedCategoryId;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(l10n.inventoryNewStocktake),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.inventoryStocktakeType, style: Theme.of(ctx).textTheme.labelMedium),
                  AppSpacing.gapH8,
                  SegmentedButton<StocktakeType>(
                    segments: [
                      ButtonSegment(value: StocktakeType.full, label: Text(l10n.inventoryStocktakeTypeFull)),
                      ButtonSegment(value: StocktakeType.partial, label: Text(l10n.inventoryStocktakeTypePartial)),
                      ButtonSegment(value: StocktakeType.category, label: Text(l10n.inventoryStocktakeTypeCategory)),
                    ],
                    selected: {selectedType},
                    onSelectionChanged: (s) => setDialogState(() => selectedType = s.first),
                  ),
                  AppSpacing.gapH16,
                  if (selectedType == StocktakeType.category) ...[
                    _CategoryDropdown(
                      value: selectedCategoryId,
                      onChanged: (v) => setDialogState(() => selectedCategoryId = v),
                    ),
                    AppSpacing.gapH16,
                  ],
                  TextField(
                    controller: notesCtrl,
                    decoration: InputDecoration(labelText: l10n.commonNotes),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    final data = {
                      'type': selectedType.value,
                      'notes': notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                      if (selectedCategoryId != null) 'category_id': selectedCategoryId,
                    };
                    final created = await ref.read(stocktakesProvider.notifier).createStocktake(data);
                    if (mounted) {
                      showPosSuccessSnackbar(context, l10n.inventoryStocktakeCreated);
                      final fresh = await ref.read(inventoryRepositoryProvider).getStocktake(created.id);
                      if (mounted) setState(() => _detailStocktake = fresh);
                    }
                  } catch (e) {
                    if (mounted) showPosErrorSnackbar(context, e.toString());
                  }
                },
                child: Text(l10n.inventoryStartStocktake),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Stocktake Detail / Count Sheet View ──────────────────────────

class _StocktakeDetailView extends ConsumerStatefulWidget {
  const _StocktakeDetailView({
    required this.stocktake,
    required this.onBack,
    required this.onCountsSaved,
  });

  final Stocktake stocktake;
  final VoidCallback onBack;
  final ValueChanged<Stocktake> onCountsSaved;

  @override
  ConsumerState<_StocktakeDetailView> createState() => _StocktakeDetailViewState();
}

class _StocktakeDetailViewState extends ConsumerState<_StocktakeDetailView> {
  late List<_CountRow> _rows;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rows = (widget.stocktake.items ?? []).map((i) => _CountRow(item: i)).toList();
  }

  @override
  void didUpdateWidget(_StocktakeDetailView old) {
    super.didUpdateWidget(old);
    if (old.stocktake.id != widget.stocktake.id) {
      _rows = (widget.stocktake.items ?? []).map((i) => _CountRow(item: i)).toList();
    }
  }

  bool get _isEditable =>
      widget.stocktake.status == StocktakeStatus.inProgress ||
      widget.stocktake.status == StocktakeStatus.review;

  Future<void> _saveCounts() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      final items = _rows.map((r) => {
        'product_id': r.item.productId,
        'counted_qty': double.tryParse(r.controller.text) ?? r.item.countedQty ?? r.item.expectedQty,
        'notes': r.notesController.text.trim().isEmpty ? null : r.notesController.text.trim(),
      }).toList();
      final updated = await ref.read(stocktakesProvider.notifier).updateCounts(widget.stocktake.id, items);
      if (mounted) {
        showPosSuccessSnackbar(context, l10n.inventoryCountsSaved);
        widget.onCountsSaved(updated);
      }
    } catch (e) {
      if (mounted) showPosErrorSnackbar(context, e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final st = widget.stocktake;

    return PosListPage(
      title: '${l10n.inventoryStocktakes} — ${st.referenceNumber ?? st.id.substring(0, 8)}',
      actions: [
        PosButton.icon(
          icon: Icons.arrow_back,
          tooltip: l10n.commonBack,
          onPressed: widget.onBack,
          variant: PosButtonVariant.ghost,
        ),
        if (_isEditable)
          PosButton(
            label: l10n.inventorySaveCounts,
            icon: Icons.save_outlined,
            onPressed: _saving ? null : _saveCounts,
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info card
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PosCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.xl,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _InfoChip(label: l10n.inventoryStocktakeType, value: _typeLabel(st.type, l10n)),
                    _InfoChip(
                      label: l10n.commonStatus,
                      value: _statusLabel(st.status, l10n),
                      color: _statusColor(st.status),
                    ),
                    if (st.categoryName != null)
                      _InfoChip(label: l10n.commonCategory, value: st.categoryName!),
                    if (st.startedAt != null)
                      _InfoChip(
                        label: l10n.inventoryStartedAt,
                        value: '${st.startedAt!.day}/${st.startedAt!.month}/${st.startedAt!.year}',
                      ),
                    _InfoChip(
                      label: l10n.inventoryItemCount,
                      value: '${st.countedItems}/${st.itemCount}',
                    ),
                    _InfoChip(
                      label: l10n.inventoryCostImpact,
                      value: 'SAR ${st.totalVarianceCostImpact.toStringAsFixed(3)}',
                      color: st.totalVarianceCostImpact < 0 ? AppColors.error : AppColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Count sheet table
          Expanded(
            child: _rows.isEmpty
                ? Center(child: Text(l10n.inventoryNoItemsToCount, style: TextStyle(color: AppColors.textMutedLight)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: _rows.length,
                    itemBuilder: (context, index) {
                      final row = _rows[index];
                      return _CountRowTile(
                        row: row,
                        l10n: l10n,
                        isEditable: _isEditable,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(StocktakeStatus? status, AppLocalizations l10n) {
    return switch (status) {
      StocktakeStatus.inProgress => l10n.inventoryStocktakeStatusInProgress,
      StocktakeStatus.review => l10n.inventoryStocktakeStatusReview,
      StocktakeStatus.completed => l10n.inventoryStocktakeStatusCompleted,
      StocktakeStatus.cancelled => l10n.inventoryStocktakeStatusCancelled,
      null => '-',
    };
  }

  String _typeLabel(StocktakeType? type, AppLocalizations l10n) {
    return switch (type) {
      StocktakeType.full => l10n.inventoryStocktakeTypeFull,
      StocktakeType.partial => l10n.inventoryStocktakeTypePartial,
      StocktakeType.category => l10n.inventoryStocktakeTypeCategory,
      null => '-',
    };
  }

  Color _statusColor(StocktakeStatus? status) {
    return switch (status) {
      StocktakeStatus.inProgress => AppColors.info,
      StocktakeStatus.review => AppColors.warning,
      StocktakeStatus.completed => AppColors.success,
      StocktakeStatus.cancelled => AppColors.error,
      null => AppColors.textMutedLight,
    };
  }
}

class _CountRow {
  _CountRow({required this.item})
      : controller = TextEditingController(
          text: item.countedQty?.toStringAsFixed(3) ?? '',
        ),
        notesController = TextEditingController(text: item.notes ?? '');

  final StocktakeItem item;
  final TextEditingController controller;
  final TextEditingController notesController;

  void dispose() {
    controller.dispose();
    notesController.dispose();
  }
}

class _CountRowTile extends StatelessWidget {
  const _CountRowTile({required this.row, required this.l10n, required this.isEditable});

  final _CountRow row;
  final AppLocalizations l10n;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final item = row.item;
    final variance = item.variance;
    final hasVariance = variance != null && variance != 0;
    return PosCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? item.productId.substring(0, 8),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (item.productSku != null)
                    Text(item.productSku!, style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.inventoryExpectedQty, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                  Text(item.expectedQty.toStringAsFixed(3)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: isEditable
                  ? TextFormField(
                      controller: row.controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.inventoryCountedQty,
                        isDense: true,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.inventoryCountedQty, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                        Text(item.countedQty?.toStringAsFixed(3) ?? '-'),
                      ],
                    ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.inventoryVariance, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                  Text(
                    variance != null ? variance.toStringAsFixed(3) : '-',
                    style: TextStyle(
                      color: hasVariance ? (variance! > 0 ? AppColors.success : AppColors.error) : null,
                      fontWeight: hasVariance ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: isEditable
                  ? TextFormField(
                      controller: row.notesController,
                      decoration: InputDecoration(
                        labelText: l10n.commonNotes,
                        isDense: true,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.commonNotes, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                        Text(item.notes ?? '-', overflow: TextOverflow.ellipsis),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small helpers ─────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _CategoryDropdown extends ConsumerWidget {
  const _CategoryDropdown({required this.value, required this.onChanged});
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);
    if (categoriesState is! CategoriesLoaded) {
      ref.read(categoriesProvider.notifier).load();
      return const CircularProgressIndicator.adaptive();
    }
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String?>(
      value: value,
      decoration: InputDecoration(labelText: l10n.commonCategory),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.inventoryAllCategories)),
        ...categoriesState.categories.map(
          (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
