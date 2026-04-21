import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/receivables/enums/receivable_enums.dart';
import 'package:wameedpos/features/receivables/models/receivable.dart';
import 'package:wameedpos/features/receivables/providers/receivables_providers.dart';
import 'package:wameedpos/features/receivables/providers/receivables_state.dart';
import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/providers/order_providers.dart';
import 'package:wameedpos/features/orders/providers/order_state.dart';

class ReceivableListPage extends ConsumerStatefulWidget {
  const ReceivableListPage({super.key});

  @override
  ConsumerState<ReceivableListPage> createState() => _ReceivableListPageState();
}

class _ReceivableListPageState extends ConsumerState<ReceivableListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(receivablesProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  PosBadgeVariant _statusVariant(ReceivableStatus status) {
    switch (status) {
      case ReceivableStatus.pending:
        return PosBadgeVariant.warning;
      case ReceivableStatus.partiallyPaid:
        return PosBadgeVariant.info;
      case ReceivableStatus.fullyPaid:
        return PosBadgeVariant.success;
      case ReceivableStatus.reversed:
        return PosBadgeVariant.error;
    }
  }

  String _statusLabel(ReceivableStatus status, AppLocalizations l10n) {
    switch (status) {
      case ReceivableStatus.pending:
        return l10n.receivablesStatusPending;
      case ReceivableStatus.partiallyPaid:
        return l10n.receivablesStatusPartiallyPaid;
      case ReceivableStatus.fullyPaid:
        return l10n.receivablesStatusFullyPaid;
      case ReceivableStatus.reversed:
        return l10n.receivablesStatusReversed;
    }
  }

  String _typeLabel(ReceivableType type, AppLocalizations l10n) {
    switch (type) {
      case ReceivableType.creditSale:
        return l10n.receivablesTypeCreditSale;
      case ReceivableType.loan:
        return l10n.receivablesTypeLoan;
      case ReceivableType.inventoryAdjustment:
        return l10n.receivablesTypeInventoryAdjustment;
      case ReceivableType.manual:
        return l10n.receivablesTypeManual;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(receivablesProvider);

    return PosListPage(
      title: l10n.receivablesTitle,
      searchController: _searchController,
      onSearchChanged: (value) => ref.read(receivablesProvider.notifier).search(value),
      actions: [
        PopupMenuButton<String?>(
          icon: const Icon(Icons.filter_list),
          tooltip: l10n.receivablesFilterByStatus,
          onSelected: (value) {
            ref.read(receivablesProvider.notifier).filterByStatus(value);
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(value: null, child: Text(l10n.receivablesAll)),
            PopupMenuItem(value: 'pending', child: Text(l10n.receivablesStatusPending)),
            PopupMenuItem(value: 'partially_paid', child: Text(l10n.receivablesStatusPartiallyPaid)),
            PopupMenuItem(value: 'fully_paid', child: Text(l10n.receivablesStatusFullyPaid)),
            PopupMenuItem(value: 'reversed', child: Text(l10n.receivablesStatusReversed)),
          ],
        ),
        PopupMenuButton<String?>(
          icon: const Icon(Icons.category_outlined),
          tooltip: l10n.receivablesFilterByType,
          onSelected: (value) {
            ref.read(receivablesProvider.notifier).filterByType(value);
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(value: null, child: Text(l10n.receivablesAll)),
            PopupMenuItem(value: 'credit_sale', child: Text(l10n.receivablesTypeCreditSale)),
            PopupMenuItem(value: 'loan', child: Text(l10n.receivablesTypeLoan)),
            PopupMenuItem(value: 'inventory_adjustment', child: Text(l10n.receivablesTypeInventoryAdjustment)),
            PopupMenuItem(value: 'manual', child: Text(l10n.receivablesTypeManual)),
          ],
        ),
        PosButton(
          label: l10n.add,
          icon: Icons.add,
          onPressed: () async {
            final result = await context.push<String>(Routes.receivablesCreate);
            if (!mounted) return;
            if (result == 'created') {
              showPosSuccessSnackbar(context, l10n.receivablesCreatedSuccess);
            }
          },
        ),
      ],
      child: Column(
        children: [
          // Summary cards
          if (state is ReceivablesLoaded && state.summary != null) _buildSummary(state.summary!, l10n),
          Expanded(child: _buildBody(state, l10n)),
        ],
      ),
    );
  }

  Widget _buildSummary(ReceivableSummary summary, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: PosKpiGrid(
        desktopCols: 4,
        mobileCols: 2,
        cards: [
          PosKpiCard(
            label: l10n.receivablesSummaryTotal,
            value: summary.totalReceivables.toString(),
            iconColor: AppColors.primary,
          ),
          PosKpiCard(
            label: l10n.receivablesSummaryPending,
            value: summary.pendingAmount.toStringAsFixed(2),
            iconColor: AppColors.warning,
          ),
          PosKpiCard(
            label: l10n.receivablesSummaryPaid,
            value: summary.totalPaid.toStringAsFixed(2),
            iconColor: AppColors.success,
          ),
          PosKpiCard(
            label: l10n.receivablesSummaryOutstanding,
            value: summary.outstandingAmount.toStringAsFixed(2),
            iconColor: AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ReceivablesState state, AppLocalizations l10n) {
    final isLoading = state is ReceivablesLoading || state is ReceivablesInitial;
    final error = state is ReceivablesError ? state.message : null;
    final receivables = state is ReceivablesLoaded ? state.receivables : <Receivable>[];
    final loaded = state is ReceivablesLoaded ? state : null;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final showRemainingBalance = screenWidth >= 1280;
    final showDate = screenWidth >= 1100;

    return PosDataTable<Receivable>(
      columns: [
        PosTableColumn(title: l10n.receivablesReferenceNumber),
        PosTableColumn(title: l10n.receivablesCustomer),
        PosTableColumn(title: l10n.receivablesType),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.receivablesAmount, numeric: true),
        PosTableColumn(title: l10n.receivablesRemainingBalance, numeric: true, visible: showRemainingBalance),
        PosTableColumn(title: l10n.commonDate, visible: showDate),
      ],
      items: receivables,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(receivablesProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.account_balance_wallet_outlined,
        title: l10n.receivablesNoReceivables,
        subtitle: l10n.receivablesNoReceivablesSubtitle,
      ),
      actions: [
        PosTableRowAction<Receivable>(
          label: l10n.receivablesDetail,
          icon: Icons.visibility_outlined,
          onTap: (d) => context.push('${Routes.receivablesDetail}/${d.id}'),
        ),
        PosTableRowAction<Receivable>(
          label: l10n.edit,
          icon: Icons.edit_outlined,
          isVisible: (d) => d.canEdit,
          onTap: (d) async {
            final result = await context.push<String>('${Routes.receivables}/${d.id}/edit');
            if (!mounted) return;
            if (result == 'updated') {
              showPosSuccessSnackbar(context, l10n.receivablesUpdatedSuccess);
            }
          },
        ),
        PosTableRowAction<Receivable>(
          label: l10n.receivablesRecordPayment,
          icon: Icons.payments_outlined,
          isVisible: (d) => d.canRecordPayment,
          onTap: (d) => _showAllocateDialog(d),
        ),
        PosTableRowAction<Receivable>(
          label: l10n.receivablesReverse,
          icon: Icons.undo_outlined,
          isDestructive: true,
          isVisible: (d) => d.canReverse,
          onTap: (d) => _showReverseDialog(d),
        ),
        PosTableRowAction<Receivable>(
          label: l10n.delete,
          icon: Icons.delete_outlined,
          isDestructive: true,
          isVisible: (d) => d.canDelete,
          onTap: (d) => _handleDelete(d),
        ),
      ],
      cellBuilder: (receivable, colIndex, col) {
        if (col.title == l10n.receivablesReferenceNumber) {
          return Text(receivable.referenceNumber ?? '-', style: const TextStyle(fontWeight: FontWeight.w600));
        }
        if (col.title == l10n.receivablesCustomer) {
          return Text(receivable.customer?.name ?? '-');
        }
        if (col.title == l10n.receivablesType) {
          return Text(_typeLabel(ReceivableType.fromValue(receivable.receivableType), l10n));
        }
        if (col.title == l10n.commonStatus) {
          return PosBadge(
            label: _statusLabel(ReceivableStatus.fromValue(receivable.status), l10n),
            variant: _statusVariant(ReceivableStatus.fromValue(receivable.status)),
          );
        }
        if (col.title == l10n.receivablesAmount) {
          return Text(receivable.amount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w600));
        }
        if (col.title == l10n.receivablesRemainingBalance) {
          return Text(receivable.remainingBalance.toStringAsFixed(2));
        }
        if (col.title == l10n.commonDate) {
          return Text(
            receivable.createdAt != null
                ? '${receivable.createdAt!.day}/${receivable.createdAt!.month}/${receivable.createdAt!.year}'
                : '-',
          );
        }
        return const SizedBox.shrink();
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 25,
      onPreviousPage: loaded != null ? () => ref.read(receivablesProvider.notifier).previousPage() : null,
      onNextPage: loaded != null ? () => ref.read(receivablesProvider.notifier).nextPage() : null,
    );
  }

  Future<void> _showAllocateDialog(Receivable receivable) async {
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
            title: Text(l10n.receivablesReverseReceivable),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PosSearchableDropdown<String>(
                    hint: l10n.selectOrder,
                    label: l10n.receivablesOrderNumber,
                    items: orders.map((o) => PosDropdownItem(value: o.id, label: o.orderNumber)).toList(),
                    selectedValue: selectedOrderId,
                    onChanged: (v) => setDialogState(() => selectedOrderId = v),
                    showSearch: true,
                  ),
                  AppSpacing.gapH12,
                  PosTextField(
                    controller: amountController,
                    label: l10n.receivablesPaymentAmount,
                    hint: receivable.remainingBalance.toStringAsFixed(2),
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
              PosButton(
                onPressed: () => Navigator.pop(ctx, true),
                variant: PosButtonVariant.ghost,
                label: l10n.receivablesRecordPayment,
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final amount = double.tryParse(amountController.text) ?? 0;
        await ref
            .read(receivablesProvider.notifier)
            .recordPayment(
              receivableId: receivable.id,
              orderId: selectedOrderId ?? '',
              amount: amount,
              notes: notesController.text.isNotEmpty ? notesController.text : null,
            );
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.receivablesPaymentSuccess);
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

  Future<void> _showReverseDialog(Receivable receivable) async {
    final l10n = AppLocalizations.of(context)!;
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.receivablesReverseReceivable),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.receivablesReverseConfirm),
            AppSpacing.gapH12,
            PosTextField(
              controller: reasonController,
              label: l10n.receivablesReverseReason,
              hint: l10n.receivablesReverseReason,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx, false), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(onPressed: () => Navigator.pop(ctx, true), variant: PosButtonVariant.ghost, label: l10n.receivablesReverse),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref
            .read(receivablesProvider.notifier)
            .reverseReceivable(receivable.id, reason: reasonController.text.isNotEmpty ? reasonController.text : null);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.receivablesReversedSuccess);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }

    reasonController.dispose();
  }

  Future<void> _handleDelete(Receivable receivable) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.delete,
      message: l10n.receivablesDeleteConfirm,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(receivablesProvider.notifier).deleteReceivable(receivable.id);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.receivablesDeletedSuccess);
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }
}
