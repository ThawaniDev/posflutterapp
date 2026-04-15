import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/pos_error_state.dart';
import 'package:wameedpos/features/pos_customization/pages/iframe_helper_stub.dart'
    if (dart.library.js_interop) 'package:wameedpos/features/pos_customization/pages/iframe_helper_web.dart';
import 'package:wameedpos/features/pos_customization/repositories/customization_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Fetches a signed preview URL then displays it in a WebView (native)
/// or an iframe (web).
class TemplatePreviewPage extends ConsumerStatefulWidget {
  final String templateType;
  final String templateId;
  final String templateName;

  const TemplatePreviewPage({super.key, required this.templateType, required this.templateId, required this.templateName});

  @override
  ConsumerState<TemplatePreviewPage> createState() => _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends ConsumerState<TemplatePreviewPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  int _loadProgress = 0;
  String? _previewUrl;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              if (mounted) setState(() => _loadProgress = progress);
            },
            onPageFinished: (_) {
              if (mounted) setState(() => _isLoading = false);
            },
            onWebResourceError: (error) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = error.description;
                });
              }
            },
          ),
        );
    }
    _fetchAndLoad();
  }

  Future<void> _fetchAndLoad() async {
    try {
      final repo = ref.read(customizationRepositoryProvider);
      final String url;
      switch (widget.templateType) {
        case 'receipt':
          url = await repo.getReceiptTemplatePreviewUrl(widget.templateId);
        case 'cfd':
          url = await repo.getCfdThemePreviewUrl(widget.templateId);
        case 'label':
          url = await repo.getLabelTemplatePreviewUrl(widget.templateId);
        case 'marketplace':
          url = await repo.getMarketplaceListingPreviewUrl(widget.templateId);
        default:
          throw ArgumentError('Unknown template type: ${widget.templateType}');
      }
      if (kIsWeb) {
        if (mounted)
          setState(() {
            _previewUrl = url;
            _isLoading = false;
          });
      } else {
        _controller!.loadRequest(Uri.parse(url));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.templatePreviewTitle}: ${widget.templateName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.templatePreviewRefresh,
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
                _loadProgress = 0;
                _previewUrl = null;
              });
              _fetchAndLoad();
            },
          ),
        ],
      ),
      body: _errorMessage != null
          ? PosErrorState(
              message: _errorMessage!,
              onRetry: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                  _loadProgress = 0;
                  _previewUrl = null;
                });
                _fetchAndLoad();
              },
            )
          : Stack(
              children: [
                if (kIsWeb)
                  _previewUrl != null ? buildIframePreview(_previewUrl!) : const SizedBox.shrink()
                else
                  WebViewWidget(controller: _controller!),
                if (_isLoading)
                  LinearProgressIndicator(
                    value: _loadProgress > 0 ? _loadProgress / 100.0 : null,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
              ],
            ),
    );
  }
}
