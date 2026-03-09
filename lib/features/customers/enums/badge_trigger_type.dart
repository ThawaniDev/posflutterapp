enum BadgeTriggerType {
  purchaseCount('purchase_count'),
  spendTotal('spend_total'),
  streakDays('streak_days'),
  categoryExplorer('category_explorer'),
  referralCount('referral_count');

  const BadgeTriggerType(this.value);
  final String value;

  static BadgeTriggerType fromValue(String value) {
    return BadgeTriggerType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BadgeTriggerType: $value'),
    );
  }

  static BadgeTriggerType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
