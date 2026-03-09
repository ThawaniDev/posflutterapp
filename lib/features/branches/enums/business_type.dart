enum BusinessType {
  retail('retail'),
  restaurant('restaurant'),
  pharmacy('pharmacy'),
  grocery('grocery'),
  jewelry('jewelry'),
  mobileShop('mobile_shop'),
  flowerShop('flower_shop'),
  bakery('bakery'),
  service('service'),
  custom('custom');

  const BusinessType(this.value);
  final String value;

  static BusinessType fromValue(String value) {
    return BusinessType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BusinessType: $value'),
    );
  }

  static BusinessType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
