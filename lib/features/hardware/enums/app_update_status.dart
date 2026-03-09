enum AppUpdateStatus {
  pending('pending'),
  downloading('downloading'),
  downloaded('downloaded'),
  installed('installed'),
  failed('failed');

  const AppUpdateStatus(this.value);
  final String value;

  static AppUpdateStatus fromValue(String value) {
    return AppUpdateStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AppUpdateStatus: $value'),
    );
  }

  static AppUpdateStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
