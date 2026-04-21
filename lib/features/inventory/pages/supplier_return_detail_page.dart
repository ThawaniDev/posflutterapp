import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/inventory/enums/supplier_return_status.dart';
import 'package:wameedpos/features/inventory/models/supplier_return.dart';
import 'package:wameedpos/features/inventory/providers/inventory_providers.dart';
import 'package:wameedpos/features/inventory/repositories/inventory_repository.dart';

class SupplierReturnDetailPage extends ConsumerStatefulWidget {
  const SupplierReturnDetailPage({super.key, required this.returnId});
  final String returnId;

  @override
  ConsumerState<SupplierReturnDetailPage> createState() => _SupplierReturnDetailPageState();
}

class _SupplierReturnDetailPageState extends ConsumerState<SupplierReturnDetailPage> {
  SupplierReturn? _returnData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await ref.read(inventoryRepositoryProvider).getSupplierReturn(widget.returnId);
      if (mounted) {
        setState(() {
          _returnData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
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

  Future<void> _handleStatusAction(String action) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(supplierReturnsProvider.notifier);
    final label = _returnData?.referenceNumber ?? widget.returnId.substring(0, 8);

    final confirmed = await showPosConfirmDialog(
      context,
      title: '$action "$label"?',
      message: l10n.supplierReturnActionConfirm(action, label),
      confirmLabel: action,
      cancelLabel: l10n.commonCancel,
      isDanger: action == 'Cancel',
    );

    if (confirmed != true || !mounted) return;

    try {
      switch (action) {
        case 'Submit':
          await notifier.submitReturn(widget.returnId);
        case 'Approve':
          await notifier.approveReturn(widget.returnId);
        case 'Complete':
          await notifier.completeReturn(widget.returnId);
        case 'Cancel':
          await notifier.cancelReturn(widget.returnId);
      }
      if (mounted) {
        showPosSuccessSnackbar(context, l10n.supplierReturnActionSuccess(action));
        _loadDetail();
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

    return PosListPage(
      title: l10n.supplierReturnDetail,
      showSearch: false,
      actions: [
        PosButton.icon(icon: Icons.refresh, tooltip: l10n.commonRefresh, onPressed: _loadDetail, variant: PosButtonVariant.ghost),
      ],
      isLoading: _isLoading,
      hasError: _error != null,
      errorMessage: _error,
      onRetry: _loadDetail,
      child: _returnData == null ? const SizedBox.shrink() : _buildContent(l10n),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final ret = _returnData!;
    final status = ret.status;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Header with status
        PosCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ret.referenceNumber ?? ret.id.substring(0, 8),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    PosBadge(label: _statusLabel(status, l10n), variant: _badgeVariant(status)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _detailRow(l10n.inventorySupplier, ret.supplierName ?? '-'),
                _detailRow(l10n.supplierReturnReason, ret.reason ?? '-'),
                _detailRow(l10n.inventoryTotalCost, '${ret.totalAmount.toStringAsFixed(2)} \u0081'),
                if (ret.notes != null && ret.notes!.isNotEmpty) _detailRow(l10n.commonNotes, ret.notes!),
                if (ret.createdByName != null) _detailRow(l10n.supplierReturnCreatedBy, ret.createdByName!),
                if (ret.approvedByName != null) _detailRow(l10n.supplierReturnApprovedBy, ret.approvedByName!),
                if (ret.approvedAt != null) _detailRow(l10n.supplierReturnApprovedAt, _formatDate(ret.approvedAt!)),
                if (ret.completedAt != null) _detailRow(l10n.supplierReturnCompletedAt, _formatDate(ret.completedAt!)),
                if (ret.createdAt != null) _detailRow(l10n.supplierReturnCreatedAt, _formatDate(ret.createdAt!)),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Status actions
        if (status == SupplierReturnStatus.draft ||
            status == SupplierReturnStatus.submitted ||
            status == SupplierReturnStatus.approved)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (status == SupplierReturnStatus.draft)
                  PosButton(
                    label: l10n.supplierReturnSubmitAction,
                    icon: Icons.send_outlined,
                    onPressed: () => _handleStatusAction('Submit'),
                  ),
                if (status == SupplierReturnStatus.submitted)
                  PosButton(
                    label: l10n.inventoryApprove,
                    icon: Icons.check_circle_outline,
                    onPressed: () => _handleStatusAction('Approve'),
                  ),
                if (status == SupplierReturnStatus.approved)
                  PosButton(
                    label: l10n.supplierReturnCompleteAction,
                    icon: Icons.done_all,
                    onPressed: () => _handleStatusAction('Complete'),
                  ),
                if (status == SupplierReturnStatus.draft || status == SupplierReturnStatus.submitted)
                  PosButton(
                    label: l10n.commonCancel,
                    icon: Icons.cancel_outlined,
                    variant: PosButtonVariant.outline,
                    onPressed: () => _handleStatusAction('Cancel'),
                  ),
              ],
            ),
          ),

        // Items
        Text(l10n.inventoryLineItems, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (ret.items != null && ret.items!.isNotEmpty) ...[
          ...ret.items!.asMap().entries.map((entry) {
            final item = entry.value;
            return PosCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName ?? '-',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (item.productSku != null) Text('SKU: ${item.productSku}', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        _chip(l10n.inventoryQuantity, item.quantity.toStringAsFixed(2)),
                        const SizedBox(width: AppSpacing.sm),
                        _chip(l10n.inventoryUnitCostLabel, item.unitCost.toStringAsFixed(2)),
                        const SizedBox(width: AppSpacing.sm),
                        _chip(l10n.inventoryTotal, (item.quantity * item.unitCost).toStringAsFixed(2)),
                      ],
                    ),
                    if (item.reason != null && item.reason!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text('${l10n.supplierReturnItemReason}: ${item.reason}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                    if (item.batchNumber != null && item.batchNumber!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${l10n.supplierReturnBatchNumber}: ${item.batchNumber}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ] else
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(child: Text(l10n.supplierReturnNoItems, style: Theme.of(context).textTheme.bodyMedium)),
          ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(flex: 3, child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _chip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: AppRadius.borderXs),
      child: Text('$label: $value', style: Theme.of(context).textTheme.bodySmall),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}
