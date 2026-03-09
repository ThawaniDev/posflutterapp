enum ProductionScheduleStatus {
  planned('planned'),
  inProgress('in_progress'),
  completed('completed');

  const ProductionScheduleStatus(this.value);
  final String value;

  static ProductionScheduleStatus fromValue(String value) {
    return ProductionScheduleStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ProductionScheduleStatus: $value'),
    );
  }

  static ProductionScheduleStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
