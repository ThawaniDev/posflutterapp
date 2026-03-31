enum StocktakeType {
  full('full'),
  partial('partial'),
  category('category');

  const StocktakeType(this.value);
  final String value;

  static StocktakeType fromValue(String value) {
    return StocktakeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StocktakeType: $value'),
    );
  }

  static StocktakeType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
