import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_terminal/enums/payment_method.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction_item.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

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

  List<Transaction> _recentTransactions = const [];
  bool _isLoadingRecent = false;
  String _recentSearch = '';

  @override
  void initState() {
    super.initState();
    _receiptController.addListener(() {
      if (_recentSearch != _receiptController.text) {
        setState(() => _recentSearch = _receiptController.text);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRecent());
  }

  @override
  void dispose() {
    _receiptController.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    setState(() => _isLoadingRecent = true);
    try {
      final repo = ref.read(posTerminalRepositoryProvider);
      final result = await repo.listTransactions(page: 1, perPage: 20, type: 'sale', status: 'completed');
      if (!mounted) return;
      setState(() => _recentTransactions = result.items);
    } catch (_) {
      // silent: placeholder shows enter-receipt hint on failure
    } finally {
      if (mounted) setState(() => _isLoadingRecent = false);
    }
  }

  Future<void> _selectTransaction(Transaction tx) async {
    setState(() {
      _isSearching = true;
      _error = null;
      _transaction = null;
      _returnQuantities.clear();
    });
    try {
      final repo = ref.read(posTerminalRepositoryProvider);
      final full = await repo.getTransaction(tx.id);
      if (!mounted) return;
      setState(() {
        _transaction = full;
        final txItems = full.items ?? [];
        for (int i = 0; i < txItems.length; i++) {
          _returnQuantities[i] = 0;
        }
        _receiptController.text = full.transactionNumber;
      });
    } catch (e) {
      if (mounted) setState(() => _error = AppLocalizations.of(context)!.posTransactionLookupFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  List<Transaction> get _filteredRecent {
    final q = _recentSearch.trim().toLowerCase();
    if (q.isEmpty) return _recentTransactions;
    return _recentTransactions.where((t) {
      return t.transactionNumber.toLowerCase().contains(q) || t.totalAmount.toStringAsFixed(2).contains(q);
    }).toList();
  }

  bool get _isFullyRefunded {
    final tx = _transaction;
    if (tx?.items == null || tx!.items!.isEmpty) return false;
    final refunded = tx.refundedQuantities;
    if (refunded == null || refunded.isEmpty) return false;
    for (final item in tx.items!) {
      final r = refunded[item.productId] ?? 0;
      if (r < item.quantity) return false;
    }
    return true;
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
      double subtotal = 0;
      double taxTotal = 0;
      double discountTotal = 0;
      for (final entry in _returnQuantities.entries) {
        if (entry.value > 0 && entry.key < txItems.length) {
          final item = txItems[entry.key];
          final qty = entry.value;
          final unitPrice = item.unitPrice;
          // Pro-rate the original line's tax/discount/total to the returned qty.
          final ratio = item.quantity > 0 ? qty / item.quantity : 0;
          final lineTotal = (item.lineTotal * ratio);
          final taxAmount = item.taxAmount * ratio;
          final discountAmount = (item.discountAmount ?? 0) * ratio;
          subtotal += unitPrice * qty;
          taxTotal += taxAmount;
          discountTotal += discountAmount;
          items.add({
            'product_id': item.productId,
            'barcode': item.barcode,
            'product_name': item.productName,
            'product_name_ar': item.productNameAr,
            'quantity': qty,
            'unit_price': unitPrice,
            'cost_price': item.costPrice,
            'discount_amount': discountAmount,
            'tax_rate': item.taxRate,
            'tax_amount': taxAmount,
            'line_total': lineTotal,
            'is_return_item': true,
            'reason': AppLocalizations.of(context)!.posCustomerReturn,
          });
        }
      }

      final totalAmount = subtotal - discountTotal + taxTotal;

      final payments = [
        {'method': _refundMethod.value, 'amount': totalAmount},
      ];

      // Anchor the refund to the cashier's currently-active session (not the
      // original sale's session, which might be closed). The backend falls
      // back to the original session if none is provided.
      final activeState = ref.read(activeSessionProvider);
      final currentSessionId = activeState is ActiveSessionLoaded ? activeState.session.id : null;

      await ref
          .read(saleProvider.notifier)
          .processReturn(
            returnTransactionId: _transaction!.id,
            items: items,
            payments: payments,
            subtotal: subtotal,
            discountAmount: discountTotal,
            taxAmount: taxTotal,
            totalAmount: totalAmount,
            posSessionId: currentSessionId,
          );

      final saleState = ref.read(saleProvider);
      if (saleState is SaleCompleted) {
        // Pull latest counters so the close-shift dialog shows the new refund.
        await ref.read(activeSessionProvider.notifier).refreshSession();
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
    final mutedColor = AppColors.mutedFor(context);

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
                if (_isFullyRefunded) ...[
                  Container(
                    padding: AppSpacing.paddingAll12,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.block, color: AppColors.error, size: 18),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Text(
                            'This transaction has already been fully refunded.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH12,
                ],
                Text(
                  AppLocalizations.of(context)!.posSelectItemsToReturn,
                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                AppSpacing.gapH8,
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _transaction!.items!.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.borderFor(context)),
                    itemBuilder: (context, index) {
                      final item = _transaction!.items![index];
                      final alreadyReturned =
                          _transaction!.refundedQuantities?[item.productId] ?? 0;
                      final maxReturnable = (item.quantity - alreadyReturned).clamp(0, item.quantity).toDouble();
                      return _ReturnItemRow(
                        item: item,
                        returnQty: _returnQuantities[index] ?? 0,
                        maxReturnable: maxReturnable,
                        alreadyReturned: alreadyReturned,
                        onChanged: (qty) => setState(() => _returnQuantities[index] = qty),
                        isDark: isDark,
                        mutedColor: mutedColor,
                      );
                    },
                  ),
                ),
                AppSpacing.gapH16,

                // Refund method
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.posRefundTo, style: AppTypography.labelSmall),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosSearchableDropdown<PaymentMethod>(
                        hint: AppLocalizations.of(context)!.selectPaymentMethod,
                        items: [PaymentMethod.cash, PaymentMethod.card, PaymentMethod.storeCredit].map((m) {
                          return PosDropdownItem(value: m, label: m.label);
                        }).toList(),
                        selectedValue: _refundMethod,
                        onChanged: (v) => setState(() => _refundMethod = v ?? PaymentMethod.cash),
                        showSearch: false,
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
                  child: _isLoadingRecent
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredRecent.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
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
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recent sales', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                            AppSpacing.gapH8,
                            Expanded(
                              child: ListView.separated(
                                itemCount: _filteredRecent.length,
                                separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.borderFor(context)),
                                itemBuilder: (context, index) {
                                  final tx = _filteredRecent[index];
                                  final dt = tx.createdAt;
                                  final timeLabel = dt == null
                                      ? ''
                                      : '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
                                            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                                  return ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.receipt_long_outlined, size: 20),
                                    title: Text(tx.transactionNumber, style: AppTypography.labelMedium),
                                    subtitle: Text(timeLabel, style: AppTypography.micro.copyWith(color: mutedColor)),
                                    trailing: Text(
                                      '\u0081 ${tx.totalAmount.toStringAsFixed(2)}',
                                      style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    onTap: () => _selectTransaction(tx),
                                  );
                                },
                              ),
                            ),
                          ],
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
    required this.maxReturnable,
    required this.alreadyReturned,
    required this.onChanged,
    required this.isDark,
    required this.mutedColor,
  });

  final TransactionItem item;
  final double returnQty;
  final double maxReturnable;
  final double alreadyReturned;
  final ValueChanged<double> onChanged;
  final bool isDark;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final fullyReturned = maxReturnable <= 0;
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
                  'Qty: ${item.quantity.toStringAsFixed(0)} × \u0081 ${item.unitPrice.toStringAsFixed(2)}',
                  style: AppTypography.micro.copyWith(color: mutedColor),
                ),
                if (alreadyReturned > 0)
                  Text(
                    fullyReturned
                        ? 'Already fully refunded'
                        : 'Refunded: ${alreadyReturned.toStringAsFixed(0)} · Remaining: ${maxReturnable.toStringAsFixed(0)}',
                    style: AppTypography.micro.copyWith(
                      color: fullyReturned ? AppColors.error : AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
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
              _MiniButton(icon: Icons.add, onTap: returnQty < maxReturnable ? () => onChanged(returnQty + 1) : null),
            ],
          ),
          // Line refund
          SizedBox(
            width: 80,
            child: Text(
              returnQty > 0 ? '\u0081 ${((item.lineTotal / item.quantity) * returnQty).toStringAsFixed(2)}' : '-',
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
          border: Border.all(color: onTap != null ? AppColors.borderFor(context) : AppColors.borderSubtleLight),
        ),
        child: Icon(icon, size: 14, color: onTap != null ? null : AppColors.textDisabledLight),
      ),
    );
  }
}
