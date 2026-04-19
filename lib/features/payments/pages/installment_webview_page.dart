import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/installment_provider.dart';
import 'package:wameedpos/features/payments/models/installment_payment.dart';
import 'package:wameedpos/features/payments/providers/installment_providers.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Full-screen WebView checkout page for Tamara, MisPay, and Madfu.
class InstallmentWebViewPage extends ConsumerStatefulWidget {
  const InstallmentWebViewPage({super.key, required this.payment, required this.provider});

  final InstallmentPayment payment;
  final InstallmentProvider provider;

  @override
  ConsumerState<InstallmentWebViewPage> createState() => _InstallmentWebViewPageState();
}

class _InstallmentWebViewPageState extends ConsumerState<InstallmentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    final checkoutUrl = widget.payment.checkoutUrl;
    if (checkoutUrl == null || checkoutUrl.isEmpty) {
      setState(() => _error = 'No checkout URL available');
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _error = error.description;
              });
            }
          },
          onNavigationRequest: (request) {
            return _handleNavigation(request);
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final url = request.url.toLowerCase();

    // Detect success/failure/cancel callbacks
    if (url.contains('/callback/') && url.contains('/success')) {
      _onPaymentSuccess();
      return NavigationDecision.prevent;
    }
    if (url.contains('/callback/') && url.contains('/failure')) {
      _onPaymentFailure();
      return NavigationDecision.prevent;
    }
    if (url.contains('/callback/') && url.contains('/cancel')) {
      _onPaymentCancelled();
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _onPaymentSuccess() {
    ref.read(installmentCheckoutProvider.notifier).confirmPayment(widget.payment.id);
    if (mounted) {
      Navigator.pop(context, InstallmentCheckoutResult.success);
    }
  }

  void _onPaymentFailure() {
    ref
        .read(installmentCheckoutProvider.notifier)
        .failPayment(widget.payment.id, errorCode: 'PROVIDER_FAILURE', errorMessage: 'Payment failed at provider checkout');
    if (mounted) {
      Navigator.pop(context, InstallmentCheckoutResult.failure);
    }
  }

  void _onPaymentCancelled() {
    ref.read(installmentCheckoutProvider.notifier).cancelPayment(widget.payment.id);
    if (mounted) {
      Navigator.pop(context, InstallmentCheckoutResult.cancelled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
      title: '${widget.provider.label} ${l10n.checkout}',
      showSearch: false,
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsetsDirectional.only(end: 16),
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          ),
      ],
      child: _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  AppSpacing.gapH16,
                  Text(_error!, style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
                  AppSpacing.gapH16,
                  PosButton(label: l10n.goBack, onPressed: () => Navigator.pop(context, InstallmentCheckoutResult.failure)),
                ],
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading) const PosLoading(),
              ],
            ),
    );
  }

  void _confirmCancel(AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.cancelPayment,
      message: l10n.cancelPaymentConfirm,
      confirmLabel: l10n.yes,
      cancelLabel: l10n.no,
    );
    if (confirmed == true) {
      _onPaymentCancelled();
    }
  }
}

/// Result of the installment checkout flow.
enum InstallmentCheckoutResult { success, failure, cancelled }
