import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/inventory/enums/supplier_return_status.dart';
import 'package:wameedpos/features/inventory/models/supplier_return.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/providers/inventory_state.dart';

class SupplierReturnsPage extends ConsumerStatefulWidget {
  const SupplierReturnsPage({super.key});

  @override
  ConsumerState<SupplierReturnsPage> createState() => _SupplierReturnsPageState();
}

class _SupplierReturnsPageState extends ConsumerState<SupplierReturnsPage> {
  final _searchController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(supplierReturnsProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  PosBadgeVariant _badgeVariant(SupplierReturnStatus? status) {
    return switch (status) {
      SupplierReturnStatus.draft => PosBadgeVariant.neutral,
      SupplierReturnStatus.submitted => PosBadgeVariant.info,
      SupplierReturnStatus.approved => PosBadgeVariant.warning,
      SupplierReturnStatus.completed => PosBadgeVariant.success,
      SupplierReturnStatus.cancelled => PosBadgeVariant.error,
      null => PosBadgeVariant.neutral,
    };
  }

  String _statusLabel(SupplierReturnStatus? status, AppLocalizations l10n) {
    return switch (status) {
      SupplierReturnStatus.draft => l10n.inventoryDraft,
      SupplierReturnStatus.submitted => l10n.supplierReturnSubmitted,
      SupplierReturnStatus.approved => l10n.inventoryApprove,
      SupplierReturnStatus.completed => l10n.supplierReturnCompleted,
      SupplierReturnStatus.cancelled => l10n.inventoryCancelled,
      null => l10n.inventoryDraft,
    };
  }

  Future<void> _handleAction(String action, SupplierReturn ret) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(supplierReturnsProvider.notifier);
    final label = ret.referenceNumber ?? ret.id.substring(0, 8);

    final confirmed = await showPosConfirmDialog(
      context,
      title: '$action "$label"?',
      message: l10n.supplierReturnActionConfirm(action, label),
      confirmLabel: action,
      cancelLabel: l10n.commonCancel,
      isDanger: action == 'Cancel' || action == 'Delete',
    );

    if (confirmed != true || !mounted) return;

    try {
      switch (action) {
        case 'Submit':
          await notifier.submitReturn(ret.id);
        case 'Approve':
          await notifier.approveReturn(ret.id);
        case 'Complete':
          await notifier.completeReturn(ret.id);
        case 'Cancel':
          await notifier.cancelReturn(ret.id);
        case 'Delete':
          await notifier.deleteReturn(ret.id);
      }
      if (mounted) {
        showPosSuccessSnackbar(context, l10n.supplierReturnActionSuccess(action));
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
    final state = ref.watch(supplierReturnsProvider);

    return PosListPage(
      title: l10n.supplierReturnsTitle,
      searchController: _searchController,
      searchHint: l10n.supplierReturnSearchHint,
      onSearchSubmitted: (v) => ref.read(supplierReturnsProvider.notifier).searchReturns(v),
      onSearchClear: () {
        _searchController.clear();
        ref.read(supplierReturnsProvider.notifier).searchReturns(null);
      },
      filters: [
        SizedBox(
          width: 180,
          child: PosSearchableDropdown<String?>(
            items: SupplierReturnStatus.values
                .map((s) => PosDropdownItem<String?>(value: s.value, label: _statusLabel(s, l10n)))
                .toList(),
            selectedValue: _selectedStatus,
            onChanged: (v) {
              setState(() => _selectedStatus = v);
              ref.read(supplierReturnsProvider.notifier).filterByStatus(v);
            },
            hint: l10n.inventoryFilterByStatus,
            showSearch: false,
            clearable: true,
          ),
        ),
      ],
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showSupplierReturnsInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(supplierReturnsProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(
          label: l10n.supplierReturnNew,
          icon: Icons.add,
          onPressed: () async {
            final created = await context.push<bool>(Routes.supplierReturnsAdd);
            if (created == true) ref.read(supplierReturnsProvider.notifier).load();
          },
        ),
      ],
      child: _buildBody(state),
    );
  }

  Widget _buildBody(SupplierReturnsState state) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = state is SupplierReturnsLoading || state is SupplierReturnsInitial;
    final error = state is SupplierReturnsError ? state.message : null;
    final returns = state is SupplierReturnsLoaded ? state.returns : <SupplierReturn>[];
    final loaded = state is SupplierReturnsLoaded ? state : null;

    return PosDataTable<SupplierReturn>(
      columns: [
        PosTableColumn(title: l10n.inventoryReference),
        PosTableColumn(title: l10n.inventorySupplier),
        PosTableColumn(title: l10n.commonStatus),
        PosTableColumn(title: l10n.supplierReturnReason),
        PosTableColumn(title: l10n.inventoryTotalCost, numeric: true),
      ],
      items: returns,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(supplierReturnsProvider.notifier).load(),
      emptyConfig: PosTableEmptyConfig(
        icon: Icons.assignment_return_outlined,
        title: l10n.supplierReturnNoReturns,
        subtitle: l10n.supplierReturnNoReturnsHint,
      ),
      onRowTap: (ret) => context.push('${Routes.supplierReturnDetail}?id=${ret.id}'),
      actions: [
        PosTableRowAction<SupplierReturn>(
          label: l10n.supplierReturnSubmitAction,
          icon: Icons.send_outlined,
          color: AppColors.info,
          isVisible: (r) => r.status == SupplierReturnStatus.draft,
          onTap: (r) => _handleAction('Submit', r),
        ),
        PosTableRowAction<SupplierReturn>(
          label: l10n.inventoryApprove,
          icon: Icons.check_circle_outline,
          color: AppColors.success,
          isVisible: (r) => r.status == SupplierReturnStatus.submitted,
          onTap: (r) => _handleAction('Approve', r),
        ),
        PosTableRowAction<SupplierReturn>(
          label: l10n.supplierReturnCompleteAction,
          icon: Icons.done_all,
          color: AppColors.success,
          isVisible: (r) => r.status == SupplierReturnStatus.approved,
          onTap: (r) => _handleAction('Complete', r),
        ),
        PosTableRowAction<SupplierReturn>(
          label: l10n.commonCancel,
          icon: Icons.cancel_outlined,
          color: AppColors.warning,
          isVisible: (r) => r.status == SupplierReturnStatus.draft || r.status == SupplierReturnStatus.submitted,
          onTap: (r) => _handleAction('Cancel', r),
        ),
        PosTableRowAction<SupplierReturn>(
          label: l10n.commonDelete,
          icon: Icons.delete_outline,
          isDestructive: true,
          isVisible: (r) => r.status == SupplierReturnStatus.draft,
          onTap: (r) => _handleAction('Delete', r),
        ),
      ],
      cellBuilder: (ret, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Text(ret.referenceNumber ?? ret.id.substring(0, 8));
          case 1:
            return Text(ret.supplierName ?? '-');
          case 2:
            return PosBadge(label: _statusLabel(ret.status, l10n), variant: _badgeVariant(ret.status));
          case 3:
            return Text(ret.reason ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis);
          case 4:
            return Text(ret.totalAmount.toStringAsFixed(2));
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 25,
      onPreviousPage: loaded != null ? () => ref.read(supplierReturnsProvider.notifier).load(page: loaded.currentPage - 1) : null,
      onNextPage: loaded != null ? () => ref.read(supplierReturnsProvider.notifier).load(page: loaded.currentPage + 1) : null,
    );
  }
}
