import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/models/installment_payment.dart';
import 'package:wameedpos/features/payments/pages/installment_payment_dialog.dart';
import 'package:wameedpos/features/pos_terminal/enums/payment_method.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';

/// A payment entry: method + amount. Supports split payments.
class _PaymentLeg {
  _PaymentLeg({required this.method, required this.amount})
    : controller = TextEditingController(text: amount > 0 ? amount.toStringAsFixed(2) : '');
  PaymentMethod method;
  double amount;
  final TextEditingController controller;

  void dispose() => controller.dispose();
}

class PosPaymentDialog extends ConsumerStatefulWidget {
  const PosPaymentDialog({super.key, required this.totalAmount, required this.sessionId});

  final double totalAmount;
  final String sessionId;

  @override
  ConsumerState<PosPaymentDialog> createState() => _PosPaymentDialogState();
}

class _PosPaymentDialogState extends ConsumerState<PosPaymentDialog> {
  late final List<_PaymentLeg> _legs;
  double _cashTendered = 0;
  final _cashTenderedController = TextEditingController();
  double _tipAmount = 0;
  final _tipController = TextEditingController();
  String? _error;

  double get _totalWithTip => widget.totalAmount + _tipAmount;
  double get _totalPaid => _legs.fold(0.0, (s, l) => s + l.amount);
  double get _remaining => _totalWithTip - _totalPaid;
  bool get _isFullyPaid => _remaining <= 0.005;

