enum SyncStatus {
  pending('pending'),
  synced('synced'),
  failed('failed');

  const SyncStatus(this.value);
  final String value;

  static SyncStatus fromValue(String value) {
    return SyncStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SyncStatus: $value'),
    );
  }

  static SyncStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
