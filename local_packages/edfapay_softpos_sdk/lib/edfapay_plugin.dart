// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'edfapay_bridge.dart';
import 'enums/flow_type.dart';
import 'models/edfapay_credentials.dart';
import 'models/txn_params.dart';
import 'models/transaction.dart';
import 'models/sdk_theme.dart';
import 'models/pagination.dart';
import 'models/invoice_request.dart';
import 'models/bnpl_response.dart';
import 'src/plugin_extension.dart';
import 'src/plugin_utils.dart';
import 'src/remote_access.dart';

export 'edfapay_bridge.dart'
    show
        ProcessCompleteCallback,
        TimeOutCallBack,
        CancelByUserCallBack,
        OnErrorCallBack,
        OnSuccessCallback,
        OnTerminalBindingTask;

export 'enums/env.dart';
export 'enums/flow_type.dart';
export 'enums/transaction_type.dart';
export 'enums/presentation.dart';
export 'enums/purchase_secondary_action.dart';
export 'enums/function_code.dart';
export 'enums/bnpl_provider.dart';
export 'models/edfapay_credentials.dart';
export 'models/txn_params.dart';
export 'models/transaction.dart';
export 'models/pagination.dart';
export 'models/location.dart';
export 'models/sdk_theme.dart';
export 'models/terminal.dart';
export 'models/terminal_binding_task.dart';
export 'models/user_info.dart';
export 'models/invoice_request.dart';
export 'models/bnpl_response.dart';
export 'src/plugin_extension.dart';
export 'src/plugin_utils.dart';
export 'src/remote_access.dart';

/// Main EdfaPay SDK entry point.
///
/// Mirrors the native Kotlin API exactly:
///   EdfaPayPlugin.initiate(...)
///   EdfaPayPlugin.purchase(...)
///   EdfaPayPlugin.Extension.loginWithToken(...)
///   EdfaPayPlugin.Utils.getDeviceId()
///   EdfaPayPlugin.RemoteChannel.LocalNetwork(port:8080, timeout:30.0).open()
abstract class EdfaPayPlugin {
  EdfaPayPlugin._();

  static final _bridge = EdfaPayBridge.instance;

  // ── Sub-objects ───────────────────────────────────────────────────────────

  static final PluginExtension Extension = PluginExtension.create();
  static final PluginUtils Utils = PluginUtils.create();
  static final RemoteAccess RemoteChannel = RemoteAccess.create();

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  /// Call once at app startup to begin listening for native callbacks.

  // ── Theme ─────────────────────────────────────────────────────────────────

  /// Returns a chainable SdkTheme builder.
  /// Usage: EdfaPayPlugin.theme().setPrimaryColor('#00cc66')
  static SdkTheme theme() => SdkTheme.create();

  /// Set global animation speed multiplier.
  static Future<void> setAnimationSpeedX(double speed) =>
      _bridge.invoke('setAnimationSpeedX', params: {'speed': speed});

  // ── Initialization ────────────────────────────────────────────────────────

  /// Set encrypted partner configuration before calling initiate().
  static Future<void> setPartnerConfig(String config) =>
      _bridge.invoke('setPartnerConfig', params: {'partnerConfig': config});

  /// Enable or disable debug logging.
  static Future<void> enableLogs(bool enable) =>
      _bridge.invoke('setEnableLogs', params: {'enable': enable});

