enum FcmDeviceType {
  android('android'),
  ios('ios');

  const FcmDeviceType(this.value);
  final String value;

  static FcmDeviceType fromValue(String value) {
    return FcmDeviceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid FcmDeviceType: $value'),
    );
  }

  static FcmDeviceType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
