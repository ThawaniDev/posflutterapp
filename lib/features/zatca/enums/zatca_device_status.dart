enum ZatcaDeviceStatus {
  pending('pending'),
  active('active'),
  suspended('suspended'),
  tampered('tampered'),
  revoked('revoked');

  const ZatcaDeviceStatus(this.value);
  final String value;

  static ZatcaDeviceStatus fromValue(String value) =>
      ZatcaDeviceStatus.values.firstWhere((e) => e.value == value, orElse: () => ZatcaDeviceStatus.pending);

  static ZatcaDeviceStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return ZatcaDeviceStatus.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
