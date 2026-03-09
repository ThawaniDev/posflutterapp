enum DatabaseBackupType {
  autoDaily('auto_daily'),
  autoWeekly('auto_weekly'),
  manual('manual');

  const DatabaseBackupType(this.value);
  final String value;

  static DatabaseBackupType fromValue(String value) {
    return DatabaseBackupType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DatabaseBackupType: $value'),
    );
  }

  static DatabaseBackupType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
