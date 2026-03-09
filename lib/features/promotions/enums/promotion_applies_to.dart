enum PromotionAppliesTo {
  allProducts('all_products'),
  specificCategory('specific_category');

  const PromotionAppliesTo(this.value);
  final String value;

  static PromotionAppliesTo fromValue(String value) {
    return PromotionAppliesTo.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PromotionAppliesTo: $value'),
    );
  }

  static PromotionAppliesTo? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
