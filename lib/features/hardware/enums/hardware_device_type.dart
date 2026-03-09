enum HardwareDeviceType {
  receiptPrinter('receipt_printer'),
  barcodeScanner('barcode_scanner'),
  weighingScale('weighing_scale'),
  labelPrinter('label_printer'),
  cashDrawer('cash_drawer'),
  cardTerminal('card_terminal'),
  nfcReader('nfc_reader'),
  customerDisplay('customer_display');

  const HardwareDeviceType(this.value);
  final String value;

  static HardwareDeviceType fromValue(String value) {
    return HardwareDeviceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid HardwareDeviceType: $value'),
    );
  }

  static HardwareDeviceType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
