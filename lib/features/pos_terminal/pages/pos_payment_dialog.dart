import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/pos_terminal/enums/payment_method.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_state.dart';

/// A payment entry: method + amount. Supports split payments.
class _PaymentLeg {
  PaymentMethod method;
  double amount;
  final TextEditingController controller;

  _PaymentLeg({required this.method, required this.amount})
    : controller = TextEditingController(text: amount > 0 ? amount.toStringAsFixed(2) : '');

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
  String? _error;

  double get _totalPaid => _legs.fold(0.0, (s, l) => s + l.amount);
  double get _remaining => widget.totalAmount - _totalPaid;
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
      return (_cashTendered - widget.totalAmount).clamp(0, double.infinity);
    }
    return 0;
  }

  Future<void> _completePayment() async {
    if (!_isFullyPaid) {
      setState(() => _error = 'Total paid does not cover the outstanding amount');
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
      return map;
    }).toList();

    await ref.read(saleProvider.notifier).completeSale(sessionId: widget.sessionId, cart: cart, payments: payments);

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
                Text('Payment Successful', style: AppTypography.headlineSmall),
                AppSpacing.gapH8,
                Text(
                  'Transaction #${state.transactionNumber}',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedLight),
                ),
                AppSpacing.gapH8,
                Text(
                  'SAR ${state.totalAmount.toStringAsFixed(2)}',
                  style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
                ),
                if (state.changeGiven != null && state.changeGiven! > 0) ...[
                  AppSpacing.gapH4,
                  Text(
                    'Change: SAR ${state.changeGiven!.toStringAsFixed(2)}',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.success),
                  ),
                ],
                AppSpacing.gapH24,
                PosButton(
                  label: 'Done',
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
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

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
                          Text('Payment', style: AppTypography.headlineSmall),
                          Text(
                            'Total: SAR ${widget.totalAmount.toStringAsFixed(2)}',
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
                      label: const Text('Split Payment'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    ),
                  ),

                AppSpacing.gapH16,

                // Cash tendered (only if any leg is cash)
                if (_legs.any((l) => l.method == PaymentMethod.cash)) ...[
                  Text('Cash Tendered', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
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
                      return OutlinedButton(
                        onPressed: () => _onQuickCash(amount),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        ),
                        child: Text('SAR ${amount.toStringAsFixed(amount == amount.roundToDouble() ? 0 : 2)}'),
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
                          Text('Change', style: AppTypography.bodySmall.copyWith(color: AppColors.success)),
                          Text(
                            'SAR ${_changeGiven.toStringAsFixed(2)}',
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
                        Text('Remaining', style: AppTypography.bodySmall.copyWith(color: AppColors.warning)),
                        Text(
                          'SAR ${_remaining.toStringAsFixed(2)}',
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
                        label: 'Cancel',
                        variant: PosButtonVariant.outline,
                        onPressed: isProcessing ? null : () => Navigator.pop(context),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      flex: 2,
                      child: PosButton(
                        label: 'Complete Payment',
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
            child: DropdownButtonFormField<PaymentMethod>(
              value: leg.method,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
              ),
              items: _availableMethods.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_methodIcon(m), size: 18, color: mutedColor),
                      AppSpacing.gapW8,
                      Text(m.label, style: AppTypography.bodySmall),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) _updateLegMethod(index, v);
              },
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

  IconData _methodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money_rounded;
      case PaymentMethod.card:
      case PaymentMethod.cardMada:
      case PaymentMethod.cardVisa:
      case PaymentMethod.cardMastercard:
        return Icons.credit_card_rounded;
      case PaymentMethod.mada:
        return Icons.credit_card_rounded;
      case PaymentMethod.applePay:
        return Icons.phone_iphone_rounded;
      case PaymentMethod.stcPay:
        return Icons.phone_android_rounded;
      case PaymentMethod.storeCredit:
        return Icons.account_balance_wallet_rounded;
      case PaymentMethod.giftCard:
        return Icons.card_giftcard_rounded;
      case PaymentMethod.loyaltyPoints:
        return Icons.stars_rounded;
      case PaymentMethod.mobilePayment:
        return Icons.smartphone_rounded;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_rounded;
    }
  }
}
