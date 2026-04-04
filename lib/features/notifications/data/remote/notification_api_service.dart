import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class NotificationApiService {
  final Dio _dio;

  NotificationApiService(this._dio);

  /// GET /notifications — List notifications
  Future<Map<String, dynamic>> listNotifications({
    String? category,
    bool? isRead,
    int? limit,
    String? priority,
    String? dateFrom,
    String? dateTo,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (isRead != null) queryParams['is_read'] = isRead ? 1 : 0;
    if (limit != null) queryParams['limit'] = limit;
    if (priority != null) queryParams['priority'] = priority;
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;

    final response = await _dio.get(ApiEndpoints.notifications, queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  /// POST /notifications — Create a notification
  Future<Map<String, dynamic>> createNotification({
    required String category,
    required String title,
    required String message,
    String? actionUrl,
    String? referenceType,
    String? referenceId,
    String? priority,
    String? channel,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.notifications,
      data: {
        'category': category,
        'title': title,
        'message': message,
        if (actionUrl != null) 'action_url': actionUrl,
        if (referenceType != null) 'reference_type': referenceType,
        if (referenceId != null) 'reference_id': referenceId,
        if (priority != null) 'priority': priority,
        if (channel != null) 'channel': channel,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /notifications/batch — Create batch notifications
  Future<Map<String, dynamic>> createBatch({
    required String category,
    required String title,
    required String message,
    required List<String> userIds,
    String? priority,
    String? channel,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.notificationBatch,
      data: {
        'category': category,
        'title': title,
        'message': message,
        'user_ids': userIds,
        if (priority != null) 'priority': priority,
        if (channel != null) 'channel': channel,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /notifications/bulk — Bulk delete notifications
  Future<Map<String, dynamic>> bulkDelete({required List<String> ids}) async {
    final response = await _dio.delete(ApiEndpoints.notificationBulkDelete, data: {'ids': ids});
    return response.data as Map<String, dynamic>;
  }

  /// GET /notifications/unread-count
  Future<Map<String, dynamic>> getUnreadCount() async {
    final response = await _dio.get(ApiEndpoints.notificationUnreadCount);
    return response.data as Map<String, dynamic>;
  }

  /// GET /notifications/unread-count-by-category
  Future<Map<String, dynamic>> getUnreadCountByCategory() async {
    final response = await _dio.get(ApiEndpoints.notificationUnreadCountByCategory);
    return response.data as Map<String, dynamic>;
  }

  /// GET /notifications/stats
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(ApiEndpoints.notificationStats);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /notifications/{id}/read — Mark one as read
  Future<Map<String, dynamic>> markAsRead(String id) async {
    final response = await _dio.put(ApiEndpoints.notificationMarkRead(id));
    return response.data as Map<String, dynamic>;
  }

  /// PUT /notifications/read-all — Mark all as read
  Future<Map<String, dynamic>> markAllAsRead() async {
    final response = await _dio.put(ApiEndpoints.notificationReadAll);
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /notifications/{id}
  Future<Map<String, dynamic>> deleteNotification(String id) async {
    final response = await _dio.delete(ApiEndpoints.notificationDelete(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── Delivery Logs ────────────────────────────────────────

  /// GET /notifications/delivery-logs
  Future<Map<String, dynamic>> getDeliveryLogs({String? channel, String? status, int? perPage}) async {
    final response = await _dio.get(
      ApiEndpoints.notificationDeliveryLogs,
      queryParameters: {
        if (channel != null) 'channel': channel,
        if (status != null) 'status': status,
        if (perPage != null) 'per_page': perPage,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /notifications/delivery-stats
  Future<Map<String, dynamic>> getDeliveryStats() async {
    final response = await _dio.get(ApiEndpoints.notificationDeliveryStats);
    return response.data as Map<String, dynamic>;
  }

  // ─── Preferences ──────────────────────────────────────────

  /// GET /notifications/preferences
  Future<Map<String, dynamic>> getPreferences() async {
    final response = await _dio.get(ApiEndpoints.notificationPreferences);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /notifications/preferences
  Future<Map<String, dynamic>> updatePreferences({
    Map<String, dynamic>? preferences,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? soundEnabled,
    String? emailDigest,
  }) async {
    final response = await _dio.put(
      ApiEndpoints.notificationPreferences,
      data: {
        if (preferences != null) 'preferences': preferences,
        if (quietHoursStart != null) 'quiet_hours_start': quietHoursStart,
        if (quietHoursEnd != null) 'quiet_hours_end': quietHoursEnd,
        if (soundEnabled != null) 'sound_enabled': soundEnabled,
        if (emailDigest != null) 'email_digest': emailDigest,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  // ─── Sound Configs ────────────────────────────────────────

  /// GET /notifications/sound-configs
  Future<Map<String, dynamic>> getSoundConfigs() async {
    final response = await _dio.get(ApiEndpoints.notificationSoundConfigs);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /notifications/sound-configs
  Future<Map<String, dynamic>> updateSoundConfig({
    required String eventKey,
    String? soundFile,
    double? volume,
    bool? isEnabled,
  }) async {
    final response = await _dio.put(
      ApiEndpoints.notificationSoundConfigs,
      data: {
        'event_key': eventKey,
        if (soundFile != null) 'sound_file': soundFile,
        if (volume != null) 'volume': volume,
        if (isEnabled != null) 'is_enabled': isEnabled,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  // ─── Schedules ────────────────────────────────────────────

  /// GET /notifications/schedules
  Future<Map<String, dynamic>> getSchedules() async {
    final response = await _dio.get(ApiEndpoints.notificationSchedules);
    return response.data as Map<String, dynamic>;
  }

  /// POST /notifications/schedules
  Future<Map<String, dynamic>> createSchedule({
    required String category,
    required String title,
    required String message,
    required String channel,
    required String scheduledAt,
    String? priority,
    String? recurrenceRule,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.notificationSchedules,
      data: {
        'category': category,
        'title': title,
        'message': message,
        'channel': channel,
        'scheduled_at': scheduledAt,
        if (priority != null) 'priority': priority,
        if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// PUT /notifications/schedules/{id}/cancel
  Future<Map<String, dynamic>> cancelSchedule(String id) async {
    final response = await _dio.put(ApiEndpoints.notificationScheduleCancel(id));
    return response.data as Map<String, dynamic>;
  }

  // ─── FCM Tokens ───────────────────────────────────────────

  /// POST /notifications/fcm-tokens — Register FCM token
  Future<Map<String, dynamic>> registerFcmToken({required String token, required String deviceType}) async {
    final response = await _dio.post(ApiEndpoints.fcmTokens, data: {'token': token, 'device_type': deviceType});
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /notifications/fcm-tokens — Remove FCM token
  Future<Map<String, dynamic>> removeFcmToken(String token) async {
    final response = await _dio.delete(ApiEndpoints.fcmTokens, data: {'token': token});
    return response.data as Map<String, dynamic>;
  }
}

final notificationApiServiceProvider = Provider<NotificationApiService>((ref) {
  return NotificationApiService(ref.watch(dioClientProvider));
});
