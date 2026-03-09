enum DrugScheduleType {
  otc('otc'),
  prescriptionOnly('prescription_only'),
  controlled('controlled');

  const DrugScheduleType(this.value);
  final String value;

  static DrugScheduleType fromValue(String value) {
    return DrugScheduleType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DrugScheduleType: $value'),
    );
  }

  static DrugScheduleType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
