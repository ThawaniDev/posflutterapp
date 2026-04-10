enum AIFeatureCategory {
  inventory('inventory'),
  sales('sales'),
  operations('operations'),
  catalog('catalog'),
  customer('customer'),
  communication('communication'),
  financial('financial'),
  platform('platform');

  const AIFeatureCategory(this.value);
  final String value;

  static AIFeatureCategory fromValue(String value) {
    return AIFeatureCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AIFeatureCategory: $value'),
    );
  }

  static AIFeatureCategory? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
