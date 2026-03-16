enum SyncConflictResolution {
  localWins('local_wins'),
  cloudWins('cloud_wins'),
  merged('merged');

  const SyncConflictResolution(this.value);
  final String value;

  static SyncConflictResolution fromValue(String value) => SyncConflictResolution.values.firstWhere((e) => e.value == value);

  static SyncConflictResolution? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
