enum ReminderType {
  upcoming('upcoming'),
  overdue('overdue');

  const ReminderType(this.value);
  final String value;

  static ReminderType fromValue(String value) {
    return ReminderType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ReminderType: $value'),
    );
  }

  static ReminderType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
