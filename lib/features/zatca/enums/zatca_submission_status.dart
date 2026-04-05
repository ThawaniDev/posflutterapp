enum ZatcaSubmissionStatus {
  pending('pending'),
  submitted('submitted'),
  accepted('accepted'),
  reported('reported'),
  rejected('rejected'),
  warning('warning');

  const ZatcaSubmissionStatus(this.value);
  final String value;

  static ZatcaSubmissionStatus fromValue(String value) {
    return ZatcaSubmissionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ZatcaSubmissionStatus: $value'),
    );
  }

  static ZatcaSubmissionStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
