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
//   "type": "idle" | "cart" | "receipt",
//   "logo_url": "https://...",
//   "store_name": "Store Name",
//   "welcome": "Welcome",
//   "currency": "OMR",
//   "items": [{"name": "...", "quantity": 1, "unit_price": 0.0, "line_total": 0.0}],
//   "subtotal": 0.0,
//   "discount": 0.0,
//   "tax": 0.0,
//   "total": 0.0,
//   "change": 0.0
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_presentation_display/flutter_presentation_display.dart';

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
      title: 'Customer Display',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFD8209)),
        useMaterial3: true,
      ),
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
    return Container(
      color: Colors.white,
      child: type == 'cart'
          ? _PreviewCartBody(payload: payload)
          : type == 'receipt'
          ? _PreviewReceiptBody(payload: payload)
          : _PreviewIdleBody(payload: payload),
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
              ? const Center(
                  child: Text('Cart is empty', style: TextStyle(fontSize: 20, color: Colors.black38)),
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
    final total = _num(payload['total']);
    final change = _num(payload['change']);
    final currency = _displayCurrency(payload['currency']);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 160, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Payment Successful', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
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
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: _buildView(_payload)),
      ),
    );
  }

  Widget _buildView(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? 'idle';
    switch (type) {
      case 'cart':
        return _CartView(key: const ValueKey('cart'), data: data);
      case 'receipt':
        return _ReceiptView(key: const ValueKey('receipt'), data: data);
      case 'idle':
      default:
        return _IdleView(key: const ValueKey('idle'), data: data);
    }
  }
}

// ─── Idle view (store logo centred) ───────────────────────────────────

class _IdleView extends StatelessWidget {
  const _IdleView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final logoUrl = data['logo_url']?.toString();
    final storeName = data['store_name']?.toString();
    final welcome = data['welcome']?.toString();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
            child: (logoUrl != null && logoUrl.isNotEmpty)
                ? Image.network(logoUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => _wameedFallbackLogo())
                : _wameedFallbackLogo(),
          ),
          if (storeName != null && storeName.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              storeName,
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
          if (welcome != null && welcome.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              welcome,
              style: const TextStyle(fontSize: 26, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Cart view (live items + totals) ───────────────────────────────────

class _CartView extends StatelessWidget {
  const _CartView({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
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
                ? const Center(
                    child: Text('Your cart is empty', style: TextStyle(fontSize: 24, color: Colors.black38)),
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
