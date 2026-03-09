enum ActivityEntityType {
  order('order'),
  product('product'),
  customer('customer');

  const ActivityEntityType(this.value);
  final String value;

  static ActivityEntityType fromValue(String value) {
    return ActivityEntityType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ActivityEntityType: $value'),
    );
  }

  static ActivityEntityType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
