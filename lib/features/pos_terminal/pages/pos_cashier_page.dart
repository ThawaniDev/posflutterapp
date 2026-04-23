import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/security/repositories/security_repository.dart';
import 'package:wameedpos/features/pos_terminal/models/cart_item.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_open_shift_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_close_shift_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_payment_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_held_carts_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_return_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_customer_search_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_cash_event_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_shift_report_dialog.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_reprint_receipt_dialog.dart';
import 'package:wameedpos/features/pos_terminal/widgets/age_verification_dialog.dart';
import 'package:wameedpos/features/pos_terminal/widgets/manager_pin_dialog.dart';
import 'package:wameedpos/features/pos_terminal/widgets/quick_add_customer_dialog.dart';
import 'package:wameedpos/features/pos_terminal/widgets/tax_exempt_dialog.dart';
import 'package:wameedpos/features/settings/models/store_settings.dart';
import 'package:wameedpos/features/settings/providers/settings_providers.dart';

class PosCashierPage extends ConsumerStatefulWidget {
  const PosCashierPage({super.key});

  @override
  ConsumerState<PosCashierPage> createState() => _PosCashierPageState();
}

class _PosCashierPageState extends ConsumerState<PosCashierPage> {
  final _searchController = TextEditingController();
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(posProductsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── Keyboard shortcuts ───────────────────────────────────────

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.f2) {
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.f4) {
      _handlePay();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.f8) {
      _handleHoldCart();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.f9) {
      _handleRecallCart();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ─── Actions ──────────────────────────────────────────────────

  void _handlePay() {
    final cart = ref.read(cartProvider);
    final session = ref.read(activeSessionProvider);
    if (cart.isEmpty || session is! ActiveSessionLoaded) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PosPaymentDialog(totalAmount: cart.totalAmount, sessionId: session.session.id),
    );
  }

  Future<void> _handleHoldCart() async {
    final cart = ref.read(cartProvider);
    final session = ref.read(activeSessionProvider);
    if (cart.isEmpty || session is! ActiveSessionLoaded) return;

    final label = await _showLabelDialog();
    if (label == null) return;

    final cartData = cart.toHoldCartJson();
    await ref.read(heldCartsProvider.notifier).holdCart({...cartData, 'label': label});
    ref.read(cartProvider.notifier).clear();
    if (mounted) showPosSuccessSnackbar(context, AppLocalizations.of(context)!.posCartHeld);
  }

