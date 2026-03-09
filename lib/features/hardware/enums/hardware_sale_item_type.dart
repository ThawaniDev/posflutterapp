enum HardwareSaleItemType {
  terminal('terminal'),
  printer('printer'),
  scanner('scanner'),
  other('other');

  const HardwareSaleItemType(this.value);
  final String value;

  static HardwareSaleItemType fromValue(String value) {
    return HardwareSaleItemType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid HardwareSaleItemType: $value'),
    );
  }

  static HardwareSaleItemType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
