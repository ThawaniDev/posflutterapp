enum BarcodeType {
  code128('CODE128'),
  ean13('EAN13'),
  ean8('EAN8'),
  qr('QR'),
  code39('Code39');

  const BarcodeType(this.value);
  final String value;

  static BarcodeType fromValue(String value) {
    return BarcodeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid BarcodeType: $value'),
    );
  }

  static BarcodeType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
