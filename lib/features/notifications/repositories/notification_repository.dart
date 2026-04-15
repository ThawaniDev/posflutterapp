import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/notifications/data/remote/notification_api_service.dart';

class NotificationRepository {
  final NotificationApiService _apiService;

  NotificationRepository(this._apiService);

  Future<Map<String, dynamic>> listNotifications({
    String? category,
    bool? isRead,
    int? limit,
    String? priority,
    String? dateFrom,
    String? dateTo,
  }) => _apiService.listNotifications(
    category: category,
    isRead: isRead,
    limit: limit,
    priority: priority,
    dateFrom: dateFrom,
    dateTo: dateTo,
  );

  Future<Map<String, dynamic>> createNotification({
    required String category,
    required String title,
    required String message,
    String? actionUrl,
    String? referenceType,
    String? referenceId,
    String? priority,
    String? channel,
  }) => _apiService.createNotification(
    category: category,
    title: title,
    message: message,
    actionUrl: actionUrl,
    referenceType: referenceType,
    referenceId: referenceId,
    priority: priority,
    channel: channel,
  );

  Future<Map<String, dynamic>> createBatch({
    required String category,
    required String title,
    required String message,
    required List<String> userIds,
    String? priority,
    String? channel,
  }) => _apiService.createBatch(
    category: category,
    title: title,
    message: message,
    userIds: userIds,
    priority: priority,
    channel: channel,
  );

  Future<Map<String, dynamic>> bulkDelete({required List<String> ids}) => _apiService.bulkDelete(ids: ids);

  Future<Map<String, dynamic>> getUnreadCount() => _apiService.getUnreadCount();

  Future<Map<String, dynamic>> getUnreadCountByCategory() => _apiService.getUnreadCountByCategory();

  Future<Map<String, dynamic>> getStats() => _apiService.getStats();

  Future<Map<String, dynamic>> markAsRead(String id) => _apiService.markAsRead(id);

  Future<Map<String, dynamic>> markAllAsRead() => _apiService.markAllAsRead();

  Future<Map<String, dynamic>> deleteNotification(String id) => _apiService.deleteNotification(id);

  Future<Map<String, dynamic>> getDeliveryLogs({String? channel, String? status, int? perPage}) =>
      _apiService.getDeliveryLogs(channel: channel, status: status, perPage: perPage);

  Future<Map<String, dynamic>> getDeliveryStats() => _apiService.getDeliveryStats();

  Future<Map<String, dynamic>> getPreferences() => _apiService.getPreferences();

  Future<Map<String, dynamic>> updatePreferences({
    Map<String, dynamic>? preferences,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? soundEnabled,
    String? emailDigest,
  }) => _apiService.updatePreferences(
    preferences: preferences,
    quietHoursStart: quietHoursStart,
    quietHoursEnd: quietHoursEnd,
    soundEnabled: soundEnabled,
    emailDigest: emailDigest,
  );

  Future<Map<String, dynamic>> getSoundConfigs() => _apiService.getSoundConfigs();

  Future<Map<String, dynamic>> updateSoundConfig({
    required String eventKey,
    String? soundFile,
    double? volume,
    bool? isEnabled,
  }) => _apiService.updateSoundConfig(eventKey: eventKey, soundFile: soundFile, volume: volume, isEnabled: isEnabled);

  Future<Map<String, dynamic>> getSchedules() => _apiService.getSchedules();

  Future<Map<String, dynamic>> createSchedule({
    required String category,
    required String title,
    required String message,
    required String channel,
    required String scheduledAt,
    String? priority,
    String? recurrenceRule,
    String scheduleType = 'once',
  }) => _apiService.createSchedule(
    category: category,
    title: title,
    message: message,
    channel: channel,
    scheduledAt: scheduledAt,
    priority: priority,
    recurrenceRule: recurrenceRule,
    scheduleType: scheduleType,
  );

  Future<Map<String, dynamic>> cancelSchedule(String id) => _apiService.cancelSchedule(id);

  Future<Map<String, dynamic>> registerFcmToken({required String token, required String deviceType}) =>
      _apiService.registerFcmToken(token: token, deviceType: deviceType);

  Future<Map<String, dynamic>> removeFcmToken(String token) => _apiService.removeFcmToken(token);
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(notificationApiServiceProvider));
});
