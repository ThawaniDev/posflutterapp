enum ConditionGrade {
  brandNew('new'),
  a('A'),
  b('B'),
  c('C'),
  d('D');

  const ConditionGrade(this.value);
  final String value;

  static ConditionGrade fromValue(String value) {
    return ConditionGrade.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ConditionGrade: $value'),
    );
  }

  static ConditionGrade? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
