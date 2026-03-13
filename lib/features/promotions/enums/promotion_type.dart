enum PromotionType {
  percentage('percentage'),
  fixedAmount('fixed_amount'),
  bogo('bogo'),
  bundle('bundle'),
  happyHour('happy_hour');

  const PromotionType(this.value);
  final String value;

  String get label => switch (this) {
    percentage => 'Percentage',
    fixedAmount => 'Fixed Amount',
    bogo => 'Buy One Get One',
    bundle => 'Bundle',
    happyHour => 'Happy Hour',
  };

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
