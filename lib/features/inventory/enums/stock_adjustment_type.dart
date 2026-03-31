enum StockAdjustmentType {
  increase('increase'),
  decrease('decrease'),
  damage('damage');

  const StockAdjustmentType(this.value);
  final String value;

  static StockAdjustmentType fromValue(String value) {
    return StockAdjustmentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StockAdjustmentType: $value'),
    );
  }

  static StockAdjustmentType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