  Future<String?> _showLabelDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(ctx)!.posHoldCart, style: AppTypography.headlineSmall),
                AppSpacing.gapH16,
                PosTextField(
                  controller: controller,
                  label: AppLocalizations.of(ctx)!.posLabelOptional,
                  hint: AppLocalizations.of(ctx)!.posLabelHint,
                  autofocus: true,
                  onSubmitted: (_) => Navigator.pop(
                    ctx,
                    controller.text.trim().isEmpty ? AppLocalizations.of(ctx)!.posHeldCart : controller.text.trim(),
                  ),
                ),
                AppSpacing.gapH16,
                Row(
                  children: [
                    Expanded(
                      child: PosButton(
                        label: AppLocalizations.of(ctx)!.posCancel,
                        variant: PosButtonVariant.outline,
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosButton(
                        label: AppLocalizations.of(ctx)!.posHold,
                        onPressed: () => Navigator.pop(
                          ctx,
                          controller.text.trim().isEmpty ? AppLocalizations.of(ctx)!.posHeldCart : controller.text.trim(),
                        ),
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

  void _handleRecallCart() {
    showDialog(context: context, builder: (_) => const PosHeldCartsDialog());
  }

  void _handleReturn() {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const PosReturnDialog());
  }

  void _handleCustomerSearch() {
    showDialog(context: context, builder: (_) => const PosCustomerSearchDialog());
  }

  void _handleProductSearch(String query) {
    if (query.isEmpty) {
      ref.read(posProductsProvider.notifier).load(categoryId: _selectedCategoryId);
    } else {
      ref.read(posProductsProvider.notifier).load(search: query, categoryId: _selectedCategoryId);
    }
  }

  void _handleBarcodeScan(String barcode) async {
    final product = await ref.read(posProductsProvider.notifier).findByBarcode(barcode);
    if (product != null) {
      await _addProductToCart(product);
      _searchController.clear();
    } else {
      if (mounted) showPosErrorSnackbar(context, AppLocalizations.of(context)!.posProductNotFound);
    }
  }

  Future<void> _addProductToCart(Product product) async {
    if (product.ageRestricted == true) {
      final verified = await showPosAgeVerificationDialog(context, minimumAge: 18);
      if (verified != true) return;
    }

    double qty = 1;
    if (product.isWeighable == true) {
      final weight = await showPosWeightDialog(
        context,
        title: AppLocalizations.of(context)!.posEnterWeight,
        message: product.tareWeight != null && product.tareWeight! > 0
            ? AppLocalizations.of(context)!.posTareWeightNote(product.tareWeight!.toStringAsFixed(3))
            : null,
        confirmLabel: AppLocalizations.of(context)!.commonConfirm,
        cancelLabel: AppLocalizations.of(context)!.commonCancel,
        hintText: AppLocalizations.of(context)!.posWeightHint,
      );
      if (weight == null) return;
      qty = weight;
    }

    ref.read(cartProvider.notifier).addProduct(product, qty: qty);
    if (product.ageRestricted == true) {
      final cart = ref.read(cartProvider);
      final idx = cart.items.indexWhere((i) => i.product.id == product.id);
      if (idx >= 0) {
        ref.read(cartProvider.notifier).markAgeVerified(idx);
      }
    }
    if (mounted) showPosSuccessSnackbar(context, AppLocalizations.of(context)!.posProductAdded(product.name));
  }

  Future<void> _handleDiscount() async {
    final cart = ref.read(cartProvider);
    final controller = TextEditingController(
      text: cart.manualDiscount != null && cart.manualDiscount! > 0 ? cart.manualDiscount!.toStringAsFixed(2) : '',
    );
    final result = await showDialog<double?>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(ctx)!.posCartDiscount, style: AppTypography.headlineSmall),
                AppSpacing.gapH8,
                Text(
                  AppLocalizations.of(ctx)!.posSubtotalAmount(cart.subtotal.toStringAsFixed(2)),
                  style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                ),
                AppSpacing.gapH16,
                PosTextField(
                  controller: controller,
                  label: AppLocalizations.of(ctx)!.posDiscountAmountSar,
                  hint: '0.00',
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) {
                    final val = double.tryParse(controller.text.trim());
                    Navigator.pop(ctx, val);
                  },
                ),
                AppSpacing.gapH16,
                Row(
                  children: [
                    Expanded(
                      child: PosButton(
                        label: AppLocalizations.of(ctx)!.posRemove,
                        variant: PosButtonVariant.outline,
                        onPressed: () => Navigator.pop(ctx, 0.0),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosButton(
                        label: AppLocalizations.of(ctx)!.posApply,
                        onPressed: () {
                          final val = double.tryParse(controller.text.trim());
                          Navigator.pop(ctx, val);
                        },
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
    if (result != null) {
      // Check whether manager approval is needed for this discount.
      final settingsState = ref.read(storeSettingsProvider);
      final settings = settingsState is StoreSettingsLoaded ? settingsState.settings : null;
      final requirePin = settings?.requireManagerForDiscount ?? false;
      final maxPct = settings?.maxDiscountPercent ?? 100;
      final cart = ref.read(cartProvider);
      final subtotal = cart.subtotal;
      final effectivePct = subtotal > 0 ? (result / subtotal * 100) : 0;
      final exceedsLimit = result > 0 && (requirePin || (maxPct < 100 && effectivePct > maxPct));

      if (exceedsLimit) {
        final approval = await showPosManagerPinDialog(
          context,
          action: 'discount',
          ref: ref,
        );
        if (approval == null) {
          if (mounted) {
            showPosErrorSnackbar(context, AppLocalizations.of(context)!.posManagerPinInvalid);
          }
          return;
        }
      }
      ref.read(cartProvider.notifier).setManualDiscount(result > 0 ? result : null);
    }
  }

  Future<void> _handleNotes() async {
    final cart = ref.read(cartProvider);
    final controller = TextEditingController(text: cart.notes ?? '');
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(ctx)!.posOrderNotes, style: AppTypography.headlineSmall),
                AppSpacing.gapH16,
                PosTextField(
                  controller: controller,
                  label: AppLocalizations.of(ctx)!.posNotes,
                  hint: AppLocalizations.of(ctx)!.posNotesHint,
                  autofocus: true,
                  maxLines: 3,
                  onSubmitted: (_) => Navigator.pop(ctx, controller.text.trim()),
                ),
                AppSpacing.gapH16,
                Row(
                  children: [
                    Expanded(
                      child: PosButton(
                        label: AppLocalizations.of(ctx)!.posClear,
                        variant: PosButtonVariant.outline,
                        onPressed: () => Navigator.pop(ctx, ''),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: PosButton(
                        label: AppLocalizations.of(ctx)!.posSave,
                        onPressed: () => Navigator.pop(ctx, controller.text.trim()),
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
    if (result != null) {
      ref.read(cartProvider.notifier).setNotes(result.isEmpty ? null : result);
    }
  }

  Future<void> _handleTaxExempt() async {
    final cart = ref.read(cartProvider);
    // Toggle off if currently exempt
    if (cart.taxExempt) {
      ref.read(cartProvider.notifier).setTaxExemption(null);
      return;
    }

    final details = await showPosTaxExemptDialog(context);
    if (details == null) return;

    final approval = await showPosManagerPinDialog(
      context,
      action: 'tax_exempt',
      ref: ref,
    );
    if (approval == null) {
      if (mounted) {
        showPosErrorSnackbar(context, AppLocalizations.of(context)!.posManagerPinInvalid);
      }
      return;
    }
    ref.read(cartProvider.notifier).setTaxExemption(details);
    if (mounted) {
      showPosSuccessSnackbar(context, AppLocalizations.of(context)!.posTaxExempt);
    }
  }

  void _handleVoidLastItem() {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;
    final lastItem = cart.items.last;
    showPosConfirmDialog(
      context,
      title: AppLocalizations.of(context)!.posVoidLastItem,
      message: AppLocalizations.of(context)!.posRemoveItemFromCart(lastItem.product.name),
      confirmLabel: AppLocalizations.of(context)!.posRemove,
      isDanger: true,
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(cartProvider.notifier).removeItem(cart.items.length - 1);
      }
    });
  }

  Future<void> _handleLogout() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.logoutTitle,
      message: l10n.logoutConfirm,
      confirmLabel: l10n.logout,
      isDanger: true,
    );
    if (confirmed == true) {
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated && authState.user.storeId != null) {
        ref
            .read(securityRepositoryProvider)
            .endAllSessions(storeId: authState.user.storeId!)
            .catchError((_) => <String, dynamic>{});
      }
      ref.read(authProvider.notifier).logout(l10n);
    }
  }

  // ─── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(activeSessionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sessionState is! ActiveSessionLoaded) {
      return _buildNoSessionView(isDark, sessionState);
    }

    final isMobile = context.isPhone;

    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: isMobile
            ? _buildMobileBody(isDark, sessionState.session)
            : Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildTopBar(isDark, sessionState.session),
                        _buildSearchBar(isDark),
                        Expanded(child: _buildProductGrid(isDark)),
                      ],
                    ),
                  ),
                  SizedBox(width: 480, child: _buildCartPanel(isDark)),
                ],
              ),
      ),
    );
  }

  // ─── Mobile Body ──────────────────────────────────────────────

  Widget _buildMobileBody(bool isDark, PosSession session) {
    final cart = ref.watch(cartProvider);
    return Column(
      children: [
        // Compact mobile top bar
        _buildMobileTopBar(isDark, session),
        // Search
        _buildSearchBar(isDark),
        // Product grid
        Expanded(child: _buildProductGrid(isDark)),
        // Mobile cart summary bar — tap to expand
        _buildMobileCartBar(isDark, cart),
      ],
    );
  }

  Widget _buildMobileTopBar(bool isDark, PosSession session) {
    final user = ref.watch(currentUserProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user?.name ?? AppLocalizations.of(context)!.posCashier, style: AppTypography.titleSmall),
                Text(
                  AppLocalizations.of(context)!.posSessionNumber(session.id.substring(0, 8)),
                  style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context), fontSize: 11),
                ),
              ],
            ),
          ),
          // Compact icon actions
          IconButton(
            icon: const Icon(Icons.discount_outlined, size: 20),
            tooltip: AppLocalizations.of(context)!.posDiscount,
            onPressed: _handleDiscount,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            icon: const Icon(Icons.note_alt_outlined, size: 20),
            tooltip: AppLocalizations.of(context)!.posNotes,
            onPressed: _handleNotes,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            icon: const Icon(Icons.assignment_return_outlined, size: 20),
            tooltip: AppLocalizations.of(context)!.posReturn,
            onPressed: _handleReturn,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onSelected: (value) {
              switch (value) {
                case 'void_last':
                  _handleVoidLastItem();
                case 'held_carts':
                  _handleRecallCart();
                case 'cash_in':
                  showDialog(
                    context: context,
                    builder: (_) => PosCashEventDialog(sessionId: session.id, type: 'cash_in'),
                  ).then((ok) {
                    if (ok == true) ref.read(activeSessionProvider.notifier).refreshSession();
                  });
                case 'cash_out':
                  showDialog(
                    context: context,
                    builder: (_) => PosCashEventDialog(sessionId: session.id, type: 'cash_out'),
                  ).then((ok) {
                    if (ok == true) ref.read(activeSessionProvider.notifier).refreshSession();
                  });
                case 'x_report':
                  showDialog(
                    context: context,
                    builder: (_) => PosShiftReportDialog(sessionId: session.id, isZReport: false),
                  );
                case 'z_report':
                  showDialog(
                    context: context,
                    builder: (_) => PosShiftReportDialog(sessionId: session.id, isZReport: true),
                  );
                case 'reprint':
                  showDialog(context: context, builder: (_) => const PosReprintReceiptDialog());
                case 'end_shift':
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => PosCloseShiftDialog(session: session),
                  );
                case 'logout':
                  _handleLogout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'void_last',
                child: ListTile(
                  leading: const Icon(Icons.backspace_outlined, size: 20),
                  title: Text(AppLocalizations.of(context)!.posVoidLast),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'held_carts',
                child: ListTile(
                  leading: const Icon(Icons.pause_circle_outline, size: 20),
                  title: Text(AppLocalizations.of(context)!.posHeldF9),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'cash_in',
                child: ListTile(
                  leading: Icon(Icons.add_circle_outline, size: 20, color: AppColors.success),
                  title: Text('Cash In (Paid-In)'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'cash_out',
                child: ListTile(
                  leading: Icon(Icons.remove_circle_outline, size: 20, color: AppColors.warning),
                  title: Text('Cash Out (Drop / Payout)'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'x_report',
                child: ListTile(
                  leading: Icon(Icons.insights, size: 20),
                  title: Text('X-Report (Snapshot)'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'z_report',
                child: ListTile(
                  leading: Icon(Icons.assessment, size: 20),
                  title: Text('Z-Report'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'reprint',
                child: ListTile(
                  leading: Icon(Icons.receipt_long, size: 20),
                  title: Text('Reprint Receipt'),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'end_shift',
                child: ListTile(
                  leading: const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
                  title: Text(AppLocalizations.of(context)!.posEndShift, style: const TextStyle(color: AppColors.error)),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: const Icon(Icons.power_settings_new_rounded, size: 20),
                  title: Text(AppLocalizations.of(context)!.logout),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCartBar(bool isDark, CartState cart) {
    final saleState = ref.watch(saleProvider);
    return GestureDetector(
      onTap: cart.isNotEmpty ? () => _showMobileCartSheet(isDark) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          border: Border(top: BorderSide(color: AppColors.borderFor(context))),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Cart icon + badge
              Stack(
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 24, color: AppColors.primary),
                  if (cart.isNotEmpty)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              AppSpacing.gapW12,
              // Total
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cart.isEmpty
                          ? AppLocalizations.of(context)!.posNoItems
                          : AppLocalizations.of(context)!.amountWithSar(cart.totalAmount.toStringAsFixed(2)),
                      style: AppTypography.titleMedium.copyWith(color: cart.isEmpty ? (AppColors.mutedFor(context)) : null),
                    ),
                    if (cart.isNotEmpty)
                      Text(
                        '${cart.itemCount} ${AppLocalizations.of(context)!.posItems} • Tap to view cart',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context), fontSize: 11),
                      ),
                  ],
                ),
              ),
              // Pay button
              PosButton(
                label: AppLocalizations.of(context)!.posPay,
                icon: Icons.payment_rounded,
                size: PosButtonSize.md,
                isLoading: saleState is SaleProcessing,
                onPressed: cart.isNotEmpty ? _handlePay : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileCartSheet(bool isDark) {
    final cart = ref.read(cartProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.borderFor(context), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            // Cart header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 22, color: AppColors.primary),
                  AppSpacing.gapW8,
                  Text(AppLocalizations.of(context)!.posCart, style: AppTypography.headlineSmall),
                  const Spacer(),
                  PosBadge(label: '${cart.itemCount}', variant: PosBadgeVariant.primary),
                  AppSpacing.gapW8,
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Customer
            _buildCustomerRow(isDark, cart),
            const Divider(height: 1),
            // Items
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: cart.items.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                itemBuilder: (context, index) => _CartItemTile(item: cart.items[index], index: index, isDark: isDark),
              ),
            ),
            // Footer with totals + buttons
            _buildCartFooter(isDark, cart, ref.read(saleProvider)),
          ],
        ),
      ),
    );
  }

  // ─── No Session View ──────────────────────────────────────────

  Widget _buildNoSessionView(bool isDark, ActiveSessionState sessionState) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: PosCard(
          padding: AppSpacing.paddingAll24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                  child: const Icon(Icons.point_of_sale_rounded, size: 40, color: AppColors.primary),
                ),
                AppSpacing.gapH24,
                Text(AppLocalizations.of(context)!.posStartYourShift, style: AppTypography.headlineLarge),
                AppSpacing.gapH8,
                Text(
                  AppLocalizations.of(context)!.posOpenShiftDescription,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapH24,
                if (sessionState is ActiveSessionError) ...[
                  Container(
                    padding: AppSpacing.paddingAll16,
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Text(sessionState.message, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH16,
                ],
                if (sessionState is ActiveSessionLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                else
                  PosButton(
                    label: AppLocalizations.of(context)!.posOpenShift,
                    icon: Icons.login_rounded,
                    size: PosButtonSize.lg,
                    isFullWidth: true,
                    onPressed: () =>
                        showDialog(context: context, barrierDismissible: false, builder: (_) => const PosOpenShiftDialog()),
                  ),
                AppSpacing.gapH12,
                PosButton(
                  label: AppLocalizations.of(context)!.logout,
                  icon: Icons.power_settings_new_rounded,
                  variant: PosButtonVariant.outline,
                  size: PosButtonSize.md,
                  isFullWidth: true,
                  onPressed: _handleLogout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Top Action Bar ───────────────────────────────────────────

  Widget _buildTopBar(bool isDark, PosSession session) {
    final user = ref.watch(currentUserProvider);
    final cart = ref.watch(cartProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Row(
        children: [
          // Cashier name + session info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(user?.name ?? AppLocalizations.of(context)!.posCashier, style: AppTypography.titleMedium),
              Text(
                AppLocalizations.of(context)!.posSessionNumber(session.id.substring(0, 8)),
                style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
              ),
            ],
          ),
          const Spacer(),
          // Action buttons — touch-friendly md size
          PosButton(
            label: AppLocalizations.of(context)!.posDiscount,
            icon: Icons.discount_outlined,
            variant: cart.isNotEmpty ? PosButtonVariant.soft : PosButtonVariant.outline,
            size: PosButtonSize.md,
            onPressed: cart.isNotEmpty ? _handleDiscount : null,
          ),
          AppSpacing.gapW8,
          PosButton(
            label: AppLocalizations.of(context)!.posNotes,
            icon: Icons.note_alt_outlined,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.md,
            onPressed: cart.isNotEmpty ? _handleNotes : null,
          ),
          AppSpacing.gapW8,
          PosButton(
            label: AppLocalizations.of(context)!.posVoidLast,
            icon: Icons.backspace_outlined,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.md,
            onPressed: cart.isNotEmpty ? _handleVoidLastItem : null,
          ),
          AppSpacing.gapW8,
          PosButton(
            label: AppLocalizations.of(context)!.posTaxExempt,
            icon: Icons.receipt_long_outlined,
            variant: cart.taxExempt ? PosButtonVariant.primary : PosButtonVariant.outline,
            size: PosButtonSize.md,
            onPressed: cart.isNotEmpty ? _handleTaxExempt : null,
          ),
          AppSpacing.gapW12,
          Container(width: 1, height: 32, color: AppColors.borderFor(context)),
          AppSpacing.gapW12,
          PosButton(
            label: AppLocalizations.of(context)!.posReturn,
            icon: Icons.assignment_return_outlined,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.md,
            onPressed: _handleReturn,
          ),
          AppSpacing.gapW8,
          PosButton(
            label: AppLocalizations.of(context)!.posHeldF9,
            icon: Icons.pause_circle_outline,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.md,
            onPressed: _handleRecallCart,
          ),
          AppSpacing.gapW8,
          PosButton(
            label: AppLocalizations.of(context)!.posEndShift,
            icon: Icons.logout_rounded,
            variant: PosButtonVariant.danger,
            size: PosButtonSize.md,
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => PosCloseShiftDialog(session: session),
            ),
          ),
          AppSpacing.gapW8,
          PosButton(
            label: AppLocalizations.of(context)!.logout,
            icon: Icons.power_settings_new_rounded,
            variant: PosButtonVariant.outline,
            size: PosButtonSize.md,
            onPressed: _handleLogout,
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ───────────────────────────────────────────────

  Widget _buildSearchBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: PosSearchField(
              controller: _searchController,
              hint: AppLocalizations.of(context)!.posSearchProductsHint,
              onChanged: _handleProductSearch,
              onSubmitted: (val) {
                if (val.isNotEmpty && RegExp(r'^\d{4,}$').hasMatch(val)) {
                  _handleBarcodeScan(val);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Product Grid ─────────────────────────────────────────────

  Widget _buildProductGrid(bool isDark) {
    final productsState = ref.watch(posProductsProvider);

    if (productsState is PosProductsLoading || productsState is PosProductsInitial) {
      return Center(child: PosLoadingSkeleton.list(count: 6));
    }

    if (productsState is PosProductsError) {
      return PosErrorState(message: productsState.message, onRetry: () => ref.read(posProductsProvider.notifier).load());
    }

    final products = productsState is PosProductsLoaded ? productsState.products : <Product>[];

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight),
            AppSpacing.gapH8,
            Text(
              AppLocalizations.of(context)!.posNoProductsFound,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
            ),
            AppSpacing.gapH4,
            Text(
              AppLocalizations.of(context)!.posNoProductsSubtitle,
              style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 0.82,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) =>
            _ProductGridTile(product: products[index], onTap: () => _addProductToCart(products[index])),
      ),
    );
  }

  // ─── Cart Panel ───────────────────────────────────────────────

  Widget _buildCartPanel(bool isDark) {
    final cart = ref.watch(cartProvider);
    final saleState = ref.watch(saleProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(left: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Column(
        children: [
          // Cart header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.base),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderFor(context))),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 24, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(AppLocalizations.of(context)!.posCart, style: AppTypography.headlineSmall),
                const Spacer(),
                if (cart.notes != null && cart.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                    child: Icon(Icons.note_alt_outlined, size: 16, color: AppColors.mutedFor(context)),
                  ),
                if (cart.isNotEmpty) PosBadge(label: '${cart.itemCount}', variant: PosBadgeVariant.primary),
              ],
            ),
          ),

          // Customer
          _buildCustomerRow(isDark, cart),

          // Cart items
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 48,
                          color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
                        ),
                        AppSpacing.gapH8,
                        Text(
                          AppLocalizations.of(context)!.posNoItems,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          AppLocalizations.of(context)!.posTapProductsToAdd,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                    itemBuilder: (context, index) => _CartItemTile(item: cart.items[index], index: index, isDark: isDark),
                  ),
          ),

          // Totals + actions
          _buildCartFooter(isDark, cart, saleState),
        ],
      ),
    );
  }

  Widget _buildCustomerRow(bool isDark, CartState cart) {
    return InkWell(
      onTap: _handleCustomerSearch,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.base),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight)),
        ),
        child: Row(
          children: [
            Icon(Icons.person_outline, size: 20, color: AppColors.mutedFor(context)),
            AppSpacing.gapW8,
            Expanded(
              child: Text(
                cart.customer?.name ?? AppLocalizations.of(context)!.posWalkInCustomer,
                style: AppTypography.bodyMedium.copyWith(
                  color: cart.customer != null
                      ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                      : (AppColors.mutedFor(context)),
                ),
              ),
            ),
            if (cart.customer != null)
              GestureDetector(
                onTap: () => ref.read(cartProvider.notifier).setCustomer(null),
                child: const Icon(Icons.close, size: 18, color: AppColors.textDisabledLight),
              )
            else
              Icon(Icons.chevron_right, size: 18, color: AppColors.mutedFor(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFooter(bool isDark, CartState cart, SaleState saleState) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceFor(context),
        border: Border(top: BorderSide(color: AppColors.borderFor(context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal
          _buildTotalRow(AppLocalizations.of(context)!.posSubtotal, cart.subtotal, isDark),
          if (cart.discountTotal > 0)
            _buildTotalRow(AppLocalizations.of(context)!.posDiscount, -cart.discountTotal, isDark, color: AppColors.error),
          _buildTotalRow(AppLocalizations.of(context)!.posTax15, cart.taxAmount, isDark),
          AppSpacing.gapH12,
          Divider(height: 1, color: AppColors.borderFor(context)),
          AppSpacing.gapH12,
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.posTotal, style: AppTypography.headlineLarge),
              Text(
                AppLocalizations.of(context)!.amountWithSar(cart.totalAmount.toStringAsFixed(2)),
                style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          AppSpacing.gapH16,
          // Action buttons — large for touch
          Row(
            children: [
              // Hold
              Expanded(
                child: PosButton(
                  label: AppLocalizations.of(context)!.posHoldF8,
                  icon: Icons.pause_rounded,
                  variant: PosButtonVariant.outline,
                  size: PosButtonSize.xl,
                  onPressed: cart.isNotEmpty ? _handleHoldCart : null,
                ),
              ),
              AppSpacing.gapW12,
              // Pay
              Expanded(
                flex: 2,
                child: PosButton(
                  label: AppLocalizations.of(context)!.posPayF4,
                  icon: Icons.payment_rounded,
                  size: PosButtonSize.xl,
                  isLoading: saleState is SaleProcessing,
                  onPressed: cart.isNotEmpty ? _handlePay : null,
                ),
              ),
            ],
          ),
          if (cart.isNotEmpty) ...[
            AppSpacing.gapH8,
            PosButton(
              label: AppLocalizations.of(context)!.posClearCart,
              variant: PosButtonVariant.ghost,
              size: PosButtonSize.md,
              isFullWidth: true,
              onPressed: () async {
                final confirmed = await showPosConfirmDialog(
                  context,
                  title: AppLocalizations.of(context)!.posClearCartConfirm,
                  message: AppLocalizations.of(context)!.posClearCartMessage,
                  confirmLabel: AppLocalizations.of(context)!.posClear,
                  isDanger: true,
                );
                if (confirmed == true) ref.read(cartProvider.notifier).clear();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, bool isDark, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.titleSmall.copyWith(color: AppColors.mutedFor(context))),
          Text(
            '${amount < 0 ? '-' : ''}${AppLocalizations.of(context)!.amountWithSar(amount.abs().toStringAsFixed(2))}',
            style: AppTypography.titleSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

// ─── Product Grid Tile ──────────────────────────────────────────

class _ProductGridTile extends StatelessWidget {
  const _ProductGridTile({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasOffer =
        product.offerPrice != null &&
        product.offerStart != null &&
        product.offerEnd != null &&
        DateTime.now().isAfter(product.offerStart!) &&
        DateTime.now().isBefore(product.offerEnd!);

    return Material(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderMd,
            border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Product image or icon — larger for touch
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: AppRadius.borderSm),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: AppRadius.borderSm,
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 28),
                        ),
                      )
                    : const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 28),
              ),
              AppSpacing.gapH8,
              // Name
              Text(
                product.name,
                style: AppTypography.labelMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapH4,
              // Price
              if (hasOffer)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\u0081 ${product.offerPrice!.toStringAsFixed(2)}',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                    ),
                    AppSpacing.gapW4,
                    Text(
                      product.sellPrice.toStringAsFixed(2),
                      style: AppTypography.bodySmall.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.textDisabledLight,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  '\u0081 ${product.sellPrice.toStringAsFixed(2)}',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Cart Item Tile ─────────────────────────────────────────────

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item, required this.index, required this.isDark});

  final CartItem item;
  final int index;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('${item.product.id}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 16),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
      ),
      onDismissed: (_) => ref.read(cartProvider.notifier).removeItem(index),
      child: GestureDetector(
        onLongPress: () => _showItemOptions(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    AppSpacing.gapH4,
                    Text(
                      '\u0081 ${item.unitPrice.toStringAsFixed(2)} x ${item.quantity.toStringAsFixed(item.quantity == item.quantity.roundToDouble() ? 0 : 2)}',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.mutedFor(context)),
                    ),
                    if (item.discountAmount != null && item.discountAmount! > 0)
                      Text(
                        '-\u0081 ${item.discountAmount!.toStringAsFixed(2)}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                      ),
                  ],
                ),
              ),
              // Quantity controls — larger for touch
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () => ref.read(cartProvider.notifier).updateQuantity(index, item.quantity - 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      item.quantity.toStringAsFixed(item.quantity == item.quantity.roundToDouble() ? 0 : 2),
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () => ref.read(cartProvider.notifier).updateQuantity(index, item.quantity + 1),
                  ),
                ],
              ),
              AppSpacing.gapW12,
              // Line total
              SizedBox(
                width: 88,
                child: Text(
                  '\u0081 ${item.lineTotal.toStringAsFixed(2)}',
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showItemOptions(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.discount_outlined),
              title: Text(l.posDiscount),
              subtitle: item.discountAmount != null && item.discountAmount! > 0
                  ? Text('Current: ${item.discountAmount!.toStringAsFixed(2)}')
                  : null,
              onTap: () async {
                Navigator.pop(ctx);
                final v = await _promptAmount(context, 'Item discount', item.discountAmount ?? 0);
                if (v != null) ref.read(cartProvider.notifier).setItemDiscount(index, v);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_alt_outlined),
              title: Text(l.posNotes),
              subtitle: (item.notes?.isNotEmpty ?? false) ? Text(item.notes!) : null,
              onTap: () async {
                Navigator.pop(ctx);
                final v = await _promptText(context, 'Item note', item.notes ?? '');
                if (v != null) ref.read(cartProvider.notifier).setItemNotes(index, v);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(l.remove, style: const TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(cartProvider.notifier).removeItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<double?> _promptAmount(BuildContext context, String title, double initial) async {
    final controller = TextEditingController(text: initial > 0 ? initial.toStringAsFixed(2) : '');
    return showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))],
          decoration: const InputDecoration(prefixIcon: Icon(Icons.attach_money)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(controller.text.trim()) ?? 0),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  Future<String?> _promptText(BuildContext context, String title, String initial) async {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true, minLines: 2, maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderMd,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: AppColors.borderFor(context)),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}
