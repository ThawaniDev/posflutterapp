import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart' show currentUserProvider;
import 'package:wameedpos/features/customer_facing_display/providers/secondary_display_providers.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/services/digital_receipt_service.dart';
import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';
import 'package:wameedpos/features/hardware/providers/hardware_providers.dart';
import 'package:wameedpos/features/hardware/providers/hardware_state.dart' show NetworkScanComplete;
import 'package:wameedpos/features/hardware/services/hardware_auto_detector.dart' show DetectedDevice;
import 'package:wameedpos/features/hardware/services/receipt_printer_service.dart';
import 'package:wameedpos/features/onboarding/providers/store_onboarding_providers.dart' show myStoreProvider;
import 'package:wameedpos/features/onboarding/providers/store_onboarding_state.dart' show StoreLoaded;
import 'package:wameedpos/features/payments/models/installment_payment.dart';
import 'package:wameedpos/features/payments/pages/installment_payment_dialog.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';
import 'package:wameedpos/features/pos_terminal/enums/payment_method.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:wameedpos/features/pos_terminal/widgets/card_scheme_badge.dart';
import 'package:wameedpos/features/promotions/services/promotion_evaluator.dart';
import 'package:wameedpos/features/settings/models/store_settings.dart';
import 'package:wameedpos/features/settings/providers/settings_providers.dart';
import 'package:wameedpos/features/softpos/providers/softpos_providers.dart';
import 'package:wameedpos/features/softpos/providers/softpos_state.dart';
import 'package:wameedpos/features/softpos/services/softpos_service.dart';

/// A payment entry: method + amount. Supports split payments.
class _PaymentLeg {
  _PaymentLeg({required this.method, required this.amount})
    : controller = TextEditingController(text: amount > 0 ? amount.toStringAsFixed(2) : '');
  PaymentMethod method;
  double amount;
  final TextEditingController controller;

  void dispose() => controller.dispose();
}

class _SoftPosTokenSync {
  const _SoftPosTokenSync({this.token, this.changed = false});

  final String? token;
  final bool changed;

  bool get hasToken => token != null && token!.isNotEmpty;
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

  // SoftPOS
  SoftPosPaymentResult? _softPosResult;

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

  // ─── Secondary display (customer-facing) ─────────────────────────
  //
  // While SoftPOS is waiting for the customer to tap their card, swap the
  // secondary screen to an animated "tap your card" prompt that points to
  // the device's NFC reader. Restored to the live cart view on completion
  // or failure.

  ({String? logoUrl, String? storeName}) _storeBranding() {
    final storeState = ref.read(myStoreProvider);
    if (storeState is StoreLoaded) {
      return (logoUrl: storeState.store.logoUrl, storeName: storeState.store.name);
    }
    return (logoUrl: null, storeName: null);
  }

  void _pushAwaitingPaymentToSecondary(double amount) {
    if (!isSecondaryDisplaySupported) return;
    final settings = ref.read(currentStoreSettingsProvider);
    final branding = _storeBranding();
    final l10n = AppLocalizations.of(context);
    ref
        .read(secondaryDisplayControllerProvider)
        .pushAwaitingPayment(
          total: amount,
          currency: settings?.currencySymbol ?? '',
          message: l10n?.softposTapCard,
          logoUrl: branding.logoUrl,
          storeName: branding.storeName,
        );
  }

  void _restoreCartOnSecondary() {
    if (!isSecondaryDisplaySupported) return;
    final cart = ref.read(cartProvider);
    final settings = ref.read(currentStoreSettingsProvider);
    final branding = _storeBranding();
    final items = cart.items
        .map(
          (item) => <String, dynamic>{
            'name': item.product.name,
            'quantity': item.quantity,
            'unit_price': item.unitPrice,
            'line_total': item.subtotal,
          },
        )
        .toList();
    final discount = (cart.manualDiscount ?? 0) + cart.items.fold<double>(0, (s, i) => s + (i.discountAmount ?? 0));
    ref
        .read(secondaryDisplayControllerProvider)
        .pushCart(
          items: items,
          subtotal: cart.subtotal,
          discount: discount,
          tax: cart.taxAmount,
          total: cart.totalAmount,
          currency: settings?.currencySymbol ?? '',
          logoUrl: branding.logoUrl,
          storeName: branding.storeName,
        );
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
    if (method == PaymentMethod.softPos) {
      _selectSoftPosMethod(index);
      return;
    }
    setState(() => _legs[index].method = method);
  }

