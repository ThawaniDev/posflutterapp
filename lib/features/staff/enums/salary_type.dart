enum SalaryType {
  hourly('hourly'),
  monthly('monthly'),
  commissionOnly('commission_only');

  const SalaryType(this.value);
  final String value;

  static SalaryType fromValue(String value) {
    return SalaryType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SalaryType: $value'),
    );
  }

  static SalaryType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
