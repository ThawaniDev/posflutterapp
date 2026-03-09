enum ChallengeType {
  purchaseCount('purchase_count'),
  spendAmount('spend_amount'),
  categoryExplore('category_explore'),
  streak('streak');

  const ChallengeType(this.value);
  final String value;

  static ChallengeType fromValue(String value) {
    return ChallengeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ChallengeType: $value'),
    );
  }

  static ChallengeType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
