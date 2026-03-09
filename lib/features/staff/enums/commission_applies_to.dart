enum CommissionAppliesTo {
  allSales('all_sales'),
  specificCategory('specific_category'),
  specificProduct('specific_product');

  const CommissionAppliesTo(this.value);
  final String value;

  static CommissionAppliesTo fromValue(String value) {
    return CommissionAppliesTo.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CommissionAppliesTo: $value'),
    );
  }

  static CommissionAppliesTo? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
