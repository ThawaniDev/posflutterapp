import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wameedpos/core/theme/app_colors.dart';

/// A lightweight WebView page for marketplace PayTabs checkout.
/// Receives a [redirectUrl] (PayTabs payment page) and calls [onComplete]
/// when the user finishes or the return URL is detected.
class MarketplacePaymentWebViewPage extends StatefulWidget {
  final String redirectUrl;
  final VoidCallback onComplete;

  const MarketplacePaymentWebViewPage({
    super.key,
    required this.redirectUrl,
    required this.onComplete,
  });

  @override
  State<MarketplacePaymentWebViewPage> createState() => _MarketplacePaymentWebViewPageState();
}

class _MarketplacePaymentWebViewPageState extends State<MarketplacePaymentWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
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
            if (request.url.contains('/payment/result') ||
                request.url.contains('/provider-payments/return')) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showCancelDialog(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Payment?'),
        content: const Text('Are you sure you want to cancel? Your purchase will be pending until payment is completed.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Continue')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              widget.onComplete();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
