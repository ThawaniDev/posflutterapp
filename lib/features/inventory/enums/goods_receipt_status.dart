enum GoodsReceiptStatus {
  draft('draft'),
  confirmed('confirmed');

  const GoodsReceiptStatus(this.value);
  final String value;

  static GoodsReceiptStatus fromValue(String value) {
    return GoodsReceiptStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid GoodsReceiptStatus: $value'),
    );
  }

  static GoodsReceiptStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
