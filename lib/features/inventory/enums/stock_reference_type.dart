enum StockReferenceType {
  goodsReceipt('goods_receipt'),
  adjustment('adjustment'),
  transfer('transfer'),
  transaction('transaction'),
  waste('waste'),
  stocktake('stocktake');

  const StockReferenceType(this.value);
  final String value;

  static StockReferenceType fromValue(String value) {
    return StockReferenceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid StockReferenceType: $value'),
    );
  }

  static StockReferenceType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
