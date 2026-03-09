enum MakingChargesType {
  flat('flat'),
  percentage('percentage'),
  perGram('per_gram');

  const MakingChargesType(this.value);
  final String value;

  static MakingChargesType fromValue(String value) {
    return MakingChargesType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid MakingChargesType: $value'),
    );
  }

  static MakingChargesType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
