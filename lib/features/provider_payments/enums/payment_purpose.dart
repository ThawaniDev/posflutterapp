enum PaymentPurpose {
  subscription('subscription'),
  planAddon('plan_addon'),
  aiBilling('ai_billing'),
  hardware('hardware'),
  implementationFee('implementation_fee'),
  other('other');

  const PaymentPurpose(this.value);
  final String value;

  static PaymentPurpose fromValue(String value) {
    return PaymentPurpose.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PaymentPurpose: $value'),
    );
  }

  static PaymentPurpose? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }

  String get label => switch (this) {
    subscription => 'Subscription',
    planAddon => 'Plan Add-on',
    aiBilling => 'AI Billing',
    hardware => 'Hardware',
    implementationFee => 'Implementation Fee',
    other => 'Other',
  };
}
