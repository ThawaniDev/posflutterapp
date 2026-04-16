import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

/// Notification channel for Android heads-up notifications.
const _androidChannel = AndroidNotificationChannel(
  'wameedpos_push', // id
  'WameedPOS Notifications', // name
  description: 'Push notifications from WameedPOS',
  importance: Importance.high,
);

/// Service that manages Firebase Cloud Messaging lifecycle:
/// - Requests permissions
/// - Obtains and registers the device token with the backend
/// - Listens for foreground messages (shows local notification)
/// - Handles notification taps (onMessageOpenedApp / getInitialMessage)
class PushNotificationService {
  PushNotificationService(this._ref);

  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _listenersSetUp = false;

  /// Call every time the user becomes authenticated.
  /// Sets up listeners once, but always re-registers the FCM token.
  Future<void> initialize() async {
    // One-time: permission + listeners + local notifications setup
    if (!_listenersSetUp) {
      _listenersSetUp = true;

      await _requestPermission();
      await _initLocalNotifications();

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

  // ─── Local Notifications Setup ───────────────────────

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(initSettings, onDidReceiveNotificationResponse: _onLocalNotificationTap);

    // Create the Android notification channel for high-importance
    if (!kIsWeb && Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
    }
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    // Refresh notifications when user taps the local notification
    _ref.read(unreadCountProvider.notifier).load();
  }

  // ─── Permission ──────────────────────────────────────────

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true, provisional: false);
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  // ─── Token Management ────────────────────────────────────

  Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      final deviceType = _deviceType();
      _ref.read(fcmTokenProvider.notifier).register(token: token, deviceType: deviceType);
      debugPrint('FCM token registered ($deviceType): ${token.substring(0, 20)}...');
    } catch (e) {
      debugPrint('FCM token registration failed: $e');
    }
  }

  void _onTokenRefresh(String token) {
    final deviceType = _deviceType();
    _ref.read(fcmTokenProvider.notifier).register(token: token, deviceType: deviceType);
    debugPrint('FCM token refreshed ($deviceType)');
  }

  // ─── Message Handlers ────────────────────────────────────

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('FCM foreground: ${message.notification?.title}');

    // Show a visible heads-up notification while app is in foreground
    final notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        payload: message.data['reference_type'],
      );
    }

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

  // ─── Cleanup on Logout ────────────────────────────────

  /// Remove the current FCM token from the backend so the user
  /// stops receiving push notifications after logout.
  Future<void> unregisterToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        _ref.read(fcmTokenProvider.notifier).remove(token);
        debugPrint('FCM token unregistered on logout');
      }
    } catch (e) {
      debugPrint('FCM token unregister failed: $e');
    }
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
