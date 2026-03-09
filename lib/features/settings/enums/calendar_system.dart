enum CalendarSystem {
  gregorian('gregorian'),
  hijri('hijri'),
  both('both');

  const CalendarSystem(this.value);
  final String value;

  static CalendarSystem fromValue(String value) {
    return CalendarSystem.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CalendarSystem: $value'),
    );
  }

  static CalendarSystem? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
