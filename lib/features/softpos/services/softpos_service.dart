// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:edfapay_softpos_sdk/edfapay_softpos_sdk.dart';
import 'package:edfapay_softpos_sdk/enums/env.dart';
import 'package:edfapay_softpos_sdk/enums/flow_type.dart';
import 'package:edfapay_softpos_sdk/enums/presentation.dart';
import 'package:edfapay_softpos_sdk/enums/purchase_secondary_action.dart';
import 'package:edfapay_softpos_sdk/helpers.dart';
import 'package:edfapay_softpos_sdk/models/edfapay_credentials.dart';
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
    this.amount,
    this.errorMessage,
    this.rawResult,
  });

  factory SoftPosPaymentResult.failure(String message) => SoftPosPaymentResult(success: false, errorMessage: message);

  final bool success;
  final String? approvalCode;
  final String? rrn;
  final String? transactionId;
  final String? cardScheme; // mada, visa, mastercard
  final String? maskedCard;
  final String? cardHolderName;
  final String? amount;
  final String? errorMessage;
  final Map<String, dynamic>? rawResult;
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

    EdfaPayPlugin.enableLogs(false); // disable verbose logs in production

    EdfaPayPlugin.initiate(
      credentials: credentials,
      onError: (e) {
        _isInitiated = false;
        final msg = _extractError(e);
        print('[SoftPOS] Init error: $msg');
        onError?.call(msg);
      },
      onTerminalBindingTask: (bindingTask) {
        // Use the SDK's built-in terminal selection UI
        bindingTask.bind();
      },
      onSuccess: (sessionId) {
        _isInitiated = true;
        print('[SoftPOS] Init success. Session: $sessionId');
        onSuccess?.call(sessionId ?? '');
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
          completer.complete(_buildResult(success: success, code: code, raw: result));
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
      theme.setHeaderImage(logo).setPoweredByImage(logo);
    }

    theme.setPresentation(presentation);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  SoftPosPaymentResult _buildResult({required bool success, required String? code, required Map<String, dynamic>? raw}) {
    if (!success) {
      final msg = raw?['message'] as String? ?? 'Payment declined (code: $code).';
      return SoftPosPaymentResult.failure(msg);
    }

    final txn = (raw?['transaction'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return SoftPosPaymentResult(
      success: true,
      approvalCode: txn['auth_code'] as String?,
      rrn: txn['rrn'] as String?,
      transactionId: txn['transaction_number'] as String?,
      cardScheme: txn['scheme'] as String?,
      maskedCard: txn['credit_number'] as String?,
      cardHolderName: txn['cardholder_name'] as String?,
      amount: txn['amount'] as String?,
      rawResult: raw,
    );
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
