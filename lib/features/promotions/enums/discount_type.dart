enum DiscountType {
  percentage('percentage'),
  fixed('fixed');

  const DiscountType(this.value);
  final String value;

  static DiscountType fromValue(String value) {
    return DiscountType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DiscountType: $value'),
    );
  }

  static DiscountType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
