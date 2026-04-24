import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/services/receipt_printer_service.dart';
import 'package:wameedpos/features/payments/models/installment_payment.dart';
import 'package:wameedpos/features/payments/pages/installment_payment_dialog.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';
import 'package:wameedpos/features/pos_terminal/enums/payment_method.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:wameedpos/features/promotions/services/promotion_evaluator.dart';
import 'package:wameedpos/features/settings/models/store_settings.dart';
import 'package:wameedpos/features/settings/providers/settings_providers.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/services/digital_receipt_service.dart';

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

  // Gift card
  final _giftCardController = TextEditingController();
  String? _giftCardCode;
  double? _giftCardBalance;
  bool _giftCardLoading = false;
  String? _giftCardError;

  // Coupon
  final _couponController = TextEditingController();
  String? _appliedCouponCode;
  String? _appliedCouponCodeId;
  double _couponDiscount = 0;
  bool _couponLoading = false;
  String? _couponError;

  double get _totalWithTip => widget.totalAmount + _tipAmount;
  double get _totalAfterCoupon => (_totalWithTip - _couponDiscount).clamp(0, double.infinity);
  double get _totalPaid => _legs.fold(0.0, (s, l) => s + l.amount);
  double get _remaining => _totalAfterCoupon - _totalPaid;
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
    _giftCardController.dispose();
    _couponController.dispose();
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
  // ── Gift card ─────────────────────────────────────────────────

  Future<void> _checkGiftCard() async {
    final code = _giftCardController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _giftCardLoading = true;
      _giftCardError = null;
    });
    try {
      final api = ref.read(posTerminalApiServiceProvider);
      final result = await api.checkGiftCardBalance(code);
      final balance = double.tryParse(result['balance']?.toString() ?? '0') ?? 0;
      setState(() {
        _giftCardCode = code;
        _giftCardBalance = balance;
      });
      // Auto-add a gift card leg for the usable amount
      final apply = balance.clamp(0, _remaining).toDouble();
      if (apply > 0) {
        setState(() {
          _legs.add(_PaymentLeg(method: PaymentMethod.giftCard, amount: apply));
        });
      }
    } catch (e) {
      setState(() => _giftCardError = e.toString());
    } finally {
      setState(() => _giftCardLoading = false);
    }
  }

  // ── Coupon ─────────────────────────────────────────────────────

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _couponLoading = true;
      _couponError = null;
    });
    try {
      final api = ref.read(posTerminalApiServiceProvider);
      final cart = ref.read(cartProvider);
      final result = await api.validateCoupon(code: code, customerId: cart.customer?.id, orderTotal: _totalWithTip);
      final discount = double.tryParse(result['discount_amount']?.toString() ?? '0') ?? 0;
      setState(() {
        _appliedCouponCode = code;
        _appliedCouponCodeId = result['coupon_code_id'] as String?;
        _couponDiscount = discount;
        // Adjust first leg amount if single leg
        if (_legs.length == 1) {
          _legs.first.amount = _totalAfterCoupon;
          _legs.first.controller.text = _totalAfterCoupon.toStringAsFixed(2);
        }
      });
    } catch (e) {
      // Offline fallback — use local evaluator
      try {
        final cart = ref.read(cartProvider);
        final evaluator = ref.read(promotionEvaluatorProvider);
        final items = cart.items
            .map(
              (ci) => EvalCartItem(
                productId: ci.product.id,
                categoryId: ci.product.categoryId,
                unitPrice: ci.unitPrice,
                quantity: ci.quantity.toInt(),
              ),
            )
            .toList();
        final result = await evaluator.evaluate(items: items, customerId: cart.customer?.id, couponCode: code);
        final applied = result.applied.where((a) => a.couponCode == code.toUpperCase()).toList();
        if (applied.isEmpty) {
          setState(() => _couponError = e.toString());
        } else {
          setState(() {
            _appliedCouponCode = code;
            _appliedCouponCodeId = null;
            _couponDiscount = applied.fold(0.0, (s, a) => s + a.discount);
            if (_legs.length == 1) {
              _legs.first.amount = _totalAfterCoupon;
              _legs.first.controller.text = _totalAfterCoupon.toStringAsFixed(2);
            }
          });
        }
      } catch (_) {
        setState(() => _couponError = e.toString());
      }
    } finally {
      setState(() => _couponLoading = false);
    }
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
      if (l.method == PaymentMethod.giftCard && _giftCardCode != null) {
        map['gift_card_code'] = _giftCardCode;
      }
      if (l.method == PaymentMethod.loyaltyPoints) {
        final pts = cart.customer?.loyaltyPoints ?? 0;
        map['loyalty_points_used'] = pts;
      }
      return map;
    }).toList();

    // Attach coupon code ID to the first payment leg so the backend logs it
    if (_appliedCouponCodeId != null && payments.isNotEmpty) {
      payments.first['coupon_code'] = _appliedCouponCode;
      payments.first['coupon_code_id'] = _appliedCouponCodeId;
    }

    await ref
        .read(saleProvider.notifier)
        .completeSale(
          sessionId: widget.sessionId,
          cart: cart,
          payments: payments,
          tipAmount: _tipAmount,
          saleType: ref.read(currentStoreSettingsProvider)?.defaultSaleType,
        );

    final saleState = ref.read(saleProvider);
    if (saleState is SaleCompleted) {
      // Capture customer BEFORE clearing the cart so the receipt prompt can use it.
      final customerForReceipt = ref.read(cartProvider).customer;
      ref.read(cartProvider.notifier).clear();

      final settings = ref.read(currentStoreSettingsProvider);

      // Auto-open cash drawer when a cash payment leg was used
      if (_legs.any((l) => l.method == PaymentMethod.cash)) {
        try {
          await ref.read(hardwareManagerProvider).cashDrawer.open();
        } catch (_) {}
      }

      // Auto-print receipt when enabled in settings.
      if (settings?.autoPrintReceipt ?? false) {
        try {
          final printer = ref.read(hardwareManagerProvider).receiptPrinter;
          await printer.printReceipt(_buildSaleReceiptLines(saleState, cart, settings));
        } catch (_) {
          // Silent failure; user can re-print from receipt dialog.
        }
      }

      // Send to kitchen display when enabled and the sale type matches a
      // dine-in/takeaway/delivery flow that the KDS handles.
      if ((settings?.enableKitchenDisplay ?? false)) {
        try {
          // Best-effort: emit a snackbar; backend ticket is created on the
          // server when sale_type is provided. No client-side push needed.
          if (mounted) {
            showPosInfoSnackbar(context, AppLocalizations.of(context)!.posKdsTicketSent);
          }
        } catch (_) {}
      }

      if (mounted) {
        Navigator.pop(context);
        _showReceiptDialog(saleState, customerForReceipt);
      }
    } else if (saleState is SaleError) {
      setState(() => _error = saleState.message);
    }
  }

  void _showReceiptDialog(SaleCompleted state, Customer? customer) {
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
                if (customer != null) ...[
                  AppSpacing.gapH16,
                  Text(
                    AppLocalizations.of(context)!.customersSendReceipt,
                    style: AppTypography.bodyMedium,
                  ),
                  AppSpacing.gapH8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if ((customer.email ?? '').isNotEmpty)
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.customersReceiptViaEmail,
                          icon: const Icon(Icons.email_outlined),
                          onPressed: () async {
                            try {
                              await ref.read(digitalReceiptServiceProvider).sendEmail(
                                    customerId: customer.id,
                                    orderId: state.transactionId,
                                    destination: customer.email,
                                  );
                              if (ctx.mounted) {
                                showPosSuccessSnackbar(ctx, AppLocalizations.of(ctx)!.customersReceiptSent);
                              }
                            } catch (e) {
                              if (ctx.mounted) showPosErrorSnackbar(ctx, e.toString());
                            }
                          },
                        ),
                      if (customer.phone.isNotEmpty)
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.customersReceiptViaWhatsapp,
                          icon: const Icon(Icons.chat_outlined),
                          onPressed: () async {
                            try {
                              await ref.read(digitalReceiptServiceProvider).sendWhatsApp(
                                    customerId: customer.id,
                                    orderId: state.transactionId,
                                    phone: customer.phone,
                                    receiptUrl: 'Receipt #${state.transactionNumber}',
                                  );
                            } catch (e) {
                              if (ctx.mounted) showPosErrorSnackbar(ctx, e.toString());
                            }
                          },
                        ),
                      if (customer.phone.isNotEmpty)
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.customersReceiptViaSms,
                          icon: const Icon(Icons.sms_outlined),
                          onPressed: () async {
                            try {
                              await ref.read(digitalReceiptServiceProvider).sendSms(
                                    customerId: customer.id,
                                    orderId: state.transactionId,
                                    phone: customer.phone,
                                    body: 'Receipt #${state.transactionNumber}',
                                  );
                            } catch (e) {
                              if (ctx.mounted) showPosErrorSnackbar(ctx, e.toString());
                            }
                          },
                        ),
                    ],
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

                // Tip entry — only when store settings enable tips
                if (() {
                  final s = ref.read(storeSettingsProvider);
                  return s is StoreSettingsLoaded ? s.settings.enableTips : false;
                }()) ...[
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
                ], // end tip section

                AppSpacing.gapH16,

                // ── Coupon / Voucher ──────────────────────────────────────
                if (_appliedCouponCode == null) ...[
                  Text(
                    AppLocalizations.of(context)!.posCouponCode,
                    style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  AppSpacing.gapH4,
                  Row(
                    children: [
                      Expanded(
                        child: PosTextField(
                          controller: _couponController,
                          hint: AppLocalizations.of(context)!.posCouponHint,
                          prefixIcon: Icons.discount_outlined,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-_]'))],
                          onSubmitted: (_) => _applyCoupon(),
                        ),
                      ),
                      AppSpacing.gapW8,
                      PosButton(
                        label: AppLocalizations.of(context)!.posApply,
                        isLoading: _couponLoading,
                        onPressed: _couponLoading ? null : _applyCoupon,
                      ),
                    ],
                  ),
                  if (_couponError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(_couponError!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                    ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.posCouponApplied(_appliedCouponCode!, _couponDiscount.toStringAsFixed(2)),
                            style: AppTypography.bodySmall.copyWith(color: AppColors.success),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            _appliedCouponCode = null;
                            _appliedCouponCodeId = null;
                            _couponDiscount = 0;
                            _couponController.clear();
                          }),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          color: AppColors.mutedFor(context),
                        ),
                      ],
                    ),
                  ),
                ],
                AppSpacing.gapH12,

                // ── Gift Card ──────────────────────────────────────────────
                if (_giftCardCode == null) ...[
                  Text(
                    AppLocalizations.of(context)!.posGiftCard,
                    style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  AppSpacing.gapH4,
                  Row(
                    children: [
                      Expanded(
                        child: PosTextField(
                          controller: _giftCardController,
                          hint: AppLocalizations.of(context)!.posGiftCardHint,
                          prefixIcon: Icons.card_giftcard_rounded,
                          onSubmitted: (_) => _checkGiftCard(),
                        ),
                      ),
                      AppSpacing.gapW8,
                      PosButton(
                        label: AppLocalizations.of(context)!.posCheck,
                        isLoading: _giftCardLoading,
                        onPressed: _giftCardLoading ? null : _checkGiftCard,
                      ),
                    ],
                  ),
                  if (_giftCardError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(_giftCardError!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                    ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                    child: Row(
                      children: [
                        const Icon(Icons.card_giftcard_rounded, color: AppColors.info, size: 18),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.posGiftCardApplied(_giftCardCode!, (_giftCardBalance ?? 0).toStringAsFixed(2)),
                            style: AppTypography.bodySmall.copyWith(color: AppColors.info),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            _giftCardCode = null;
                            _giftCardBalance = null;
                            _giftCardController.clear();
                            _legs.removeWhere((l) => l.method == PaymentMethod.giftCard);
                          }),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          color: AppColors.mutedFor(context),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Loyalty / Store Credit (customer-attached) ─────────────
                if (() {
                  final cart = ref.read(cartProvider);
                  return cart.customer != null &&
                      ((cart.customer!.loyaltyPoints ?? 0) > 0 || (cart.customer!.storeCreditBalance ?? 0) > 0);
                }()) ...[
                  AppSpacing.gapH12,
                  _buildCustomerBalance(),
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

  Widget _buildCustomerBalance() {
    final cart = ref.read(cartProvider);
    final customer = cart.customer;
    if (customer == null) return const SizedBox.shrink();

    final settingsState = ref.read(storeSettingsProvider);
    final settings = settingsState is StoreSettingsLoaded ? settingsState.settings : null;
    final redeemValue = settings?.loyaltyRedemptionValue ?? 0.01;
    final loyaltyPoints = customer.loyaltyPoints ?? 0;
    final storeCredit = customer.storeCreditBalance ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((settings?.enableLoyaltyPoints ?? true) && loyaltyPoints > 0) ...[
          Text(
            AppLocalizations.of(context)!.posLoyaltyPoints,
            style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.gapH4,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: AppRadius.borderSm,
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.posAvailablePoints(loyaltyPoints.toString()),
                      style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
                    ),
                    Text(
                      AppLocalizations.of(context)!.posPointsValue((loyaltyPoints * redeemValue).toStringAsFixed(2)),
                      style: AppTypography.bodySmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                if (!_legs.any((l) => l.method == PaymentMethod.loyaltyPoints))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: PosButton(
                      label: AppLocalizations.of(context)!.posRedeemPoints,
                      variant: PosButtonVariant.outline,
                      onPressed: () {
                        final sarValue = (loyaltyPoints * redeemValue).clamp(0, _remaining).toDouble();
                        setState(() {
                          _legs.add(_PaymentLeg(method: PaymentMethod.loyaltyPoints, amount: sarValue));
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gapH8,
        ],
        if (storeCredit > 0) ...[
          Text(
            AppLocalizations.of(context)!.posStoreCredit,
            style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.gapH4,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: AppRadius.borderSm,
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.posAvailableCredit(storeCredit.toStringAsFixed(2)),
                  style: AppTypography.bodySmall.copyWith(color: AppColors.info),
                ),
                if (!_legs.any((l) => l.method == PaymentMethod.storeCredit))
                  PosButton(
                    label: AppLocalizations.of(context)!.posApplyCredit,
                    variant: PosButtonVariant.outline,
                    onPressed: () {
                      final apply = storeCredit.clamp(0, _remaining).toDouble();
                      setState(() {
                        _legs.add(_PaymentLeg(method: PaymentMethod.storeCredit, amount: apply));
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentLeg(int index, _PaymentLeg leg, bool isDark, Color mutedColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_legs.length > 1) ...[
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                  child: Text(
                    '${index + 1}',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                AppSpacing.gapW8,
              ],
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.selectPaymentMethod,
                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (_legs.length > 1)
                IconButton(
                  onPressed: () => _removeLeg(index),
                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 20),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                  tooltip: AppLocalizations.of(context)!.posCancel,
                ),
            ],
          ),
          AppSpacing.gapH8,
          // Method picker as selectable cards
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickMethods.map((m) {
              final selected = leg.method == m;
              return _MethodCard(
                label: _methodLabel(m),
                icon: _methodIcon(m),
                selected: selected,
                onTap: () => _updateLegMethod(index, m),
              );
            }).toList(),
          ),
          AppSpacing.gapH8,
          // Amount input
          PosTextField(
            controller: leg.controller,
            hint: '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: Icons.account_balance_wallet_outlined,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            textAlign: TextAlign.end,
            onChanged: (v) => _updateLegAmount(index, v),
          ),
        ],
      ),
    );
  }

  // Primary methods shown as cards. Other methods (gift card, store credit, etc.)
  // can be added as additional split legs and chosen here too — keeping the
  // surface small to match real-world POS workflows.
  List<PaymentMethod> get _quickMethods => const [PaymentMethod.cash, PaymentMethod.card];

  String _methodLabel(PaymentMethod m) {
    final l10n = AppLocalizations.of(context)!;
    return switch (m) {
      PaymentMethod.cash => l10n.filterCash,
      PaymentMethod.card => l10n.filterCard,
      _ => m.label,
    };
  }

  IconData _methodIcon(PaymentMethod m) {
    return switch (m) {
      PaymentMethod.cash => Icons.payments_rounded,
      PaymentMethod.card ||
      PaymentMethod.cardMada ||
      PaymentMethod.cardVisa ||
      PaymentMethod.cardMastercard ||
      PaymentMethod.mada => Icons.credit_card_rounded,
      PaymentMethod.applePay => Icons.phone_iphone_rounded,
      PaymentMethod.stcPay => Icons.smartphone_rounded,
      PaymentMethod.giftCard => Icons.card_giftcard_rounded,
      PaymentMethod.storeCredit => Icons.account_balance_wallet_rounded,
      PaymentMethod.loyaltyPoints => Icons.stars_rounded,
      PaymentMethod.bankTransfer => Icons.account_balance_rounded,
      PaymentMethod.tabby || PaymentMethod.tamara || PaymentMethod.mispay || PaymentMethod.madfu => Icons.credit_score_rounded,
      _ => Icons.payment_rounded,
    };
  }

  List<ReceiptLine> _buildSaleReceiptLines(SaleCompleted sale, CartState cart, StoreSettings? settings) {
    final lines = <ReceiptLine>[
      if ((settings?.receiptHeader ?? '').isNotEmpty)
        ReceiptLine.text(settings!.receiptHeader!, alignment: PrintAlignment.center, bold: true),
      ReceiptLine.text('# ${sale.transactionNumber}', alignment: PrintAlignment.center),
      if (settings?.receiptShowDate ?? true)
        ReceiptLine.text(DateTime.now().toString().substring(0, 19), alignment: PrintAlignment.center),
      ReceiptLine.separator(),
      for (final item in cart.items)
        ReceiptLine.twoColumn(
          '${item.product.name}  x${item.quantity.toStringAsFixed(item.quantity == item.quantity.floor() ? 0 : 2)}',
          (item.unitPrice * item.quantity).toStringAsFixed(2),
        ),
      ReceiptLine.separator(),
      ReceiptLine.twoColumn('Subtotal', cart.subtotal.toStringAsFixed(2)),
      if (cart.discountTotal > 0) ReceiptLine.twoColumn('Discount', '-${cart.discountTotal.toStringAsFixed(2)}'),
      if ((settings?.receiptShowTaxBreakdown ?? true) && cart.taxAmount > 0)
        ReceiptLine.twoColumn(settings?.taxLabel ?? 'Tax', cart.taxAmount.toStringAsFixed(2)),
      ReceiptLine.twoColumn('TOTAL', sale.totalAmount.toStringAsFixed(2), bold: true),
      ReceiptLine.separator(),
      if ((settings?.receiptFooter ?? '').isNotEmpty)
        ReceiptLine.text(settings!.receiptFooter!, alignment: PrintAlignment.center),
      ReceiptLine.feed(2),
    ];
    return lines;
  }

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

class _MethodCard extends StatelessWidget {
  const _MethodCard({required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surfaceFor(context);
    final border = selected ? AppColors.primary : AppColors.borderFor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = selected ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.borderMd,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: selected ? 2 : 1),
            borderRadius: AppRadius.borderMd,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 26),
              AppSpacing.gapH4,
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(color: fg, fontWeight: selected ? FontWeight.bold : FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
