enum SyncDirection {
  push('push'),
  pull('pull'),
  full('full'),
  upload('upload'),
  download('download');

  const SyncDirection(this.value);
  final String value;

  static SyncDirection fromValue(String value) => SyncDirection.values.firstWhere((e) => e.value == value);

  static SyncDirection? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
