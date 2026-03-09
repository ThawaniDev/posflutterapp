enum MilestoneRewardType {
  points('points'),
  discountPercentage('discount_percentage'),
  tierUpgrade('tier_upgrade'),
  badge('badge');

  const MilestoneRewardType(this.value);
  final String value;

  static MilestoneRewardType fromValue(String value) {
    return MilestoneRewardType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid MilestoneRewardType: $value'),
    );
  }

  static MilestoneRewardType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
