import '../edfapay_bridge.dart';
import '../models/location.dart';
import '../enums/function_code.dart';

/// EdfaPayPlugin.Extension — advanced methods for custom integrations.
/// Matches: EdfaPayPlugin.Extension in native SDK.
class PluginExtension {
  PluginExtension._();
  factory PluginExtension.create() => PluginExtension._();

  final _bridge = EdfaPayBridge.instance;

  Future<void> init({
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.init',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> loginWithCredentials({
    required String email,
    required String password,
    required Location location,
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.loginWithCredentials',
      params: {'email': email, 'password': password, 'location': location.toMap()},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> loginWithToken({
    required String token,
    required Location location,
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.loginWithToken',
      params: {'token': token, 'location': location.toMap()},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> verifyOtp({
    required String sessionId,
    required String otp,
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.verifyOtp',
      params: {'sessionId': sessionId, 'otp': otp},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> resendOtp({
    required String sessionId,
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.resendOtp',
      params: {'sessionId': sessionId},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> getAvailableTerminal({
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.getAvailableTerminal',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> registerTerminal({
    required String trsm,
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.registerTerminal',
      params: {'trsm': trsm},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> getTerminalConfig({
    bool forceDownload = false,
    FunctionCode configurationType = FunctionCode.FULL_TERMINAL_CONFIGURATION,
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.getTerminalConfig',
      params: {'forceDownload': forceDownload, 'configurationType': configurationType.name},
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> getInitialKey({
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.getInitialKey',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> renewSessionIfRequiredAndPossible({
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.renewSessionIfRequiredAndPossible',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> initKernels({
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.initKernels',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> prepareTerminalWithToken({
    required String token,
    required Location location,
    required OnTerminalBindingTask onTerminalBindingTask,
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.prepareTerminalWithToken',
      params: {'token': token, 'location': location.toMap()},
      callbacks: {
        'onTerminalBindingTask': onTerminalBindingTask,
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }

  Future<void> getUserInfo({
    required OnSuccessCallback onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Extension.getUserInfo',
      callbacks: {
        'onSuccess': onSuccess,
        'onError': onError,
      },
    );
  }
}
