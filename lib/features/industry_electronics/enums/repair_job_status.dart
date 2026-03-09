enum RepairJobStatus {
  received('received'),
  diagnosing('diagnosing'),
  repairing('repairing'),
  testing('testing'),
  ready('ready'),
  collected('collected'),
  cancelled('cancelled');

  const RepairJobStatus(this.value);
  final String value;

  static RepairJobStatus fromValue(String value) {
    return RepairJobStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid RepairJobStatus: $value'),
    );
  }

  static RepairJobStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
