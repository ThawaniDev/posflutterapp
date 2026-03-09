enum ConnectionType {
  usb('usb'),
  network('network'),
  bluetooth('bluetooth'),
  serial('serial');

  const ConnectionType(this.value);
  final String value;

  static ConnectionType fromValue(String value) {
    return ConnectionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ConnectionType: $value'),
    );
  }

  static ConnectionType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
