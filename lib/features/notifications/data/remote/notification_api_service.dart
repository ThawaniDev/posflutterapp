import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class NotificationApiService {
  final Dio _dio;

  NotificationApiService(this._dio);

  /// GET /notifications — List notifications
  Future<Map<String, dynamic>> listNotifications({String? category, bool? isRead, int? limit}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (isRead != null) queryParams['is_read'] = isRead ? 1 : 0;
    if (limit != null) queryParams['limit'] = limit;

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
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /notifications/unread-count
  Future<Map<String, dynamic>> getUnreadCount() async {
    final response = await _dio.get(ApiEndpoints.notificationUnreadCount);
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
  }) async {
    final response = await _dio.put(
      ApiEndpoints.notificationPreferences,
      data: {
        if (preferences != null) 'preferences': preferences,
        if (quietHoursStart != null) 'quiet_hours_start': quietHoursStart,
        if (quietHoursEnd != null) 'quiet_hours_end': quietHoursEnd,
      },
    );
    return response.data as Map<String, dynamic>;
  }

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
