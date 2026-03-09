enum ThawaniOrderStatus {
  newValue('new'),
  accepted('accepted'),
  preparing('preparing'),
  ready('ready'),
  dispatched('dispatched'),
  completed('completed'),
  rejected('rejected'),
  cancelled('cancelled');

  const ThawaniOrderStatus(this.value);
  final String value;

  static ThawaniOrderStatus fromValue(String value) {
    return ThawaniOrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ThawaniOrderStatus: $value'),
    );
  }

  static ThawaniOrderStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
