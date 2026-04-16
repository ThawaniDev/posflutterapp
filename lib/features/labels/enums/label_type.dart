enum LabelType {
  barcode('barcode'),
  price('price'),
  priceTag('price_tag'),
  shelf('shelf'),
  jewelry('jewelry'),
  pharmacy('pharmacy'),
  custom('custom');

  const LabelType(this.value);
  final String value;

  static LabelType fromValue(String value) {
    return LabelType.values.firstWhere((e) => e.value == value, orElse: () => throw ArgumentError('Invalid LabelType: $value'));
  }

  static LabelType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
