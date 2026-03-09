enum EmploymentType {
  fullTime('full_time'),
  partTime('part_time'),
  contractor('contractor');

  const EmploymentType(this.value);
  final String value;

  static EmploymentType fromValue(String value) {
    return EmploymentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid EmploymentType: $value'),
    );
  }

  static EmploymentType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
