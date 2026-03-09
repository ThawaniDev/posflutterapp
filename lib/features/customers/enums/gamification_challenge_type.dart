enum GamificationChallengeType {
  buyXGetY('buy_x_get_y'),
  spendTarget('spend_target'),
  visitStreak('visit_streak'),
  categorySpend('category_spend'),
  referral('referral');

  const GamificationChallengeType(this.value);
  final String value;

  static GamificationChallengeType fromValue(String value) {
    return GamificationChallengeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GamificationChallengeType: $value'),
    );
  }

  static GamificationChallengeType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
