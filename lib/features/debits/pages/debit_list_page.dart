import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/debits/enums/debit_enums.dart';
import 'package:wameedpos/features/debits/models/debit.dart';
import 'package:wameedpos/features/debits/providers/debits_providers.dart';
import 'package:wameedpos/features/debits/providers/debits_state.dart';
import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/providers/order_providers.dart';
import 'package:wameedpos/features/orders/providers/order_state.dart';

class DebitListPage extends ConsumerStatefulWidget {
  const DebitListPage({super.key});

  @override
  ConsumerState<DebitListPage> createState() => _DebitListPageState();
}

class _DebitListPageState extends ConsumerState<DebitListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(debitsProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  PosBadgeVariant _statusVariant(DebitStatus status) {
    switch (status) {
      case DebitStatus.pending:
        return PosBadgeVariant.warning;
      case DebitStatus.partiallyAllocated:
        return PosBadgeVariant.info;
      case DebitStatus.fullyAllocated:
        return PosBadgeVariant.success;
      case DebitStatus.reversed:
        return PosBadgeVariant.error;
    }
  }

  String _statusLabel(DebitStatus status, AppLocalizations l10n) {
    switch (status) {
      case DebitStatus.pending:
        return l10n.debitsStatusPending;
      case DebitStatus.partiallyAllocated:
        return l10n.debitsStatusPartiallyAllocated;
      case DebitStatus.fullyAllocated:
        return l10n.debitsStatusFullyAllocated;
      case DebitStatus.reversed:
        return l10n.debitsStatusReversed;
    }
  }

  String _typeLabel(DebitType type, AppLocalizations l10n) {
    switch (type) {
      case DebitType.customerCredit:
        return l10n.debitsTypeCustomerCredit;
      case DebitType.supplierReturn:
        return l10n.debitsTypeSupplierReturn;
      case DebitType.inventoryAdjustment:
        return l10n.debitsTypeInventoryAdjustment;
      case DebitType.manualCredit:
        return l10n.debitsTypeManualCredit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(debitsProvider);

    return PosListPage(
      title: l10n.debitsTitle,
      searchController: _searchController,
      onSearchChanged: (value) => ref.read(debitsProvider.notifier).search(value),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showDebitListInfo(context),
        ),
        PopupMenuButton<String?>(
          icon: const Icon(Icons.filter_list),
          tooltip: l10n.debitsFilterByStatus,
          onSelected: (value) {
            ref.read(debitsProvider.notifier).filterByStatus(value);
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(value: null, child: Text(l10n.debitsAll)),
            PopupMenuItem(value: 'pending', child: Text(l10n.debitsStatusPending)),
            PopupMenuItem(value: 'partially_allocated', child: Text(l10n.debitsStatusPartiallyAllocated)),
            PopupMenuItem(value: 'fully_allocated', child: Text(l10n.debitsStatusFullyAllocated)),
            PopupMenuItem(value: 'reversed', child: Text(l10n.debitsStatusReversed)),
          ],
        ),
        PopupMenuButton<String?>(
          icon: const Icon(Icons.category_outlined),
          tooltip: l10n.debitsFilterByType,
          onSelected: (value) {
            ref.read(debitsProvider.notifier).filterByType(value);
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(value: null, child: Text(l10n.debitsAll)),
            PopupMenuItem(value: 'customer_credit', child: Text(l10n.debitsTypeCustomerCredit)),
            PopupMenuItem(value: 'supplier_return', child: Text(l10n.debitsTypeSupplierReturn)),
            PopupMenuItem(value: 'inventory_adjustment', child: Text(l10n.debitsTypeInventoryAdjustment)),
            PopupMenuItem(value: 'manual_credit', child: Text(l10n.debitsTypeManualCredit)),
          ],
        ),
        PosButton(
          label: l10n.add,
          icon: Icons.add,
          onPressed: () async {
            final result = await context.push<String>(Routes.debitsCreate);
            if (!mounted) return;
            if (result == 'created') {
              showPosSuccessSnackbar(context, l10n.debitsCreatedSuccess);
            }
          },
        ),
      ],
      child: Column(
        children: [
          // Summary cards
          if (state is DebitsLoaded && state.summary != null) _buildSummary(state.summary!, l10n),
          Expanded(child: _buildBody(state, l10n)),
        ],
      ),
    );
  }

  Widget _buildSummary(DebitSummary summary, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: PosKpiGrid(
        desktopCols: 4,
        mobileCols: 2,
        cards: [
          PosKpiCard(label: l10n.debitsSummaryTotal, value: summary.totalDebits.toString(), iconColor: AppColors.primary),
          PosKpiCard(
            label: l10n.debitsSummaryPending,
            value: summary.pendingAmount.toStringAsFixed(2),
            iconColor: AppColors.warning,
          ),
          PosKpiCard(
            label: l10n.debitsSummaryAllocated,
            value: summary.totalAllocated.toStringAsFixed(2),
            iconColor: AppColors.success,
          ),
          PosKpiCard(
            label: l10n.debitsSummaryUnallocated,
            value: summary.unallocatedAmount.toStringAsFixed(2),
            iconColor: AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(DebitsState state, AppLocalizations l10n) {
    final isLoading = state is DebitsLoading || state is DebitsInitial;
    final error = state is DebitsError ? state.message : null;
    final debits = state is DebitsLoaded ? state.debits : <Debit>[];
    final loaded = state is DebitsLoaded ? state : null;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final showRemainingBalance = screenWidth >= 1280;
    final showDate = screenWidth >= 1100;

    return PosDataTable<Debit>(
      columns: [
        PosTableColumn(title: l10n.debitsReferenceNumber),
        PosTableColumn(title: l10n.debitsCustomer),
        PosTableColumn(title: l10n.debitsType),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.debitsAmount, numeric: true),
        PosTableColumn(title: l10n.debitsRemainingBalance, numeric: true, visible: showRemainingBalance),
        PosTableColumn(title: l10n.commonDate, visible: showDate),
      ],
      items: debits,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(debitsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.account_balance_wallet_outlined,
        title: l10n.debitsNoDebits,
        subtitle: l10n.debitsNoDebitsSubtitle,
      ),
      actions: [
        PosTableRowAction<Debit>(
          label: l10n.debitsDetail,
          icon: Icons.visibility_outlined,
          onTap: (d) => context.push('${Routes.debitsDetail}/${d.id}'),
        ),
        PosTableRowAction<Debit>(
          label: l10n.edit,
          icon: Icons.edit_outlined,
          isVisible: (d) => d.canEdit,
          onTap: (d) async {
            final result = await context.push<String>('${Routes.debits}/${d.id}/edit');
            if (!mounted) return;
            if (result == 'updated') {
              showPosSuccessSnackbar(context, l10n.debitsUpdatedSuccess);
            }
          },
        ),
        PosTableRowAction<Debit>(
          label: l10n.debitsAllocate,
          icon: Icons.payments_outlined,
          isVisible: (d) => d.canAllocate,
          onTap: (d) => _showAllocateDialog(d),
        ),
        PosTableRowAction<Debit>(
          label: l10n.debitsReverse,
          icon: Icons.undo_outlined,
          isDestructive: true,
          isVisible: (d) => d.canReverse,
          onTap: (d) => _showReverseDialog(d),
        ),
        PosTableRowAction<Debit>(
          label: l10n.delete,
          icon: Icons.delete_outlined,
          isDestructive: true,
          isVisible: (d) => d.canDelete,
          onTap: (d) => _handleDelete(d),
        ),
      ],
      cellBuilder: (debit, colIndex, col) {
        if (col.title == l10n.debitsReferenceNumber) {
          return Text(debit.referenceNumber ?? '-', style: const TextStyle(fontWeight: FontWeight.w600));
        }
        if (col.title == l10n.debitsCustomer) {
          return Text(debit.customer?.name ?? '-');
        }
        if (col.title == l10n.debitsType) {
          return Text(_typeLabel(DebitType.fromValue(debit.debitType), l10n));
        }
        if (col.title == l10n.commonStatus) {
          return PosBadge(
            label: _statusLabel(DebitStatus.fromValue(debit.status), l10n),
            variant: _statusVariant(DebitStatus.fromValue(debit.status)),
          );
        }
        if (col.title == l10n.debitsAmount) {
          return Text(debit.amount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w600));
        }
        if (col.title == l10n.debitsRemainingBalance) {
          return Text(debit.remainingBalance.toStringAsFixed(2));
        }
        if (col.title == l10n.commonDate) {
          return Text(
            debit.createdAt != null ? '${debit.createdAt!.day}/${debit.createdAt!.month}/${debit.createdAt!.year}' : '-',
          );
        }
        return const SizedBox.shrink();
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 25,
      onPreviousPage: loaded != null ? () => ref.read(debitsProvider.notifier).previousPage() : null,
      onNextPage: loaded != null ? () => ref.read(debitsProvider.notifier).nextPage() : null,
    );
  }

  Future<void> _showAllocateDialog(Debit debit) async {
    final l10n = AppLocalizations.of(context)!;
    String? selectedOrderId;
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    // Ensure orders are loaded for the picker
    ref.read(ordersProvider.notifier).load();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final ordersState = ref.watch(ordersProvider);
          final orders = ordersState is OrdersLoaded ? ordersState.orders : <Order>[];
          return AlertDialog(
            title: Text(l10n.debitsAllocateDebit),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PosSearchableDropdown<String>(
                    hint: l10n.selectOrder,
                    label: l10n.debitsOrderId,
                    items: orders.map((o) => PosDropdownItem(value: o.id, label: o.orderNumber)).toList(),
                    selectedValue: selectedOrderId,
                    onChanged: (v) => setDialogState(() => selectedOrderId = v),
                    showSearch: true,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: amountController,
                    label: l10n.debitsAllocateAmount,
                    hint: debit.remainingBalance.toStringAsFixed(2),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: notesController,
                    label: l10n.commonNotesOptional,
                    hint: l10n.commonNotesOptional,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              PosButton(onPressed: () => Navigator.pop(ctx, false), variant: PosButtonVariant.ghost, label: l10n.cancel),
              PosButton(onPressed: () => Navigator.pop(ctx, true), variant: PosButtonVariant.ghost, label: l10n.debitsAllocate),
            ],
          );
        },
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final amount = double.tryParse(amountController.text) ?? 0;
        await ref
            .read(debitsProvider.notifier)
            .allocateDebit(
              debitId: debit.id,
              orderId: selectedOrderId ?? '',
              amount: amount,
              notes: notesController.text.isNotEmpty ? notesController.text : null,
            );
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.debitsAllocatedSuccess);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }

    amountController.dispose();
    notesController.dispose();
  }

  Future<void> _showReverseDialog(Debit debit) async {
    final l10n = AppLocalizations.of(context)!;
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.debitsReverseDebit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.debitsReverseConfirm),
            AppSpacing.gapH12,
            PosTextField(
              controller: reasonController,
              label: l10n.debitsReverseReason,
              hint: l10n.debitsReverseReason,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx, false), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(onPressed: () => Navigator.pop(ctx, true), variant: PosButtonVariant.ghost, label: l10n.debitsReverse),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref
            .read(debitsProvider.notifier)
            .reverseDebit(debit.id, reason: reasonController.text.isNotEmpty ? reasonController.text : null);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.debitsReversedSuccess);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }

    reasonController.dispose();
  }

  Future<void> _handleDelete(Debit debit) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.delete,
      message: l10n.debitsDeleteConfirm,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(debitsProvider.notifier).deleteDebit(debit.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.debitsDeletedSuccess);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }
}
