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
  final List<Map<String, dynamic>> notifications;
  const NotificationListLoaded(this.notifications);
}

class NotificationListError extends NotificationListState {
  final String message;
  const NotificationListError(this.message);
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
  final int count;
  final Map<String, int>? byCategory;
  const UnreadCountLoaded(this.count, {this.byCategory});
}

class UnreadCountError extends UnreadCountState {
  final String message;
  const UnreadCountError(this.message);
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
  final String message;
  const NotificationActionSuccess(this.message);
}

class NotificationActionError extends NotificationActionState {
  final String message;
  const NotificationActionError(this.message);
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
  final Map<String, dynamic> preferences;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final bool? soundEnabled;
  final String? emailDigest;
  const NotificationPreferencesLoaded({
    required this.preferences,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.soundEnabled,
    this.emailDigest,
  });
}

class NotificationPreferencesError extends NotificationPreferencesState {
  final String message;
  const NotificationPreferencesError(this.message);
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
  final String token;
  final String deviceType;
  const FcmTokenRegistered({required this.token, required this.deviceType});
}

class FcmTokenRemoved extends FcmTokenState {
  const FcmTokenRemoved();
}

class FcmTokenError extends FcmTokenState {
  final String message;
  const FcmTokenError(this.message);
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
  final List<NotificationDeliveryLog> logs;
  const DeliveryLogsLoaded(this.logs);
}

class DeliveryLogsError extends DeliveryLogsState {
  final String message;
  const DeliveryLogsError(this.message);
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
  final List<NotificationSoundConfig> configs;
  const SoundConfigsLoaded(this.configs);
}

class SoundConfigsError extends SoundConfigsState {
  final String message;
  const SoundConfigsError(this.message);
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
  final List<NotificationSchedule> schedules;
  const SchedulesLoaded(this.schedules);
}

class SchedulesError extends SchedulesState {
  final String message;
  const SchedulesError(this.message);
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
  final Map<String, dynamic> stats;
  const NotificationStatsLoaded(this.stats);
}

class NotificationStatsError extends NotificationStatsState {
  final String message;
  const NotificationStatsError(this.message);
}
