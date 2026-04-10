import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/payments/enums/installment_provider.dart';
import 'package:thawani_pos/features/payments/models/checkout_provider_option.dart';
import 'package:thawani_pos/features/payments/models/installment_payment.dart';
import 'package:thawani_pos/features/payments/pages/installment_webview_page.dart';
import 'package:thawani_pos/features/payments/providers/installment_providers.dart';
import 'package:thawani_pos/features/payments/providers/installment_state.dart';

/// Dialog for selecting an installment provider and initiating checkout.
/// Returns the completed [InstallmentPayment] on success, or null on cancel/failure.
class InstallmentPaymentDialog extends ConsumerStatefulWidget {
  const InstallmentPaymentDialog({
    super.key,
    required this.amount,
    required this.currency,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.items,
    this.orderReference,
  });

  final double amount;
  final String currency;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final List<Map<String, dynamic>>? items;
  final String? orderReference;

  @override
  ConsumerState<InstallmentPaymentDialog> createState() => _InstallmentPaymentDialogState();
}

class _InstallmentPaymentDialogState extends ConsumerState<InstallmentPaymentDialog> {
  CheckoutProviderOption? _selectedProvider;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(installmentCheckoutProvider.notifier).loadProviders(amount: widget.amount, currency: widget.currency);
    });
  }

  @override
  void dispose() {
    ref.read(installmentCheckoutProvider.notifier).reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(installmentCheckoutProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      child: const Icon(Icons.credit_score_rounded, color: AppColors.primary, size: 24),
                    ),
                    AppSpacing.gapW16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.installmentPayment, style: AppTypography.headlineSmall),
                          Text(
                            l10n.amountWithSar(widget.amount.toStringAsFixed(2)),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                AppSpacing.gapH24,

                // Content based on state
                _buildContent(state, l10n, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(InstallmentCheckoutState state, AppLocalizations l10n, bool isDark) {
    return switch (state) {
      InstallmentCheckoutInitial() || InstallmentCheckoutLoading() => const Center(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 32), child: CircularProgressIndicator()),
      ),
      InstallmentCheckoutProvidersLoaded(:final providers) => _buildProviderSelection(providers, l10n, isDark),
      InstallmentCheckoutCreated(:final payment) => _buildCheckoutCreated(payment, l10n),
      InstallmentCheckoutCompleted(:final payment) => _buildCompleted(payment, l10n),
      InstallmentCheckoutCancelled() => _buildCancelled(l10n),
      InstallmentCheckoutFailed(:final message) => _buildFailed(message, l10n),
      InstallmentCheckoutError(:final message) => _buildError(message, l10n),
    };
  }

  Widget _buildProviderSelection(List<CheckoutProviderOption> providers, AppLocalizations l10n, bool isDark) {
    if (providers.isEmpty) {
      return Column(
        children: [
          Icon(Icons.payment_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),
          AppSpacing.gapH12,
          Text(l10n.noInstallmentProvidersForAmount, style: AppTypography.bodyMedium),
          AppSpacing.gapH24,
          PosButton(
            label: l10n.goBack,
            variant: PosButtonVariant.outline,
            isFullWidth: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }

    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.selectInstallmentProvider, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
        AppSpacing.gapH12,

        // Provider options
        ...providers.map((provider) => _buildProviderOption(provider, isAr, isDark)),

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
              child: PosButton(label: l10n.cancel, variant: PosButtonVariant.outline, onPressed: () => Navigator.pop(context)),
            ),
            AppSpacing.gapW12,
            Expanded(
              flex: 2,
              child: PosButton(
                label: l10n.payWithInstallments,
                icon: Icons.credit_score_rounded,
                onPressed: _selectedProvider != null ? _initiateCheckout : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProviderOption(CheckoutProviderOption provider, bool isAr, bool isDark) {
    final isSelected = _selectedProvider?.provider == provider.provider;
    final name = isAr ? (provider.nameAr ?? provider.name) : provider.name;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return GestureDetector(
      onTap: () => setState(() => _selectedProvider = provider),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: AppSpacing.paddingAll12,
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : null,
        ),
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.primary : mutedColor, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                      ),
                    )
                  : null,
            ),
            AppSpacing.gapW12,

            // Provider info
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), borderRadius: AppRadius.borderSm),
              child: provider.logoUrl != null
                  ? ClipRRect(
                      borderRadius: AppRadius.borderSm,
                      child: Image.network(
                        provider.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.payment, color: AppColors.primary, size: 18),
                      ),
                    )
                  : const Icon(Icons.payment, color: AppColors.primary, size: 18),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                  if (provider.installmentCounts.isNotEmpty)
                    Text(
                      '${provider.installmentCounts.join("/")} ${AppLocalizations.of(context)!.installments} · '
                      '${AppLocalizations.of(context)!.sarCurrency} ${provider.installmentAmount.toStringAsFixed(2)}',
                      style: AppTypography.bodySmall.copyWith(color: mutedColor),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initiateCheckout() {
    if (_selectedProvider == null) return;

    setState(() => _error = null);

    final data = <String, dynamic>{
      'provider': _selectedProvider!.provider,
      'amount': widget.amount,
      'currency': widget.currency,
      if (widget.customerName != null) 'customer_name': widget.customerName,
      if (widget.customerPhone != null) 'customer_phone': widget.customerPhone,
      if (widget.customerEmail != null) 'customer_email': widget.customerEmail,
      if (widget.items != null) 'items': widget.items,
      if (widget.orderReference != null) 'order_reference': widget.orderReference,
    };

    ref.read(installmentCheckoutProvider.notifier).createCheckout(data);
  }

  Widget _buildCheckoutCreated(InstallmentPayment payment, AppLocalizations l10n) {
    // Auto-navigate to WebView
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = InstallmentProvider.tryFromValue(payment.provider.value);
      if (provider == null) return;

      final result = await Navigator.push<InstallmentCheckoutResult>(
        context,
        MaterialPageRoute(
          builder: (_) => InstallmentWebViewPage(payment: payment, provider: provider),
        ),
      );

      if (!mounted) return;

      switch (result) {
        case InstallmentCheckoutResult.success:
          // Payment confirmed — return success to the payment dialog
          Navigator.pop(context, payment);
        case InstallmentCheckoutResult.failure:
          setState(() => _error = l10n.installmentPaymentFailed);
          ref.read(installmentCheckoutProvider.notifier).loadProviders(amount: widget.amount, currency: widget.currency);
        case InstallmentCheckoutResult.cancelled:
          ref.read(installmentCheckoutProvider.notifier).loadProviders(amount: widget.amount, currency: widget.currency);
        case null:
          ref.read(installmentCheckoutProvider.notifier).loadProviders(amount: widget.amount, currency: widget.currency);
      }
    });

    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Opening checkout...')],
        ),
      ),
    );
  }

  Widget _buildCompleted(InstallmentPayment payment, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.10), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
        ),
        AppSpacing.gapH16,
        Text(l10n.installmentPaymentSuccess, style: AppTypography.headlineSmall),
        AppSpacing.gapH8,
        Text(
          l10n.amountWithSar(payment.amount.toStringAsFixed(2)),
          style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
        ),
        AppSpacing.gapH24,
        PosButton(label: l10n.done, isFullWidth: true, onPressed: () => Navigator.pop(context, payment)),
      ],
    );
  }

  Widget _buildCancelled(AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(Icons.cancel_outlined, color: AppColors.warning, size: 48),
        AppSpacing.gapH16,
        Text(l10n.installmentPaymentCancelled, style: AppTypography.titleMedium),
        AppSpacing.gapH24,
        PosButton(
          label: l10n.goBack,
          isFullWidth: true,
          variant: PosButtonVariant.outline,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildFailed(String message, AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: AppColors.error, size: 48),
        AppSpacing.gapH16,
        Text(l10n.installmentPaymentFailed, style: AppTypography.titleMedium),
        AppSpacing.gapH8,
        Text(message, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
        AppSpacing.gapH24,
        Row(
          children: [
            Expanded(
              child: PosButton(label: l10n.cancel, variant: PosButtonVariant.outline, onPressed: () => Navigator.pop(context)),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: PosButton(
                label: l10n.retry,
                onPressed: () {
                  ref.read(installmentCheckoutProvider.notifier).loadProviders(amount: widget.amount, currency: widget.currency);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildError(String message, AppLocalizations l10n) {
    return _buildFailed(message, l10n);
  }
}
