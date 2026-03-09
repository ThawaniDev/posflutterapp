enum DriverProtocol {
  escPos('esc_pos'),
  zpl('zpl'),
  tspl('tspl'),
  serialScale('serial_scale'),
  hid('hid'),
  nearpaySdk('nearpay_sdk'),
  nfcHid('nfc_hid');

  const DriverProtocol(this.value);
  final String value;

  static DriverProtocol fromValue(String value) {
    return DriverProtocol.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DriverProtocol: $value'),
    );
  }

  static DriverProtocol? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
