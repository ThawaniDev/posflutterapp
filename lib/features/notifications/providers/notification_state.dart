import 'package:wameedpos/features/notifications/models/notification_delivery_log.dart';
import 'package:wameedpos/features/notifications/models/notification_schedule.dart';
import 'package:wameedpos/features/notifications/models/notification_sound_config.dart';

// ─── Notification List State ─────────────────────────────
sealed class NotificationListState {
  const NotificationListState();
}

class NotificationListInitial extends NotificationListState {
  const NotificationListInitial();
}

class NotificationListLoading extends NotificationListState {
  const NotificationListLoading();
}

class NotificationListLoaded extends NotificationListState {
  const NotificationListLoaded(this.notifications);
  final List<Map<String, dynamic>> notifications;
}

class NotificationListError extends NotificationListState {
  const NotificationListError(this.message);
  final String message;
}

// ─── Unread Count State ─────────────────────────────────
sealed class UnreadCountState {
  const UnreadCountState();
}

class UnreadCountInitial extends UnreadCountState {
  const UnreadCountInitial();
}

class UnreadCountLoading extends UnreadCountState {
  const UnreadCountLoading();
}

class UnreadCountLoaded extends UnreadCountState {
  const UnreadCountLoaded(this.count, {this.byCategory});
  final int count;
  final Map<String, int>? byCategory;
}

class UnreadCountError extends UnreadCountState {
  const UnreadCountError(this.message);
  final String message;
}

// ─── Notification Action State ──────────────────────────
sealed class NotificationActionState {
  const NotificationActionState();
}

class NotificationActionInitial extends NotificationActionState {
  const NotificationActionInitial();
}

class NotificationActionLoading extends NotificationActionState {
  const NotificationActionLoading();
}

class NotificationActionSuccess extends NotificationActionState {
  const NotificationActionSuccess(this.message);
  final String message;
}

class NotificationActionError extends NotificationActionState {
  const NotificationActionError(this.message);
  final String message;
}

// ─── Preferences State ──────────────────────────────────
sealed class NotificationPreferencesState {
  const NotificationPreferencesState();
}

class NotificationPreferencesInitial extends NotificationPreferencesState {
  const NotificationPreferencesInitial();
}

class NotificationPreferencesLoading extends NotificationPreferencesState {
  const NotificationPreferencesLoading();
}

class NotificationPreferencesLoaded extends NotificationPreferencesState {
  const NotificationPreferencesLoaded({
    required this.preferences,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.soundEnabled,
    this.emailDigest,
  });
  final Map<String, dynamic> preferences;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final bool? soundEnabled;
  final String? emailDigest;
}

class NotificationPreferencesError extends NotificationPreferencesState {
  const NotificationPreferencesError(this.message);
  final String message;
}

// ─── FCM Token State ────────────────────────────────────
sealed class FcmTokenState {
  const FcmTokenState();
}

class FcmTokenInitial extends FcmTokenState {
  const FcmTokenInitial();
}

class FcmTokenLoading extends FcmTokenState {
  const FcmTokenLoading();
}

class FcmTokenRegistered extends FcmTokenState {
  const FcmTokenRegistered({required this.token, required this.deviceType});
  final String token;
  final String deviceType;
}

class FcmTokenRemoved extends FcmTokenState {
  const FcmTokenRemoved();
}

class FcmTokenError extends FcmTokenState {
  const FcmTokenError(this.message);
  final String message;
}

// ─── Delivery Logs State ────────────────────────────────
sealed class DeliveryLogsState {
  const DeliveryLogsState();
}

class DeliveryLogsInitial extends DeliveryLogsState {
  const DeliveryLogsInitial();
}

class DeliveryLogsLoading extends DeliveryLogsState {
  const DeliveryLogsLoading();
}

class DeliveryLogsLoaded extends DeliveryLogsState {
  const DeliveryLogsLoaded(this.logs);
  final List<NotificationDeliveryLog> logs;
}

class DeliveryLogsError extends DeliveryLogsState {
  const DeliveryLogsError(this.message);
  final String message;
}

// ─── Sound Configs State ────────────────────────────────
sealed class SoundConfigsState {
  const SoundConfigsState();
}

class SoundConfigsInitial extends SoundConfigsState {
  const SoundConfigsInitial();
}

class SoundConfigsLoading extends SoundConfigsState {
  const SoundConfigsLoading();
}

class SoundConfigsLoaded extends SoundConfigsState {
  const SoundConfigsLoaded(this.configs);
  final List<NotificationSoundConfig> configs;
}

class SoundConfigsError extends SoundConfigsState {
  const SoundConfigsError(this.message);
  final String message;
}

// ─── Schedules State ────────────────────────────────────
sealed class SchedulesState {
  const SchedulesState();
}

class SchedulesInitial extends SchedulesState {
  const SchedulesInitial();
}

class SchedulesLoading extends SchedulesState {
  const SchedulesLoading();
}

class SchedulesLoaded extends SchedulesState {
  const SchedulesLoaded(this.schedules);
  final List<NotificationSchedule> schedules;
}

class SchedulesError extends SchedulesState {
  const SchedulesError(this.message);
  final String message;
}

// ─── Notification Stats State ───────────────────────────
sealed class NotificationStatsState {
  const NotificationStatsState();
}

class NotificationStatsInitial extends NotificationStatsState {
  const NotificationStatsInitial();
}

class NotificationStatsLoading extends NotificationStatsState {
  const NotificationStatsLoading();
}

class NotificationStatsLoaded extends NotificationStatsState {
  const NotificationStatsLoaded(this.stats);
  final Map<String, dynamic> stats;
}

class NotificationStatsError extends NotificationStatsState {
  const NotificationStatsError(this.message);
  final String message;
}
