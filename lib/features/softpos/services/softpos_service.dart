import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:edfapay_softpos_sdk/edfapay_softpos_sdk.dart';
import 'package:edfapay_softpos_sdk/enums/env.dart';
import 'package:edfapay_softpos_sdk/enums/flow_type.dart';
import 'package:edfapay_softpos_sdk/enums/presentation.dart';
import 'package:edfapay_softpos_sdk/enums/purchase_secondary_action.dart';
import 'package:edfapay_softpos_sdk/helpers.dart';
import 'package:edfapay_softpos_sdk/models/edfapay_credentials.dart';
import 'package:edfapay_softpos_sdk/models/transaction.dart' as edfapay;
import 'package:edfapay_softpos_sdk/models/txn_params.dart';

/// Result returned after a SoftPOS payment attempt.
class SoftPosPaymentResult {
  const SoftPosPaymentResult({
    required this.success,
    this.approvalCode,
    this.rrn,
    this.transactionId,
    this.cardScheme,
    this.maskedCard,
    this.cardHolderName,
    this.cardExpiry,
    this.stan,
    this.acquirerBank,
    this.applicationId,
    this.amount,
    this.errorMessage,
    this.sdkRawResponse,
    this.rawResult,
  });

  factory SoftPosPaymentResult.failure(String message) => SoftPosPaymentResult(success: false, errorMessage: message);

  final bool success;
  final String? approvalCode;
  final String? rrn;
  final String? transactionId; // EdfaPay transaction_number UUID
  final String? cardScheme; // normalised: mada, visa, mastercard, amex
  final String? maskedCard; // e.g. "5069 68** **** 0286"
  final String? cardHolderName;
  final String? cardExpiry; // YYMM from SDK e.g. "2902"
  final String? stan; // System Trace Audit Number
  final String? acquirerBank; // e.g. "RAJB"
  final String? applicationId; // EMV AID e.g. "A0000002281010"
  final String? amount;
  final String? errorMessage;
  final Map<String, dynamic>? sdkRawResponse; // full transaction object from EdfaPay
  final Map<String, dynamic>? rawResult; // full SDK payload (for debugging)
}

/// Wraps the EdfaPay SoftPOS SDK for integration with Wameed POS.
///
/// Platform: **Android only**. On other platforms all methods return a
/// graceful failure without throwing.
class SoftPosService {
  bool _isInitiated = false;

  bool get isInitiated => _isInitiated;
  bool get isAvailable => Platform.isAndroid;

  // ─── Initialization ──────────────────────────────────────────────────────

