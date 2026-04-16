enum BackupType {
  auto('auto'),
  manual('manual'),
  preUpdate('pre_update'),
  full('full'),
  incremental('incremental');

  const BackupType(this.value);
  final String value;

  static BackupType fromValue(String value) {
    return BackupType.values.firstWhere((e) => e.value == value, orElse: () => throw ArgumentError('Invalid BackupType: $value'));
  }

  static BackupType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
