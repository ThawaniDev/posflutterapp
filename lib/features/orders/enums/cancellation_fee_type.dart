enum CancellationFeeType {
  none('none'),
  fixed('fixed'),
  percentage('percentage');

  const CancellationFeeType(this.value);
  final String value;

  static CancellationFeeType fromValue(String value) {
    return CancellationFeeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CancellationFeeType: $value'),
    );
  }

  static CancellationFeeType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
