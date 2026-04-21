import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_providers.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Initiates a payment and shows a WebView to complete PayTabs checkout.
class PaymentCheckoutPage extends ConsumerStatefulWidget {

  const PaymentCheckoutPage({
    super.key,
    required this.purpose,
    required this.purposeLabel,
    required this.amount,
    this.taxAmount,
    this.subscriptionPlanId,
    this.addOnId,
    this.purposeReferenceId,
    this.currency,
    this.notes,
    this.onSuccessRoute,
  });
  final String purpose;
  final String purposeLabel;
  final double amount;
  final double? taxAmount;
  final String? subscriptionPlanId;
  final String? addOnId;
  final String? purposeReferenceId;
  final String? currency;
  final String? notes;
  final String? onSuccessRoute;

  @override
  ConsumerState<PaymentCheckoutPage> createState() => _PaymentCheckoutPageState();
}

class _PaymentCheckoutPageState extends ConsumerState<PaymentCheckoutPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  WebViewController? _webController;
  bool _paymentInitiated = false;
  String? _redirectUrl;
  bool _webViewLoading = true;
  bool _webLaunched = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_initiatePayment);
  }

  void _initiatePayment() {
    if (_paymentInitiated) return;
    _paymentInitiated = true;

    ref
        .read(providerPaymentActionProvider.notifier)
        .initiatePayment(
          purpose: widget.purpose,
          purposeLabel: widget.purposeLabel,
          amount: widget.amount,
          taxAmount: widget.taxAmount,
          subscriptionPlanId: widget.subscriptionPlanId,
          addOnId: widget.addOnId,
          purposeReferenceId: widget.purposeReferenceId,
          currency: widget.currency,
          notes: widget.notes,
        );
  }

  void _setupWebView(String url) {
    if (kIsWeb) {
      // On web, open the payment URL in the same browser tab.
      // The payment gateway will redirect back to the return URL.
      _webLaunched = true;
      launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
      return;
    }
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _webViewLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _webViewLoading = false);
          },
          onNavigationRequest: (request) {
            // Detect return URL to navigate back
            if (request.url.contains('/provider-payments/return') || request.url.contains('/payment/result')) {
              context.go(widget.onSuccessRoute ?? Routes.providerPayments);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(providerPaymentActionProvider);

    ref.listen<ProviderPaymentActionState>(providerPaymentActionProvider, (prev, next) {
      if (next is ProviderPaymentActionSuccess && next.payment?.redirectUrl != null) {
        setState(() => _redirectUrl = next.payment!.redirectUrl);
        _setupWebView(next.payment!.redirectUrl!);
      } else if (next is ProviderPaymentActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
      title: l10n.posCompletePayment,
      showSearch: false,
      onBack: () => _showCancelConfirmation(context),
      child: _buildBody(actionState),
    );
  }

  Widget _buildBody(ProviderPaymentActionState state) {
    if (state is ProviderPaymentActionLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const PosLoading(), const SizedBox(height: 16), Text(l10n.providerPaymentInitiating)],
        ),
      );
    }

    if (state is ProviderPaymentActionError) {
      return PosErrorState(
        message: state.message,
        onRetry: () {
          _paymentInitiated = false;
          _initiatePayment();
        },
      );
    }

    if (_redirectUrl != null && _webLaunched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const PosLoading(), const SizedBox(height: 16), Text(l10n.providerPaymentInitiating)],
        ),
      );
    }

    if (_redirectUrl != null && _webController != null) {
      return Stack(
        children: [
          WebViewWidget(controller: _webController!),
          if (_webViewLoading) const PosLoading(),
        ],
      );
    }

    return const PosLoading();
  }

  void _showCancelConfirmation(BuildContext context) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.providerPaymentCancelTitle,
      message: l10n.providerPaymentCancelBody,
      confirmLabel: l10n.cancel,
      cancelLabel: l10n.providerPaymentContinue,
    );
    if (confirmed == true) {
      context.go(Routes.providerPayments);
    }
  }
}
