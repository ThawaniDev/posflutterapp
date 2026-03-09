enum GamificationRewardType {
  points('points'),
  discountPercentage('discount_percentage'),
  freeItem('free_item'),
  badge('badge');

  const GamificationRewardType(this.value);
  final String value;

  static GamificationRewardType fromValue(String value) {
    return GamificationRewardType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GamificationRewardType: $value'),
    );
  }

  static GamificationRewardType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
