enum ProductUnit {
  piece('piece'),
  kg('kg'),
  litre('litre'),
  custom('custom');

  const ProductUnit(this.value);
  final String value;

  static ProductUnit fromValue(String value) {
    return ProductUnit.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ProductUnit: $value'),
    );
  }

  static ProductUnit? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