  /// Initialize the SDK with credentials.
  ///
  /// When terminal binding is required, [onTerminalBindingTask] will be called
  /// with a [TerminalBindingTask] that contains available terminals.
  /// Use `task.bind()` to show native UI or `task.bindTerminal(trsm: ...)` to
  /// bind programmatically. After binding completes, [onSuccess] or [onError]
  /// will be called automatically.
  static Future<void> initiate({
    required EdfaPayCredentials credentials,
    required void Function(String? sessionId) onSuccess,
    required OnTerminalBindingTask onTerminalBindingTask,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'initiate',
      params: {'credentials': credentials.toMap()},
      callbacks: {
        'onTerminalBindingTask': onTerminalBindingTask,
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  // ── Payment Operations ────────────────────────────────────────────────────

  static Future<void> purchase({
    required TxnParams txnParams,
    FlowType flowType = FlowType.DETAIL,
    required ProcessCompleteCallback onPaymentProcessComplete,
    required TimeOutCallBack onRequestTimerEnd,
    required TimeOutCallBack onCardScanTimerEnd,
    required CancelByUserCallBack onCancelByUser,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'purchase',
      params: {'txnParams': txnParams.toMap(), 'flowType': flowType.name},
      callbacks: {
        'onPaymentProcessComplete': onPaymentProcessComplete,
        'onRequestTimerEnd': onRequestTimerEnd,
        'onCardScanTimerEnd': onCardScanTimerEnd,
        'onCancelByUser': onCancelByUser,
        'onError': onError,
      },
    );
  }

  static Future<void> authorize({
    required TxnParams txnParams,
    FlowType flowType = FlowType.DETAIL,
    required ProcessCompleteCallback onPaymentProcessComplete,
    required TimeOutCallBack onRequestTimerEnd,
    required TimeOutCallBack onCardScanTimerEnd,
    required CancelByUserCallBack onCancelByUser,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'authorize',
      params: {'txnParams': txnParams.toMap(), 'flowType': flowType.name},
      callbacks: {
        'onPaymentProcessComplete': onPaymentProcessComplete,
        'onRequestTimerEnd': onRequestTimerEnd,
        'onCardScanTimerEnd': onCardScanTimerEnd,
        'onCancelByUser': onCancelByUser,
        'onError': onError,
      },
    );
  }

  static Future<void> capture({
    required TxnParams txnParams,
    FlowType flowType = FlowType.DETAIL,
    required ProcessCompleteCallback onPaymentProcessComplete,
    required TimeOutCallBack onRequestTimerEnd,
    required TimeOutCallBack onCardScanTimerEnd,
    required CancelByUserCallBack onCancelByUser,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'capture',
      params: {'txnParams': txnParams.toMap(), 'flowType': flowType.name},
      callbacks: {
        'onPaymentProcessComplete': onPaymentProcessComplete,
        'onRequestTimerEnd': onRequestTimerEnd,
        'onCardScanTimerEnd': onCardScanTimerEnd,
        'onCancelByUser': onCancelByUser,
        'onError': onError,
      },
    );
  }

  static Future<void> refund({
    required TxnParams txnParams,
    FlowType flowType = FlowType.DETAIL,
    required ProcessCompleteCallback onPaymentProcessComplete,
    required TimeOutCallBack onRequestTimerEnd,
    required TimeOutCallBack onCardScanTimerEnd,
    required CancelByUserCallBack onCancelByUser,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'refund',
      params: {'txnParams': txnParams.toMap(), 'flowType': flowType.name},
      callbacks: {
        'onPaymentProcessComplete': onPaymentProcessComplete,
        'onRequestTimerEnd': onRequestTimerEnd,
        'onCardScanTimerEnd': onCardScanTimerEnd,
        'onCancelByUser': onCancelByUser,
        'onError': onError,
      },
    );
  }

  static Future<void> changePin({
    required List<String> parameters,
    FlowType flowType = FlowType.DETAIL,
    required onProcessComplete onProcessComplete,
    required TimeOutCallBack onRequestTimerEnd,
    required TimeOutCallBack onCardScanTimerEnd,
    required CancelByUserCallBack onCancelByUser,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'changePin',
      params: {'parameters': parameters, 'flowType': flowType.name},
      callbacks: {
        'onProcessComplete': onProcessComplete,
        'onRequestTimerEnd': onRequestTimerEnd,
        'onCardScanTimerEnd': onCardScanTimerEnd,
        'onCancelByUser': onCancelByUser,
        'onError': onError,
      },
    );
  }

  static Future<void> activateCard({
    required List<String> parameters,
    FlowType flowType = FlowType.DETAIL,
    required onProcessComplete onProcessComplete,
    required TimeOutCallBack onRequestTimerEnd,
    required TimeOutCallBack onCardScanTimerEnd,
    required CancelByUserCallBack onCancelByUser,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'activateCard',
      params: {'parameters': parameters, 'flowType': flowType.name},
      callbacks: {
        'onProcessComplete': onProcessComplete,
        'onRequestTimerEnd': onRequestTimerEnd,
        'onCardScanTimerEnd': onCardScanTimerEnd,
        'onCancelByUser': onCancelByUser,
        'onError': onError,
      },
    );
  }

  static Future<void> void$({
    required Transaction transaction,
    required void Function(Map<String, dynamic> response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'void',
      params: {'transaction': transaction.toMap()},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  static Future<void> reverse({
    required Transaction transaction,
    required void Function(Map<String, dynamic> response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'reverse',
      params: {'transaction': transaction.toMap()},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  static Future<void> reverseLastTransaction({
    required void Function(Map<String, dynamic> response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'reverseLastTransaction',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  // ── BNPL (Buy Now Pay Later) ─────────────────────────────────────────────

  /// Initiate BNPL checkout with Tamara or Tabby.
  ///
  /// [request] contains provider, merchant info, customer details, and invoice.
  /// [onSuccess] returns checkout deeplink URL to redirect customer.
  /// [onError] called on failure with error details.
  static Future<void> buyNowPayLater({
    required InvoiceRequest request,
    required void Function(BnplResponse response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'buyNowPayLater',
      params: {'request': request.toMap()},
      callbacks: {
        'onSuccess': (Map<String, dynamic> result) => onSuccess(BnplResponse.fromMap(result)),
        'onError': onError,
      },
    );
  }

  /// Initiate checkout link generation (invoice-based payment link).
  ///
  /// [request] contains provider, merchant info, customer details, and invoice.
  /// [onSuccess] returns checkout deeplink URL to redirect customer.
  /// [onError] called on failure with error details.
  static Future<void> checkoutLinkApi({
    required InvoiceRequest request,
    required void Function(BnplResponse response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'checkoutLinkApi',
      params: {'request': request.toMap()},
      callbacks: {
        'onSuccess': (Map<String, dynamic> result) => onSuccess(BnplResponse.fromMap(result)),
        'onError': onError,
      },
    );
  }

  // ── Transaction History ───────────────────────────────────────────────────

  static Future<void> txnHistory({
    Pagination? pagination,
    required void Function(Map<String, dynamic> transactions) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'txnHistory',
      params: {'pagination': pagination?.toMap()},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  static Future<void> txnDetail({
    required String txnId,
    required void Function(Map<String, dynamic> transaction) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'txnDetail',
      params: {'txnId': txnId},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  static Future<void> txnDetailApi({
    required String txnId,
    required void Function(Map<String, dynamic> transaction) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'txnDetailApi',
      params: {'txnId': txnId},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  // ── Reconciliation ────────────────────────────────────────────────────────

  static Future<void> reconcile({
    required void Function(Map<String, dynamic> response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'reconcile',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  static Future<void> reconciliationHistory({
    required void Function(Map<String, dynamic> response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'reconciliationHistory',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  static Future<void> reconciliationDetail({
    required String id,
    required void Function(Map<String, dynamic> response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'reconciliationDetail',
      params: {'id': id},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  static Future<void> reconciliationReceipt({
    required String id,
    required void Function(Map<String, dynamic> response) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'reconciliationReceipt',
      params: {'id': id},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  // ── Terminal Management ───────────────────────────────────────────────────

  static Future<void> terminalInfo({
    required void Function(Map<String, dynamic> terminalInfo) onSuccess,
    OnErrorCallBack? onError,
  }) {
    return _bridge.invoke(
      'terminalInfo',
      callbacks: {
        'onSuccess': onSuccess,
        if (onError != null) 'onError': onError,
      },
    );
  }

  static Future<void> activateTerminal({
    String? password,
    required void Function() onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'activateTerminal',
      params: {'password': password},
      callbacks: {
        'onSuccess': (_) => onSuccess(),
        'onError': onError,
      },
    );
  }

  static Future<void> deActivateTerminal({
    String? password,
    required void Function() onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'deActivateTerminal',
      params: {'password': password},
      callbacks: {
        'onSuccess': (_) => onSuccess(),
        'onError': onError,
      },
    );
  }

  static Future<void> syncTerminal({
    required void Function() onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'syncTerminal',
      callbacks: {
        'onSuccess': (_) => onSuccess(),
        'onError': onError,
      },
    );
  }

  // ── Session Management ────────────────────────────────────────────────────

  static Future<String?> getSessionId() async {
    final result = await _bridge.invoke('getSessionId');
    return result as String?;
  }

  static Future<Map<String, dynamic>?> getSessionDetail() async {
    final result = await _bridge.invoke('getSessionDetail');
    return result == null ? null : Map<String, dynamic>.from(result as Map);
  }

  static Future<List<Map<String, dynamic>>> getSessionList() async {
    final result = await _bridge.invoke('getSessionList');
    return ((result as List?) ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  static Future<void> logoutCurrentSession({
    required void Function() onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'logoutCurrentSession',
      callbacks: {
        'onSuccess': (_) => onSuccess(),
        'onError': onError,
      },
    );
  }

  static Future<void> logoutSession({
    required String sessionId,
    required void Function() onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'logoutSession',
      params: {'sessionId': sessionId},
      callbacks: {
        'onSuccess': (_) => onSuccess(),
        'onError': onError,
      },
    );
  }
}
