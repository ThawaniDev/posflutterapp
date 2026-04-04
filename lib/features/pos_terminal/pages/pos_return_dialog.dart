import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/pos_terminal/enums/payment_method.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction_item.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:thawani_pos/features/pos_terminal/repositories/pos_terminal_repository.dart';

class PosReturnDialog extends ConsumerStatefulWidget {
  const PosReturnDialog({super.key});

  @override
  ConsumerState<PosReturnDialog> createState() => _PosReturnDialogState();
}

class _PosReturnDialogState extends ConsumerState<PosReturnDialog> {
  final _receiptController = TextEditingController();
  Transaction? _transaction;
  final Map<int, double> _returnQuantities = {};
  PaymentMethod _refundMethod = PaymentMethod.cash;
  bool _isSearching = false;
  bool _isProcessing = false;
  String? _error;

  @override
  void dispose() {
    _receiptController.dispose();
    super.dispose();
  }

  double get _refundTotal {
    if (_transaction?.items == null) return 0;
    final txItems = _transaction!.items!;
    double total = 0;
    for (final entry in _returnQuantities.entries) {
      if (entry.value > 0 && entry.key < txItems.length) {
        final item = txItems[entry.key];
        total += (item.lineTotal / item.quantity) * entry.value;
      }
    }
    return total;
  }

  bool get _hasSelectedItems => _returnQuantities.values.any((q) => q > 0);

  Future<void> _lookupTransaction() async {
    final number = _receiptController.text.trim();
    if (number.isEmpty) {
      setState(() => _error = AppLocalizations.of(context)!.posEnterReceiptNumber);
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _transaction = null;
      _returnQuantities.clear();
    });

    try {
      final repo = ref.read(posTerminalRepositoryProvider);
      final result = await repo.getTransactionByNumber(number);
      setState(() {
        _transaction = result;
        final txItems = result.items ?? [];
        for (int i = 0; i < txItems.length; i++) {
          _returnQuantities[i] = 0;
        }
      });
    } catch (e) {
      setState(() => _error = AppLocalizations.of(context)!.posTransactionLookupFailed(e.toString()));
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _processReturn() async {
    if (_transaction == null || !_hasSelectedItems) return;

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final items = <Map<String, dynamic>>[];
      final txItems = _transaction!.items ?? [];
      for (final entry in _returnQuantities.entries) {
        if (entry.value > 0 && entry.key < txItems.length) {
          final item = txItems[entry.key];
          items.add({
            'product_id': item.productId,
            'quantity': entry.value,
            'unit_price': item.unitPrice,
            'reason': AppLocalizations.of(context)!.posCustomerReturn,
          });
        }
      }

      final payments = [
        {'method': _refundMethod.value, 'amount': _refundTotal},
      ];

      await ref
          .read(saleProvider.notifier)
          .processReturn(returnTransactionId: _transaction!.id, items: items, payments: payments);

      final saleState = ref.read(saleProvider);
      if (saleState is SaleCompleted) {
        if (mounted) {
          showPosSuccessSnackbar(context, AppLocalizations.of(context)!.posReturnProcessed(saleState.transactionNumber));
          Navigator.pop(context);
        }
      } else if (saleState is SaleError) {
        setState(() => _error = saleState.message);
      }
    } catch (e) {
      setState(() => _error = AppLocalizations.of(context)!.posReturnFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 700),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.assignment_return_outlined, color: AppColors.warning, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(child: Text(AppLocalizations.of(context)!.posReturnRefund, style: AppTypography.headlineSmall)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              AppSpacing.gapH16,

              // Receipt lookup
              Row(
                children: [
                  Expanded(
                    child: PosTextField(
                      controller: _receiptController,
                      hint: AppLocalizations.of(context)!.posReceiptNumber,
                      prefixIcon: Icons.receipt_long_outlined,
                      autofocus: true,
                      onSubmitted: (_) => _lookupTransaction(),
                    ),
                  ),
                  AppSpacing.gapW8,
                  PosButton(
                    label: AppLocalizations.of(context)!.posFind,
                    icon: Icons.search_rounded,
                    size: PosButtonSize.sm,
                    isLoading: _isSearching,
                    onPressed: _isSearching ? null : _lookupTransaction,
                  ),
                ],
              ),
              AppSpacing.gapH16,

              // Transaction items
              if (_transaction != null && _transaction!.items != null) ...[
                Text(
                  AppLocalizations.of(context)!.posSelectItemsToReturn,
                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                AppSpacing.gapH8,
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _transaction!.items!.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: isDark ? AppColors.borderLight : AppColors.borderLight),
                    itemBuilder: (context, index) => _ReturnItemRow(
                      item: _transaction!.items![index],
                      returnQty: _returnQuantities[index] ?? 0,
                      onChanged: (qty) => setState(() => _returnQuantities[index] = qty),
                      isDark: isDark,
                      mutedColor: mutedColor,
                    ),
                  ),
                ),
                AppSpacing.gapH16,

                // Refund method
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.posRefundTo, style: AppTypography.labelSmall),
                    AppSpacing.gapW12,
                    Expanded(
                      child: DropdownButtonFormField<PaymentMethod>(
                        value: _refundMethod,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                        ),
                        items: [PaymentMethod.cash, PaymentMethod.card, PaymentMethod.storeCredit].map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(m.label, style: AppTypography.bodySmall),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _refundMethod = v ?? PaymentMethod.cash),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH12,

                // Refund total
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.posRefundAmount, style: AppTypography.labelSmall),
                      Text(
                        AppLocalizations.of(context)!.amountWithSar(_refundTotal.toStringAsFixed(2)),
                        style: AppTypography.headlineSmall.copyWith(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ] else if (!_isSearching && _error == null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 48,
                          color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
                        ),
                        AppSpacing.gapH8,
                        Text(
                          AppLocalizations.of(context)!.posEnterReceiptNumberHint,
                          style: AppTypography.bodySmall.copyWith(color: mutedColor),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_error != null) ...[
                AppSpacing.gapH12,
                Container(
                  padding: AppSpacing.paddingAll12,
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                      AppSpacing.gapW8,
                      Expanded(
                        child: Text(_error!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                      ),
                    ],
                  ),
                ),
              ],

