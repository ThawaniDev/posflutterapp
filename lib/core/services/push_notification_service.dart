import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';

/// Top-level handler for background/terminated FCM messages.
/// Must be a top-level function (not a method or closure).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized (via main.dart).
  // Background messages are automatically displayed by the system tray on
  // Android/iOS when the payload contains a `notification` block.
  debugPrint('FCM background message: ${message.messageId}');
}

/// Service that manages Firebase Cloud Messaging lifecycle:
/// - Requests permissions
/// - Obtains and registers the device token with the backend
/// - Listens for foreground messages
/// - Handles notification taps (onMessageOpenedApp / getInitialMessage)
class PushNotificationService {
  PushNotificationService(this._ref);

  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _listenersSetUp = false;

  /// Call every time the user becomes authenticated.
  /// Sets up listeners once, but always re-registers the FCM token.
  Future<void> initialize() async {
    // One-time: permission + listeners
    if (!_listenersSetUp) {
      _listenersSetUp = true;

      await _requestPermission();

      _messaging.onTokenRefresh.listen(_onTokenRefresh);
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _onMessageOpenedApp(initialMessage);
      }
    }

    // Always register the token (backend may have cleared it on logout)
    await _registerToken();
  }

  // ─── Permission ──────────────────────────────────────────

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  // ─── Token Management ────────────────────────────────────

  Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      final deviceType = _deviceType();
      _ref.read(fcmTokenProvider.notifier).register(
        token: token,
        deviceType: deviceType,
      );
      debugPrint('FCM token registered ($deviceType): ${token.substring(0, 20)}...');
    } catch (e) {
      debugPrint('FCM token registration failed: $e');
    }
  }

  void _onTokenRefresh(String token) {
    final deviceType = _deviceType();
    _ref.read(fcmTokenProvider.notifier).register(
      token: token,
      deviceType: deviceType,
    );
    debugPrint('FCM token refreshed ($deviceType)');
  }

  // ─── Message Handlers ────────────────────────────────────

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('FCM foreground: ${message.notification?.title}');

    // Refresh the unread count so the badge updates in real-time
    _ref.read(unreadCountProvider.notifier).load();
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('FCM opened app: ${message.data}');

    // Refresh notifications list
    _ref.read(unreadCountProvider.notifier).load();

    // Deep link based on reference_type / reference_id from data payload
    // The go_router handles routes; we can navigate via the data payload.
    // For now, the notification list page will be the landing target.
    // Future: use message.data['reference_type'] + message.data['reference_id']
    // to navigate to the specific screen.
  }

  // ─── Helpers ─────────────────────────────────────────────

  String _deviceType() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }
}

/// Provider for the push notification service singleton.
final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService(ref);
});
