import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/pos_terminal/enums/transaction_status.dart';
import 'package:thawani_pos/features/pos_terminal/enums/transaction_type.dart';
import 'package:thawani_pos/features/pos_terminal/models/payment.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction_item.dart';
import 'package:thawani_pos/features/transactions/providers/transaction_explorer_providers.dart';
import 'package:thawani_pos/features/transactions/providers/transaction_explorer_state.dart';

class TransactionDetailPage extends ConsumerStatefulWidget {
  const TransactionDetailPage({super.key, required this.transactionId});

  final String transactionId;

  @override
  ConsumerState<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends ConsumerState<TransactionDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(transactionDetailProvider.notifier).load(widget.transactionId));
  }

  Future<void> _handleVoid(AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.txVoidConfirmTitle,
      message: l10n.txVoidConfirmMessage,
      confirmLabel: l10n.txVoidAction,
      isDanger: true,
    );
    if (confirmed == true) {
      await ref.read(transactionDetailProvider.notifier).voidTransaction(widget.transactionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(transactionDetailProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.txDetailTitle),
        actions: [
          if (state is TransactionDetailLoaded && state.transaction.status != TransactionStatus.voided)
            IconButton(
              icon: const Icon(Icons.block_outlined),
              tooltip: l10n.txVoidAction,
              color: AppColors.error,
              onPressed: () => _handleVoid(l10n),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(transactionDetailProvider.notifier).load(widget.transactionId),
          ),
        ],
      ),
      body: _buildBody(state, l10n, isDark),
    );
  }

  Widget _buildBody(TransactionDetailState state, AppLocalizations l10n, bool isDark) {
    if (state is TransactionDetailLoading || state is TransactionDetailInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is TransactionDetailError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message, style: const TextStyle(color: AppColors.error)),
            AppSpacing.gapH12,
            ElevatedButton(
              onPressed: () => ref.read(transactionDetailProvider.notifier).load(widget.transactionId),
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      );
    }
    final loaded = state as TransactionDetailLoaded;
    final tx = loaded.transaction;
    final payments = loaded.payments;
    final isMobile = context.isPhone;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(tx, l10n, isDark),
          AppSpacing.gapH16,
          _buildInfoCard(tx, l10n, isDark),
          AppSpacing.gapH16,
          if (tx.items != null && tx.items!.isNotEmpty) ...[_buildItemsSection(tx.items!, l10n, isDark), AppSpacing.gapH16],
          if (payments != null && payments.isNotEmpty) ...[_buildPaymentsSection(payments, l10n, isDark), AppSpacing.gapH16],
          _buildTotalsCard(tx, l10n, isDark),
          AppSpacing.gapH16,
          if (tx.zatcaUuid != null || tx.zatcaHash != null || tx.zatcaQrCode != null) ...[
            _buildZatcaCard(tx, l10n, isDark),
            AppSpacing.gapH16,
          ],
          if (tx.notes != null && tx.notes!.isNotEmpty) ...[_buildNotesCard(tx, l10n, isDark), AppSpacing.gapH16],
        ],
      ),
    );
  }

  Widget _buildHeaderCard(Transaction tx, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.receipt_long_rounded, size: 28, color: AppColors.primary),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.transactionNumber, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    PosBadge(label: _typeLabel(tx.type, l10n), variant: _typeVariant(tx.type)),
                    PosBadge(label: _statusLabel(tx.status, l10n), variant: _statusVariant(tx.status)),
                  ],
                ),
              ],
            ),
          ),
          Text(
            tx.totalAmount.toStringAsFixed(3),
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Transaction tx, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.txInfoTitle, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          _infoRow(
            l10n.txInfoDate,
            tx.createdAt != null
                ? '${tx.createdAt!.day}/${tx.createdAt!.month}/${tx.createdAt!.year} ${tx.createdAt!.hour.toString().padLeft(2, '0')}:${tx.createdAt!.minute.toString().padLeft(2, '0')}'
                : '-',
            isDark,
          ),
          _infoRow(l10n.txInfoCashier, tx.cashierId, isDark),
          _infoRow(l10n.txInfoRegister, tx.registerId, isDark),
          _infoRow(l10n.txInfoSession, tx.posSessionId, isDark),
          _infoRow(l10n.txInfoStore, tx.storeId, isDark),
          if (tx.customerId != null) _infoRow(l10n.txInfoCustomer, tx.customerId!, isDark),
          if (tx.externalType != null) _infoRow(l10n.txInfoExternalType, tx.externalType!.value, isDark),
          if (tx.externalId != null) _infoRow(l10n.txInfoExternalId, tx.externalId!, isDark),
          if (tx.returnTransactionId != null) _infoRow(l10n.txInfoReturnRef, tx.returnTransactionId!, isDark),
          _infoRow(l10n.txInfoSyncStatus, tx.syncStatus?.value ?? '-', isDark),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(List<TransactionItem> items, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.txItemsTitle, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${items.length} ${l10n.txItemsCount}',
                style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
          AppSpacing.gapH12,
          ...items.map((item) => _buildItemRow(item, isDark)),
        ],
      ),
    );
  }

  Widget _buildItemRow(TransactionItem item, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                if (item.barcode != null)
                  Text(
                    item.barcode!,
                    style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                if (item.serialNumber != null)
                  Text('S/N: ${item.serialNumber}', style: AppTypography.micro.copyWith(color: AppColors.info)),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '×${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity}',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall,
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(item.unitPrice.toStringAsFixed(3), textAlign: TextAlign.end, style: AppTypography.bodySmall),
          ),
          SizedBox(
            width: 80,
            child: Text(
              item.lineTotal.toStringAsFixed(3),
              textAlign: TextAlign.end,
              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsSection(List<Payment> payments, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.txPaymentsTitle, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          ...payments.map((p) => _buildPaymentRow(p, isDark)),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(Payment payment, bool isDark) {
    final methodName = payment.method.value
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Icon(_paymentIcon(payment.method), size: 16, color: AppColors.info),
          ),
          AppSpacing.gapW8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(methodName, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                if (payment.cardLastFour != null)
                  Text(
                    '•••• ${payment.cardLastFour}${payment.cardBrand != null ? ' · ${payment.cardBrand}' : ''}',
                    style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
              ],
            ),
          ),
          Text(payment.amount.toStringAsFixed(3), style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  IconData _paymentIcon(dynamic method) {
    final v = method.toString().toLowerCase();
    if (v.contains('cash')) return Icons.money;
    if (v.contains('card') || v.contains('visa') || v.contains('mastercard') || v.contains('mada')) return Icons.credit_card;
    if (v.contains('apple')) return Icons.phone_iphone;
    if (v.contains('gift')) return Icons.card_giftcard;
    if (v.contains('loyalty')) return Icons.star;
    if (v.contains('bank')) return Icons.account_balance;
    return Icons.payment;
  }

  Widget _buildTotalsCard(Transaction tx, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.txTotalsTitle, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH12,
          _totalRow(l10n.txTotalsSubtotal, tx.subtotal, isDark),
          if (tx.discountAmount != null && tx.discountAmount! > 0)
            _totalRow(l10n.txTotalsDiscount, -tx.discountAmount!, isDark, color: AppColors.error),
          _totalRow(l10n.txTotalsTax, tx.taxAmount, isDark),
          if (tx.tipAmount != null && tx.tipAmount! > 0)
            _totalRow(l10n.txTotalsTip, tx.tipAmount!, isDark, color: AppColors.success),
          const Divider(),
          _totalRow(l10n.txTotalsTotal, tx.totalAmount, isDark, isBold: true),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double value, bool isDark, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? null : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
          Text(
            value.toStringAsFixed(3),
            style: AppTypography.bodySmall.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              fontSize: isBold ? 16 : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZatcaCard(Transaction tx, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined, size: 18, color: AppColors.success),
              AppSpacing.gapW8,
              Text(l10n.txZatcaTitle, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          AppSpacing.gapH12,
          if (tx.zatcaUuid != null) _infoRow(l10n.txZatcaUuid, tx.zatcaUuid!, isDark),
          if (tx.zatcaHash != null) _infoRow(l10n.txZatcaHash, tx.zatcaHash!, isDark),
          if (tx.zatcaStatus != null) _infoRow(l10n.txZatcaStatus, tx.zatcaStatus!.value, isDark),
        ],
      ),
    );
  }

  Widget _buildNotesCard(Transaction tx, AppLocalizations l10n, bool isDark) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.txNotesTitle, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH8,
          Text(tx.notes!, style: AppTypography.bodySmall),
        ],
      ),
    );
  }

  PosBadgeVariant _statusVariant(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return PosBadgeVariant.success;
      case TransactionStatus.voided:
        return PosBadgeVariant.error;
      case TransactionStatus.pending:
        return PosBadgeVariant.warning;
    }
  }

  String _statusLabel(TransactionStatus status, AppLocalizations l10n) {
    switch (status) {
      case TransactionStatus.completed:
        return l10n.txStatusCompleted;
      case TransactionStatus.voided:
        return l10n.txStatusVoided;
      case TransactionStatus.pending:
        return l10n.txStatusPending;
    }
  }

  PosBadgeVariant _typeVariant(TransactionType type) {
    switch (type) {
      case TransactionType.sale:
        return PosBadgeVariant.primary;
      case TransactionType.returnValue:
        return PosBadgeVariant.warning;
      case TransactionType.voidValue:
        return PosBadgeVariant.error;
      case TransactionType.exchange:
        return PosBadgeVariant.info;
    }
  }

  String _typeLabel(TransactionType type, AppLocalizations l10n) {
    switch (type) {
      case TransactionType.sale:
        return l10n.txTypeSale;
      case TransactionType.returnValue:
        return l10n.txTypeReturn;
      case TransactionType.voidValue:
        return l10n.txTypeVoid;
      case TransactionType.exchange:
        return l10n.txTypeExchange;
    }
  }
}
