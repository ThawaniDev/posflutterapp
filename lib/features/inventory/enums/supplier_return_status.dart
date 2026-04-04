enum SupplierReturnStatus {
  draft('draft'),
  submitted('submitted'),
  approved('approved'),
  completed('completed'),
  cancelled('cancelled');

  const SupplierReturnStatus(this.value);
  final String value;

  static SupplierReturnStatus fromValue(String value) {
    return SupplierReturnStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SupplierReturnStatus: $value'),
    );
  }

  static SupplierReturnStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
