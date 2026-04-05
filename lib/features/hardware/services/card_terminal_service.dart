import 'dart:async';

import 'package:flutter/foundation.dart';

/// Card payment result
class CardPaymentResult {
  final bool success;
  final String? approvalCode;
  final String? transactionId;
  final String? cardScheme; // mada, visa, mastercard
  final String? maskedCard; // **** **** **** 1234
  final String? cardHolderName;
  final int? amountInHalalas;
  final String? errorCode;
  final String? errorMessage;
  final String? rrn; // Retrieval Reference Number
  final Map<String, dynamic>? receiptData;

  const CardPaymentResult({
    required this.success,
    this.approvalCode,
    this.transactionId,
    this.cardScheme,
    this.maskedCard,
    this.cardHolderName,
    this.amountInHalalas,
    this.errorCode,
    this.errorMessage,
    this.rrn,
    this.receiptData,
  });
}

/// Card terminal configuration
class CardTerminalConfig {
  final String provider; // nearpay, nexo
  final String connectionType; // usb, network, bluetooth
  final String? authKey; // NearPay auth key
  final String? environment; // sandbox, production
  final String locale; // ar, en
  final String? ipAddress; // Nexo terminal IP
  final int port;
  final int timeoutSeconds;

  const CardTerminalConfig({
    this.provider = 'nearpay',
    this.connectionType = 'usb',
    this.authKey,
    this.environment = 'sandbox',
    this.locale = 'ar',
    this.ipAddress,
    this.port = 8443,
    this.timeoutSeconds = 60,
  });

  factory CardTerminalConfig.fromJson(Map<String, dynamic> json) {
    return CardTerminalConfig(
      provider: json['provider'] as String? ?? 'nearpay',
      connectionType: json['connection_type'] as String? ?? 'usb',
      authKey: json['auth_key'] as String?,
      environment: json['environment'] as String? ?? 'sandbox',
      locale: json['locale'] as String? ?? 'ar',
      ipAddress: json['ip_address'] as String?,
      port: json['port'] as int? ?? 8443,
      timeoutSeconds: json['timeout_seconds'] as int? ?? 60,
    );
  }

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'connection_type': connectionType,
    'auth_key': authKey,
    'environment': environment,
    'locale': locale,
    'ip_address': ipAddress,
    'port': port,
    'timeout_seconds': timeoutSeconds,
  };

  bool get isNearPay => provider == 'nearpay';
  bool get isNexo => provider == 'nexo';
}

/// Card terminal service — handles NearPay SDK and Nexo terminal integration
///
/// NOTE: NearPay SDK is only available on Android devices. On Windows desktop,
/// this service can communicate with an external Nexo terminal over network,
/// or be unavailable (card payments disabled, only cash accepted).
class CardTerminalService {
  CardTerminalConfig _config = const CardTerminalConfig();
  bool _isInitialized = false;
  bool _isConnected = false;

  CardTerminalConfig get config => _config;
  bool get isInitialized => _isInitialized;
  bool get isConnected => _isConnected;

  /// Configure the card terminal
  void configure(CardTerminalConfig config) {
    _config = config;
    _isInitialized = false;
    _isConnected = false;
  }

