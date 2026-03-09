enum PurchaseOrderStatus {
  draft('draft'),
  sent('sent'),
  partiallyReceived('partially_received'),
  fullyReceived('fully_received'),
  cancelled('cancelled');

  const PurchaseOrderStatus(this.value);
  final String value;

  static PurchaseOrderStatus fromValue(String value) {
    return PurchaseOrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid PurchaseOrderStatus: $value'),
    );
  }

  static PurchaseOrderStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
