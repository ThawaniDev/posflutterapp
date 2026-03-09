enum ImplementationFeeStatus {
  invoiced('invoiced'),
  paid('paid');

  const ImplementationFeeStatus(this.value);
  final String value;

  static ImplementationFeeStatus fromValue(String value) {
    return ImplementationFeeStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ImplementationFeeStatus: $value'),
    );
  }

  static ImplementationFeeStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
