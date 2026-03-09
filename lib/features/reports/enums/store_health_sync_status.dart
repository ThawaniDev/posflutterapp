enum StoreHealthSyncStatus {
  ok('ok'),
  error('error'),
  pending('pending');

  const StoreHealthSyncStatus(this.value);
  final String value;

  static StoreHealthSyncStatus fromValue(String value) {
    return StoreHealthSyncStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StoreHealthSyncStatus: $value'),
    );
  }

  static StoreHealthSyncStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
