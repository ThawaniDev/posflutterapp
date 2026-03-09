enum ZatcaComplianceStatus {
  pending('pending'),
  submitted('submitted'),
  accepted('accepted'),
  rejected('rejected');

  const ZatcaComplianceStatus(this.value);
  final String value;

  static ZatcaComplianceStatus fromValue(String value) {
    return ZatcaComplianceStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ZatcaComplianceStatus: $value'),
    );
  }

  static ZatcaComplianceStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
