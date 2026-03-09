enum FlowerFreshnessStatus {
  fresh('fresh'),
  markedDown('marked_down'),
  disposed('disposed');

  const FlowerFreshnessStatus(this.value);
  final String value;

  static FlowerFreshnessStatus fromValue(String value) {
    return FlowerFreshnessStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid FlowerFreshnessStatus: $value'),
    );
  }

  static FlowerFreshnessStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
