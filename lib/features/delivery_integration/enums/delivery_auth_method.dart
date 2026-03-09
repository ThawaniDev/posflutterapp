enum DeliveryAuthMethod {
  bearer('bearer'),
  apiKey('api_key'),
  basic('basic'),
  oauth2('oauth2');

  const DeliveryAuthMethod(this.value);
  final String value;

  static DeliveryAuthMethod fromValue(String value) {
    return DeliveryAuthMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeliveryAuthMethod: $value'),
    );
  }

  static DeliveryAuthMethod? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
