enum BackupHistoryStatus {
  completed('completed'),
  failed('failed'),
  corrupted('corrupted');

  const BackupHistoryStatus(this.value);
  final String value;

  static BackupHistoryStatus fromValue(String value) {
    return BackupHistoryStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BackupHistoryStatus: $value'),
    );
  }

  static BackupHistoryStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
