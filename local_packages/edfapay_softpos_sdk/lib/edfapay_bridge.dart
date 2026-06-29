// ignore_for_file: avoid_print
import 'package:flutter/services.dart';
import 'models/terminal_binding_task.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Callback typedefs — mirror native Kotlin typealiases exactly
// ─────────────────────────────────────────────────────────────────────────────

typedef ProcessCompleteCallback = void Function(
  bool status,
  String? code,
  Map<String, dynamic>? transaction,
  bool isFlowComplete,
);
typedef onProcessComplete = void Function(
  bool status,
  String? code,
  Map<String, dynamic>? transaction,
  bool isFlowComplete,
);
typedef TimeOutCallBack = void Function();
typedef CancelByUserCallBack = void Function();
typedef OnErrorCallBack = void Function(Map<String, dynamic> error);
typedef OnSuccessCallback = void Function(Map<String, dynamic> result);
typedef OnTerminalBindingTask = void Function(TerminalBindingTask task);
typedef Completion = void Function(Map<String, dynamic>? error, Map<String, dynamic>? result);

// ─────────────────────────────────────────────────────────────────────────────
// EdfaPayBridge  (INTERNAL — do not use directly, use EdfaPayPlugin)
//
//  Invoke channel  : com.edfapay.invoke   Flutter → Native
//  Callback channel: com.edfapay.callback Native  → Flutter
// ─────────────────────────────────────────────────────────────────────────────

class EdfaPayBridge {
  EdfaPayBridge._() {
    _callbackChannel.setMethodCallHandler(_onCallback);
  }
  static final EdfaPayBridge instance = EdfaPayBridge._();

  static const _invokeChannel = MethodChannel('com.edfapay.invoke');
  static const _callbackChannel = MethodChannel('com.edfapay.callback');

  // ── Registered callbacks ──────────────────────────────────────────────────

  Map<String, Map<String, Function>> _callbacks = {};

  // ── Flutter → Native ──────────────────────────────────────────────────────

  Future<dynamic> invoke(
    String method, {
    dynamic params,
    Map<String, Function>? callbacks,
  }) {
    if (callbacks != null) {
      _callbacks[method] = callbacks;
    }
    return _invokeChannel.invokeMethod(method, params);
  }

  // ── Native → Flutter ──────────────────────────────────────────────────────

  Future<void> _onCallback(MethodCall call) async {
    final method = call.method;
    final reqName = method.split(".").first;
    final cbName = method.split(".").last;
    final cb = _callbacks[reqName]?[cbName];

    if (cb == null) {
      print('[EdfaPayBridge] No callback registered for: $cbName');
      return;
    }

    final args = call.arguments;
    List<dynamic> positionalArgs = [];

    if (args is List) {
      positionalArgs = args;
    } else if (args != null) {
      positionalArgs = [args];
    }

    // Special handling for terminal binding task
    if (cbName == 'onTerminalBindingTask' && positionalArgs.isNotEmpty) {
      final terminalMaps = (positionalArgs[0] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      final task = TerminalBindingTask.fromList(terminalMaps);
      Function.apply(cb, [task]);
      print('[EdfaPayBridge] Triggered onTerminalBindingTask with ${task.terminals.length} terminals');
      return;
    }

    // Default handling for other callbacks
    List params = positionalArgs.map((i) {
      if (i is Map) {
        return Map<String, dynamic>.from(i);
      }
      return i;
    }).toList(growable: false);

    Function.apply(cb, params);
    print("[EdfaPayBridge] Triggered with ${params.length} Parms: ~> $cb ");
  }
}