  /// Guards SoftPOS method selection by syncing the active register's EdfaPay
  /// token into secure storage before allowing the leg to switch, then
  /// pre-warms the SDK so terminal binding (if needed) happens now — before
  /// the user clicks "Pay" — rather than blocking the final payment step.
  Future<void> _selectSoftPosMethod(int index) async {
    final service = ref.read(softPosServiceProvider);
    if (!service.isAvailable) {
      setState(() => _error = AppLocalizations.of(context)!.softposNotConfigured);
      return;
    }

    final sync = await _syncSoftPosTokenFromActiveRegister(refreshRegisters: true);
    if (!sync.hasToken) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context)!.softposNotConfigured);
      }
      return;
    }
    setState(() => _legs[index].method = PaymentMethod.softPos);

    // Pre-warm: initialise the EdfaPay SDK now (terminal binding UI if
    // needed appears here, before payment), so _completePayment is instant.
    if (!service.isInitiated || sync.changed) {
      try {
        await ref.read(softPosProvider.notifier).initWithToken(token: sync.token!, environment: 'production');
        final initState = ref.read(softPosProvider);
        if (mounted && initState is SoftPosError) {
          setState(() => _error = initState.message);
        }
      } catch (_) {
        // Non-fatal here — _completePayment will retry and surface any error.
      }
    }
  }

  Future<_SoftPosTokenSync> _syncSoftPosTokenFromActiveRegister({required bool refreshRegisters}) async {
    String? token = (await ref.read(softPosTokenProvider.future))?.trim();

    final sessionState = ref.read(activeSessionProvider);
    if (sessionState is! ActiveSessionLoaded) {
      return _SoftPosTokenSync(token: token);
    }

    try {
      final registers = refreshRegisters
          ? await ref.refresh(activeRegistersProvider.future)
          : (ref.read(activeRegistersProvider).asData?.value ?? await ref.read(activeRegistersProvider.future));
      if (registers == null) {
        return _SoftPosTokenSync(token: token);
      }
      final register = registers.where((r) => r.id == sessionState.session.registerId).firstOrNull;
      final registerToken = register?.edfapayToken?.trim();

      if (register != null && register.softposEnabled && registerToken != null && registerToken.isNotEmpty) {
        if (registerToken != token) {
          await ref.read(softPosProvider.notifier).saveConfig(token: registerToken, environment: 'production');
          ref.invalidate(softPosTokenProvider);
          return _SoftPosTokenSync(token: registerToken, changed: true);
        }
        return _SoftPosTokenSync(token: registerToken);
      }
    } catch (_) {
      // Keep the locally stored token usable if the register refresh fails.
    }

    return _SoftPosTokenSync(token: token);
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

    try {
      // ── SoftPOS pre-payment via EdfaPay SDK ─────────────────────────────
      final softPosLegs = _legs.where((l) => l.method == PaymentMethod.softPos).toList();
      if (softPosLegs.isNotEmpty) {
        final service = ref.read(softPosServiceProvider);
        if (!service.isAvailable) {
          setState(() => _error = AppLocalizations.of(context)!.softposNotConfigured);
          return;
        }
        final tokenSync = await _syncSoftPosTokenFromActiveRegister(refreshRegisters: true);
        if (!tokenSync.hasToken) {
          setState(() => _error = AppLocalizations.of(context)!.softposNotConfigured);
          return;
        }
        // Initialise with the freshly synced register token instead of
        // re-reading secure storage, which can lag behind the provider cache.
        if (!service.isInitiated || tokenSync.changed) {
          await ref.read(softPosProvider.notifier).initWithToken(token: tokenSync.token!, environment: 'production');
          final initState = ref.read(softPosProvider);
          if (initState is SoftPosError) {
            setState(() => _error = initState.message);
            return;
          }
          if (initState is! SoftPosReady) {
            setState(() => _error = AppLocalizations.of(context)!.softposInitializing);
            return;
          }
        }
        // Execute NFC payment for each softPos leg
        for (int i = 0; i < softPosLegs.length; i++) {
          final leg = softPosLegs[i];
          final orderId = '${widget.sessionId}-softpos-$i';
          _pushAwaitingPaymentToSecondary(leg.amount);
          SoftPosPaymentResult result;
          try {
            result = await service.purchase(amount: leg.amount.toStringAsFixed(2), orderId: orderId);
          } catch (_) {
            _restoreCartOnSecondary();
            rethrow;
          }
          if (!result.success) {
            _restoreCartOnSecondary();
            setState(() => _error = result.errorMessage ?? AppLocalizations.of(context)!.softposPaymentFailed);
            return;
          }
          _softPosResult = result;
        }
        _restoreCartOnSecondary();
      }

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
        if (l.method == PaymentMethod.softPos && _softPosResult != null) {
          if (_softPosResult!.approvalCode != null) map['approval_code'] = _softPosResult!.approvalCode;
          if (_softPosResult!.rrn != null) map['rrn'] = _softPosResult!.rrn;
          if (_softPosResult!.transactionId != null) map['card_transaction_id'] = _softPosResult!.transactionId;
          if (_softPosResult!.cardScheme != null) map['card_scheme'] = _softPosResult!.cardScheme;
          if (_softPosResult!.maskedCard != null) map['masked_card'] = _softPosResult!.maskedCard;
          if (_softPosResult!.cardHolderName != null) map['cardholder_name'] = _softPosResult!.cardHolderName;
          if (_softPosResult!.cardExpiry != null) map['card_expiry'] = _softPosResult!.cardExpiry;
          if (_softPosResult!.stan != null) map['stan'] = _softPosResult!.stan;
          if (_softPosResult!.acquirerBank != null) map['acquirer_bank'] = _softPosResult!.acquirerBank;
          if (_softPosResult!.applicationId != null) map['application_id'] = _softPosResult!.applicationId;
          if (_softPosResult!.sdkRawResponse != null) map['sdk_raw_response'] = _softPosResult!.sdkRawResponse;
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

        // Build receipt lines NOW using the local `cart` snapshot captured before
        // completeSale was called (the provider cart is already cleared above).
        final receiptLines = _buildSaleReceiptLines(saleState, cart, settings);

        // Auto-open cash drawer when a cash payment leg was used
        if (_legs.any((l) => l.method == PaymentMethod.cash)) {
          try {
            await ref.read(hardwareManagerProvider).cashDrawer.open();
          } catch (_) {}
        }

        // Auto-print receipt when enabled in settings.
        bool autoPrinted = false;
        PrinterStatusCode? autoPrintErrorCode;
        if (settings?.autoPrintReceipt ?? false) {
          try {
            final printerSel = ref.read(activePrinterProvider);
            final printer = ref.read(hardwareManagerProvider).receiptPrinter;
            // Configure to whichever printer was auto-selected/user-selected.
            if (printerSel != null) printer.configure(printerSel.config);
            final status = await printer.checkStatus();
            if (!status.isReady) {
              autoPrintErrorCode = status.code;
            } else {
              final ok = await printer.printReceipt(receiptLines);
              autoPrinted = ok;
              if (!ok) autoPrintErrorCode = PrinterStatusCode.notConnected;
            }
          } catch (_) {
            autoPrintErrorCode = PrinterStatusCode.error;
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
          _showReceiptDialog(
            saleState,
            customerForReceipt,
            receiptLines: receiptLines,
            autoPrinted: autoPrinted,
            autoPrintErrorCode: autoPrintErrorCode,
          );
        }
      } else if (saleState is SaleError) {
        setState(() => _error = saleState.message);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  void _showReceiptDialog(
    SaleCompleted state,
    Customer? customer, {
    required List<ReceiptLine> receiptLines,
    bool autoPrinted = false,
    PrinterStatusCode? autoPrintErrorCode,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => _ReceiptSuccessDialog(
        saleState: state,
        customer: customer,
        receiptLines: receiptLines,
        autoPrinted: autoPrinted,
        autoPrintErrorCode: autoPrintErrorCode,
        cardScheme: _softPosResult?.cardScheme,
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
                // Padding(
                //   padding: const EdgeInsets.only(top: 4),
                //   child: TextButton.icon(
                //     onPressed: isProcessing ? null : _openInstallmentPayment,
                //     icon: const Icon(Icons.credit_score_rounded, size: 18),
                //     label: Text(AppLocalizations.of(context)!.payWithInstallments),
                //     style: TextButton.styleFrom(foregroundColor: AppColors.info),
                //   ),
                // ),
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
                  // Percentage preset shortcuts (e.g. 10/15/20/25). Skipped
                  // if the store admin hasn't configured any presets.
                  Builder(
                    builder: (ctx) {
                      final s = ref.read(storeSettingsProvider);
                      if (s is! StoreSettingsLoaded) return const SizedBox.shrink();
                      final presets = s.settings.tipPresets;
                      if (presets.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final pct in presets)
                              ChoiceChip(
                                label: Text('$pct%'),
                                selected: (widget.totalAmount > 0 && (_tipAmount / widget.totalAmount * 100).round() == pct),
                                onSelected: (_) {
                                  final tip = double.parse((widget.totalAmount * pct / 100).toStringAsFixed(2));
                                  setState(() {
                                    _tipAmount = tip;
                                    _tipController.text = tip.toStringAsFixed(2);
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
                            ChoiceChip(
                              label: Text(AppLocalizations.of(context)!.posTipNone),
                              selected: _tipAmount == 0,
                              onSelected: (_) {
                                setState(() {
                                  _tipAmount = 0;
                                  _tipController.text = '';
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
                          ],
                        ),
                      );
                    },
                  ),
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

                // // ── Coupon / Voucher ──────────────────────────────────────
                // if (_appliedCouponCode == null) ...[
                //   Text(
                //     AppLocalizations.of(context)!.posCouponCode,
                //     style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                //   ),
                //   AppSpacing.gapH4,
                //   Row(
                //     children: [
                //       Expanded(
                //         child: PosTextField(
                //           controller: _couponController,
                //           hint: AppLocalizations.of(context)!.posCouponHint,
                //           prefixIcon: Icons.discount_outlined,
                //           inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-_]'))],
                //           onSubmitted: (_) => _applyCoupon(),
                //         ),
                //       ),
                //       AppSpacing.gapW8,
                //       PosButton(
                //         label: AppLocalizations.of(context)!.posApply,
                //         isLoading: _couponLoading,
                //         onPressed: _couponLoading ? null : _applyCoupon,
                //       ),
                //     ],
                //   ),
                //   if (_couponError != null)
                //     Padding(
                //       padding: const EdgeInsets.only(top: 4),
                //       child: Text(_couponError!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                //     ),
                // ] else ...[
                //   Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                //     decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                //     child: Row(
                //       children: [
                //         const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                //         AppSpacing.gapW8,
                //         Expanded(
                //           child: Text(
                //             AppLocalizations.of(
                //               context,
                //             )!.posCouponApplied(_appliedCouponCode!, _couponDiscount.toStringAsFixed(2)),
                //             style: AppTypography.bodySmall.copyWith(color: AppColors.success),
                //           ),
                //         ),
                //         IconButton(
                //           onPressed: () => setState(() {
                //             _appliedCouponCode = null;
                //             _appliedCouponCodeId = null;
                //             _couponDiscount = 0;
                //             _couponController.clear();
                //           }),
                //           icon: const Icon(Icons.close_rounded, size: 18),
                //           color: AppColors.mutedFor(context),
                //         ),
                //       ],
                //     ),
                //   ),
                // ],
                // AppSpacing.gapH12,

                // // ── Gift Card ──────────────────────────────────────────────
                // if (_giftCardCode == null) ...[
                //   Text(
                //     AppLocalizations.of(context)!.posGiftCard,
                //     style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                //   ),
                //   AppSpacing.gapH4,
                //   Row(
                //     children: [
                //       Expanded(
                //         child: PosTextField(
                //           controller: _giftCardController,
                //           hint: AppLocalizations.of(context)!.posGiftCardHint,
                //           prefixIcon: Icons.card_giftcard_rounded,
                //           onSubmitted: (_) => _checkGiftCard(),
                //         ),
                //       ),
                //       AppSpacing.gapW8,
                //       PosButton(
                //         label: AppLocalizations.of(context)!.posCheck,
                //         isLoading: _giftCardLoading,
                //         onPressed: _giftCardLoading ? null : _checkGiftCard,
                //       ),
                //     ],
                //   ),
                //   if (_giftCardError != null)
                //     Padding(
                //       padding: const EdgeInsets.only(top: 4),
                //       child: Text(_giftCardError!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                //     ),
                // ] else ...[
                //   Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                //     decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                //     child: Row(
                //       children: [
                //         const Icon(Icons.card_giftcard_rounded, color: AppColors.info, size: 18),
                //         AppSpacing.gapW8,
                //         Expanded(
                //           child: Text(
                //             AppLocalizations.of(
                //               context,
                //             )!.posGiftCardApplied(_giftCardCode!, (_giftCardBalance ?? 0).toStringAsFixed(2)),
                //             style: AppTypography.bodySmall.copyWith(color: AppColors.info),
                //           ),
                //         ),
                //         IconButton(
                //           onPressed: () => setState(() {
                //             _giftCardCode = null;
                //             _giftCardBalance = null;
                //             _giftCardController.clear();
                //             _legs.removeWhere((l) => l.method == PaymentMethod.giftCard);
                //           }),
                //           icon: const Icon(Icons.close_rounded, size: 18),
                //           color: AppColors.mutedFor(context),
                //         ),
                //       ],
                //     ),
                //   ),
                // ],

                // // ── Loyalty / Store Credit (customer-attached) ─────────────
                // if (() {
                //   final cart = ref.read(cartProvider);
                //   return cart.customer != null &&
                //       ((cart.customer!.loyaltyPoints ?? 0) > 0 || (cart.customer!.storeCreditBalance ?? 0) > 0);
                // }()) ...[
                //   AppSpacing.gapH12,
                //   _buildCustomerBalance(),
                // ],
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
          // SoftPOS tap hint
          if (leg.method == PaymentMethod.softPos) ...[
            AppSpacing.gapH4,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
              child: Row(
                children: [
                  const Icon(Icons.contactless_rounded, color: AppColors.primary, size: 16),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.softposTapCard,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Primary methods shown as cards. Other methods (gift card, store credit, etc.)
  // can be added as additional split legs and chosen here too — keeping the
  // surface small to match real-world POS workflows.
  List<PaymentMethod> get _quickMethods => const [PaymentMethod.cash, PaymentMethod.card, PaymentMethod.softPos];

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
      PaymentMethod.softPos => Icons.contactless_rounded,
      PaymentMethod.tabby || PaymentMethod.tamara || PaymentMethod.mispay || PaymentMethod.madfu => Icons.credit_score_rounded,
      _ => Icons.payment_rounded,
    };
  }

  List<ReceiptLine> _buildSaleReceiptLines(SaleCompleted sale, CartState cart, StoreSettings? settings) {
    // Resolve store identity + cashier from the live providers so the receipt
    // mirrors the store's configured profile instead of hard-coded values.
    final storeState = ref.read(myStoreProvider);
    final store = storeState is StoreLoaded ? storeState.store : null;
    final cashier = ref.read(currentUserProvider);

    // Every element below is gated on the store's receipt settings so the
    // owner controls what shows and what is hidden from /settings/receipt.
    final showLogo = settings?.receiptShowLogo ?? true;
    final showAddress = settings?.receiptShowAddress ?? true;
    final showPhone = settings?.receiptShowPhone ?? true;
    final showDate = settings?.receiptShowDate ?? true;
    final showCashier = settings?.receiptShowCashier ?? true;
    final showTax = settings?.receiptShowTaxBreakdown ?? true;
    final showBarcode = settings?.receiptShowBarcode ?? true;
    final lang = settings?.receiptLanguage ?? 'ar';

    final taxLabel = settings?.taxLabel ?? 'VAT';
    final taxNumber = (settings?.taxNumber?.trim().isNotEmpty ?? false) ? settings!.taxNumber!.trim() : store?.vatNumber?.trim();

    final lines = <ReceiptLine>[];

    // ─── Branding / store identity ───────────────────────────
    // The store logo is printed as a raster image by the graphics path; in the
    // text receipt the store name is the brand line. `showLogo` controls
    // whether it is emphasised (double-size) at the very top.
    if (store?.name.trim().isNotEmpty ?? false) {
      lines.add(ReceiptLine.text(store!.name.trim(), alignment: PrintAlignment.center, bold: true, doubleSize: showLogo));
    }
    if (showAddress) {
      final address = [store?.address, store?.city].where((e) => (e?.trim().isNotEmpty ?? false)).join(', ');
      if (address.isNotEmpty) lines.add(ReceiptLine.text(address, alignment: PrintAlignment.center));
    }
    if (showPhone && (store?.phone?.trim().isNotEmpty ?? false)) {
      lines.add(ReceiptLine.text(store!.phone!.trim(), alignment: PrintAlignment.center));
    }
    if (taxNumber?.isNotEmpty ?? false) {
      lines.add(ReceiptLine.text('$taxLabel: $taxNumber', alignment: PrintAlignment.center));
    }
    if ((settings?.receiptHeader ?? '').trim().isNotEmpty) {
      lines.add(ReceiptLine.text(settings!.receiptHeader!.trim(), alignment: PrintAlignment.center));
    }
    lines.add(ReceiptLine.separator());

    // ─── Transaction meta ────────────────────────────────────
    lines.add(ReceiptLine.text('# ${sale.transactionNumber}', alignment: PrintAlignment.center));
    if (showDate) {
      lines.add(ReceiptLine.text(DateTime.now().toString().substring(0, 19), alignment: PrintAlignment.center));
    }
    if (showCashier && (cashier?.name.trim().isNotEmpty ?? false)) {
      lines.add(
        ReceiptLine.text(
          '${_receiptLabel('Cashier', 'الكاشير', lang)}: ${cashier!.name.trim()}',
          alignment: PrintAlignment.center,
        ),
      );
    }
    lines.add(ReceiptLine.separator());

    // ─── Items ───────────────────────────────────────────────
    for (final item in cart.items) {
      lines.add(
        ReceiptLine.twoColumn(
          '${item.product.name}  x${item.quantity.toStringAsFixed(item.quantity == item.quantity.floor() ? 0 : 2)}',
          (item.unitPrice * item.quantity).toStringAsFixed(2),
        ),
      );
    }
    lines.add(ReceiptLine.separator());

    // ─── Totals ──────────────────────────────────────────────
    lines.add(ReceiptLine.twoColumn(_receiptLabel('Subtotal', 'الإجمالي الفرعي', lang), cart.subtotal.toStringAsFixed(2)));
    if (cart.discountTotal > 0) {
      lines.add(ReceiptLine.twoColumn(_receiptLabel('Discount', 'الخصم', lang), '-${cart.discountTotal.toStringAsFixed(2)}'));
    }
    if (showTax && cart.taxAmount > 0) {
      lines.add(ReceiptLine.twoColumn(taxLabel, cart.taxAmount.toStringAsFixed(2)));
    }
    lines.add(ReceiptLine.twoColumn(_receiptLabel('TOTAL', 'الإجمالي', lang), sale.totalAmount.toStringAsFixed(2), bold: true));
    lines.add(ReceiptLine.separator());

    // ─── Footer ──────────────────────────────────────────────
    if ((settings?.receiptFooter ?? '').trim().isNotEmpty) {
      lines.add(ReceiptLine.text(settings!.receiptFooter!.trim(), alignment: PrintAlignment.center));
    }

    // ─── ZATCA QR (TLV) — only when present and enabled ───────
    if (showBarcode && (sale.zatcaQrCode?.trim().isNotEmpty ?? false)) {
      lines.add(ReceiptLine.feed());
      lines.add(ReceiptLine.qr(sale.zatcaQrCode!.trim()));
    }

    lines.add(ReceiptLine.feed(2));
    return lines;
  }

  /// Choose a receipt label according to the store's `receipt_language` setting
  /// (`ar`, `en`, or `both`). Dynamic content (store name, items) keeps its own
  /// language; only the fixed labels are localised here.
  String _receiptLabel(String en, String ar, String lang) {
    switch (lang) {
      case 'ar':
        return ar;
      case 'both':
        return '$ar / $en';
      default:
        return en;
    }
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

// ─────────────────────────────────────────────────────────────────────────────
// Receipt Success Dialog
// ─────────────────────────────────────────────────────────────────────────────

enum _PrintPhase { idle, checking, printing, success, error }

class _ReceiptSuccessDialog extends ConsumerStatefulWidget {
  const _ReceiptSuccessDialog({
    required this.saleState,
    this.customer,
    required this.receiptLines,
    this.autoPrinted = false,
    this.autoPrintErrorCode,
    this.cardScheme,
  });

  final SaleCompleted saleState;
  final Customer? customer;
  final List<ReceiptLine> receiptLines;
  final bool autoPrinted;
  final PrinterStatusCode? autoPrintErrorCode;
  final String? cardScheme;

  @override
  ConsumerState<_ReceiptSuccessDialog> createState() => _ReceiptSuccessDialogState();
}

class _ReceiptSuccessDialogState extends ConsumerState<_ReceiptSuccessDialog> {
  _PrintPhase _phase = _PrintPhase.idle;
  PrinterStatusCode? _errorCode;

  @override
  void initState() {
    super.initState();
    if (widget.autoPrinted) {
      _phase = _PrintPhase.success;
    } else if (widget.autoPrintErrorCode != null) {
      _phase = _PrintPhase.error;
      _errorCode = widget.autoPrintErrorCode;
    }
  }

  /// Map a printer status code to a localized, user-friendly message.
  String _errorMessage(AppLocalizations l10n) {
    if (_errorCode == PrinterStatusCode.notConfigured) {
      return l10n.posPrinterNotConfigured;
    }
    // not connected / out of paper / generic failure all collapse to the
    // message the cashier needs to act on.
    return l10n.posPrinterNotConnectedOrPaper;
  }

  Future<void> _printReceipt() async {
    final printerSel = ref.read(activePrinterProvider);

    if (printerSel == null) {
      setState(() {
        _phase = _PrintPhase.error;
        _errorCode = PrinterStatusCode.notConfigured;
      });
      return;
    }

    setState(() {
      _phase = _PrintPhase.checking;
      _errorCode = null;
    });

    try {
      final printer = ref.read(hardwareManagerProvider).receiptPrinter;
      // Apply the active selection (built-in / network / BT / user-picked).
      printer.configure(printerSel.config);

      // Probe status before sending data so we can show a precise error.
      final status = await printer.checkStatus();
      if (!status.isReady) {
        if (mounted) {
          setState(() {
            _phase = _PrintPhase.error;
            _errorCode = status.code;
          });
        }
        return;
      }

      if (mounted) setState(() => _phase = _PrintPhase.printing);
      final ok = await printer.printReceipt(widget.receiptLines);
      if (!mounted) return;
      setState(() {
        if (ok) {
          _phase = _PrintPhase.success;
        } else {
          _phase = _PrintPhase.error;
          _errorCode = PrinterStatusCode.notConnected;
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _phase = _PrintPhase.error;
          _errorCode = PrinterStatusCode.error;
        });
      }
    }
  }

  /// Shows a bottom sheet listing all available printers so the cashier can
  /// switch before printing.
  void _showPrinterPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final builtIn = ref.watch(builtInPrinterProvider).valueOrNull;
          final scan = ref.watch(networkScanProvider);
          final detected = switch (scan) {
            NetworkScanComplete(:final devices) => devices.where((d) => d.type == HardwareDeviceType.receiptPrinter).toList(),
            _ => <DetectedDevice>[],
          };

          final items = <_PrinterOption>[
            if (builtIn != null) _PrinterOption(selection: builtIn, icon: Icons.print),
            for (final d in detected.where((d) => d.connectionType == 'network'))
              _PrinterOption(
                selection: PrinterSelection(
                  label: d.name,
                  config: PrinterConfig(connectionType: 'network', ipAddress: d.address, port: d.port ?? 9100),
                ),
                icon: Icons.wifi,
              ),
            for (final d in detected.where((d) => d.connectionType == 'bluetooth'))
              _PrinterOption(
                selection: PrinterSelection(
                  label: d.name,
                  config: PrinterConfig(connectionType: 'bluetooth', bluetoothAddress: d.address),
                ),
                icon: Icons.bluetooth,
              ),
          ];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.posSelectPrinter, style: AppTypography.titleMedium),
                AppSpacing.gapH12,
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      l10n.posNoPrinterDetected,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(ctx)),
                    ),
                  )
                else
                  ...items.map(
                    (item) => ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.selection.label),
                      subtitle: Text(
                        item.selection.isBuiltIn
                            ? item.selection.config.usbDevicePath ?? ''
                            : item.selection.config.ipAddress ?? item.selection.config.bluetoothAddress ?? '',
                        style: AppTypography.micro.copyWith(
                          color: isDark ? AppColors.textMutedDark : Colors.grey.shade500,
                          fontFamily: 'monospace',
                        ),
                      ),
                      selected: ref.watch(selectedPrinterProvider)?.label == item.selection.label,
                      onTap: () {
                        ref.read(selectedPrinterProvider.notifier).state = item.selection;
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                AppSpacing.gapH8,
                // "Auto-select" reset option
                if (ref.watch(selectedPrinterProvider) != null)
                  TextButton(
                    onPressed: () {
                      ref.read(selectedPrinterProvider.notifier).state = null;
                      Navigator.pop(ctx);
                    },
                    child: const Text('Auto-select'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrinterSection(AppLocalizations l10n) {
    // Active printer indicator row (shown in all non-idle states too)
    final printerRow = Consumer(
      builder: (ctx, ref, _) {
        final active = ref.watch(activePrinterProvider);
        if (active == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => _showPrinterPicker(ctx),
            child: Row(
              children: [
                Icon(active.isBuiltIn ? Icons.print_rounded : Icons.wifi, size: 14, color: AppColors.mutedFor(ctx)),
                AppSpacing.gapW4,
                Expanded(
                  child: Text(
                    l10n.posActivePrinterLabel(active.label),
                    style: AppTypography.micro.copyWith(color: AppColors.mutedFor(ctx)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  l10n.posChangePrinter,
                  style: AppTypography.micro.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        printerRow,
        switch (_phase) {
          _PrintPhase.success => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.print_rounded, color: AppColors.success, size: 18),
                AppSpacing.gapW8,
                Text(
                  l10n.posReceiptPrinted,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          _PrintPhase.checking || _PrintPhase.printing => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
              AppSpacing.gapW8,
              Text(
                _phase == _PrintPhase.checking ? l10n.posCheckingPrinter : l10n.posPrintingReceipt,
                style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
              ),
            ],
          ),
          _PrintPhase.error => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.print_disabled_outlined, color: AppColors.error, size: 18),
                    AppSpacing.gapW8,
                    Flexible(
                      child: Text(
                        _errorMessage(l10n),
                        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapH8,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PosButton(
                    label: l10n.posRetryPrint,
                    variant: PosButtonVariant.outline,
                    icon: Icons.print_outlined,
                    size: PosButtonSize.sm,
                    onPressed: _printReceipt,
                  ),
                  AppSpacing.gapW8,
                  PosButton(
                    label: l10n.posChangePrinter,
                    variant: PosButtonVariant.ghost,
                    icon: Icons.swap_horiz,
                    size: PosButtonSize.sm,
                    onPressed: () => _showPrinterPicker(context),
                  ),
                ],
              ),
            ],
          ),
          _PrintPhase.idle => PosButton(
            label: l10n.posPrintReceipt,
            variant: PosButtonVariant.outline,
            icon: Icons.print_outlined,
            isFullWidth: true,
            onPressed: _printReceipt,
          ),
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Success icon ──────────────────────────────────────
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.10), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
                ),
                AppSpacing.gapH16,
                Text(l10n.posPaymentSuccessful, style: AppTypography.headlineSmall),
                AppSpacing.gapH8,
                Text(
                  l10n.posTransactionNumber(widget.saleState.transactionNumber),
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                ),
                if (widget.saleState.isOffline) ...[
                  AppSpacing.gapH8,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off_rounded, color: AppColors.warning, size: 16),
                        AppSpacing.gapW8,
                        Flexible(
                          child: Text(
                            l10n.posOfflineQueued,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                AppSpacing.gapH8,
                Text(
                  l10n.amountWithSar(widget.saleState.totalAmount.toStringAsFixed(2)),
                  style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
                ),
                // Card scheme badge — only shown for SoftPOS payments
                if (widget.cardScheme != null) ...[AppSpacing.gapH8, CardSchemeBadge(scheme: widget.cardScheme, size: 14)],
                if (widget.saleState.changeGiven != null && widget.saleState.changeGiven! > 0) ...[
                  AppSpacing.gapH4,
                  Text(
                    l10n.posChangeAmount(widget.saleState.changeGiven!.toStringAsFixed(2)),
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.success),
                  ),
                ],

                // ── Print section ─────────────────────────────────────
                AppSpacing.gapH16,
                _buildPrinterSection(l10n),

                // ── Digital receipt ───────────────────────────────────
                if (widget.customer != null) ...[
                  AppSpacing.gapH16,
                  Text(l10n.customersSendReceipt, style: AppTypography.bodyMedium),
                  AppSpacing.gapH8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if ((widget.customer!.email ?? '').isNotEmpty)
                        IconButton(
                          tooltip: l10n.customersReceiptViaEmail,
                          icon: const Icon(Icons.email_outlined),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(digitalReceiptServiceProvider)
                                  .sendEmail(
                                    customerId: widget.customer!.id,
                                    orderId: widget.saleState.transactionId,
                                    destination: widget.customer!.email,
                                  );
                              if (context.mounted) showPosSuccessSnackbar(context, l10n.customersReceiptSent);
                            } catch (e) {
                              if (context.mounted) showPosErrorSnackbar(context, e.toString());
                            }
                          },
                        ),
                      if (widget.customer!.phone.isNotEmpty)
                        IconButton(
                          tooltip: l10n.customersReceiptViaWhatsapp,
                          icon: const Icon(Icons.chat_outlined),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(digitalReceiptServiceProvider)
                                  .sendWhatsApp(
                                    customerId: widget.customer!.id,
                                    orderId: widget.saleState.transactionId,
                                    phone: widget.customer!.phone,
                                    receiptUrl: 'Receipt #${widget.saleState.transactionNumber}',
                                  );
                            } catch (e) {
                              if (context.mounted) showPosErrorSnackbar(context, e.toString());
                            }
                          },
                        ),
                      if (widget.customer!.phone.isNotEmpty)
                        IconButton(
                          tooltip: l10n.customersReceiptViaSms,
                          icon: const Icon(Icons.sms_outlined),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(digitalReceiptServiceProvider)
                                  .sendSms(
                                    customerId: widget.customer!.id,
                                    orderId: widget.saleState.transactionId,
                                    phone: widget.customer!.phone,
                                    body: 'Receipt #${widget.saleState.transactionNumber}',
                                  );
                            } catch (e) {
                              if (context.mounted) showPosErrorSnackbar(context, e.toString());
                            }
                          },
                        ),
                    ],
                  ),
                ],

                AppSpacing.gapH24,
                PosButton(
                  label: l10n.posDone,
                  isFullWidth: true,
                  onPressed: () {
                    Navigator.of(context).pop();
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

// ─── Printer Picker helpers ────────────────────────────────

class _PrinterOption {
  const _PrinterOption({required this.selection, required this.icon});
  final PrinterSelection selection;
  final IconData icon;
}
