enum Handedness {
  left('left'),
  right('right'),
  center('center');

  const Handedness(this.value);
  final String value;

  static Handedness fromValue(String value) {
    return Handedness.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid Handedness: $value'),
    );
  }

  static Handedness? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
