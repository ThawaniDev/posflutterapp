enum TaxExemptionType {
  diplomatic('diplomatic'),
  government('government'),
  exportValue('export'),
  charity('charity');

  const TaxExemptionType(this.value);
  final String value;

  static TaxExemptionType fromValue(String value) {
    return TaxExemptionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid TaxExemptionType: $value'),
    );
  }

  static TaxExemptionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
