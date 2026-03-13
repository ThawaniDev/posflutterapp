import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/notifications/data/remote/notification_api_service.dart';

class NotificationRepository {
  final NotificationApiService _apiService;

  NotificationRepository(this._apiService);

  Future<Map<String, dynamic>> listNotifications({String? category, bool? isRead, int? limit}) =>
      _apiService.listNotifications(category: category, isRead: isRead, limit: limit);

  Future<Map<String, dynamic>> createNotification({
    required String category,
    required String title,
    required String message,
    String? actionUrl,
    String? referenceType,
    String? referenceId,
  }) => _apiService.createNotification(
    category: category,
    title: title,
    message: message,
    actionUrl: actionUrl,
    referenceType: referenceType,
    referenceId: referenceId,
  );

  Future<Map<String, dynamic>> getUnreadCount() => _apiService.getUnreadCount();

  Future<Map<String, dynamic>> markAsRead(String id) => _apiService.markAsRead(id);

  Future<Map<String, dynamic>> markAllAsRead() => _apiService.markAllAsRead();

  Future<Map<String, dynamic>> deleteNotification(String id) => _apiService.deleteNotification(id);

  Future<Map<String, dynamic>> getPreferences() => _apiService.getPreferences();

  Future<Map<String, dynamic>> updatePreferences({
    Map<String, dynamic>? preferences,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) => _apiService.updatePreferences(preferences: preferences, quietHoursStart: quietHoursStart, quietHoursEnd: quietHoursEnd);

  Future<Map<String, dynamic>> registerFcmToken({required String token, required String deviceType}) =>
      _apiService.registerFcmToken(token: token, deviceType: deviceType);

  Future<Map<String, dynamic>> removeFcmToken(String token) => _apiService.removeFcmToken(token);
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(notificationApiServiceProvider));
});