  /// Initialises the SDK with an EdfaPay terminal token.
  ///
  /// [token]       — Terminal token generated from the EdfaPay SoftPOS portal.
  /// [environment] — `'production'` or `'development'`.
  /// [logoPath]    — Optional asset path for the branded logo (e.g. 'assets/images/wameedlogo.png').
  Future<void> initialize({
    required String token,
    required String environment,
    String? logoPath,
    void Function(String error)? onError,
    void Function(String sessionId)? onSuccess,
  }) async {
    if (!isAvailable) {
      onError?.call('SoftPOS is only available on Android.');
      return;
    }

    final env = environment == 'production' ? Env.PRODUCTION : Env.DEVELOPMENT;

    final credentials = EdfaPayCredentials.withToken(environment: env, token: token);

    // Apply Wameed theme
    await _applyTheme(logoPath: logoPath);

    EdfaPayPlugin.enableLogs(kDebugMode); // verbose only in debug builds

    // EdfaPayPlugin.initiate() is fire-and-forget — onSuccess/onError fire
    // asynchronously via the platform channel.  Use a Completer so that
    // `await initialize()` does not return until the SDK has actually
    // succeeded or failed; without this the caller reads SoftPosInitialising
    // and bails out immediately.
    final completer = Completer<void>();
    bool timedOut = false;

    debugPrint('[SoftPOS] initiate() dispatched to native SDK');

    EdfaPayPlugin.initiate(
      credentials: credentials,
      onError: (e) {
        if (timedOut) return;
        _isInitiated = false;
        final msg = _extractError(e);
        debugPrint('[SoftPOS] initiate() onError: $msg');
        onError?.call(msg);
        if (!completer.isCompleted) completer.complete();
      },
      onTerminalBindingTask: (bindingTask) {
        debugPrint(
          '[SoftPOS] onTerminalBindingTask fired — ${bindingTask.terminals.length} terminals — showing native binding UI',
        );
        // Use the SDK's built-in terminal selection UI; completer is resolved
        // by onSuccess/onError after binding completes.
        bindingTask.bind();
      },
      onSuccess: (sessionId) {
        if (timedOut) return;
        _isInitiated = true;
        debugPrint('[SoftPOS] initiate() onSuccess: sessionId=$sessionId');
        onSuccess?.call(sessionId ?? '');
        if (!completer.isCompleted) completer.complete();
      },
    );

    // Safety timeout — if the SDK never fires a callback (e.g. crash in
    // the platform layer) don't hang the UI forever.
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () async {
        timedOut = true;
        if (_isInitiated) return;
        // Log whether the backend session exists (diagnostic only — we cannot
        // use getSessionId() as a success signal because the Alcineo EMV kernel
        // is only initialised when onSuccess fires via the native callback).
        try {
          final sessionId = await EdfaPayPlugin.getSessionId();
          debugPrint('[SoftPOS] initiate() timed out. Backend session: $sessionId');
        } catch (_) {}
        const msg = 'SoftPOS initialization timed out. Please try again.';
        onError?.call(msg);
      },
    );
  }

  // ─── Purchase ────────────────────────────────────────────────────────────

  /// Launches the EdfaPay tap-to-pay card scanning UI.
  ///
  /// [amount]  — The amount string, e.g. `"25.00"`.
  /// [orderId] — Unique order/transaction reference from the POS.
  Future<SoftPosPaymentResult> purchase({required String amount, required String orderId}) async {
    if (!isAvailable) {
      return SoftPosPaymentResult.failure('SoftPOS is only available on Android.');
    }
    if (!_isInitiated) {
      return SoftPosPaymentResult.failure('SoftPOS SDK is not initialised. Please configure your terminal token in Settings.');
    }

    final completer = Completer<SoftPosPaymentResult>();
    final params = TxnParams(amount: amount, orderId: orderId);

    EdfaPayPlugin.purchase(
      txnParams: params,
      flowType: FlowType.DETAIL,
      onPaymentProcessComplete: (success, code, result, isFlowCompleted) {
        if (!completer.isCompleted) {
          try {
            final paymentResult = _buildResult(success: success, code: code, raw: result);
            completer.complete(paymentResult);
          } catch (e) {
            completer.complete(SoftPosPaymentResult.failure('Unable to parse SoftPOS payment response: $e'));
          }
        }
      },
      onRequestTimerEnd: () {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure('Payment request timed out. Please try again.'));
        }
      },
      onCardScanTimerEnd: () {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure('Card scan timed out. Please tap your card and try again.'));
        }
      },
      onCancelByUser: () {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure('Payment was cancelled.'));
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure(_extractError(error)));
        }
      },
    );

    return completer.future;
  }

  // ─── Refund ──────────────────────────────────────────────────────────────

  /// Launches the EdfaPay tap-to-pay refund UI against an original transaction.
  ///
  /// [amount]  — The refund amount string, e.g. `"25.00"`.
  /// [orderId] — Unique reference for this refund operation.
  /// [rrn]     — Retrieval Reference Number from the original sale (required by
  ///             the network to locate the original authorisation).
  Future<SoftPosPaymentResult> refund({required String amount, required String orderId, String? rrn}) async {
    if (!isAvailable) {
      return SoftPosPaymentResult.failure('SoftPOS is only available on Android.');
    }
    if (!_isInitiated) {
      return SoftPosPaymentResult.failure('SoftPOS SDK is not initialised. Please configure your terminal token in Settings.');
    }

    final completer = Completer<SoftPosPaymentResult>();
    final params = TxnParams(amount: amount, orderId: orderId);
    if (rrn != null) {
      params.setOriginalTransaction(edfapay.Transaction.withRRN(rrn, null));
    }

    EdfaPayPlugin.refund(
      txnParams: params,
      flowType: FlowType.DETAIL,
      onPaymentProcessComplete: (success, code, result, isFlowCompleted) {
        if (!completer.isCompleted) {
          completer.complete(_buildResult(success: success, code: code, raw: result));
        }
      },
      onRequestTimerEnd: () {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure('Refund request timed out. Please try again.'));
        }
      },
      onCardScanTimerEnd: () {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure('Card scan timed out. Please tap your card and try again.'));
        }
      },
      onCancelByUser: () {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure('Refund was cancelled.'));
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.complete(SoftPosPaymentResult.failure(_extractError(error)));
        }
      },
    );

    return completer.future;
  }

  // ─── Theme ───────────────────────────────────────────────────────────────

  Future<void> _applyTheme({String? logoPath}) async {
    String? logo;
    if (logoPath != null) {
      try {
        logo = await assetsBase64(logoPath);
      } catch (_) {}
    }

    final presentation = Presentation.DIALOG_CENTER
        .sizePercent(0.90)
        .dismissOnBackPress(false)
        .dismissOnTouchOutside(false)
        .animateEntry(true)
        .animateExit(true)
        .dimBackground(true)
        .dimAmount(0.85)
        .cornerRadius(20)
        .marginHorizontal(16)
        .marginVertical(24)
        .setPurchaseSecondaryAction(PurchaseSecondaryAction.NONE);

    final theme = EdfaPayPlugin.theme()
        .setPrimaryColor('#FD8209') // Wameed primary orange
        .setSecondaryColor('#FFBF0D'); // Wameed secondary yellow

    if (logo != null) {
      // Note: setPoweredByImage is not permitted by EdfaPay for merchant apps —
      // only the header image can be customized.
      theme.setHeaderImage(logo);
    }

    theme.setPresentation(presentation);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  SoftPosPaymentResult _buildResult({required bool success, required String? code, required Map<String, dynamic>? raw}) {
    if (!success) {
      // Even when the SDK reports success=false, the card may already have been
      // charged (e.g. the EdfaPay session token can't be refreshed AFTER the
      // bank has approved the transaction).  Check the raw payload for hard
      // approval signals before treating the result as a failure.
      final txnCheck = _findTransactionObject(raw) ?? raw ?? <String, dynamic>{};
      final status = (_stringValue(txnCheck['status']) ?? '').toUpperCase();
      final rc = _stringValue(txnCheck['response_message_code']) ?? '';
      final ac = _stringValue(txnCheck['auth_code']) ?? '';
      if (status == 'APPROVED' || rc == '000' || ac.isNotEmpty) {
        // Payload shows bank approval, so fall through and extract card data.
      } else {
        // With FlowType.DETAIL the SDK fires onPaymentProcessComplete when the
        // user closes the result screen — code '9999' is EdfaPay's generic
        // "flow ended with failure" code.  The real acquirer response code lives
        // in `response_message_code` inside the raw payload.
        final effectiveCode = rc.isNotEmpty ? rc : (code ?? '');

        // Error 940/941/942 = terminal/TRSM system error.
        if (effectiveCode == '940' || effectiveCode == '941' || effectiveCode == '942') {
          return SoftPosPaymentResult.failure(
            'SoftPOS terminal error (code $effectiveCode). '
            'The terminal session has expired or needs re-binding. '
            'Go to Settings → Hardware Setup → SoftPOS, clear and re-save the token to re-initialise.',
          );
        }
        // 9999 = user closed the EdfaPay result screen after a decline.
        if (code == '9999') {
          final innerMsg = raw?['message'] as String?;
          return SoftPosPaymentResult.failure(
            innerMsg ?? 'Payment was unsuccessful. Please try again or use a different payment method.',
          );
        }
        final msg = raw?['message'] as String? ?? 'Payment declined (code: $code).';
        return SoftPosPaymentResult.failure(msg);
      }
    }

    // The EdfaPay SDK's `result` payload may arrive in one of several shapes
    // depending on FlowType / SDK version:
    //   1. {transaction: {...}}                       (flat, what we assumed)
    //   2. {data: {transaction: {...}, status, code}} (full envelope)
    //   3. {data: {data: {transaction: {...}}}}      (double-nested in some builds)
    // Walk every nested 'data'/'transaction' path until we find the txn object.
    final txn = _findTransactionObject(raw) ?? <String, dynamic>{};

    // Prefer the human-readable application_label from the nested request object
    // (e.g. "mada", "VISA", "MasterCard") over the raw EMV scheme code ("P1", "VI", "MC").
    // Fall back to deriving the scheme from the EMV AID (`application_id`),
    // mada-specific fields, or the card BIN.
    final request = _stringKeyedMap(txn['request']);
    final rawScheme = _stringValue(txn['scheme']) ?? '';
    final appLabel = _stringValue(request?['application_label']) ?? '';
    var cardScheme = _normaliseScheme(appLabel.isNotEmpty ? appLabel : rawScheme);
    if (cardScheme.isEmpty) {
      cardScheme = _deriveSchemeFromTxn(txn);
    }

    return SoftPosPaymentResult(
      success: true,
      approvalCode: _stringValue(txn['auth_code']),
      rrn: _stringValue(txn['rrn']),
      transactionId: _stringValue(txn['transaction_number']),
      cardScheme: cardScheme.isNotEmpty ? cardScheme : null,
      maskedCard: _stringValue(txn['credit_number']),
      cardHolderName: _stringValue(txn['cardholder_name']),
      cardExpiry: _stringValue(txn['card_expiration_date']),
      stan: _stringValue(txn['stan']),
      acquirerBank: _stringValue(txn['acquirer_bank']),
      applicationId: _stringValue(txn['application_id']),
      amount: _stringValue(txn['amount']),
      // Always send the raw payload to Laravel — even if `transaction` is empty,
      // we need the audit trail to debug SDK shape mismatches.
      sdkRawResponse: txn.isNotEmpty ? Map<String, dynamic>.from(txn) : (raw == null ? null : Map<String, dynamic>.from(raw)),
      rawResult: raw,
    );
  }

  /// Locates the transaction object inside the SDK payload.
  /// EdfaPay SoftPOS may deliver the payload in any of these shapes:
  ///   1. Flat — root contains `auth_code`, `credit_number`, etc. directly.
  ///   2. Wrapped — `{transaction: {...}}`
  ///   3. Enveloped — `{data: {transaction: {...}}}` or `{data: {data: {transaction: {...}}}}`
  Map<String, dynamic>? _findTransactionObject(Map<String, dynamic>? node, {int depth = 0}) {
    if (node == null || depth > 4) return null;

    // Case 1: the node itself looks like a transaction (has any of the canonical fields).
    const txnMarkers = [
      'auth_code',
      'credit_number',
      'transaction_number',
      'rrn',
      'stan',
      'cardholder_name',
      'card_expiration_date',
      'application_id',
    ];
    if (txnMarkers.any(node.containsKey)) {
      return _stringKeyedMap(node);
    }

    // Case 2: explicit `transaction` key.
    final direct = node['transaction'];
    if (direct is Map) {
      return _stringKeyedMap(direct);
    }

    // Case 3: walk into a nested `data` envelope.
    final inner = node['data'];
    if (inner is Map) {
      return _findTransactionObject(_stringKeyedMap(inner), depth: depth + 1);
    }
    return null;
  }

  Map<String, dynamic>? _stringKeyedMap(Object? value) {
    if (value is! Map) return null;
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  String? _stringValue(Object? value) => value == null ? null : value.toString();

  /// Normalises raw EdfaPay / EMV scheme codes to canonical lower-case names
  /// that match the Filament admin panel and `SoftPosFeeService`.
  String _normaliseScheme(String raw) {
    final v = raw.toLowerCase().trim();
    if (v == 'mada' || v == 'p1') return 'mada';
    if (v == 'visa' || v == 'vi') return 'visa';
    if (v == 'mastercard' || v == 'master card' || v == 'mc') return 'mastercard';
    if (v == 'amex' || v == 'ax' || v == 'ae' || v.contains('american express')) return 'amex';
    return v; // pass through anything else (e.g. 'stc_pay')
  }

  /// Derives the card scheme from EMV AID, mada markers, or card BIN when the
  /// SDK doesn't provide an explicit `scheme` / `application_label`.
  String _deriveSchemeFromTxn(Map<String, dynamic> txn) {
    // 1. Mada-specific markers — strongest signal.
    if (txn['mada_merchant_id'] != null || txn['mada_terminal_id'] != null) {
      return 'mada';
    }

    // 2. EMV Application Identifier (AID) — registered with EMVCo.
    final aid = (txn['application_id'] as String? ?? '').toUpperCase().replaceAll(' ', '');
    if (aid.isNotEmpty) {
      if (aid.startsWith('A0000002281010')) return 'mada';
      if (aid.startsWith('A000000003')) return 'visa';
      if (aid.startsWith('A000000004')) return 'mastercard';
      if (aid.startsWith('A000000025')) return 'amex';
    }

    // 3. Card BIN fallback (first 6 digits of the masked PAN).
    final pan = (txn['credit_number'] as String? ?? '').replaceAll(RegExp(r'\D'), '');
    if (pan.length >= 6) {
      final bin = pan.substring(0, 6);
      // Mada BIN ranges (subset of the official Saudi mada BIN list).
      const madaBins = ['446672', '446673', '446674', '457865', '484783', '506968', '588845', '604906', '968202'];
      if (madaBins.any(bin.startsWith)) return 'mada';
      final first = pan.substring(0, 1);
      if (first == '4') return 'visa';
      if (first == '5' || first == '2') return 'mastercard';
      if (first == '3') return 'amex';
    }
    return '';
  }

  String _extractError(dynamic e) {
    try {
      if (e is String) return e;
      if (e is Map) return e['message'] as String? ?? jsonEncode(e);
      return e.toString();
    } catch (_) {
      return 'Unknown error';
    }
  }
}
