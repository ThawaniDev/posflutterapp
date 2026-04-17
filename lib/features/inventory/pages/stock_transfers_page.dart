import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/branches/providers/branch_providers.dart';
import 'package:wameedpos/features/branches/providers/branch_state.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/inventory/enums/stock_transfer_status.dart';
import 'package:wameedpos/features/inventory/models/stock_transfer.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final msg = action == 'approve'
        ? l10n.stockTransferApproveConfirm
        : action == 'receive'
        ? l10n.stockTransferReceiveConfirm
        : l10n.stockTransferCancelConfirm;

    final actionLabel = action == 'approve'
        ? l10n.inventoryApprove
        : action == 'receive'
        ? l10n.inventoryReceive
        : l10n.commonCancel;

    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.stockTransferActionTitle(actionLabel),
      message: msg,
      confirmLabel: actionLabel,
      cancelLabel: l10n.commonCancel,
      isDanger: action == 'cancel',
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
        showPosSuccessSnackbar(context, l10n.stockTransferActionSuccess(action));
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(stockTransfersProvider);

    return PosListPage(
      title: l10n.inventoryStockTransfers,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showStockTransfersInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(stockTransfersProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.inventoryNewTransfer, icon: Icons.add, onPressed: () => _showCreateTransferDialog()),
      ],
      child: _buildBody(state),
    );
  }

  Widget _buildBody(StockTransfersState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is StockTransfersLoading || state is StockTransfersInitial;
    final error = state is StockTransfersError ? state.message : null;
    final transfers = state is StockTransfersLoaded ? state.transfers : <StockTransfer>[];

    return PosDataTable<StockTransfer>(
      columns: [
        PosTableColumn(title: l10n.inventoryRef),
        PosTableColumn(title: l10n.inventoryFromStore),
        PosTableColumn(title: l10n.inventoryToStore),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.commonDate),
      ],
      items: transfers,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(stockTransfersProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(icon: Icons.swap_horiz_outlined, title: l10n.inventoryNoTransfers),
      actions: [
        PosTableRowAction<StockTransfer>(
          label: l10n.inventoryApprove,
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          isVisible: (t) => t.status == StockTransferStatus.pending,
          onTap: (t) => _handleAction(t, 'approve'),
        ),
        PosTableRowAction<StockTransfer>(
          label: l10n.commonCancel,
          icon: Icons.cancel_outlined,
          isDestructive: true,
          isVisible: (t) => t.status == StockTransferStatus.pending,
          onTap: (t) => _handleAction(t, 'cancel'),
        ),
        PosTableRowAction<StockTransfer>(
          label: l10n.inventoryReceiveAction,
          icon: Icons.archive_outlined,
          color: AppColors.info,
          isVisible: (t) => t.status == StockTransferStatus.inTransit,
          onTap: (t) => _handleAction(t, 'receive'),
        ),
      ],
      cellBuilder: (t, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(t.referenceNumber ?? t.id.substring(0, 8));
          case 1:
            return Text(t.fromStoreName ?? t.fromStoreId.substring(0, 8));
          case 2:
            return Text(t.toStoreName ?? t.toStoreId.substring(0, 8));
          case 3:
            return PosBadge(label: t.status?.value ?? 'pending', variant: _statusVariant(t.status));
          case 4:
            return Text(t.createdAt != null ? '${t.createdAt!.day}/${t.createdAt!.month}/${t.createdAt!.year}' : '-');
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _showCreateTransferDialog() async {
    final l10n = AppLocalizations.of(context)!;
    // Ensure branches and products are loaded
    if (ref.read(branchListProvider) is! BranchListLoaded) {
      await ref.read(branchListProvider.notifier).load();
    }
    if (ref.read(productsProvider) is! ProductsLoaded) {
      await ref.read(productsProvider.notifier).load();
    }

    final formKey = GlobalKey<FormState>();
    final notesController = TextEditingController();
    final quantityController = TextEditingController();
    String? selectedFromStoreId;
    String? selectedToStoreId;
    String? selectedProductId;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final l10n = AppLocalizations.of(ctx)!;
          final branchState = ref.read(branchListProvider);
          final branches = branchState is BranchListLoaded ? branchState.branches : <Store>[];
          final productsState = ref.read(productsProvider);
          final productList = productsState is ProductsLoaded ? productsState.products : <Product>[];

          return AlertDialog(
            title: Text(l10n.inventoryNewTransfer),
            content: SizedBox(
              width: 500,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PosSearchableDropdown<String>(
                        items: branches.map((b) => PosDropdownItem(value: b.id, label: b.name)).toList(),
                        selectedValue: selectedFromStoreId,
                        onChanged: (v) => setDialogState(() => selectedFromStoreId = v),
                        label: l10n.inventoryFromStore,
                        hint: l10n.inventoryFromStore,
                        showSearch: true,
                        clearable: false,
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      PosSearchableDropdown<String>(
                        items: branches.map((b) => PosDropdownItem(value: b.id, label: b.name)).toList(),
                        selectedValue: selectedToStoreId,
                        onChanged: (v) => setDialogState(() => selectedToStoreId = v),
                        label: l10n.inventoryToStore,
                        hint: l10n.inventoryToStore,
                        showSearch: true,
                        clearable: false,
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      PosSearchableDropdown<String>(
                        items: productList.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
                        selectedValue: selectedProductId,
                        onChanged: (v) => setDialogState(() => selectedProductId = v),
                        label: l10n.inventoryProduct,
                        hint: l10n.inventoryProduct,
                        showSearch: true,
                        clearable: false,
                        validator: (v) => v == null ? l10n.commonRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: quantityController,
                        decoration: InputDecoration(labelText: l10n.inventoryQuantity),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.commonRequired;
                          if (double.tryParse(v) == null) return l10n.commonInvalid;
                          return null;
                        },
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
              PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.commonCancel),
              PosButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(ctx, {
                      'from_store_id': selectedFromStoreId,
                      'to_store_id': selectedToStoreId,
                      'notes': notesController.text.isNotEmpty ? notesController.text : null,
                      'items': [
                        {'product_id': selectedProductId, 'quantity_sent': double.parse(quantityController.text)},
                      ],
                    });
                  }
                },
                variant: PosButtonVariant.ghost,
                label: l10n.commonCreate,
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      try {
        await ref.read(stockTransfersProvider.notifier).createTransfer(result);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.inventoryTransferCreated);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }

    notesController.dispose();
    quantityController.dispose();
  }
}
