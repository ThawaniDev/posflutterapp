enum StocktakeStatus {
  inProgress('in_progress'),
  review('review'),
  completed('completed'),
  cancelled('cancelled');

  const StocktakeStatus(this.value);
  final String value;

  static StocktakeStatus fromValue(String value) {
    return StocktakeStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StocktakeStatus: $value'),
    );
  }

  static StocktakeStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
