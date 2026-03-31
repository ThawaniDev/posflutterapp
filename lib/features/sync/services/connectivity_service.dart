import 'dart:async';
import 'dart:io';

/// Monitors network connectivity and provides a stream of online/offline status.
class ConnectivityService {
  ConnectivityService({this.checkInterval = const Duration(seconds: 30), this.checkUrl = 'dns.google'});

  final Duration checkInterval;
  final String checkUrl;

  final _controller = StreamController<ConnectivityStatus>.broadcast();
  Timer? _timer;
  ConnectivityStatus _lastStatus = ConnectivityStatus.unknown;

  ConnectivityStatus get currentStatus => _lastStatus;
  bool get isOnline => _lastStatus == ConnectivityStatus.online;
  Stream<ConnectivityStatus> get statusStream => _controller.stream;

  /// Start periodic connectivity checks.
  void startMonitoring() {
    _timer?.cancel();
    _checkNow();
    _timer = Timer.periodic(checkInterval, (_) => _checkNow());
  }

  /// Stop monitoring.
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  /// Force an immediate check.
  Future<ConnectivityStatus> checkNow() => _checkNow();

  Future<ConnectivityStatus> _checkNow() async {
    try {
      final result = await InternetAddress.lookup(checkUrl).timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _updateStatus(ConnectivityStatus.online);
      } else {
        _updateStatus(ConnectivityStatus.offline);
      }
    } on SocketException {
      _updateStatus(ConnectivityStatus.offline);
    } on TimeoutException {
      _updateStatus(ConnectivityStatus.offline);
    } catch (_) {
      _updateStatus(ConnectivityStatus.offline);
    }
    return _lastStatus;
  }

  void _updateStatus(ConnectivityStatus newStatus) {
    if (_lastStatus != newStatus) {
      _lastStatus = newStatus;
      _controller.add(newStatus);
    }
  }

  void dispose() {
    stopMonitoring();
    _controller.close();
  }
}

enum ConnectivityStatus { online, offline, unknown }
