enum ReminderChannel {
  email('email'),
  sms('sms'),
  push('push');

  const ReminderChannel(this.value);
  final String value;

  static ReminderChannel fromValue(String value) {
    return ReminderChannel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ReminderChannel: $value'),
    );
  }

  static ReminderChannel? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
