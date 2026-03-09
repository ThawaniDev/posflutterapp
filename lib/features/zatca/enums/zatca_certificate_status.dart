enum ZatcaCertificateStatus {
  active('active'),
  expired('expired'),
  revoked('revoked');

  const ZatcaCertificateStatus(this.value);
  final String value;

  static ZatcaCertificateStatus fromValue(String value) {
    return ZatcaCertificateStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ZatcaCertificateStatus: $value'),
    );
  }

  static ZatcaCertificateStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
