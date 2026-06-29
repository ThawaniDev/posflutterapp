// Customer-facing secondary display (Landi C20 PRO second screen).
//
// Runs in a SEPARATE Flutter engine spawned by the
// `flutter_presentation_display` plugin via the `secondaryDisplayMain`
// `@pragma('vm:entry-point')` defined in `lib/main.dart`. The main engine
// pushes JSON payloads through `transferDataToPresentation(...)` and this
// widget listens via `listenDataFromMainDisplay(...)` to render either an
// idle (logo) view or a live cart view.
//
// Payload shape (JSON):
// {
//   "type": "idle" | "cart" | "receipt" | "awaiting_payment",
//   "logo_url": "https://...",
//   "store_name": "Store Name",
//   "welcome": "Welcome",
//   "currency": "OMR",
//   "items": [{"name": "...", "quantity": 1, "unit_price": 0.0, "line_total": 0.0}],
//   "subtotal": 0.0,
//   "discount": 0.0,
//   "tax": 0.0,
//   "total": 0.0,
//   "change": 0.0,
//   "message": "Tap your card to pay",
//   "subtitle": "Waiting for payment"
// }

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_presentation_display/flutter_presentation_display.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

Route<dynamic> secondaryDisplayRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'presentation':
    default:
      return MaterialPageRoute(builder: (_) => const _SecondaryDisplayScreen());
  }
}

class SecondaryDisplayApp extends StatelessWidget {
  const SecondaryDisplayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title is only shown in the system app-switcher on the device;
      // using a hardcoded string avoids calling AppLocalizations.of(context)!
      // on the root BuildContext (above any Localizations ancestor), which
      // would throw a null-check error and crash the secondary-display engine.
      title: 'Customer Display',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFD8209)),
        fontFamily: AppTypography.fontFamily,
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: secondaryDisplayRoute,
      initialRoute: 'presentation',
    );
  }
}

/// Preview the secondary-display content from a payload Map.
/// Used by the in-app debug preview overlay (no second screen required).
///
/// Fully self-contained — does not delegate to the private _CartView /
/// _IdleView / _ReceiptView classes so it is safe to embed inside any
/// dialog or overlay that provides its own bounded size.
class SecondaryDisplayPreview extends StatelessWidget {
  const SecondaryDisplayPreview({required this.payload, super.key});
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final type = payload['type']?.toString() ?? 'idle';
    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: AppTypography.fontFamily),
      child: Container(
        color: Colors.white,
        child: type == 'cart'
            ? _PreviewCartBody(payload: payload)
            : type == 'receipt'
            ? _PreviewReceiptBody(payload: payload)
            : type == 'awaiting_payment'
            ? _AwaitingPaymentView(data: payload)
            : type == 'payment_success'
            ? _PaymentSuccessView(data: payload)
            : type == 'payment_failure'
            ? _PaymentFailureView(data: payload)
            : _PreviewIdleBody(payload: payload),
      ),
    );
  }
}

// ─── Inline preview bodies ────────────────────────────────────────────

class _PreviewIdleBody extends StatelessWidget {
  const _PreviewIdleBody({required this.payload});
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final logoUrl = payload['logo_url']?.toString();
    final storeName = payload['store_name']?.toString();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: (logoUrl != null && logoUrl.isNotEmpty)
                  ? Image.network(logoUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => _wameedFallbackLogo())
                  : _wameedFallbackLogo(),
            ),
            if (storeName != null && storeName.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                storeName,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PreviewCartBody extends StatelessWidget {
  const _PreviewCartBody({required this.payload});
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final logoUrl = payload['logo_url']?.toString();
    final storeName = payload['store_name']?.toString();
    final items = (payload['items'] as List?) ?? const [];
    final currency = _displayCurrency(payload['currency']);
    final subtotal = _num(payload['subtotal']);
    final discount = _num(payload['discount']);
    final tax = _num(payload['tax']);
    final total = _num(payload['total']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: (logoUrl != null && logoUrl.isNotEmpty)
                    ? Image.network(logoUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => _wameedFallbackLogo())
                    : _wameedFallbackLogo(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  storeName ?? '',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.shopping_cart_rounded, size: 28, color: Color(0xFFFD8209)),
            ],
          ),
        ),
        const Divider(thickness: 1.5),
        // ── Items ──
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Text(l10n.cartIsEmpty, style: TextStyle(fontSize: 20, color: Colors.black38)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final itemMap = item is Map<String, dynamic> ? item : (item as Map).cast<String, dynamic>();
                    final name = itemMap['name']?.toString() ?? '';
                    final qty = _num(itemMap['quantity']);
                    final unit = _num(itemMap['unit_price']);
                    final line = _num(itemMap['line_total']);
                    final qtyLabel = qty == qty.truncateToDouble() ? qty.toStringAsFixed(0) : qty.toStringAsFixed(3);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Text('$qtyLabel ×', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 18)),
                                Text(
                                  '${unit.toStringAsFixed(3)} $currency',
                                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                          Text(line.toStringAsFixed(3), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    );
                  },
                ),
        ),
        // ── Totals ──
        const Divider(thickness: 2),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            children: [
              _pRow('Subtotal', subtotal, currency),
              if (discount > 0) _pRow('Discount', -discount, currency, color: Colors.green.shade700),
              if (tax > 0) _pRow('Tax', tax, currency),
              const SizedBox(height: 4),
              _pRow('Total', total, currency, fontSize: 26, bold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pRow(String label, double value, String currency, {Color? color, double fontSize = 18, bool bold = false}) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      color: color ?? Colors.black87,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text('${value.toStringAsFixed(3)} $currency', style: style),
        ],
      ),
    );
  }
}

