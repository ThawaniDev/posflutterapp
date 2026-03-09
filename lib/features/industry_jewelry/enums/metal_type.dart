enum MetalType {
  gold('gold'),
  silver('silver'),
  platinum('platinum');

  const MetalType(this.value);
  final String value;

  static MetalType fromValue(String value) {
    return MetalType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid MetalType: $value'),
    );
  }

  static MetalType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
