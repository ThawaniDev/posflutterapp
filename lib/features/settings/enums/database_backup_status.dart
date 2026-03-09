enum DatabaseBackupStatus {
  inProgress('in_progress'),
  completed('completed'),
  failed('failed');

  const DatabaseBackupStatus(this.value);
  final String value;

  static DatabaseBackupStatus fromValue(String value) {
    return DatabaseBackupStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DatabaseBackupStatus: $value'),
    );
  }

  static DatabaseBackupStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
