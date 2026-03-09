enum NotificationChannel {
  inApp('in_app'),
  push('push'),
  sms('sms'),
  email('email'),
  whatsapp('whatsapp'),
  sound('sound');

  const NotificationChannel(this.value);
  final String value;

  static NotificationChannel fromValue(String value) {
    return NotificationChannel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid NotificationChannel: $value'),
    );
  }

  static NotificationChannel? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
