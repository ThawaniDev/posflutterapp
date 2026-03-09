enum CancellationReasonCategory {
  price('price'),
  features('features'),
  competitor('competitor'),
  support('support'),
  other('other');

  const CancellationReasonCategory(this.value);
  final String value;

  static CancellationReasonCategory fromValue(String value) {
    return CancellationReasonCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CancellationReasonCategory: $value'),
    );
  }

  static CancellationReasonCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
