enum BusinessPromotionType {
  percentage('percentage'),
  fixed('fixed'),
  bogo('bogo'),
  happyHour('happy_hour');

  const BusinessPromotionType(this.value);
  final String value;

  static BusinessPromotionType fromValue(String value) {
    return BusinessPromotionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BusinessPromotionType: $value'),
    );
  }

  static BusinessPromotionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
