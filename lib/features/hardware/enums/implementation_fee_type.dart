enum ImplementationFeeType {
  setup('setup'),
  training('training'),
  customDev('custom_dev');

  const ImplementationFeeType(this.value);
  final String value;

  static ImplementationFeeType fromValue(String value) {
    return ImplementationFeeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ImplementationFeeType: $value'),
    );
  }

  static ImplementationFeeType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
