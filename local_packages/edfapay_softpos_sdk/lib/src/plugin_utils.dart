import '../edfapay_bridge.dart';
import '../models/location.dart';

/// EdfaPayPlugin.Utils — device and location utilities.
/// Matches: EdfaPayPlugin.Utils in native SDK.
class PluginUtils {
  PluginUtils._();
  factory PluginUtils.create() => PluginUtils._();

  final _bridge = EdfaPayBridge.instance;

  /// Returns unique device identifier.
  Future<String?> getDeviceId({int? merchantId}) async {
    final result = await _bridge.invoke(
      'Utils.getDeviceId',
      params: {'merchantId': merchantId},
    );
    return result as String?;
  }

  /// Returns true if location permission is granted.
  Future<bool> haveLocationPermission() async {
    final result = await _bridge.invoke('Utils.haveLocationPermission');
    return (result as bool?) ?? false;
  }

  /// Requests location permission. [callback] receives true if granted.
  Future<void> requestLocationPermission({
    required void Function(bool permitted) callback,
  }) {
    return _bridge.invoke(
      'Utils.requestLocationPermission',
      callbacks: {
        'onSuccess': (p) => callback((p['permitted'] as bool?) ?? false),
      },
    );
  }

  /// Gets current device location.
  /// [completion] receives (location Map?, hasPermission).
  Future<void> currentLocation({
    required void Function(Map<String, dynamic>? location, bool hasPermission)
        completion,
  }) {
    return _bridge.invoke(
      'Utils.currentLocation',
      callbacks: {
        'onSuccess': (p) => completion(
              p['location'] as Map<String, dynamic>?,
              (p['permission'] as bool?) ?? false,
            ),
      },
    );
  }

  /// Checks if [location] is mocked/fake.
  Future<bool> isLocationMocked(Location location) async {
    final result = await _bridge.invoke(
      'Utils.isLocationMocked',
      params: {'location': location.toMap()},
    );
    return (result as bool?) ?? false;
  }

  /// Shows an SDK-styled message dialog.
  Future<void> showMessageDialog({
    required String title,
    required String message,
    void Function()? onClose,
  }) {
    return _bridge.invoke(
      'Utils.showMessageDialog',
      params: {'title': title, 'message': message},
      callbacks: onClose != null ? {'onSuccess': (_) => onClose()} : null,
    );
  }

  /// Saves a value encrypted to DataStore.
  Future<void> saveData({
    required String key,
    required String value,
    required void Function(bool success) onSuccess,
    required OnErrorCallBack onError,
  }) {
    return _bridge.invoke(
      'Utils.saveData',
      params: {'key': key, 'value': value},
      callbacks: {
        'onSuccess': (p) => onSuccess((p['success'] as bool?) ?? false),
        'onError': onError,
      },
    );
  }

  /// Retrieves a value from encrypted DataStore.
  Future<String?> getData(String key) async {
    final result = await _bridge.invoke('Utils.getData', params: {'key': key});
    return result as String?;
  }
}
