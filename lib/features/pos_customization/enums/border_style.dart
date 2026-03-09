enum BorderStyle {
  solid('solid'),
  dashed('dashed');

  const BorderStyle(this.value);
  final String value;

  static BorderStyle fromValue(String value) {
    return BorderStyle.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BorderStyle: $value'),
    );
  }

  static BorderStyle? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
