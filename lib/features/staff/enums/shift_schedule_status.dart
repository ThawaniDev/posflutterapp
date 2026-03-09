enum ShiftScheduleStatus {
  scheduled('scheduled'),
  completed('completed'),
  missed('missed'),
  swapped('swapped');

  const ShiftScheduleStatus(this.value);
  final String value;

  static ShiftScheduleStatus fromValue(String value) {
    return ShiftScheduleStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ShiftScheduleStatus: $value'),
    );
  }

  static ShiftScheduleStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
