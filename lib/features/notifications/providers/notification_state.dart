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
  const UnreadCountLoaded(this.count);
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
  const NotificationPreferencesLoaded({required this.preferences, this.quietHoursStart, this.quietHoursEnd});
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