class _PreviewReceiptBody extends StatelessWidget {
  const _PreviewReceiptBody({required this.payload});
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = _num(payload['total']);
    final change = _num(payload['change']);
    final currency = _displayCurrency(payload['currency']);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 160, color: Colors.green),
          const SizedBox(height: 16),
          Text(l10n.paymentSuccessful, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Text('Total: ${total.toStringAsFixed(3)} $currency', style: const TextStyle(fontSize: 24)),
          if (change > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Change: ${change.toStringAsFixed(3)} $currency',
              style: const TextStyle(fontSize: 20, color: Color(0xFFFD8209), fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

class _SecondaryDisplayScreen extends StatefulWidget {
  const _SecondaryDisplayScreen();

  @override
  State<_SecondaryDisplayScreen> createState() => _SecondaryDisplayScreenState();
}

class _SecondaryDisplayScreenState extends State<_SecondaryDisplayScreen> {
  final FlutterPresentationDisplay _display = FlutterPresentationDisplay();
  Map<String, dynamic> _payload = const {'type': 'idle'};

  @override
  void initState() {
    super.initState();
    _display.listenDataFromMainDisplay(_onPayload);
  }

  void _onPayload(dynamic raw) {
    try {
      if (raw == null) return;
      final str = raw is String ? raw : raw.toString();
      final decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic>) {
        setState(() => _payload = decoded);
      }
    } catch (_) {
      // ignore malformed payloads — keep current view
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: AppTypography.fontFamily),
      child: Scaffold(
        body: SafeArea(
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: _buildView(_payload)),
        ),
      ),
    );
  }

  Widget _buildView(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? 'idle';
    switch (type) {
      case 'cart':
        // Show the video idle screen when the cart is empty — no point
        // displaying an empty-cart message to the customer.
        final items = data['items'] as List?;
        if (items == null || items.isEmpty) {
          return _IdleView(key: const ValueKey('idle'), data: data);
        }
        return _CartView(key: const ValueKey('cart'), data: data);
      case 'receipt':
        return _ReceiptView(key: const ValueKey('receipt'), data: data);
      case 'awaiting_payment':
        return _AwaitingPaymentView(key: const ValueKey('awaiting'), data: data);
      case 'payment_success':
        return _PaymentSuccessView(key: const ValueKey('payment_success'), data: data);
      case 'payment_failure':
        return _PaymentFailureView(key: const ValueKey('payment_failure'), data: data);
      case 'idle':
      default:
        return _IdleView(key: const ValueKey('idle'), data: data);
    }
  }
}

// ─── Idle view (looping promo video + optional store overlay) ─────────

class _IdleView extends StatefulWidget {
  const _IdleView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<_IdleView> createState() => _IdleViewState();
}