  @override
  void initState() {
    super.initState();
    _legs = [_PaymentLeg(method: PaymentMethod.cash, amount: widget.totalAmount)];
    _cashTendered = widget.totalAmount;
    _cashTenderedController.text = widget.totalAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    for (final l in _legs) {
      l.dispose();
    }
    _cashTenderedController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  void _addSplitMethod() {
    setState(() {
      _legs.add(_PaymentLeg(method: PaymentMethod.card, amount: _remaining > 0 ? _remaining : 0));
    });
  }

  void _removeLeg(int index) {
    if (_legs.length <= 1) return;
    setState(() {
      _legs[index].dispose();
      _legs.removeAt(index);
    });
  }

  void _updateLegAmount(int index, String text) {
    final val = double.tryParse(text) ?? 0;
    setState(() => _legs[index].amount = val);
  }

  void _updateLegMethod(int index, PaymentMethod method) {
    setState(() => _legs[index].method = method);
  }

  void _onQuickCash(double amount) {
    setState(() {
      _cashTendered = amount;
      _cashTenderedController.text = amount.toStringAsFixed(2);
    });
  }

  double get _changeGiven {
    if (_legs.length == 1 && _legs.first.method == PaymentMethod.cash) {
      return (_cashTendered - _totalWithTip).clamp(0, double.infinity);
    }
    return 0;
  }

  Future<void> _openInstallmentPayment() async {
    final result = await showDialog<InstallmentPayment>(
      context: context,
      barrierDismissible: false,
      builder: (_) => InstallmentPaymentDialog(amount: widget.totalAmount, currency: ''),
    );

    if (result != null && mounted) {
      // Installment payment completed — record it as the payment method
      final providerMethod = PaymentMethod.tryFromValue(result.provider.value);
      if (providerMethod != null) {
        setState(() {
          // Replace all legs with a single installment leg
          for (final l in _legs) {
            l.dispose();
          }
          _legs.clear();
          _legs.add(_PaymentLeg(method: providerMethod, amount: widget.totalAmount));
        });
        // Auto-complete the sale
        await _completePayment();
      }
    }
  }

  Future<void> _completePayment() async {
    if (!_isFullyPaid) {
      setState(() => _error = AppLocalizations.of(context)!.posPaymentNotCover);
      return;
    }

    setState(() => _error = null);

    final cart = ref.read(cartProvider);
    final payments = _legs.map((l) {
      final map = <String, dynamic>{'method': l.method.value, 'amount': l.amount};
      if (l.method == PaymentMethod.cash) {
        map['cash_tendered'] = _cashTendered;
        map['change_given'] = _changeGiven;
      }
      if (_tipAmount > 0 && l == _legs.first) {
        map['tip_amount'] = _tipAmount;
      }
      return map;
    }).toList();

    await ref
        .read(saleProvider.notifier)
        .completeSale(sessionId: widget.sessionId, cart: cart, payments: payments, tipAmount: _tipAmount);

    final saleState = ref.read(saleProvider);
    if (saleState is SaleCompleted) {
      ref.read(cartProvider.notifier).clear();
      if (mounted) {
        Navigator.pop(context);
        _showReceiptDialog(saleState);
      }
    } else if (saleState is SaleError) {
      setState(() => _error = saleState.message);
    }
  }

  void _showReceiptDialog(SaleCompleted state) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.10), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
                ),
                AppSpacing.gapH16,
                Text(AppLocalizations.of(context)!.posPaymentSuccessful, style: AppTypography.headlineSmall),
                AppSpacing.gapH8,
                Text(
                  AppLocalizations.of(context)!.posTransactionNumber(state.transactionNumber),
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                ),
                AppSpacing.gapH8,
                Text(
                  AppLocalizations.of(context)!.amountWithSar(state.totalAmount.toStringAsFixed(2)),
                  style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
                ),
                if (state.changeGiven != null && state.changeGiven! > 0) ...[
                  AppSpacing.gapH4,
                  Text(
                    AppLocalizations.of(context)!.posChangeAmount(state.changeGiven!.toStringAsFixed(2)),
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.success),
                  ),
                ],
                AppSpacing.gapH24,
                PosButton(
                  label: AppLocalizations.of(context)!.posDone,
                  isFullWidth: true,
                  onPressed: () {
                    Navigator.pop(ctx);
                    ref.read(saleProvider.notifier).reset();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final saleState = ref.watch(saleProvider);
    final isProcessing = saleState is SaleProcessing;
    final mutedColor = AppColors.mutedFor(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                      child: const Icon(Icons.payment_rounded, color: AppColors.primary, size: 24),
                    ),
                    AppSpacing.gapW16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.posPayment, style: AppTypography.headlineSmall),
                          Text(
                            AppLocalizations.of(context)!.posTotalAmount(widget.totalAmount.toStringAsFixed(2)),
                            style: AppTypography.bodySmall.copyWith(color: mutedColor),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: isProcessing ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                AppSpacing.gapH24,

                // Payment legs
                ..._legs.asMap().entries.map((entry) => _buildPaymentLeg(entry.key, entry.value, isDark, mutedColor)),

                // Add split button
                if (_legs.length < 4)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton.icon(
                      onPressed: _addSplitMethod,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(AppLocalizations.of(context)!.posSplitPayment),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    ),
                  ),

                // Installment payment button
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: TextButton.icon(
                    onPressed: isProcessing ? null : _openInstallmentPayment,
                    icon: const Icon(Icons.credit_score_rounded, size: 18),
                    label: Text(AppLocalizations.of(context)!.payWithInstallments),
                    style: TextButton.styleFrom(foregroundColor: AppColors.info),
                  ),
                ),

                AppSpacing.gapH16,

                // Tip entry
                Text(
                  AppLocalizations.of(context)!.posTipAmount,
                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                AppSpacing.gapH4,
                PosTextField(
                  controller: _tipController,
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.volunteer_activism_rounded,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                  textAlign: TextAlign.end,
                  onChanged: (v) {
                    final tip = double.tryParse(v) ?? 0;
                    setState(() {
                      _tipAmount = tip;
                      // Auto-update the first leg amount to cover total + tip
                      if (_legs.length == 1) {
                        _legs.first.amount = _totalWithTip;
                        _legs.first.controller.text = _totalWithTip.toStringAsFixed(2);
                        if (_legs.first.method == PaymentMethod.cash) {
                          _cashTendered = _totalWithTip;
                          _cashTenderedController.text = _totalWithTip.toStringAsFixed(2);
                        }
                      }
                    });
                  },
                ),
                if (_tipAmount > 0) ...[
                  AppSpacing.gapH8,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.posTotalWithTip,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.info),
                        ),
                        Text(
                          AppLocalizations.of(context)!.amountWithSar(_totalWithTip.toStringAsFixed(2)),
                          style: AppTypography.labelMedium.copyWith(color: AppColors.info, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
                AppSpacing.gapH16,

                // Cash tendered (only if any leg is cash)
                if (_legs.any((l) => l.method == PaymentMethod.cash)) ...[
                  Text(
                    AppLocalizations.of(context)!.posCashTendered,
                    style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  AppSpacing.gapH4,
                  PosTextField(
                    controller: _cashTenderedController,
                    hint: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icons.attach_money_rounded,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    textAlign: TextAlign.end,
                    onChanged: (v) => setState(() => _cashTendered = double.tryParse(v) ?? 0),
                  ),
                  AppSpacing.gapH8,
                  // Quick denominations
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickDenominations().map((amount) {
                      return PosButton(
                        onPressed: () => _onQuickCash(amount),
                        variant: PosButtonVariant.outline,
                        label:
                            '${AppLocalizations.of(context)!.sarCurrency} ${amount.toStringAsFixed(amount == amount.roundToDouble() ? 0 : 2)}',
                      );
                    }).toList(),
                  ),
                  AppSpacing.gapH8,
                  // Change
                  if (_changeGiven > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.08),
                        borderRadius: AppRadius.borderSm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.posChange,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.success),
                          ),
                          Text(
                            AppLocalizations.of(context)!.amountWithSar(_changeGiven.toStringAsFixed(2)),
                            style: AppTypography.labelMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  AppSpacing.gapH16,
                ],

                // Remaining balance
                if (!_isFullyPaid)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.posRemaining,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
                        ),
                        Text(
                          AppLocalizations.of(context)!.amountWithSar(_remaining.toStringAsFixed(2)),
                          style: AppTypography.labelMedium.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
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

                AppSpacing.gapH24,

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: PosButton(
                        label: AppLocalizations.of(context)!.posCancel,
                        variant: PosButtonVariant.outline,
                        onPressed: isProcessing ? null : () => Navigator.pop(context),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      flex: 2,
                      child: PosButton(
                        label: AppLocalizations.of(context)!.posCompletePayment,
                        icon: Icons.check_circle_outline,
                        isLoading: isProcessing,
                        onPressed: isProcessing ? null : _completePayment,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentLeg(int index, _PaymentLeg leg, bool isDark, Color mutedColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Method dropdown
          Expanded(
            flex: 2,
            child: PosSearchableDropdown<PaymentMethod>(
              hint: AppLocalizations.of(context)!.selectPaymentMethod,
              items: _availableMethods.map((m) {
                return PosDropdownItem(value: m, label: m.label);
              }).toList(),
              selectedValue: leg.method,
              onChanged: (v) {
                if (v != null) _updateLegMethod(index, v);
              },
              showSearch: false,
            ),
          ),
          AppSpacing.gapW8,
          // Amount
          Expanded(
            flex: 2,
            child: PosTextField(
              controller: leg.controller,
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              textAlign: TextAlign.end,
              onChanged: (v) => _updateLegAmount(index, v),
            ),
          ),
          // Remove button
          if (_legs.length > 1)
            IconButton(
              onPressed: () => _removeLeg(index),
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 20),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  List<PaymentMethod> get _availableMethods => [
    PaymentMethod.cash,
    PaymentMethod.card,
    PaymentMethod.cardMada,
    PaymentMethod.cardVisa,
    PaymentMethod.cardMastercard,
    PaymentMethod.applePay,
    PaymentMethod.stcPay,
    PaymentMethod.storeCredit,
    PaymentMethod.giftCard,
    PaymentMethod.loyaltyPoints,
    PaymentMethod.bankTransfer,
  ];

  List<double> _quickDenominations() {
    final total = widget.totalAmount;
    final denominations = <double>[];
    // Add the exact amount
    denominations.add(total);
    // Nearest round-up denominations
    final roundUp10 = (total / 10).ceil() * 10.0;
    if (roundUp10 > total) denominations.add(roundUp10);
    final roundUp50 = (total / 50).ceil() * 50.0;
    if (roundUp50 > total && !denominations.contains(roundUp50)) denominations.add(roundUp50);
    final roundUp100 = (total / 100).ceil() * 100.0;
    if (roundUp100 > total && !denominations.contains(roundUp100)) denominations.add(roundUp100);
    return denominations.take(4).toList();
  }
}