              AppSpacing.gapH16,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: AppLocalizations.of(context)!.posCancel,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  if (_transaction != null) ...[
                    AppSpacing.gapW12,
                    Expanded(
                      flex: 2,
                      child: PosButton(
                        label: AppLocalizations.of(context)!.posProcessReturn,
                        icon: Icons.assignment_return_rounded,
                        variant: PosButtonVariant.danger,
                        isLoading: _isProcessing,
                        onPressed: _hasSelectedItems && !_isProcessing ? _processReturn : null,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturnItemRow extends StatelessWidget {
  const _ReturnItemRow({
    required this.item,
    required this.returnQty,
    required this.onChanged,
    required this.isDark,
    required this.mutedColor,
  });

  final TransactionItem item;
  final double returnQty;
  final ValueChanged<double> onChanged;
  final bool isDark;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Item info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: AppTypography.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  'Qty: ${item.quantity.toStringAsFixed(0)} × SAR ${item.unitPrice.toStringAsFixed(2)}',
                  style: AppTypography.micro.copyWith(color: mutedColor),
                ),
              ],
            ),
          ),
          // Return quantity controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MiniButton(icon: Icons.remove, onTap: returnQty > 0 ? () => onChanged(returnQty - 1) : null),
              SizedBox(
                width: 36,
                child: Text(
                  returnQty.toStringAsFixed(0),
                  style: AppTypography.labelMedium.copyWith(color: returnQty > 0 ? AppColors.error : mutedColor),
                  textAlign: TextAlign.center,
                ),
              ),
              _MiniButton(icon: Icons.add, onTap: returnQty < item.quantity ? () => onChanged(returnQty + 1) : null),
            ],
          ),
          // Line refund
          SizedBox(
            width: 80,
            child: Text(
              returnQty > 0 ? 'SAR ${((item.lineTotal / item.quantity) * returnQty).toStringAsFixed(2)}' : '-',
              style: AppTypography.labelSmall.copyWith(color: returnQty > 0 ? AppColors.error : mutedColor),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderSm,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderSm,
          border: Border.all(color: onTap != null ? AppColors.borderLight : AppColors.borderSubtleLight),
        ),
        child: Icon(icon, size: 14, color: onTap != null ? null : AppColors.textDisabledLight),
      ),
    );
  }
}
