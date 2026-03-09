enum ThawaniConnectionStatus {
  connected('connected'),
  failed('failed'),
  unknown('unknown');

  const ThawaniConnectionStatus(this.value);
  final String value;

  static ThawaniConnectionStatus fromValue(String value) {
    return ThawaniConnectionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ThawaniConnectionStatus: $value'),
    );
  }

  static ThawaniConnectionStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
