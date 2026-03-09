enum CommissionRuleType {
  flatPercentage('flat_percentage'),
  tiered('tiered'),
  perItem('per_item');

  const CommissionRuleType(this.value);
  final String value;

  static CommissionRuleType fromValue(String value) {
    return CommissionRuleType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CommissionRuleType: $value'),
    );
  }

  static CommissionRuleType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
