import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Manages a WebSocket connection for real-time sync events from the server.
class WebSocketService {
  WebSocketService({
    required this.baseUrl,
    this.authToken,
    this.reconnectDelay = const Duration(seconds: 5),
    this.maxReconnectDelay = const Duration(minutes: 2),
    this.pingInterval = const Duration(seconds: 30),
  });

  final String baseUrl;
  String? authToken;
  final Duration reconnectDelay;
  final Duration maxReconnectDelay;
  final Duration pingInterval;

  WebSocket? _socket;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  int _reconnectAttempts = 0;
  bool _intentionallyClosed = false;

  final _messageController = StreamController<SyncEvent>.broadcast();
  final _connectionController = StreamController<WebSocketConnectionState>.broadcast();

  Stream<SyncEvent> get events => _messageController.stream;
  Stream<WebSocketConnectionState> get connectionState => _connectionController.stream;
  WebSocketConnectionState _state = WebSocketConnectionState.disconnected;
  WebSocketConnectionState get currentState => _state;

  /// Connect to the sync WebSocket endpoint.
  Future<void> connect() async {
    if (_state == WebSocketConnectionState.connected || _state == WebSocketConnectionState.connecting) return;

    _intentionallyClosed = false;
    _updateState(WebSocketConnectionState.connecting);

    try {
      final wsUrl = baseUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://');
      final uri = '$wsUrl/ws/sync';

      _socket = await WebSocket.connect(
        uri,
        headers: authToken != null ? {'Authorization': 'Bearer $authToken'} : null,
      ).timeout(const Duration(seconds: 10));

      _reconnectAttempts = 0;
      _updateState(WebSocketConnectionState.connected);

      _socket!.listen(_onMessage, onError: _onError, onDone: _onDone, cancelOnError: false);

      _startPing();
    } on SocketException {
      _updateState(WebSocketConnectionState.disconnected);
      _scheduleReconnect();
    } on TimeoutException {
      _updateState(WebSocketConnectionState.disconnected);
      _scheduleReconnect();
    } catch (e) {
      _updateState(WebSocketConnectionState.error);
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic data) {
    try {
      final decoded = json.decode(data as String) as Map<String, dynamic>;
      final event = SyncEvent(
        type: decoded['type'] as String? ?? 'unknown',
        table: decoded['table'] as String?,
        recordId: decoded['record_id'] as String?,
        data: decoded['data'] as Map<String, dynamic>?,
        timestamp: decoded['timestamp'] != null ? DateTime.tryParse(decoded['timestamp'] as String) : null,
      );
      _messageController.add(event);
    } catch (_) {
      // Ignore malformed messages
    }
  }

  void _onError(Object error) {
    _updateState(WebSocketConnectionState.error);
    _scheduleReconnect();
  }

  void _onDone() {
    _updateState(WebSocketConnectionState.disconnected);
    _stopPing();
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  /// Send a message to the server.
  void send(Map<String, dynamic> message) {
    if (_socket != null && _state == WebSocketConnectionState.connected) {
      _socket!.add(json.encode(message));
    }
  }

  /// Subscribe to a specific table's changes.
  void subscribe(String table) {
    send({'action': 'subscribe', 'table': table});
  }

  /// Unsubscribe from a table's changes.
  void unsubscribe(String table) {
    send({'action': 'unsubscribe', 'table': table});
  }

  /// Gracefully disconnect.
  Future<void> disconnect() async {
    _intentionallyClosed = true;
    _reconnectTimer?.cancel();
    _stopPing();
    await _socket?.close(WebSocketStatus.normalClosure);
    _socket = null;
    _updateState(WebSocketConnectionState.disconnected);
  }

  /// Update auth token (e.g. after refresh).
  void updateToken(String token) {
    authToken = token;
  }

  void _scheduleReconnect() {
    if (_intentionallyClosed) return;
    _reconnectTimer?.cancel();

    final delay = Duration(
      milliseconds: (reconnectDelay.inMilliseconds * (1 << _reconnectAttempts)).clamp(0, maxReconnectDelay.inMilliseconds),
    );
    _reconnectAttempts++;
    _updateState(WebSocketConnectionState.reconnecting);

    _reconnectTimer = Timer(delay, connect);
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(pingInterval, (_) {
      send({'action': 'ping', 'timestamp': DateTime.now().toIso8601String()});
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _updateState(WebSocketConnectionState newState) {
    if (_state != newState) {
      _state = newState;
      _connectionController.add(newState);
    }
  }

  void dispose() {
    _intentionallyClosed = true;
    _reconnectTimer?.cancel();
    _stopPing();
    _socket?.close(WebSocketStatus.normalClosure);
    _messageController.close();
    _connectionController.close();
  }
}

class SyncEvent {

  const SyncEvent({required this.type, this.table, this.recordId, this.data, this.timestamp});
  final String type;
  final String? table;
  final String? recordId;
  final Map<String, dynamic>? data;
  final DateTime? timestamp;
}

enum WebSocketConnectionState { disconnected, connecting, connected, reconnecting, error }
