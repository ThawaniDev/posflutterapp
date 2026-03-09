enum ExpenseCategory {
  supplies('supplies'),
  food('food'),
  transport('transport'),
  maintenance('maintenance'),
  utility('utility'),
  other('other');

  const ExpenseCategory(this.value);
  final String value;

  static ExpenseCategory fromValue(String value) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ExpenseCategory: $value'),
    );
  }

  static ExpenseCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
