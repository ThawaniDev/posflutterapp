enum OnboardingStep {
  welcome('welcome'),
  businessInfo('business_info'),
  businessType('business_type'),
  tax('tax'),
  hardware('hardware'),
  products('products'),
  staff('staff'),
  review('review');

  const OnboardingStep(this.value);
  final String value;

  static OnboardingStep fromValue(String value) {
    return OnboardingStep.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid OnboardingStep: $value'),
    );
  }

  static OnboardingStep? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
