// Controls the physical secondary display (Landi C20 PRO customer screen).
//
// Wraps `flutter_presentation_display` (maintained fork of
// `presentation_displays`, with proper AGP 8 / Java 11 support):
//   1. Discovers connected displays.
//   2. Activates the first non-primary display, routing it to the
//      `secondaryDisplayMain` Flutter entry point (registered in main.dart).
//   3. Pushes JSON payloads via `transferDataToPresentation(...)` so the
//      secondary engine can render idle / cart / receipt views.
//
// Usage from any Riverpod consumer:
//   final ctl = ref.read(secondaryDisplayControllerProvider);
//   ctl.pushIdle(logoUrl: ..., storeName: ...);
//   ctl.pushCart(items: ..., subtotal: ..., total: ...);

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_presentation_display/display.dart';
import 'package:flutter_presentation_display/flutter_presentation_display.dart';

class SecondaryDisplayController {
  SecondaryDisplayController();

  final FlutterPresentationDisplay _manager = FlutterPresentationDisplay();
  StreamSubscription<dynamic>? _hotplugSub;
  Display? _activeSecondary;
  bool _initStarted = false;
  Map<String, dynamic>? _lastPayload;
  Map<String, dynamic>? _lastIdlePayload;

  bool get hasSecondaryDisplay => _activeSecondary != null;

  /// Last payload pushed (cart/receipt/idle). Used by the debug preview
  /// overlay so the preview reflects exactly what the second screen shows.
  Map<String, dynamic>? get lastPayload => _lastPayload ?? _lastIdlePayload;

  /// Idempotent: discovers + activates the secondary display once, and
  /// re-activates on hotplug events. Safe to call from app startup.
  Future<void> init() async {
    if (_initStarted) return;
    _initStarted = true;

    await _activateSecondary();

    _hotplugSub = _manager.connectedDisplaysChangedStream.listen((_) async {
      await _activateSecondary();
      // Re-send last known payload so the new display isn't blank.
      final last = _lastPayload ?? _lastIdlePayload;
      if (last != null) {
        await _send(last);
      }
    });
  }

  Future<void> dispose() async {
    await _hotplugSub?.cancel();
    _hotplugSub = null;
    if (_activeSecondary != null) {
      try {
        await _manager.hideSecondaryDisplay(displayId: _activeSecondary!.displayId ?? -1);
      } catch (_) {}
    }
    _activeSecondary = null;
    _initStarted = false;
  }

  Future<void> _activateSecondary() async {
    try {
      // Filter by PRESENTATION category so we only get displays Android
      // considers safe to host a `Presentation` (true external/HDMI/built-in
      // secondary screens like the Landi C20 PRO customer display).
      // Without this filter, single-screen test devices may return a phantom
      // display that throws `InvalidDisplayException` on show().
      final displays = await _manager.getDisplays(category: DISPLAY_CATEGORY_PRESENTATION) ?? const <Display?>[];

      Display? chosen;
      for (final d in displays) {
        if (d?.displayId != null) {
          chosen = d;
          break;
        }
      }
      if (chosen == null) {
        _activeSecondary = null;
        return;
      }
      final id = chosen.displayId!;
      final ok = await _manager.showSecondaryDisplay(displayId: id, routerName: 'presentation');
      if (ok == true) {
        _activeSecondary = chosen;
      }
    } catch (e, st) {
      // Common on single-screen devices: SHOW_ERROR / InvalidDisplayException.
      // Treat as "no secondary display available" — debug preview still works.
      debugPrint('[SecondaryDisplay] activate failed (no secondary display?): $e\n$st');
      _activeSecondary = null;
    }
  }

  // ─── Public push API ────────────────────────────────────────────

  Future<void> pushIdle({String? logoUrl, String? storeName, String? welcome}) async {
    final payload = <String, dynamic>{
      'type': 'idle',
      if (logoUrl != null) 'logo_url': logoUrl,
      if (storeName != null) 'store_name': storeName,
      if (welcome != null) 'welcome': welcome,
    };
    _lastIdlePayload = payload;
    await _send(payload);
  }

  Future<void> pushCart({
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    String currency = '',
    String? logoUrl,
    String? storeName,
  }) async {
    final payload = <String, dynamic>{
      'type': 'cart',
      'items': items,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'currency': currency,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (storeName != null) 'store_name': storeName,
    };
    await _send(payload);
  }

  Future<void> pushReceipt({required double total, required double change, String currency = ''}) async {
    final payload = <String, dynamic>{'type': 'receipt', 'total': total, 'change': change, 'currency': currency};
    await _send(payload);
  }

  /// Show a customer-facing "tap your card" prompt while the cashier waits
  /// for the SoftPOS / NFC reader to capture the payment.
  Future<void> pushAwaitingPayment({
    required double total,
    String currency = '',
    String? message,
    String? subtitle,
    String? logoUrl,
    String? storeName,
  }) async {
    final payload = <String, dynamic>{
      'type': 'awaiting_payment',
      'total': total,
      'currency': currency,
      if (message != null) 'message': message,
      if (subtitle != null) 'subtitle': subtitle,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (storeName != null) 'store_name': storeName,
    };
    await _send(payload);
  }

  /// Show the Lottie success animation with the paid amount.
  Future<void> pushPaymentSuccess({required double total, String currency = ''}) async {
    await _send(<String, dynamic>{'type': 'payment_success', 'total': total, 'currency': currency});
  }

  /// Show the Lottie failure animation with an Arabic reason message.
  Future<void> pushPaymentFailure({String message = ''}) async {
    await _send(<String, dynamic>{'type': 'payment_failure', 'message': message});
  }

  Future<void> _send(Map<String, dynamic> payload) async {
    // Always remember the latest payload so the in-app preview can render it
    // even when no physical secondary display is attached.
    _lastPayload = payload;
    if (_activeSecondary == null) {
      // Lazy retry — maybe the display became available since startup.
      await _activateSecondary();
      if (_activeSecondary == null) return;
    }
    try {
      await _manager.transferDataToPresentation(jsonEncode(payload));
    } catch (e) {
      debugPrint('[SecondaryDisplay] transfer failed: $e');
    }
  }
}
