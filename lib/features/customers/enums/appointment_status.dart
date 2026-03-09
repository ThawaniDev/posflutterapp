enum AppointmentStatus {
  scheduled('scheduled'),
  confirmed('confirmed'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('no_show');

  const AppointmentStatus(this.value);
  final String value;

  static AppointmentStatus fromValue(String value) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AppointmentStatus: $value'),
    );
  }

  static AppointmentStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
