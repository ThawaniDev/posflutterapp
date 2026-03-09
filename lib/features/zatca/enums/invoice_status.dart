enum InvoiceStatus {
  draft('draft'),
  pending('pending'),
  paid('paid'),
  failed('failed'),
  refunded('refunded');

  const InvoiceStatus(this.value);
  final String value;

  static InvoiceStatus fromValue(String value) {
    return InvoiceStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid InvoiceStatus: $value'),
    );
  }

  static InvoiceStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
