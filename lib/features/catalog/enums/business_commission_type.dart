enum BusinessCommissionType {
  percentage('percentage'),
  fixedPerTransaction('fixed_per_transaction'),
  tiered('tiered');

  const BusinessCommissionType(this.value);
  final String value;

  static BusinessCommissionType fromValue(String value) {
    return BusinessCommissionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BusinessCommissionType: $value'),
    );
  }

  static BusinessCommissionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
