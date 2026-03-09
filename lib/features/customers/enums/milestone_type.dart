enum MilestoneType {
  totalSpend('total_spend'),
  totalVisits('total_visits'),
  membershipDays('membership_days');

  const MilestoneType(this.value);
  final String value;

  static MilestoneType fromValue(String value) {
    return MilestoneType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid MilestoneType: $value'),
    );
  }

  static MilestoneType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
