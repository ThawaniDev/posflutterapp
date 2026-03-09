enum ThankYouAnimation {
  confetti('confetti'),
  check('check'),
  none('none');

  const ThankYouAnimation(this.value);
  final String value;

  static ThankYouAnimation fromValue(String value) {
    return ThankYouAnimation.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ThankYouAnimation: $value'),
    );
  }

  static ThankYouAnimation? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
