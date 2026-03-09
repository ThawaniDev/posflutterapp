enum SecurityAlertStatus {
  newValue('new'),
  investigating('investigating'),
  resolved('resolved');

  const SecurityAlertStatus(this.value);
  final String value;

  static SecurityAlertStatus fromValue(String value) {
    return SecurityAlertStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SecurityAlertStatus: $value'),
    );
  }

  static SecurityAlertStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
