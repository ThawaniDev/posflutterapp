enum DeviceImeiStatus {
  inStock('in_stock'),
  sold('sold'),
  tradedIn('traded_in'),
  returned('returned');

  const DeviceImeiStatus(this.value);
  final String value;

  static DeviceImeiStatus fromValue(String value) {
    return DeviceImeiStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeviceImeiStatus: $value'),
    );
  }

  static DeviceImeiStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
