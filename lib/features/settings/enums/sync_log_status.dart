enum SyncLogStatus {
  success('success'),
  partial('partial'),
  failed('failed');

  const SyncLogStatus(this.value);
  final String value;

  static SyncLogStatus fromValue(String value) {
    return SyncLogStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SyncLogStatus: $value'),
    );
  }

  static SyncLogStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
