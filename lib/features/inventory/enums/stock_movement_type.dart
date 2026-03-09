enum StockMovementType {
  receipt('receipt'),
  sale('sale'),
  adjustmentIn('adjustment_in'),
  adjustmentOut('adjustment_out'),
  transferOut('transfer_out'),
  transferIn('transfer_in'),
  waste('waste'),
  recipeDeduction('recipe_deduction');

  const StockMovementType(this.value);
  final String value;

  static StockMovementType fromValue(String value) {
    return StockMovementType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StockMovementType: $value'),
    );
  }

  static StockMovementType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
