// ignore_for_file: non_constant_identifier_names
import '../edfapay_bridge.dart';

/// EdfaPayPlugin.RemoteChannel — local network remote access.
/// Matches: EdfaPayPlugin.RemoteChannel in native SDK.
class RemoteAccess {
  RemoteAccess._();
  factory RemoteAccess.create() => RemoteAccess._();

  final _bridge = EdfaPayBridge.instance;

  /// Configure and return a local network channel builder.
  /// Usage: EdfaPayPlugin.RemoteChannel.LocalNetwork(port: 8080, timeout: 30.0).open()
  LocalNetworkBuilder localNetwork(
          {required int port, required double timeout}) =>
      LocalNetworkBuilder._(port: port, timeout: timeout, bridge: _bridge);

  /// Convenience: EdfaPayPlugin.RemoteChannel.LocalNetwork(...)
  LocalNetworkBuilder LocalNetwork(
          {required int port, required double timeout}) =>
      localNetwork(port: port, timeout: timeout);
}

/// Builder returned by RemoteAccess.LocalNetwork(...). Call .open() to start.
class LocalNetworkBuilder {
  final int port;
  final double timeout;
  final EdfaPayBridge _bridge;

  LocalNetworkBuilder._({
    required this.port,
    required this.timeout,
    required EdfaPayBridge bridge,
  }) : _bridge = bridge;

  Future<void> open() => _bridge.invoke(
        'RemoteChannel.LocalNetwork.open',
        params: {'port': port, 'timeout': timeout},
      );

  Future<void> close() => _bridge.invoke('RemoteChannel.LocalNetwork.close');
}
