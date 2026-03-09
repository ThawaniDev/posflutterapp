enum StaffStatus {
  active('active'),
  inactive('inactive'),
  onLeave('on_leave');

  const StaffStatus(this.value);
  final String value;

  static StaffStatus fromValue(String value) {
    return StaffStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StaffStatus: $value'),
    );
  }

  static StaffStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
