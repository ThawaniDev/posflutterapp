import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// A lightweight WebView page for marketplace PayTabs checkout.
/// Receives a [redirectUrl] (PayTabs payment page) and calls [onComplete]
/// when the user finishes or the return URL is detected.
class MarketplacePaymentWebViewPage extends StatefulWidget {

  const MarketplacePaymentWebViewPage({super.key, required this.redirectUrl, required this.onComplete});
  final String redirectUrl;
  final VoidCallback onComplete;

  @override
  State<MarketplacePaymentWebViewPage> createState() => _MarketplacePaymentWebViewPageState();
}

class _MarketplacePaymentWebViewPageState extends State<MarketplacePaymentWebViewPage> {
  WebViewController? _controller;
  bool _loading = true;
  bool _webLaunched = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _webLaunched = true;
      launchUrl(Uri.parse(widget.redirectUrl), webOnlyWindowName: '_self');
      return;
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onNavigationRequest: (request) {
            if (request.url.contains('/payment/result') || request.url.contains('/provider-payments/return')) {
              Navigator.of(context).pop();
              widget.onComplete();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_webLaunched) {
      return PosListPage(
        title: l10n.posCompletePayment,
        showSearch: false,
        child: const Center(child: PosLoading()),
      );
    }
    return PosListPage(
      title: l10n.posCompletePayment,
      showSearch: false,
      child: Stack(
        children: [
          WebViewWidget(controller: _controller!),
          if (_loading) const PosLoading(),
        ],
      ),
    );
  }
}
