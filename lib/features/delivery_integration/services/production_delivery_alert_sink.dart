import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:wameedpos/features/delivery_integration/services/delivery_alert_service.dart';

/// Production [DeliveryAlertSink] — plays an audible chime via
/// [audioplayers] and shows a system notification via
/// [flutter_local_notifications]. Both side-effects are wrapped in
/// try/catch so a missing asset / lacking OS permission never crashes
/// the order pipeline.
class ProductionDeliveryAlertSink implements DeliveryAlertSink {
  ProductionDeliveryAlertSink({AudioPlayer? player, FlutterLocalNotificationsPlugin? notifications})
    : _player = player ?? AudioPlayer(),
      _notifications = notifications ?? FlutterLocalNotificationsPlugin();

  final AudioPlayer _player;
  final FlutterLocalNotificationsPlugin _notifications;

  static const _channelId = 'delivery_orders';
  static const _channelName = 'Delivery Orders';

  @override
  Future<void> notifyNewOrder(Map<String, dynamic> order) async {
    await _playChime();
    await _showNotification(order);
  }

  Future<void> _playChime() async {
    try {
      await _player.play(AssetSource('audio/chime.wav'));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('DeliveryAlertSink chime failed: $e\n$st');
      }
    }
  }

  Future<void> _showNotification(Map<String, dynamic> order) async {
    try {
      final platform = (order['platform'] ?? '').toString();
      final id = (order['id'] ?? order['order_id'] ?? order['external_order_id'] ?? '').toString();
      final total = order['total_amount'] ?? order['total'];

      final title = platform.isEmpty ? 'New delivery order' : 'New $platform order';
      final body = total != null ? 'Order $id · Total $total' : 'Order $id';

      await _notifications.show(
        id.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: 'New delivery orders from connected platforms',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('DeliveryAlertSink notification failed: $e\n$st');
      }
    }
  }
}
