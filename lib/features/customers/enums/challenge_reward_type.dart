enum ChallengeRewardType {
  points('points'),
  discountCoupon('discount_coupon'),
  freeItem('free_item'),
  badge('badge');

  const ChallengeRewardType(this.value);
  final String value;

  static ChallengeRewardType fromValue(String value) {
    return ChallengeRewardType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ChallengeRewardType: $value'),
    );
  }

  static ChallengeRewardType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
