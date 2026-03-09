enum AnimationStyle {
  fade('fade'),
  slide('slide'),
  none('none');

  const AnimationStyle(this.value);
  final String value;

  static AnimationStyle fromValue(String value) {
    return AnimationStyle.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AnimationStyle: $value'),
    );
  }

  static AnimationStyle? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
