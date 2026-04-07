import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/features/debits/enums/debit_enums.dart';
import 'package:thawani_pos/features/debits/models/debit.dart';
import 'package:thawani_pos/features/debits/repositories/debit_repository.dart';

class DebitDetailPage extends ConsumerStatefulWidget {
  final String debitId;

  const DebitDetailPage({super.key, required this.debitId});

  @override
  ConsumerState<DebitDetailPage> createState() => _DebitDetailPageState();
}

class _DebitDetailPageState extends ConsumerState<DebitDetailPage> {
  Debit? _debit;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDebit();
  }

  Future<void> _loadDebit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final debit = await ref.read(debitRepositoryProvider).getDebit(widget.debitId);
      if (mounted)
        setState(() {
          _debit = debit;
          _isLoading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
    }
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

  String _sourceLabel(DebitSource source, AppLocalizations l10n) {
    switch (source) {
      case DebitSource.posTerminal:
        return l10n.debitsSourcePosTerminal;
      case DebitSource.invoice:
        return l10n.debitsSourceInvoice;
      case DebitSource.returnSource:
        return l10n.debitsSourceReturn;
      case DebitSource.manual:
        return l10n.debitsSourceManual;
      case DebitSource.inventorySystem:
        return l10n.debitsSourceInventorySystem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.debitsDetail),
        actions: [
          if (_debit != null && _debit!.canEdit)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.edit,
              onPressed: () async {
                await context.push('${Routes.debits}/${_debit!.id}/edit');
                _loadDebit();
              },
            ),
          IconButton(icon: const Icon(Icons.refresh), tooltip: l10n.commonRefresh, onPressed: _loadDebit),
        ],
      ),
      body: _buildContent(l10n),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: AppColors.error)),
            AppSpacing.gapH12,
            ElevatedButton(onPressed: _loadDebit, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    final debit = _debit!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status & Amount header
          _buildHeader(debit, l10n),
          AppSpacing.gapH24,

          // Debit info card
          _buildInfoCard(debit, l10n),
          AppSpacing.gapH24,

          // Customer info
          if (debit.customer != null) ...[_buildCustomerCard(debit.customer!, l10n), AppSpacing.gapH24],

          // Allocations
          _buildAllocationsSection(debit, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(Debit debit, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (debit.referenceNumber != null)
                  Text(debit.referenceNumber!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                AppSpacing.gapH4,
                PosBadge(
                  label: _statusLabel(DebitStatus.fromValue(debit.status), l10n),
                  variant: _statusVariant(DebitStatus.fromValue(debit.status)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(l10n.debitsAmount, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text(
                debit.amount.toStringAsFixed(2),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              AppSpacing.gapH4,
              Text(
                '${l10n.debitsRemainingBalance}: ${debit.remainingBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Debit debit, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(l10n.debitsType, _typeLabel(DebitType.fromValue(debit.debitType), l10n)),
          _infoRow(l10n.debitsSource, _sourceLabel(DebitSource.fromValue(debit.source), l10n)),
          if (debit.description != null) _infoRow(l10n.debitsDescription, debit.description!),
          if (debit.descriptionAr != null) _infoRow(l10n.debitsDescriptionAr, debit.descriptionAr!),
          if (debit.notes != null) _infoRow(l10n.commonNotes, debit.notes!),
          if (debit.createdByName != null) _infoRow(l10n.debitsCreatedBy, debit.createdByName!),
          if (debit.allocatedByName != null) _infoRow(l10n.debitsAllocatedBy, debit.allocatedByName!),
          if (debit.allocatedAt != null)
            _infoRow(l10n.debitsAllocatedAt, '${debit.allocatedAt!.day}/${debit.allocatedAt!.month}/${debit.allocatedAt!.year}'),
          _infoRow(
            l10n.debitsCreatedAt,
            debit.createdAt != null ? '${debit.createdAt!.day}/${debit.createdAt!.month}/${debit.createdAt!.year}' : '-',
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
              style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
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

  Widget _buildCustomerCard(DebitCustomer customer, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.debitsCustomer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          _infoRow(l10n.customers, customer.name),
          if (customer.phone != null) _infoRow(l10n.settings, customer.phone!),
          if (customer.email != null) _infoRow(l10n.email, customer.email!),
        ],
      ),
    );
  }

  Widget _buildAllocationsSection(Debit debit, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.debitsAllocations, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          if (debit.allocations.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Text(l10n.debitsNoAllocations, style: const TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ...debit.allocations.map((a) => _allocationTile(a, l10n)),
        ],
      ),
    );
  }

  Widget _allocationTile(DebitAllocation allocation, AppLocalizations l10n) {
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
                  '${l10n.debitsOrderNumber}: ${allocation.orderNumber ?? allocation.orderId}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (allocation.notes != null)
                  Text(allocation.notes!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                if (allocation.allocatedByName != null)
                  Text(
                    '${l10n.debitsAllocatedBy}: ${allocation.allocatedByName!}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                allocation.amount.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
              ),
              if (allocation.allocatedAt != null)
                Text(
                  '${allocation.allocatedAt!.day}/${allocation.allocatedAt!.month}/${allocation.allocatedAt!.year}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
