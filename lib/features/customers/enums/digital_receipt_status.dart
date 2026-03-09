enum DigitalReceiptStatus {
  sent('sent'),
  delivered('delivered'),
  failed('failed');

  const DigitalReceiptStatus(this.value);
  final String value;

  static DigitalReceiptStatus fromValue(String value) {
    return DigitalReceiptStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DigitalReceiptStatus: $value'),
    );
  }

  static DigitalReceiptStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
