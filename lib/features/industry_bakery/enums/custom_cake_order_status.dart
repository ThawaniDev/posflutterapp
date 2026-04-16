enum CustomCakeOrderStatus {
  ordered('ordered'),
  inProgress('in_progress'),
  inProduction('in_production'),
  ready('ready'),
  delivered('delivered'),
  cancelled('cancelled');

  const CustomCakeOrderStatus(this.value);
  final String value;

  static CustomCakeOrderStatus fromValue(String value) {
    return CustomCakeOrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid CustomCakeOrderStatus: $value'),
    );
  }

  static CustomCakeOrderStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
