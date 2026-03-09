enum ZatcaCertificateType {
  compliance('compliance'),
  production('production');

  const ZatcaCertificateType(this.value);
  final String value;

  static ZatcaCertificateType fromValue(String value) {
    return ZatcaCertificateType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ZatcaCertificateType: $value'),
    );
  }

  static ZatcaCertificateType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
