enum DigitalReceiptChannel {
  email('email'),
  whatsapp('whatsapp');

  const DigitalReceiptChannel(this.value);
  final String value;

  static DigitalReceiptChannel fromValue(String value) {
    return DigitalReceiptChannel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DigitalReceiptChannel: $value'),
    );
  }

  static DigitalReceiptChannel? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
