enum LoyaltyProgramType {
  points('points'),
  stamps('stamps'),
  cashback('cashback'),
  none('none');

  const LoyaltyProgramType(this.value);
  final String value;

  static LoyaltyProgramType fromValue(String value) {
    return LoyaltyProgramType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid LoyaltyProgramType: $value'),
    );
  }

  static LoyaltyProgramType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
