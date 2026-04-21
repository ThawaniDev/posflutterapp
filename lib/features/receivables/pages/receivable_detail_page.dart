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
import 'package:wameedpos/features/receivables/repositories/receivable_repository.dart';

class ReceivableDetailPage extends ConsumerStatefulWidget {

  const ReceivableDetailPage({super.key, required this.receivableId});
  final String receivableId;

  @override
  ConsumerState<ReceivableDetailPage> createState() => _ReceivableDetailPageState();
}

class _ReceivableDetailPageState extends ConsumerState<ReceivableDetailPage> {
  Receivable? _receivable;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReceivable();
  }

  Future<void> _loadReceivable() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final receivable = await ref.read(receivableRepositoryProvider).getReceivable(widget.receivableId);
      if (mounted) {
        setState(() {
          _receivable = receivable;
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

  String _sourceLabel(ReceivableSource source, AppLocalizations l10n) {
    switch (source) {
      case ReceivableSource.posTerminal:
        return l10n.receivablesSourcePosTerminal;
      case ReceivableSource.invoice:
        return l10n.receivablesSourceInvoice;
      case ReceivableSource.returnSource:
        return l10n.receivablesSourceReturn;
      case ReceivableSource.manual:
        return l10n.receivablesSourceManual;
      case ReceivableSource.inventorySystem:
        return l10n.receivablesSourceInventorySystem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: l10n.receivablesDetail,
      showSearch: false,
      isLoading: _isLoading,
      hasError: _error != null,
      errorMessage: _error,
      onRetry: _loadReceivable,
      actions: [
        if (_receivable != null && _receivable!.canEdit)
          PosButton(
            label: l10n.edit,
            icon: Icons.edit_outlined,
            variant: PosButtonVariant.outline,
            onPressed: () async {
              final result = await context.push<String>('${Routes.receivables}/${_receivable!.id}/edit');
              if (!mounted) return;
              if (result == 'updated') {
                showPosSuccessSnackbar(context, l10n.receivablesUpdatedSuccess);
              }
              _loadReceivable();
            },
          ),
      ],
      child: _receivable == null ? const SizedBox.shrink() : _buildContent(l10n),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final receivable = _receivable!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status & Amount header
        _buildHeader(receivable, l10n),
        AppSpacing.gapH24,

        // Receivable info card
        _buildInfoCard(receivable, l10n),
        AppSpacing.gapH24,

        // Customer info
        if (receivable.customer != null) ...[_buildCustomerCard(receivable.customer!, l10n), AppSpacing.gapH24],

        // Payments
        _buildPaymentsSection(receivable, l10n),
      ],
    );
  }

  Widget _buildHeader(Receivable receivable, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (receivable.referenceNumber != null)
                  Text(receivable.referenceNumber!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                AppSpacing.gapH4,
                PosBadge(
                  label: _statusLabel(ReceivableStatus.fromValue(receivable.status), l10n),
                  variant: _statusVariant(ReceivableStatus.fromValue(receivable.status)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.receivablesAmount,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedFor(context),
                ),
              ),
              Text(
                receivable.amount.toStringAsFixed(2),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              AppSpacing.gapH4,
              Text(
                '${l10n.receivablesRemainingBalance}: ${receivable.remainingBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedFor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Receivable receivable, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(l10n.receivablesType, _typeLabel(ReceivableType.fromValue(receivable.receivableType), l10n)),
          _infoRow(l10n.receivablesSource, _sourceLabel(ReceivableSource.fromValue(receivable.source), l10n)),
          if (receivable.description != null) _infoRow(l10n.receivablesDescription, receivable.description!),
          if (receivable.descriptionAr != null) _infoRow(l10n.receivablesDescriptionAr, receivable.descriptionAr!),
          if (receivable.notes != null) _infoRow(l10n.commonNotes, receivable.notes!),
          if (receivable.createdByName != null) _infoRow(l10n.receivablesCreatedBy, receivable.createdByName!),
          if (receivable.settledByName != null) _infoRow(l10n.receivablesSettledBy, receivable.settledByName!),
          if (receivable.settledAt != null)
            _infoRow(
              l10n.receivablesSettledAt,
              '${receivable.settledAt!.day}/${receivable.settledAt!.month}/${receivable.settledAt!.year}',
            ),
          _infoRow(
            l10n.receivablesCreatedAt,
            receivable.createdAt != null
                ? '${receivable.createdAt!.day}/${receivable.createdAt!.month}/${receivable.createdAt!.year}'
                : '-',
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.mutedFor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(ReceivableCustomer customer, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.receivablesCustomer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          _infoRow(l10n.customers, customer.name),
          if (customer.phone != null) _infoRow(l10n.settings, customer.phone!),
          // email not available on ReceivableCustomer
        ],
      ),
    );
  }

  Widget _buildPaymentsSection(Receivable receivable, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.receivablesPayments, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          if (receivable.payments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Text(
                  l10n.receivablesNoPayments,
                  style: TextStyle(
                    color: AppColors.mutedFor(context),
                  ),
                ),
              ),
            )
          else
            ...receivable.payments.map((a) => _paymentTile(a, l10n)),
        ],
      ),
    );
  }

  Widget _paymentTile(ReceivablePayment payment, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.borderSubtleLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_outlined, size: 20, color: AppColors.primary),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.receivablesOrderNumber}: ${payment.orderNumber ?? payment.orderId}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (payment.notes != null)
                  Text(
                    payment.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedFor(context),
                    ),
                  ),
                if (payment.settledByName != null)
                  Text(
                    '${l10n.receivablesSettledBy}: ${payment.settledByName!}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedFor(context),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                payment.amount.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
              ),
              if (payment.settledAt != null)
                Text(
                  '${payment.settledAt!.day}/${payment.settledAt!.month}/${payment.settledAt!.year}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.mutedFor(context),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
