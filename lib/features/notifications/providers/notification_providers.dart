import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/notifications/models/notification_delivery_log.dart';
import 'package:thawani_pos/features/notifications/models/notification_schedule.dart';
import 'package:thawani_pos/features/notifications/models/notification_sound_config.dart';
import 'package:thawani_pos/features/notifications/repositories/notification_repository.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

// ─── Notification List Provider ─────────────────────────
class NotificationListNotifier extends StateNotifier<NotificationListState> {
  final NotificationRepository _repository;
  NotificationListNotifier(this._repository) : super(const NotificationListInitial());

  Future<void> load({String? category, bool? isRead, int? limit, String? priority}) async {
    if (state is! NotificationListLoaded) state = const NotificationListLoading();
    try {
      final result = await _repository.listNotifications(category: category, isRead: isRead, limit: limit, priority: priority);
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

  Future<void> loadByCategory() async {
    if (state is! UnreadCountLoaded) state = const UnreadCountLoading();
    try {
      final result = await _repository.getUnreadCountByCategory();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final byCategory = <String, int>{};
      int total = 0;
      data.forEach((key, value) {
        final count = (value as num?)?.toInt() ?? 0;
        byCategory[key] = count;
        total += count;
      });
      state = UnreadCountLoaded(total, byCategory: byCategory);
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

  Future<void> bulkDelete(List<String> ids) async {
    state = const NotificationActionLoading();
    try {
      await _repository.bulkDelete(ids: ids);
      state = NotificationActionSuccess('${ids.length} notifications deleted');
    } catch (e) {
      state = NotificationActionError(e.toString());
    }
  }

  Future<void> createBatch({
    required String category,
    required String title,
    required String message,
    required List<String> userIds,
    String? priority,
    String? channel,
  }) async {
    state = const NotificationActionLoading();
    try {
      await _repository.createBatch(
        category: category,
        title: title,
        message: message,
        userIds: userIds,
        priority: priority,
        channel: channel,
      );
      state = const NotificationActionSuccess('Batch notification created');
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
        soundEnabled: data['sound_enabled'] as bool?,
        emailDigest: data['email_digest'] as String?,
      );
    } catch (e) {
      if (state is! NotificationPreferencesLoaded) state = NotificationPreferencesError(e.toString());
    }
  }

  Future<void> update({
    Map<String, dynamic>? preferences,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? soundEnabled,
    String? emailDigest,
  }) async {
    state = const NotificationPreferencesLoading();
    try {
      final result = await _repository.updatePreferences(
        preferences: preferences,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
        soundEnabled: soundEnabled,
        emailDigest: emailDigest,
      );
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = NotificationPreferencesLoaded(
        preferences: (data['preferences'] as Map<String, dynamic>?) ?? {},
        quietHoursStart: data['quiet_hours_start'] as String?,
        quietHoursEnd: data['quiet_hours_end'] as String?,
        soundEnabled: data['sound_enabled'] as bool?,
        emailDigest: data['email_digest'] as String?,
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

// ─── Delivery Logs Provider ─────────────────────────────
class DeliveryLogsNotifier extends StateNotifier<DeliveryLogsState> {
  final NotificationRepository _repository;
  DeliveryLogsNotifier(this._repository) : super(const DeliveryLogsInitial());

  Future<void> load({String? channel, String? status, int? perPage}) async {
    if (state is! DeliveryLogsLoaded) state = const DeliveryLogsLoading();
    try {
      final result = await _repository.getDeliveryLogs(channel: channel, status: status, perPage: perPage);
      final raw = result['data'] as Map<String, dynamic>? ?? {};
      final list = (raw['data'] as List?)?.map((e) => NotificationDeliveryLog.fromJson(e as Map<String, dynamic>)).toList() ?? [];
      state = DeliveryLogsLoaded(list);
    } catch (e) {
      if (state is! DeliveryLogsLoaded) state = DeliveryLogsError(e.toString());
    }
  }
}

final deliveryLogsProvider = StateNotifierProvider<DeliveryLogsNotifier, DeliveryLogsState>((ref) {
  return DeliveryLogsNotifier(ref.watch(notificationRepositoryProvider));
});

// ─── Sound Configs Provider ─────────────────────────────
class SoundConfigsNotifier extends StateNotifier<SoundConfigsState> {
  final NotificationRepository _repository;
  SoundConfigsNotifier(this._repository) : super(const SoundConfigsInitial());

  Future<void> load() async {
    if (state is! SoundConfigsLoaded) state = const SoundConfigsLoading();
    try {
      final result = await _repository.getSoundConfigs();
      final items =
          (result['data'] as List?)?.map((e) => NotificationSoundConfig.fromJson(e as Map<String, dynamic>)).toList() ?? [];
      state = SoundConfigsLoaded(items);
    } catch (e) {
      if (state is! SoundConfigsLoaded) state = SoundConfigsError(e.toString());
    }
  }

  Future<void> updateConfig({required String eventKey, String? soundFile, double? volume, bool? isEnabled}) async {
    state = const SoundConfigsLoading();
    try {
      await _repository.updateSoundConfig(eventKey: eventKey, soundFile: soundFile, volume: volume, isEnabled: isEnabled);
      await load();
    } catch (e) {
      state = SoundConfigsError(e.toString());
    }
  }
}

final soundConfigsProvider = StateNotifierProvider<SoundConfigsNotifier, SoundConfigsState>((ref) {
  return SoundConfigsNotifier(ref.watch(notificationRepositoryProvider));
});

// ─── Schedules Provider ─────────────────────────────────
class SchedulesNotifier extends StateNotifier<SchedulesState> {
  final NotificationRepository _repository;
  SchedulesNotifier(this._repository) : super(const SchedulesInitial());

  Future<void> load() async {
    if (state is! SchedulesLoaded) state = const SchedulesLoading();
    try {
      final result = await _repository.getSchedules();
      final items =
          (result['data'] as List?)?.map((e) => NotificationSchedule.fromJson(e as Map<String, dynamic>)).toList() ?? [];
      state = SchedulesLoaded(items);
    } catch (e) {
      if (state is! SchedulesLoaded) state = SchedulesError(e.toString());
    }
  }

  Future<void> create({
    required String category,
    required String title,
    required String message,
    required String channel,
    required String scheduledAt,
    String? priority,
    String? recurrenceRule,
  }) async {
    state = const SchedulesLoading();
    try {
      await _repository.createSchedule(
        category: category,
        title: title,
        message: message,
        channel: channel,
        scheduledAt: scheduledAt,
        priority: priority,
        recurrenceRule: recurrenceRule,
      );
      await load();
    } catch (e) {
      state = SchedulesError(e.toString());
    }
  }

  Future<void> cancel(String id) async {
    state = const SchedulesLoading();
    try {
      await _repository.cancelSchedule(id);
      await load();
    } catch (e) {
      state = SchedulesError(e.toString());
    }
  }
}

final schedulesProvider = StateNotifierProvider<SchedulesNotifier, SchedulesState>((ref) {
  return SchedulesNotifier(ref.watch(notificationRepositoryProvider));
});

// ─── Notification Stats Provider ────────────────────────
class NotificationStatsNotifier extends StateNotifier<NotificationStatsState> {
  final NotificationRepository _repository;
  NotificationStatsNotifier(this._repository) : super(const NotificationStatsInitial());

  Future<void> load() async {
    if (state is! NotificationStatsLoaded) state = const NotificationStatsLoading();
    try {
      final result = await _repository.getStats();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = NotificationStatsLoaded(data);
    } catch (e) {
      if (state is! NotificationStatsLoaded) state = NotificationStatsError(e.toString());
    }
  }
}

final notificationStatsProvider = StateNotifierProvider<NotificationStatsNotifier, NotificationStatsState>((ref) {
  return NotificationStatsNotifier(ref.watch(notificationRepositoryProvider));
});