class _IdleViewState extends State<_IdleView> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/secondary_screen_preview_video.mp4')
      ..setLooping(true)
      ..setVolume(0) // silent on customer display
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeName = widget.data['store_name']?.toString();
    final welcome = widget.data['welcome']?.toString();

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Looping background video ──────────────────────────────
        if (_initialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        else
          // Fallback while video loads: black background
          Container(color: Colors.black),

        // ── Store name / welcome overlay at the bottom ────────────
        if ((storeName != null && storeName.isNotEmpty) || (welcome != null && welcome.isNotEmpty))
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.72)],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (storeName != null && storeName.isNotEmpty)
                    Text(
                      storeName,
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  if (welcome != null && welcome.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      welcome,
                      style: const TextStyle(fontSize: 26, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Cart view (live items + totals) ───────────────────────────────────

class _CartView extends StatelessWidget {
  const _CartView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final logoUrl = data['logo_url']?.toString();
    final storeName = data['store_name']?.toString();
    final items = (data['items'] as List?) ?? const [];
    final currency = _displayCurrency(data['currency']);
    final subtotal = _num(data['subtotal']);
    final discount = _num(data['discount']);
    final tax = _num(data['tax']);
    final total = _num(data['total']);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header: logo + store name
          Row(
            children: [
              SizedBox(
                height: 56,
                width: 56,
                child: (logoUrl != null && logoUrl.isNotEmpty)
                    ? Image.network(logoUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => _wameedFallbackLogo())
                    : _wameedFallbackLogo(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  storeName ?? '',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.shopping_cart_rounded, size: 32, color: Color(0xFFFD8209)),
            ],
          ),
          const Divider(thickness: 1.5, height: 24),
          // Items list
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      l10n?.yourCartIsEmpty ?? 'Your cart is empty',
                      style: const TextStyle(fontSize: 24, color: Colors.black38),
                    ),
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (_, i) {
                      final item = items[i] as Map<String, dynamic>;
                      final name = item['name']?.toString() ?? '';
                      final qty = _num(item['quantity']);
                      final unit = _num(item['unit_price']);
                      final line = _num(item['line_total']);
                      final qtyLabel = qty == qty.truncateToDouble() ? qty.toStringAsFixed(0) : qty.toStringAsFixed(3);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                '$qtyLabel ×',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: const TextStyle(fontSize: 22, color: Colors.black87)),
                                  Text(
                                    '${unit.toStringAsFixed(3)} $currency',
                                    style: const TextStyle(fontSize: 16, color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              line.toStringAsFixed(3),
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(thickness: 2),
          _totalRow('Subtotal', subtotal, currency),
          if (discount > 0) _totalRow('Discount', -discount, currency, color: Colors.green.shade700),
          if (tax > 0) _totalRow('Tax', tax, currency),
          const SizedBox(height: 8),
          _totalRow('Total', total, currency, big: true, bold: true),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double value, String currency, {Color? color, bool big = false, bool bold = false}) {
    final size = big ? 32.0 : 22.0;
    final style = TextStyle(fontSize: size, color: color ?? Colors.black87, fontWeight: bold ? FontWeight.w800 : FontWeight.w500);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text('${value.toStringAsFixed(3)} $currency', style: style),
        ],
      ),
    );
  }
}

// ─── Receipt view (after payment, brief confirmation) ───────────────────

class _ReceiptView extends StatelessWidget {
  const _ReceiptView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final total = _num(data['total']);
    final change = _num(data['change']);
    final currency = _displayCurrency(data['currency']);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded, size: 220, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'Payment Successful',
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          Text('Total: ${total.toStringAsFixed(3)} $currency', style: const TextStyle(fontSize: 28, color: Colors.black87)),
          if (change > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Change: ${change.toStringAsFixed(3)} $currency',
              style: const TextStyle(fontSize: 24, color: Color(0xFFFD8209), fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

double _num(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

String _displayCurrency(dynamic currency) {
  final value = currency?.toString().trim() ?? '';
  return value.isEmpty ? '\u0081' : value;
}

/// Wameed brand logo, used as a fallback when no store logo is available
/// (or when the store's `logo_url` fails to load).
Widget _wameedFallbackLogo() {
  return Image.asset(
    'assets/images/wameedlogo.png',
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => const Icon(Icons.store_rounded, size: 240, color: Color(0xFFFD8209)),
  );
}

// ─── Awaiting payment (NFC tap-to-pay prompt) ─────────────────────────
//
// Shown while the cashier-side is waiting for the customer to tap their
// card/phone on the device's NFC reader (top-right of the Landi C20 PRO).
// Pulsing concentric rings anchored near the top-right reader badge act as the
// "tap zone" indicator, while diagonal chevron arrows animate from the
// centre toward that inset target so the customer can see exactly where to tap.

const double _nfcReaderEdgeInset = 50;
const double _nfcReaderIconDiameter = 84;
const double _nfcReaderCenterInset = _nfcReaderEdgeInset + _nfcReaderIconDiameter / 2;
const double _nfcPulseDiameter = 520;

class _AwaitingPaymentView extends StatefulWidget {
  const _AwaitingPaymentView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<_AwaitingPaymentView> createState() => _AwaitingPaymentViewState();
}

class _AwaitingPaymentViewState extends State<_AwaitingPaymentView> with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _arrowCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
    _arrowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _arrowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _num(widget.data['total']);
    final currency = _displayCurrency(widget.data['currency']);
    final message = (widget.data['message']?.toString().trim().isNotEmpty ?? false)
        ? widget.data['message'].toString()
        : 'Tap your card here';
    final subtitle = (widget.data['subtitle']?.toString().trim().isNotEmpty ?? false)
        ? widget.data['subtitle'].toString()
        : 'Waiting for payment';

    return Container(
      color: const Color(0xFFFFF6EC),
      child: Stack(
        children: [
          // Pulsing rings anchored at the physical NFC reader badge, inset
          // from the top-right corner on the Landi C20 PRO.
          Positioned(
            top: _nfcReaderCenterInset - _nfcPulseDiameter / 2,
            right: _nfcReaderCenterInset - _nfcPulseDiameter / 2,
            width: _nfcPulseDiameter,
            height: _nfcPulseDiameter,
            child: AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => CustomPaint(painter: _NfcPulsePainter(progress: _pulseCtrl.value)),
            ),
          ),

          // Diagonal chevron arrows flowing from the centre toward the
          // inset top-right NFC reader.
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _arrowCtrl,
              builder: (_, __) => CustomPaint(painter: _ArrowToCornerPainter(progress: _arrowCtrl.value)),
            ),
          ),

          // "Tap here" callout aligned with the inset NFC reader badge.
          Positioned(
            top: _nfcReaderEdgeInset,
            right: _nfcReaderEdgeInset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.92,
                    end: 1.08,
                  ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut)),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(color: Color(0xFFFD8209), shape: BoxShape.circle),
                    child: const Icon(Icons.contactless_rounded, size: 56, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFFD8209)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ضع بطاقتك في هذا المكان',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF994E00)),
                ),
              ],
            ),
          ),

          // Centre content: amount + instruction + animated card.
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${total.toStringAsFixed(3)} $currency',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2933),
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (_, child) {
                      final t = _pulseCtrl.value;
                      // Gentle bobbing toward the corner.
                      final dx = math.sin(t * 2 * math.pi) * 6;
                      final dy = -math.sin(t * 2 * math.pi).abs() * 8;
                      return Transform.translate(offset: Offset(dx, dy), child: child);
                    },
                    child: Container(
                      width: 180,
                      height: 116,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFD8209), Color(0xFFFFB561)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFD8209).withValues(alpha: 0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.contactless_rounded, color: Colors.white, size: 32),
                            Text(
                              '•••• •••• •••• 1234',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NfcPulsePainter extends CustomPainter {
  _NfcPulsePainter({required this.progress});
  final double progress; // 0..1

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const ringCount = 4;
    for (int i = 0; i < ringCount; i++) {
      final t = ((progress + i / ringCount) % 1.0);
      final radius = size.width * (0.35 + 0.55 * t);
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = const Color(0xFFFD8209).withValues(alpha: opacity * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NfcPulsePainter old) => old.progress != progress;
}

class _ArrowToCornerPainter extends CustomPainter {
  _ArrowToCornerPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(size.width * 0.45, size.height * 0.55);
    final end = Offset(size.width - _nfcReaderCenterInset, _nfcReaderCenterInset);
    final dir = end - start;
    final length = dir.distance;
    if (length == 0) return;
    final unit = dir / length;
    final perp = Offset(-unit.dy, unit.dx);
    const chevronLen = 26.0;
    const chevronCount = 4;

    for (int i = 0; i < chevronCount; i++) {
      final t = ((progress + i / chevronCount) % 1.0);
      final pos = Offset.lerp(start, end, t)!;
      // Fade in/out around the middle of the trajectory.
      final fade = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = const Color(0xFFFD8209).withValues(alpha: fade * 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final tip = pos;
      final tail1 = tip - unit * chevronLen + perp * chevronLen * 0.65;
      final tail2 = tip - unit * chevronLen - perp * chevronLen * 0.65;
      final path = Path()
        ..moveTo(tail1.dx, tail1.dy)
        ..lineTo(tip.dx, tip.dy)
        ..lineTo(tail2.dx, tail2.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArrowToCornerPainter old) => old.progress != progress;
}

// ─── Payment success (Lottie + Arabic) ────────────────────────────────

class _PaymentSuccessView extends StatelessWidget {
  const _PaymentSuccessView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final total = _num(data['total']);
    final currency = _displayCurrency(data['currency']);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/success_lottie.json',
                width: 220,
                height: 220,
                repeat: false,
              ),
              const SizedBox(height: 16),
              const Text(
                'تمت عملية الدفع بنجاح',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF1A7F37)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'المبلغ المدفوع: ${total.toStringAsFixed(3)} $currency',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF1F2933)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Payment failure (Lottie + Arabic) ────────────────────────────────

class _PaymentFailureView extends StatelessWidget {
  const _PaymentFailureView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final message = data['message']?.toString().trim() ?? '';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/failure_lottie.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 16),
              const Text(
                'فشلت عملية الدفع',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFFD32F2F)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message.isNotEmpty ? message : 'يرجى المحاولة مرة أخرى أو التواصل مع الكاشير',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF555555)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
