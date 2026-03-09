enum GiftRegistryEventType {
  wedding('wedding'),
  birthday('birthday'),
  babyShower('baby_shower'),
  other('other');

  const GiftRegistryEventType(this.value);
  final String value;

  static GiftRegistryEventType fromValue(String value) {
    return GiftRegistryEventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GiftRegistryEventType: $value'),
    );
  }

  static GiftRegistryEventType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