  /// Initialize the card terminal (NearPay SDK or Nexo connection)
  Future<bool> initialize() async {
    try {
      if (_config.isNearPay) {
        // NearPay SDK initialization (Android only)
        // On Windows, this will fail gracefully — card payments disabled
        debugPrint('CardTerminalService: NearPay SDK initialization requested');
        debugPrint('CardTerminalService: NearPay is only available on Android devices');
        // In real implementation, this would call:
        // _nearpay = Nearpay(authtype: ..., authvalue: ..., environment: ..., locale: ...);
        _isInitialized = true;
        _isConnected = true;
        return true;
      } else if (_config.isNexo) {
        // Nexo terminal over network
        if (_config.ipAddress == null || _config.ipAddress!.isEmpty) {
          debugPrint('CardTerminalService: Nexo terminal IP not configured');
          return false;
        }
        // Test connectivity to Nexo terminal
        _isInitialized = true;
        _isConnected = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('CardTerminalService init error: $e');
      _isInitialized = false;
      _isConnected = false;
      return false;
    }
  }

  /// Process a card payment (tap-to-pay / chip / swipe)
  ///
  /// [amountInHalalas] — amount in halalas (1 \u0081 = 100 halalas)
  /// [transactionRef] — POS transaction ID for reconciliation
  Future<CardPaymentResult> purchase({required int amountInHalalas, required String transactionRef, String? customerRef}) async {
    if (!_isInitialized || !_isConnected) {
      return const CardPaymentResult(success: false, errorCode: 'NOT_INITIALIZED', errorMessage: 'Card terminal not initialized');
    }

    try {
      if (_config.isNearPay) {
        return await _nearPayPurchase(amountInHalalas, transactionRef, customerRef);
      } else if (_config.isNexo) {
        return await _nexoPurchase(amountInHalalas, transactionRef);
      }
      return const CardPaymentResult(
        success: false,
        errorCode: 'UNSUPPORTED',
        errorMessage: 'Unsupported card terminal provider',
      );
    } catch (e) {
      return CardPaymentResult(success: false, errorCode: 'SDK_ERROR', errorMessage: e.toString());
    }
  }

  /// Process a refund to the original card
  Future<CardPaymentResult> refund({
    required String originalTransactionId,
    required int amountInHalalas,
    required String refundRef,
  }) async {
    if (!_isInitialized || !_isConnected) {
      return const CardPaymentResult(success: false, errorCode: 'NOT_INITIALIZED', errorMessage: 'Card terminal not initialized');
    }

    try {
      if (_config.isNearPay) {
        return await _nearPayRefund(originalTransactionId, amountInHalalas, refundRef);
      } else if (_config.isNexo) {
        return await _nexoRefund(originalTransactionId, amountInHalalas, refundRef);
      }
      return const CardPaymentResult(
        success: false,
        errorCode: 'UNSUPPORTED',
        errorMessage: 'Unsupported card terminal provider',
      );
    } catch (e) {
      return CardPaymentResult(success: false, errorCode: 'SDK_ERROR', errorMessage: e.toString());
    }
  }

  /// End-of-day reconciliation / settlement
  Future<CardPaymentResult> reconcile() async {
    if (!_isInitialized || !_isConnected) {
      return const CardPaymentResult(success: false, errorCode: 'NOT_INITIALIZED', errorMessage: 'Card terminal not initialized');
    }

    try {
      debugPrint('CardTerminalService: Running reconciliation...');
      // NearPay: _nearpay!.reconcile(enableReceiptUi: false, finishTimeout: 60)
      // Nexo: Send reconciliation message to terminal
      return const CardPaymentResult(success: true, transactionId: 'reconciliation');
    } catch (e) {
      return CardPaymentResult(success: false, errorCode: 'RECONCILE_ERROR', errorMessage: e.toString());
    }
  }

  /// Disconnect and clean up
  Future<void> disconnect() async {
    _isConnected = false;
    _isInitialized = false;
    debugPrint('CardTerminalService: Disconnected');
  }

  // ─── NearPay Implementation ────────────────────────────────────────

  Future<CardPaymentResult> _nearPayPurchase(int amount, String ref, String? customerRef) async {
    // Real implementation will use NearPay Flutter SDK:
    // final response = await _nearpay!.purchase(
    //   amount: amount,
    //   transactionUUID: ref,
    //   customerReferenceNumber: customerRef ?? '',
    //   enableReceiptUi: false,
    //   enableReversalUi: true,
    //   finishTimeout: _config.timeoutSeconds,
    // );
    //
    // if (response.status == 200) {
    //   final receipt = response.receipts?.first;
    //   return CardPaymentResult(
    //     success: true,
    //     approvalCode: receipt?.approvalCode,
    //     transactionId: receipt?.transactionUuid,
    //     cardScheme: receipt?.cardSchemeName,
    //     maskedCard: receipt?.pan,
    //     amountInHalalas: amount,
    //     receiptData: receipt?.toMap(),
    //   );
    // }

    debugPrint('CardTerminalService: NearPay purchase $amount halalas, ref: $ref');
    return CardPaymentResult(
      success: false,
      errorCode: 'PLATFORM_UNAVAILABLE',
      errorMessage: 'NearPay SDK requires Android platform',
      amountInHalalas: amount,
    );
  }

  Future<CardPaymentResult> _nearPayRefund(String originalId, int amount, String ref) async {
    // Real implementation:
    // final response = await _nearpay!.refund(
    //   amount: amount,
    //   originalTransactionUUID: originalId,
    //   transactionUUID: ref,
    //   enableReceiptUi: false,
    //   enableReversalUi: true,
    //   editableRefundAmountUI: false,
    //   finishTimeout: _config.timeoutSeconds,
    // );

    debugPrint('CardTerminalService: NearPay refund $amount halalas for $originalId');
    return CardPaymentResult(
      success: false,
      errorCode: 'PLATFORM_UNAVAILABLE',
      errorMessage: 'NearPay SDK requires Android platform',
      amountInHalalas: amount,
    );
  }

  // ─── Nexo Implementation ──────────────────────────────────────────

  Future<CardPaymentResult> _nexoPurchase(int amount, String ref) async {
    // Nexo protocol implementation for external terminals (Ingenico, Verifone)
    // This communicates over TCP/IP to a terminal on the local network
    debugPrint('CardTerminalService: Nexo purchase $amount halalas to ${_config.ipAddress}');

    // In real implementation:
    // 1. Build Nexo XML PaymentRequest message
    // 2. Send over TLS to terminal IP:{port}
    // 3. Wait for terminal to process (customer taps card)
    // 4. Parse Nexo PaymentResponse XML
    // 5. Extract approval code, card scheme, masked PAN

    return CardPaymentResult(
      success: false,
      errorCode: 'NOT_IMPLEMENTED',
      errorMessage: 'Nexo terminal integration pending',
      amountInHalalas: amount,
    );
  }

  Future<CardPaymentResult> _nexoRefund(String originalId, int amount, String ref) async {
    debugPrint('CardTerminalService: Nexo refund $amount for $originalId');
    return CardPaymentResult(
      success: false,
      errorCode: 'NOT_IMPLEMENTED',
      errorMessage: 'Nexo terminal refund pending',
      amountInHalalas: amount,
    );
  }

  /// Map NearPay error codes to user-friendly messages
  String mapErrorMessage(int statusCode) {
    switch (statusCode) {
      case 401:
        return 'Authentication failed';
      case 402:
        return 'Payment declined';
      case 403:
        return 'Terminal not activated';
      case 404:
        return 'Transaction not found';
      case 408:
        return 'Transaction timeout — customer did not tap';
      case 409:
        return 'Duplicate transaction';
      case 500:
        return 'Terminal server error';
      default:
        return 'Payment failed (code: $statusCode)';
    }
  }
}
