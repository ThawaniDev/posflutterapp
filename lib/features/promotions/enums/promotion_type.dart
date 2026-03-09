enum PromotionType {
  percentage('percentage'),
  fixedAmount('fixed_amount'),
  bogo('bogo'),
  bundle('bundle'),
  happyHour('happy_hour');

  const PromotionType(this.value);
  final String value;

  static PromotionType fromValue(String value) {
    return PromotionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PromotionType: $value'),
    );
  }

  static PromotionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
