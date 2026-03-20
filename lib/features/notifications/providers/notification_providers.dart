import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/notifications/repositories/notification_repository.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

// ─── Notification List Provider ─────────────────────────
class NotificationListNotifier extends StateNotifier<NotificationListState> {
  final NotificationRepository _repository;
  NotificationListNotifier(this._repository) : super(const NotificationListInitial());

  Future<void> load({String? category, bool? isRead, int? limit}) async {
    if (state is! NotificationListLoaded) state = const NotificationListLoading();
    try {
      final result = await _repository.listNotifications(category: category, isRead: isRead, limit: limit);
      final data = result['data'] as List<dynamic>? ?? [];
      state = NotificationListLoaded(data.cast<Map<String, dynamic>>());
    } catch (e) {
      if (state is! NotificationListLoaded) state = NotificationListError(e.toString());
    }
  }
}

final notificationListProvider = StateNotifierProvider<NotificationListNotifier, NotificationListState>((ref) {
  return NotificationListNotifier(ref.watch(notificationRepositoryProvider));
});

// ─── Unread Count Provider ──────────────────────────────
class UnreadCountNotifier extends StateNotifier<UnreadCountState> {
  final NotificationRepository _repository;
  UnreadCountNotifier(this._repository) : super(const UnreadCountInitial());

  Future<void> load() async {
    if (state is! UnreadCountLoaded) state = const UnreadCountLoading();
    try {
      final result = await _repository.getUnreadCount();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = UnreadCountLoaded(data['unread_count'] as int? ?? 0);
    } catch (e) {
      if (state is! UnreadCountLoaded) state = UnreadCountError(e.toString());
    }
  }
}

final unreadCountProvider = StateNotifierProvider<UnreadCountNotifier, UnreadCountState>((ref) {
  return UnreadCountNotifier(ref.watch(notificationRepositoryProvider));
});

// ─── Notification Action Provider ───────────────────────
class NotificationActionNotifier extends StateNotifier<NotificationActionState> {
  final NotificationRepository _repository;
  NotificationActionNotifier(this._repository) : super(const NotificationActionInitial());

  Future<void> markAsRead(String id) async {
    state = const NotificationActionLoading();
    try {
      await _repository.markAsRead(id);
      state = const NotificationActionSuccess('Notification marked as read');
    } catch (e) {
      state = NotificationActionError(e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    state = const NotificationActionLoading();
    try {
      await _repository.markAllAsRead();
      state = const NotificationActionSuccess('All notifications marked as read');
    } catch (e) {
      state = NotificationActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const NotificationActionLoading();
    try {
      await _repository.deleteNotification(id);
      state = const NotificationActionSuccess('Notification deleted');
    } catch (e) {
      state = NotificationActionError(e.toString());
    }
  }

  void reset() => state = const NotificationActionInitial();
}

final notificationActionProvider = StateNotifierProvider<NotificationActionNotifier, NotificationActionState>((ref) {
  return NotificationActionNotifier(ref.watch(notificationRepositoryProvider));
});

// ─── Preferences Provider ───────────────────────────────
class NotificationPreferencesNotifier extends StateNotifier<NotificationPreferencesState> {
  final NotificationRepository _repository;
  NotificationPreferencesNotifier(this._repository) : super(const NotificationPreferencesInitial());

  Future<void> load() async {
    if (state is! NotificationPreferencesLoaded) state = const NotificationPreferencesLoading();
    try {
      final result = await _repository.getPreferences();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = NotificationPreferencesLoaded(
        preferences: (data['preferences'] as Map<String, dynamic>?) ?? {},
        quietHoursStart: data['quiet_hours_start'] as String?,
        quietHoursEnd: data['quiet_hours_end'] as String?,
      );
    } catch (e) {
      if (state is! NotificationPreferencesLoaded) state = NotificationPreferencesError(e.toString());
    }
  }

  Future<void> update({Map<String, dynamic>? preferences, String? quietHoursStart, String? quietHoursEnd}) async {
    state = const NotificationPreferencesLoading();
    try {
      final result = await _repository.updatePreferences(
        preferences: preferences,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
      );
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = NotificationPreferencesLoaded(
        preferences: (data['preferences'] as Map<String, dynamic>?) ?? {},
        quietHoursStart: data['quiet_hours_start'] as String?,
        quietHoursEnd: data['quiet_hours_end'] as String?,
      );
    } catch (e) {
      state = NotificationPreferencesError(e.toString());
    }
  }
}

final notificationPreferencesProvider = StateNotifierProvider<NotificationPreferencesNotifier, NotificationPreferencesState>((
  ref,
) {
  return NotificationPreferencesNotifier(ref.watch(notificationRepositoryProvider));
});

// ─── FCM Token Provider ─────────────────────────────────
class FcmTokenNotifier extends StateNotifier<FcmTokenState> {
  final NotificationRepository _repository;
  FcmTokenNotifier(this._repository) : super(const FcmTokenInitial());

  Future<void> register({required String token, required String deviceType}) async {
    state = const FcmTokenLoading();
    try {
      await _repository.registerFcmToken(token: token, deviceType: deviceType);
      state = FcmTokenRegistered(token: token, deviceType: deviceType);
    } catch (e) {
      state = FcmTokenError(e.toString());
    }
  }

  Future<void> remove(String token) async {
    state = const FcmTokenLoading();
    try {
      await _repository.removeFcmToken(token);
      state = const FcmTokenRemoved();
    } catch (e) {
      state = FcmTokenError(e.toString());
    }
  }
}

final fcmTokenProvider = StateNotifierProvider<FcmTokenNotifier, FcmTokenState>((ref) {
  return FcmTokenNotifier(ref.watch(notificationRepositoryProvider));
});
