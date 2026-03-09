enum DeliverySyncStatus {
  ok('ok'),
  error('error'),
  pending('pending');

  const DeliverySyncStatus(this.value);
  final String value;

  static DeliverySyncStatus fromValue(String value) {
    return DeliverySyncStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeliverySyncStatus: $value'),
    );
  }

  static DeliverySyncStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
